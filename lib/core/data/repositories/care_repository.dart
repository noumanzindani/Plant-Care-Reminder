import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/value_objects/enums.dart';
import '../db/database.dart';
import '../sync/outbox_writer.dart';

/// A read model for one row of the care queue (schedule + its plant + next-due).
class CareQueueItem {
  const CareQueueItem({
    required this.plantId,
    required this.scheduleId,
    required this.nickname,
    required this.type,
    required this.nextDueAt,
  });

  final String plantId;
  final String scheduleId;
  final String nickname;
  final CareType type;
  final DateTime? nextDueAt;
}

/// A read model for one entry in the care journal (a care log + its plant's nickname).
class JournalEntry {
  const JournalEntry({
    required this.logId,
    required this.plantId,
    required this.nickname,
    required this.type,
    required this.performedAt,
    required this.source,
    this.note,
  });

  final String logId;
  final String plantId;
  final String nickname;
  final CareType type;
  final DateTime performedAt;
  final CareLogSource source;
  final String? note;
}

/// The write side of the plant collection: create plants + schedules, log care.
///
/// Ids are client-generated UUID v7 (time-ordered) — the canonical identity the
/// backend will accept as-is, which makes the future anon→account sync a pure push.
/// Callers trigger a reconcile after these mutations (the schedule/log changed).
class CareRepository {
  CareRepository(this._db, {Uuid uuid = const Uuid()})
      : _uuid = uuid,
        _outbox = OutboxWriter(_db);

  final AppDatabase _db;
  final Uuid _uuid;
  final OutboxWriter _outbox;

  /// Create a plant, optionally linked to a catalog [speciesId], with a watering schedule
  /// and — when a [fertilizeIntervalDays] default is provided — a fertilize schedule too
  /// (the catalog "smart defaults"). Returns the new plant's id.
  Future<String> addPlant({
    required String nickname,
    required int wateringIntervalDays,
    required int timeOfDayMinutes,
    required String tzId,
    String? speciesId,
    int? fertilizeIntervalDays,
  }) async {
    final now = DateTime.now();
    final plantId = _uuid.v7();

    await _db.transaction(() async {
      await _db.plantsDao.insertPlant(
        UserPlantsCompanion.insert(
          id: plantId,
          nickname: nickname,
          createdAt: now,
          updatedAt: now,
          speciesId: Value(speciesId),
        ),
      );
      await _enqueuePlant(plantId, now);
      await _insertSchedule(
          plantId, CareType.water, wateringIntervalDays, timeOfDayMinutes, tzId, now);
      if (fertilizeIntervalDays != null) {
        await _insertSchedule(
            plantId, CareType.fertilize, fertilizeIntervalDays, timeOfDayMinutes, tzId, now);
      }
    });

    return plantId;
  }

  Future<void> _insertSchedule(
    String plantId,
    CareType type,
    int intervalDays,
    int timeOfDayMinutes,
    String tzId,
    DateTime now,
  ) async {
    final id = _uuid.v7();
    await _db.into(_db.careSchedules).insert(
          CareSchedulesCompanion.insert(
            id: id,
            userPlantId: plantId,
            type: type,
            baseIntervalDays: intervalDays,
            tzId: tzId,
            createdAt: now,
            updatedAt: now,
            timeOfDayMinutes: Value(timeOfDayMinutes),
          ),
        );
    await _enqueueSchedule(id, now);
  }

  /// Create a plant with a single watering schedule. Returns the new plant's id.
  /// A thin convenience over [addPlant] for the manual (no-species) add flow.
  Future<String> addWateringPlant({
    required String nickname,
    required int intervalDays,
    required int timeOfDayMinutes,
    required String tzId,
  }) {
    return addPlant(
      nickname: nickname,
      wateringIntervalDays: intervalDays,
      timeOfDayMinutes: timeOfDayMinutes,
      tzId: tzId,
    );
  }

