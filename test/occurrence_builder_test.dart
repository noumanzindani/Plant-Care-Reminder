// Pure-Dart data test (no widgets) for the occurrence builder: the bridge that turns
// Drift schedules + the latest care log into the DesiredOccurrence list the reconciler
// consumes, via the cadence engine.

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:plant_care_reminder/core/data/db/database.dart';
import 'package:plant_care_reminder/core/data/reminders/occurrence_builder.dart';
import 'package:plant_care_reminder/core/domain/ports/weather_port.dart';
import 'package:plant_care_reminder/core/domain/services/cadence_engine.dart';
import 'package:plant_care_reminder/core/domain/value_objects/enums.dart';
import 'package:plant_care_reminder/core/domain/value_objects/weather_forecast.dart';

void main() {
  tz_data.initializeTimeZones();
  final ny = tz.getLocation('America/New_York');

  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> seedRoom(String id, {required bool outdoor}) =>
      db.into(db.rooms).insert(
            RoomsCompanion.insert(
              id: id,
              name: 'Room $id',
              outdoor: Value(outdoor),
              createdAt: DateTime.utc(2026, 1, 1),
              updatedAt: DateTime.utc(2026, 1, 1),
            ),
          );

  Future<void> seedPlant(String id, String nickname, {String? roomId}) =>
      db.plantsDao.insertPlant(
        UserPlantsCompanion.insert(
          id: id,
          nickname: nickname,
          roomId: Value(roomId),
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      );

  Future<void> seedSchedule(
    String id,
    String plantId, {
    int interval = 7,
    bool weatherSensitive = false,
  }) =>
      db.into(db.careSchedules).insert(
            CareSchedulesCompanion.insert(
              id: id,
              userPlantId: plantId,
              type: CareType.water,
              baseIntervalDays: interval,
              weatherSensitive: Value(weatherSensitive),
              tzId: 'America/New_York',
              createdAt: DateTime.utc(2026, 1, 1),
              updatedAt: DateTime.utc(2026, 1, 1),
            ),
          );

  Future<void> seedLog(String id, String plantId, tz.TZDateTime performedAt) =>
      db.into(db.careLogs).insert(
            CareLogsCompanion.insert(
              id: id,
              userPlantId: plantId,
              type: CareType.water,
              performedAt: performedAt,
              createdAt: DateTime.utc(2026, 6, 1),
              updatedAt: DateTime.utc(2026, 6, 1),
            ),
          );

  test('builds an occurrence anchored to the latest care log', () async {
    await seedPlant('p1', 'Monstera');
    await seedSchedule('sch1', 'p1');
    await seedLog('log1', 'p1', tz.TZDateTime(ny, 2026, 6, 1, 9, 0));

    final builder = OccurrenceBuilder(db, const CadenceEngine());
    final occurrences = await builder.build(tz.TZDateTime(ny, 2026, 6, 1, 10, 0));

    expect(occurrences, hasLength(1));
    expect(occurrences.single.scheduleId, 'sch1');
    // Watered Jun 1 → next due Jun 8 @ 09:00 (default reminder time).
    expect(occurrences.single.firesAt, tz.TZDateTime(ny, 2026, 6, 8, 9, 0));
    expect(occurrences.single.title, contains('Monstera'));
  });

  test('snooze defers the reminder past the natural due date', () async {
    await seedPlant('p1', 'Monstera');
    await seedSchedule('sch1', 'p1'); // interval 7
    await seedLog('log1', 'p1', tz.TZDateTime(ny, 2026, 6, 1, 9, 0)); // natural: Jun 8 09:00
    // User snoozes until Jun 9 09:00 EDT (13:00 UTC) — later than the natural due date.
    await (db.update(db.careSchedules)..where((s) => s.id.equals('sch1')))
        .write(CareSchedulesCompanion(snoozedUntil: Value(DateTime.utc(2026, 6, 9, 13, 0))));

    final builder = OccurrenceBuilder(db, const CadenceEngine());
    final occurrences = await builder.build(tz.TZDateTime(ny, 2026, 6, 8, 10, 0));

    expect(occurrences.single.firesAt, tz.TZDateTime(ny, 2026, 6, 9, 9, 0));
  });

  test('a snooze earlier than the natural due date is superseded (ignored)', () async {
    await seedPlant('p1', 'Monstera');
    await seedSchedule('sch1', 'p1'); // interval 7
    await seedLog('log1', 'p1', tz.TZDateTime(ny, 2026, 6, 1, 9, 0)); // natural: Jun 8 09:00
    // A stale snooze (Jun 3) from before the plant was re-watered: cadence has moved on.
    await (db.update(db.careSchedules)..where((s) => s.id.equals('sch1')))
        .write(CareSchedulesCompanion(snoozedUntil: Value(DateTime.utc(2026, 6, 3, 13, 0))));

    final builder = OccurrenceBuilder(db, const CadenceEngine());
    final occurrences = await builder.build(tz.TZDateTime(ny, 2026, 6, 1, 10, 0));

    expect(occurrences.single.firesAt, tz.TZDateTime(ny, 2026, 6, 8, 9, 0));
  });

  test('excludes schedules of soft-deleted plants', () async {
    await seedPlant('p1', 'Alive');
    await seedSchedule('sch1', 'p1');
    await seedPlant('p2', 'Deleted');
    await seedSchedule('sch2', 'p2');
    // Soft-delete p2.
    await (db.update(db.userPlants)..where((t) => t.id.equals('p2')))
        .write(UserPlantsCompanion(deletedAt: Value(DateTime.utc(2026, 5, 1))));

    final builder = OccurrenceBuilder(db, const CadenceEngine());
    final occurrences = await builder.build(tz.TZDateTime(ny, 2026, 6, 1, 10, 0));

    expect(occurrences.map((o) => o.scheduleId), ['sch1']);
  });

  test('weather-sensitive outdoor schedule: rain defers the watering', () async {
    await seedRoom('r1', outdoor: true);
    await seedPlant('p1', 'Fern', roomId: 'r1');
    await seedSchedule('sch1', 'p1', weatherSensitive: true);
    await seedLog('log1', 'p1', tz.TZDateTime(ny, 2026, 6, 1, 9, 0)); // natural: Jun 8

    final builder = OccurrenceBuilder(
      db,
      const CadenceEngine(),
      weather: const _FakeWeatherPort(
        WeatherForecast(expectedRainMm: 12, highTempC: 21, humidityPct: 55),
      ),
    );
    final occurrences = await builder.build(tz.TZDateTime(ny, 2026, 6, 1, 10, 0));

    // Natural Jun 8 + 3-day rain delay = Jun 11.
    expect(occurrences.single.firesAt, tz.TZDateTime(ny, 2026, 6, 11, 9, 0));
  });

  test('a non-weather-sensitive schedule ignores the forecast', () async {
    await seedRoom('r1', outdoor: true);
    await seedPlant('p1', 'Cactus', roomId: 'r1');
    await seedSchedule('sch1', 'p1'); // weatherSensitive defaults to false
    await seedLog('log1', 'p1', tz.TZDateTime(ny, 2026, 6, 1, 9, 0)); // natural: Jun 8

    final builder = OccurrenceBuilder(
      db,
      const CadenceEngine(),
      weather: const _FakeWeatherPort(
        WeatherForecast(expectedRainMm: 40, highTempC: 21, humidityPct: 55),
      ),
    );
    final occurrences = await builder.build(tz.TZDateTime(ny, 2026, 6, 1, 10, 0));

    // Not weather-sensitive → base cadence (Jun 8), despite the heavy rain.
    expect(occurrences.single.firesAt, tz.TZDateTime(ny, 2026, 6, 8, 9, 0));
  });

  test('a null forecast (offline / permission denied) falls back to base cadence', () async {
    await seedRoom('r1', outdoor: true);
    await seedPlant('p1', 'Fern', roomId: 'r1');
    await seedSchedule('sch1', 'p1', weatherSensitive: true);
    await seedLog('log1', 'p1', tz.TZDateTime(ny, 2026, 6, 1, 9, 0)); // natural: Jun 8

    final builder = OccurrenceBuilder(
      db,
      const CadenceEngine(),
      weather: const _FakeWeatherPort(null), // no forecast available
    );
    final occurrences = await builder.build(tz.TZDateTime(ny, 2026, 6, 1, 10, 0));

    expect(occurrences.single.firesAt, tz.TZDateTime(ny, 2026, 6, 8, 9, 0));
  });

  test('weather-sensitive indoor schedule: rain is ignored (outdoor flag from room)', () async {
    await seedRoom('r1', outdoor: false); // indoor room
    await seedPlant('p1', 'Pothos', roomId: 'r1');
    await seedSchedule('sch1', 'p1', weatherSensitive: true);
    await seedLog('log1', 'p1', tz.TZDateTime(ny, 2026, 6, 1, 9, 0)); // natural: Jun 8

    final builder = OccurrenceBuilder(
      db,
      const CadenceEngine(),
      weather: const _FakeWeatherPort(
        WeatherForecast(expectedRainMm: 40, highTempC: 21, humidityPct: 55),
      ),
    );
    final occurrences = await builder.build(tz.TZDateTime(ny, 2026, 6, 1, 10, 0));

    // Rain can't reach an indoor plant; mild temp/humidity → base cadence (Jun 8).
    expect(occurrences.single.firesAt, tz.TZDateTime(ny, 2026, 6, 8, 9, 0));
  });
}

/// A canned forecast (or null) so the builder's weather integration is exercised without
/// any network or plugin.
class _FakeWeatherPort implements WeatherPort {
  const _FakeWeatherPort(this._forecast);

  final WeatherForecast? _forecast;

  @override
  Future<WeatherForecast?> forecast() async => _forecast;
}
