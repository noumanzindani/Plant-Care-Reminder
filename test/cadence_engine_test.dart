// Pure-Dart tests for the cadence engine — the core "when is this care task next
// due?" math. Runs under the default test binding (no widgets), with a real timezone
// database so DST behaviour is exercised for real.

import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:plant_care_reminder/core/domain/services/cadence_engine.dart';
import 'package:plant_care_reminder/core/domain/value_objects/enums.dart';

void main() {
  setUpAll(tz_data.initializeTimeZones);

  const engine = CadenceEngine();

  test('fromLastDone: next due is the last-performed date plus interval, at the set time', () {
    final ny = tz.getLocation('America/New_York');

    final request = CadenceRequest(
      baseIntervalDays: 7,
      anchor: AnchorMode.fromLastDone,
      timeOfDayMinutes: 9 * 60, // 09:00 local
      tzId: 'America/New_York',
      createdAt: DateTime.utc(2026, 1, 1),
      lastPerformedAt: tz.TZDateTime(ny, 2026, 6, 1, 14, 30), // watered June 1 @ 2:30pm
    );

    final due = engine.nextDue(request, tz.TZDateTime(ny, 2026, 6, 1, 15, 0));

    // 7 days after June 1 = June 8, pinned to 09:00 New York time.
    expect(due, tz.TZDateTime(ny, 2026, 6, 8, 9, 0));
  });

  test('fixedCalendar: next due is the next grid slot after now, ignoring last done', () {
    final ny = tz.getLocation('America/New_York');

    final request = CadenceRequest(
      baseIntervalDays: 30,
      anchor: AnchorMode.fixedCalendar,
      timeOfDayMinutes: 8 * 60, // 08:00
      tzId: 'America/New_York',
      createdAt: tz.TZDateTime(ny, 2026, 1, 1, 8, 0), // grid: Jan 1, Jan 31, Mar 2, ...
      lastPerformedAt: tz.TZDateTime(ny, 2026, 2, 15), // done recently — must NOT shift grid
    );

    final due = engine.nextDue(request, tz.TZDateTime(ny, 2026, 2, 10, 12, 0));

    // Grid points: Jan 1, Jan 31, Mar 2. First one at/after Feb 10 is Mar 2 @ 08:00.
    expect(due, tz.TZDateTime(ny, 2026, 3, 2, 8, 0));
  });

  test('seasonal multiplier stretches the interval based on the anchor-date season', () {
    final ny = tz.getLocation('America/New_York');

    final request = CadenceRequest(
      baseIntervalDays: 7,
      anchor: AnchorMode.fromLastDone,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
      createdAt: DateTime.utc(2026, 1, 1),
      lastPerformedAt: tz.TZDateTime(ny, 2026, 1, 15, 9, 0), // January → winter (N. hem.)
      seasonalMultipliers: {Season.winter: 2.0},
    );

    final due = engine.nextDue(request, tz.TZDateTime(ny, 2026, 1, 15, 10, 0));

    // Winter ×2 → effective 14-day interval → Jan 15 + 14 = Jan 29 @ 09:00.
    expect(due, tz.TZDateTime(ny, 2026, 1, 29, 9, 0));
  });

  // --- Regression guards for the design's core guarantees ---

  test('DST: a 09:00 reminder stays at 09:00 local across spring-forward', () {
    final ny = tz.getLocation('America/New_York');

    final request = CadenceRequest(
      baseIntervalDays: 7,
      anchor: AnchorMode.fromLastDone,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
      createdAt: DateTime.utc(2026, 1, 1),
      lastPerformedAt: tz.TZDateTime(ny, 2026, 3, 3, 9, 0), // EST (-05:00)
    );

    // US DST springs forward on 2026-03-08. Seven days after Mar 3 is Mar 10 — the
    // reminder must still be 09:00 LOCAL (EDT, -04:00), NOT 10:00. Storing a UTC instant
    // and adding 7*24h would drift it to 10:00; storing wall-clock + tzId does not.
    final due = engine.nextDue(request, tz.TZDateTime(ny, 2026, 3, 3, 10, 0));

    expect(due, tz.TZDateTime(ny, 2026, 3, 10, 9, 0));
    expect(due.hour, 9);
    expect(due.timeZoneOffset, const Duration(hours: -4)); // EDT, post spring-forward
  });

  test('fromLastDone: first due (never performed) anchors to createdAt', () {
    final ny = tz.getLocation('America/New_York');

    final request = CadenceRequest(
      baseIntervalDays: 3,
      anchor: AnchorMode.fromLastDone,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
      createdAt: tz.TZDateTime(ny, 2026, 5, 1, 12, 0),
      lastPerformedAt: null, // never watered
    );

    final due = engine.nextDue(request, tz.TZDateTime(ny, 2026, 5, 1, 12, 0));

    // 3 days after the May 1 creation date, at 09:00.
    expect(due, tz.TZDateTime(ny, 2026, 5, 4, 9, 0));
  });
}