  /// Add (or update) a care schedule of [type] for an existing plant, enforcing the
  /// one-active-schedule-per-(plant, type) invariant: if that type already exists it is
  /// updated and reactivated (rather than duplicated), otherwise a new one is inserted.
  /// Returns the schedule id.
  Future<String> addSchedule({
    required String plantId,
    required CareType type,
    required int intervalDays,
    required int timeOfDayMinutes,
    required String tzId,
  }) async {
    final now = DateTime.now();
    return _db.transaction(() async {
      final existing = await (_db.select(_db.careSchedules)
            ..where((s) => s.userPlantId.equals(plantId) & s.type.equalsValue(type))
            ..limit(1))
          .getSingleOrNull();

      if (existing != null) {
        await (_db.update(_db.careSchedules)..where((s) => s.id.equals(existing.id)))
            .write(CareSchedulesCompanion(
          baseIntervalDays: Value(intervalDays),
          timeOfDayMinutes: Value(timeOfDayMinutes),
          tzId: Value(tzId),
          active: const Value(true), // reactivate a previously-removed type
          snoozedUntil: const Value(null), // a fresh cadence clears any stale snooze
          updatedAt: Value(now),
        ));
        await _enqueueSchedule(existing.id, now);
        return existing.id;
      }

      final id = _uuid.v7();
      await _db.into(_db.careSchedules).insert(
            CareSchedulesCompanion.insert(
              id: id,
              userPlantId: plantId,
              type: type,
              baseIntervalDays: intervalDays,
              tzId: tzId,
              createdAt: now,
              updatedAt: now,
              timeOfDayMinutes: Value(timeOfDayMinutes),
            ),
          );
      await _enqueueSchedule(id, now);
      return id;
    });
  }

  /// Soft-remove a care type from a plant: mark the schedule inactive so it leaves the
  /// queue and the reconciler cancels its OS alarm. History (care logs) is preserved.
  Future<void> deactivateSchedule(String scheduleId) async {
    final now = DateTime.now();
    await _db.transaction(() async {
      await (_db.update(_db.careSchedules)..where((s) => s.id.equals(scheduleId))).write(
        CareSchedulesCompanion(
          active: const Value(false),
          updatedAt: Value(now),
        ),
      );
      await _enqueueSchedule(scheduleId, now);
    });
  }

  /// Live list of one plant's active care schedules (all its care types), soonest-due
  /// first — the plant detail screen.
  Stream<List<CareQueueItem>> watchPlantSchedules(String plantId) {
    final query = _db.select(_db.careSchedules).join([
      innerJoin(
        _db.userPlants,
        _db.userPlants.id.equalsExp(_db.careSchedules.userPlantId),
      ),
    ])
      ..where(_db.careSchedules.active.equals(true) &
          _db.careSchedules.userPlantId.equals(plantId) &
          _db.userPlants.deletedAt.isNull())
      ..orderBy([OrderingTerm(expression: _db.careSchedules.nextDueAt)]);

    return query.watch().map(_toCareQueueItems);
  }

  /// Live "care queue": one row per active schedule of an active plant, ordered by
  /// next-due (soonest first). `nextDueAt` is the cached projection the reconciler
  /// writes; the UI groups these into Overdue / Today / Upcoming.
  Stream<List<CareQueueItem>> watchCareQueue() {
    final query = _db.select(_db.careSchedules).join([
      innerJoin(
        _db.userPlants,
        _db.userPlants.id.equalsExp(_db.careSchedules.userPlantId),
      ),
    ])
      ..where(_db.careSchedules.active.equals(true) &
          _db.userPlants.deletedAt.isNull() &
          _db.userPlants.status.equalsValue(PlantStatus.active))
      ..orderBy([OrderingTerm(expression: _db.careSchedules.nextDueAt)]);

    return query.watch().map(_toCareQueueItems);
  }

