import 'package:drift/drift.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/ports/weather_port.dart';
import '../../domain/services/cadence_engine.dart';
import '../../domain/services/reconciler.dart';
import '../../domain/services/weather_policy.dart';
import '../../domain/value_objects/enums.dart';
import '../db/database.dart';

/// Bridges the persistence layer to the reminder engine: reads active schedules of
/// active plants + each one's latest care log, runs them through the pure
/// [CadenceEngine], and produces the [DesiredOccurrence] list the [Reconciler] consumes.
///
/// Lives in the data layer (it depends on Drift) so the domain core stays pure.
class OccurrenceBuilder {
  const OccurrenceBuilder(
    this._db,
    this._engine, {
    WeatherPort? weather,
    WeatherPolicy weatherPolicy = const WeatherPolicy(),
  })  : _weather = weather,
        _weatherPolicy = weatherPolicy;

  final AppDatabase _db;
  final CadenceEngine _engine;

  /// Optional weather source. When absent (or it returns null), reminders fall back to the
  /// pure base cadence — the weather overlay is an enhancement, never a dependency.
  final WeatherPort? _weather;
  final WeatherPolicy _weatherPolicy;

  /// One occurrence per active schedule, each holding the next-due instant as of [now].
  Future<List<DesiredOccurrence>> build(tz.TZDateTime now) async {
    final query = _db.select(_db.careSchedules).join([
      innerJoin(
        _db.userPlants,
        _db.userPlants.id.equalsExp(_db.careSchedules.userPlantId),
      ),
      leftOuterJoin(
        _db.rooms,
        _db.rooms.id.equalsExp(_db.userPlants.roomId),
      ),
    ])
      ..where(_db.careSchedules.active.equals(true) &
          _db.userPlants.deletedAt.isNull() &
          _db.userPlants.status.equalsValue(PlantStatus.active));

    final rows = await query.get();

    // One forecast for the whole build (the user's coarse location); null when unavailable.
    final forecast = await _weather?.forecast();

    final occurrences = <DesiredOccurrence>[];
    for (final row in rows) {
      final schedule = row.readTable(_db.careSchedules);
      final plant = row.readTable(_db.userPlants);
      final room = row.readTableOrNull(_db.rooms);
      final lastLog = await _latestLog(schedule.userPlantId, schedule.type);

      final request = CadenceRequest(
        baseIntervalDays: schedule.baseIntervalDays,
        anchor: schedule.anchor,
        timeOfDayMinutes: schedule.timeOfDayMinutes,
        tzId: schedule.tzId,
        createdAt: schedule.createdAt,
        lastPerformedAt: lastLog?.performedAt,
        // TODO(seasonal): parse schedule.seasonalMul JSON once seasonal config has UI.
      );

      // Engine → weather overlay → snooze. Weather refines the forecast-driven estimate;
      // the user's explicit snooze then gets the final say (it only wins when later).
      final naturalDue = _engine.nextDue(request, now);
      final weatherDue = (forecast == null || !schedule.weatherSensitive)
          ? naturalDue
          : _weatherPolicy.adjust(
              baseDue: naturalDue,
              forecast: forecast,
              outdoor: room?.outdoor ?? false,
            );
      final due = _applySnooze(schedule.snoozedUntil, weatherDue, schedule.tzId);
      final label = _careLabel(schedule.type);
      occurrences.add(
        DesiredOccurrence(
          scheduleId: schedule.id,
          firesAt: due,
          title: '$label ${plant.nickname}',
          body: 'Time to ${label.toLowerCase()} your ${plant.nickname}.',
          payload: schedule.userPlantId,
        ),
      );
    }
    return occurrences;
  }

  /// Overlay a "remind me later" snooze on the cadence's natural due date. The snooze
  /// only wins when it is *later* than the natural date: once the user logs the care, the
  /// natural date advances past the (now stale) snooze, which quietly supersedes it — so
  /// a snooze is self-clearing and never strands a plant earlier than its real schedule.
  tz.TZDateTime _applySnooze(
    DateTime? snoozedUntil,
    tz.TZDateTime naturalDue,
    String tzId,
  ) {
    if (snoozedUntil == null) return naturalDue;
    final snooze = tz.TZDateTime.from(snoozedUntil, tz.getLocation(tzId));
    return snooze.isAfter(naturalDue) ? snooze : naturalDue;
  }

  Future<CareLog?> _latestLog(String plantId, CareType type) {
    return (_db.select(_db.careLogs)
          ..where((l) =>
              l.userPlantId.equals(plantId) &
              l.type.equalsValue(type) &
              l.deletedAt.isNull())
          ..orderBy([(l) => OrderingTerm.desc(l.performedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  String _careLabel(CareType type) => switch (type) {
        CareType.water => 'Water',
        CareType.fertilize => 'Fertilize',
        CareType.mist => 'Mist',
        CareType.repot => 'Repot',
        CareType.rotate => 'Rotate',
        CareType.prune => 'Prune',
        CareType.clean => 'Clean',
        CareType.inspect => 'Inspect',
      };
}
