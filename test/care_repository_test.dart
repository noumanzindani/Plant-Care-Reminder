// Pure-Dart data test for the CareRepository — the write side the UI drives:
// adding a plant (with its water schedule) and logging a completed care task.

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:plant_care_reminder/core/data/db/database.dart';
import 'package:plant_care_reminder/core/data/repositories/care_repository.dart';
import 'package:plant_care_reminder/core/domain/value_objects/enums.dart';

void main() {
  late AppDatabase db;
  late CareRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = CareRepository(db);
  });
  tearDown(() => db.close());

  test('addWateringPlant creates a plant and a matching water schedule', () async {
    final id = await repo.addWateringPlant(
      nickname: 'Fern',
      intervalDays: 5,
      timeOfDayMinutes: 8 * 60,
      tzId: 'America/New_York',
    );

    final plants = await db.plantsDao.watchActivePlants().first;
    expect(plants.map((p) => p.nickname), ['Fern']);

    final schedules = await db.select(db.careSchedules).get();
    expect(schedules, hasLength(1));
    expect(schedules.single.userPlantId, id);
    expect(schedules.single.type, CareType.water);
    expect(schedules.single.baseIntervalDays, 5);
    expect(schedules.single.timeOfDayMinutes, 8 * 60);
  });

  test('logCare records an immutable care log for the plant', () async {
    final id = await repo.addWateringPlant(
      nickname: 'Fern',
      intervalDays: 5,
      timeOfDayMinutes: 8 * 60,
      tzId: 'America/New_York',
    );
    final when = DateTime.utc(2026, 6, 5, 12);

    await repo.logCare(plantId: id, type: CareType.water, performedAt: when);

    final logs =
        await (db.select(db.careLogs)..where((l) => l.userPlantId.equals(id))).get();
    expect(logs, hasLength(1));
    expect(logs.single.type, CareType.water);
    expect(logs.single.performedAt.isAtSameMomentAs(when), isTrue);
  });

  test('watchCareQueue surfaces the active schedule with its plant', () async {
    await repo.addWateringPlant(
      nickname: 'Fern',
      intervalDays: 5,
      timeOfDayMinutes: 8 * 60,
      tzId: 'America/New_York',
    );

    final queue = await repo.watchCareQueue().first;
    expect(queue, hasLength(1));
    expect(queue.single.nickname, 'Fern');
    expect(queue.single.type, CareType.water);
  });

  test('addPlant links the plant to a species and creates a water schedule', () async {
    final id = await repo.addPlant(
      nickname: 'My Monstera',
      speciesId: 'monstera-deliciosa',
      wateringIntervalDays: 7,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );

    final plant =
        await (db.select(db.userPlants)..where((p) => p.id.equals(id))).getSingle();
    expect(plant.speciesId, 'monstera-deliciosa');

    final schedules = await db.select(db.careSchedules).get();
    expect(schedules, hasLength(1));
    expect(schedules.single.type, CareType.water);
    expect(schedules.single.baseIntervalDays, 7);
  });

  test('addPlant with a fertilize default also creates a fertilize schedule', () async {
    await repo.addPlant(
      nickname: 'Fern',
      wateringIntervalDays: 5,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
      fertilizeIntervalDays: 30,
    );

    final schedules = await db.select(db.careSchedules).get();
    expect(schedules, hasLength(2));
    final byType = {for (final s in schedules) s.type: s};
    expect(byType[CareType.water]!.baseIntervalDays, 5);
    expect(byType[CareType.fertilize]!.baseIntervalDays, 30);
  });

  test('addSchedule adds a second care type to an existing plant', () async {
    final plantId = await repo.addWateringPlant(
      nickname: 'Fern',
      intervalDays: 7,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );

    await repo.addSchedule(
      plantId: plantId,
      type: CareType.fertilize,
      intervalDays: 30,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );

    final schedules = await db.select(db.careSchedules).get();
    expect(schedules, hasLength(2));
    expect(schedules.map((s) => s.type), containsAll([CareType.water, CareType.fertilize]));
  });

  test('addSchedule updates an existing care type instead of duplicating it', () async {
    final plantId = await repo.addWateringPlant(
      nickname: 'Fern',
      intervalDays: 7,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );

    // Re-adding water with a tighter cadence should update the one schedule, not add one.
    await repo.addSchedule(
      plantId: plantId,
      type: CareType.water,
      intervalDays: 3,
      timeOfDayMinutes: 8 * 60,
      tzId: 'America/New_York',
    );

    final water = await (db.select(db.careSchedules)
          ..where((s) => s.type.equalsValue(CareType.water)))
        .get();
    expect(water, hasLength(1));
    expect(water.single.baseIntervalDays, 3);
    expect(water.single.timeOfDayMinutes, 8 * 60);
  });

  test('deactivateSchedule removes the care type from the queue', () async {
    await repo.addWateringPlant(
      nickname: 'Fern',
      intervalDays: 7,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );
    final scheduleId = (await db.select(db.careSchedules).get()).single.id;

    await repo.deactivateSchedule(scheduleId);

    expect(await repo.watchCareQueue().first, isEmpty);
  });

  test('watchPlantSchedules returns only the given plant\'s active care types', () async {
    final p1 = await repo.addWateringPlant(
      nickname: 'A',
      intervalDays: 7,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );
    final p2 = await repo.addWateringPlant(
      nickname: 'B',
      intervalDays: 7,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );
    await repo.addSchedule(
      plantId: p1,
      type: CareType.mist,
      intervalDays: 2,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );

    final list = await repo.watchPlantSchedules(p1).first;

    expect(list, hasLength(2)); // water + mist, for p1 only
    expect(list.every((i) => i.plantId == p1), isTrue);
    expect(list.map((i) => i.type), containsAll([CareType.water, CareType.mist]));
    // p2 exists but must not leak in.
    expect(list.any((i) => i.plantId == p2), isFalse);
  });

  test('snooze writes the schedule snoozedUntil marker', () async {
    final id = await repo.addWateringPlant(
      nickname: 'Fern',
      intervalDays: 5,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );
    final scheduleId = (await db.select(db.careSchedules).get()).single.id;
    final until = DateTime.utc(2026, 7, 2, 13);

    await repo.snooze(scheduleId: scheduleId, until: until);

    final schedule = (await db.select(db.careSchedules).get()).single;
    expect(schedule.snoozedUntil, isNotNull);
    expect(schedule.snoozedUntil!.isAtSameMomentAs(until), isTrue);
    expect(schedule.userPlantId, id); // sanity: same plant's schedule
  });

  test('watchJournal returns care logs newest-first with the plant nickname', () async {
    final id = await repo.addWateringPlant(
      nickname: 'Fern',
      intervalDays: 5,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );
    await repo.logCare(
        plantId: id, type: CareType.water, performedAt: DateTime.utc(2026, 6, 1, 9));
    await repo.logCare(
        plantId: id, type: CareType.water, performedAt: DateTime.utc(2026, 6, 8, 9));

    final journal = await repo.watchJournal().first;

    expect(journal, hasLength(2));
    // Newest first.
    expect(journal.first.performedAt.isAtSameMomentAs(DateTime.utc(2026, 6, 8, 9)), isTrue);
    expect(journal.first.nickname, 'Fern');
    expect(journal.first.type, CareType.water);
    expect(journal.last.performedAt.isAtSameMomentAs(DateTime.utc(2026, 6, 1, 9)), isTrue);
  });

  // --- Slice 3.0: the sync Outbox invariant --------------------------------------
  // Every mutation must append exactly one Outbox change-log row per row it writes,
  // atomically in the same transaction — the client-side foundation for delta sync.

  test('addPlant enqueues an upsert Outbox entry for the plant and each schedule',
      () async {
    final plantId = await repo.addPlant(
      nickname: 'Fern',
      wateringIntervalDays: 5,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
      fertilizeIntervalDays: 30,
    );

    final outbox = await db.select(db.outboxEntries).get();
    expect(outbox, hasLength(3)); // plant + water schedule + fertilize schedule
    expect(outbox.every((e) => e.op == 'upsert'), isTrue);

    final plantEntry = outbox.firstWhere((e) => e.entity == 'user_plants');
    expect(plantEntry.entityId, plantId);
    expect(plantEntry.payload, contains(plantId)); // a snapshot of the row's attributes

    expect(outbox.where((e) => e.entity == 'care_schedules'), hasLength(2));
  });

  test('logCare enqueues an upsert Outbox entry for the care log', () async {
    final id = await repo.addWateringPlant(
      nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');
    await db.delete(db.outboxEntries).go(); // isolate logCare's entry from the add

    await repo.logCare(
        plantId: id, type: CareType.water, performedAt: DateTime.utc(2026, 6, 5));

    final outbox = await db.select(db.outboxEntries).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entity, 'care_logs');
    expect(outbox.single.op, 'upsert');
    expect(outbox.single.entityId, isNotEmpty);
  });

  test('snooze enqueues an Outbox entry for the schedule', () async {
    await repo.addWateringPlant(
        nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');
    final scheduleId = (await db.select(db.careSchedules).get()).single.id;
    await db.delete(db.outboxEntries).go();

    await repo.snooze(scheduleId: scheduleId, until: DateTime.utc(2026, 7, 2));

    final outbox = await db.select(db.outboxEntries).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entity, 'care_schedules');
    expect(outbox.single.entityId, scheduleId);
    expect(outbox.single.op, 'upsert');
  });

  test('deactivateSchedule enqueues an Outbox entry for the schedule', () async {
    await repo.addWateringPlant(
        nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');
    final scheduleId = (await db.select(db.careSchedules).get()).single.id;
    await db.delete(db.outboxEntries).go();

    await repo.deactivateSchedule(scheduleId);

    final outbox = await db.select(db.outboxEntries).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entity, 'care_schedules');
    expect(outbox.single.entityId, scheduleId);
    expect(outbox.single.op, 'upsert');
  });

  test('a mutation rolls back its row AND its Outbox entry together on failure',
      () async {
    // A UUID generator that hands both schedules the SAME id, so the fertilize insert
    // collides with the water schedule's primary key mid-transaction. The plant + water
    // rows AND their already-appended Outbox entries must all roll back — proving write
    // and enqueue share one transaction (no committed mutation invisible to the server).
    final doomed = CareRepository(db, uuid: _CollidingUuid());

    await expectLater(
      doomed.addPlant(
        nickname: 'Doomed',
        wateringIntervalDays: 5,
        timeOfDayMinutes: 540,
        tzId: 'UTC',
        fertilizeIntervalDays: 30, // forces the second (colliding) schedule insert
      ),
      throwsA(anything),
    );

    expect(await db.select(db.userPlants).get(), isEmpty);
    expect(await db.select(db.careSchedules).get(), isEmpty);
    expect(await db.select(db.outboxEntries).get(), isEmpty);
  });

  // --- Slice 5.x: per-schedule weather-adaptive toggle ------------------------------

  test('setWeatherSensitive flips the flag and enqueues an Outbox upsert', () async {
    await repo.addWateringPlant(
        nickname: 'Fern', intervalDays: 7, timeOfDayMinutes: 540, tzId: 'UTC');
    final schedule = (await db.select(db.careSchedules).get()).single;
    expect(schedule.weatherSensitive, isFalse); // off by default
    await db.delete(db.outboxEntries).go(); // isolate the toggle's entry

    await repo.setWeatherSensitive(schedule.id, true);

    final updated =
        (await db.select(db.careSchedules).get()).single;
    expect(updated.weatherSensitive, isTrue);

    final outbox = await db.select(db.outboxEntries).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entity, 'care_schedules');
    expect(outbox.single.entityId, schedule.id);
    expect(outbox.single.op, 'upsert');
  });

  test('watchPlantSchedules surfaces the weatherSensitive flag for the UI', () async {
    final plantId = await repo.addWateringPlant(
        nickname: 'Fern', intervalDays: 7, timeOfDayMinutes: 540, tzId: 'UTC');
    final scheduleId = (await db.select(db.careSchedules).get()).single.id;

    // Off by default…
    expect((await repo.watchPlantSchedules(plantId).first).single.weatherSensitive, isFalse);

    await repo.setWeatherSensitive(scheduleId, true);

    // …and the toggle is reflected in the read model the detail screen renders from.
    expect((await repo.watchPlantSchedules(plantId).first).single.weatherSensitive, isTrue);
  });
}

/// A [Uuid] whose `v7()` returns `plant-id` on the first call and `schedule-id` on every
/// call after — so `addPlant`'s water and fertilize schedules collide on their primary
/// key, forcing a mid-transaction failure used to exercise rollback atomicity.
class _CollidingUuid implements Uuid {
  int _calls = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #v7) {
      _calls++;
      return _calls == 1 ? 'plant-id' : 'schedule-id';
    }
    return super.noSuchMethod(invocation);
  }
}