  /// Map joined (careSchedules ⋈ userPlants) rows into the [CareQueueItem] read model.
  /// Shared by [watchCareQueue] and [watchPlantSchedules] so the projection can't drift.
  List<CareQueueItem> _toCareQueueItems(List<TypedResult> rows) => [
        for (final row in rows)
          CareQueueItem(
            plantId: row.readTable(_db.userPlants).id,
            scheduleId: row.readTable(_db.careSchedules).id,
            nickname: row.readTable(_db.userPlants).nickname,
            type: row.readTable(_db.careSchedules).type,
            nextDueAt: row.readTable(_db.careSchedules).nextDueAt,
          ),
      ];

  /// Defer a schedule's next reminder to [until] ("remind me later"). Writes a marker;
  /// the caller reconciles. The reminder engine only honors it while it is later than the
  /// natural due date — logging the care supersedes it (see [OccurrenceBuilder]).
  Future<void> snooze({required String scheduleId, required DateTime until}) async {
    final now = DateTime.now();
    await _db.transaction(() async {
      await (_db.update(_db.careSchedules)..where((s) => s.id.equals(scheduleId))).write(
        CareSchedulesCompanion(
          snoozedUntil: Value(until),
          updatedAt: Value(now),
        ),
      );
      await _enqueueSchedule(scheduleId, now);
    });
  }

  /// Live care journal: every (non-deleted) care log newest-first, joined to its plant's
  /// nickname. Logs of soft-deleted plants are excluded, matching the care queue.
  Stream<List<JournalEntry>> watchJournal() {
    final query = _db.select(_db.careLogs).join([
      innerJoin(
        _db.userPlants,
        _db.userPlants.id.equalsExp(_db.careLogs.userPlantId),
      ),
    ])
      ..where(_db.careLogs.deletedAt.isNull() & _db.userPlants.deletedAt.isNull())
      ..orderBy([OrderingTerm.desc(_db.careLogs.performedAt)]);

    return query.watch().map((rows) {
      return [
        for (final row in rows)
          JournalEntry(
            logId: row.readTable(_db.careLogs).id,
            plantId: row.readTable(_db.userPlants).id,
            nickname: row.readTable(_db.userPlants).nickname,
            type: row.readTable(_db.careLogs).type,
            performedAt: row.readTable(_db.careLogs).performedAt,
            source: row.readTable(_db.careLogs).source,
            note: row.readTable(_db.careLogs).note,
          ),
      ];
    });
  }

  /// Record that a care task was performed (append-only history that re-anchors the
  /// schedule's next due date).
  Future<void> logCare({
    required String plantId,
    required CareType type,
    required DateTime performedAt,
  }) async {
    final now = DateTime.now();
    final logId = _uuid.v7();
    await _db.transaction(() async {
      await _db.into(_db.careLogs).insert(
            CareLogsCompanion.insert(
              id: logId,
              userPlantId: plantId,
              type: type,
              performedAt: performedAt,
              createdAt: now,
              updatedAt: now,
            ),
          );
      final row = await (_db.select(_db.careLogs)..where((l) => l.id.equals(logId)))
          .getSingle();
      await _outbox.upsert('care_logs', logId, row.toJson(), now);
    });
  }

  // --- Sync Outbox (Slice 3.0) ---------------------------------------------------
  // Every mutation appends exactly one change-log row per row it writes, *inside the
  // same transaction* (via [OutboxWriter]) — so a committed local mutation can never be
  // invisible to the server. The snapshot is read back post-mutation so it reflects the
  // row's final state.

  Future<void> _enqueuePlant(String plantId, DateTime now) async {
    final row = await (_db.select(_db.userPlants)..where((p) => p.id.equals(plantId)))
        .getSingle();
    await _outbox.upsert('user_plants', plantId, row.toJson(), now);
  }

  Future<void> _enqueueSchedule(String scheduleId, DateTime now) async {
    final row =
        await (_db.select(_db.careSchedules)..where((s) => s.id.equals(scheduleId)))
            .getSingle();
    await _outbox.upsert('care_schedules', scheduleId, row.toJson(), now);
  }
}
