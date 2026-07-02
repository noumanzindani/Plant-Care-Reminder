// Pure-Dart tests for the reconciler — the engine that diffs the DESIRED set of
// reminders (computed from schedules) against what the OS currently holds, respecting
// the rolling window under iOS's 64-notification cap. No widgets, no real notifications.

import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:plant_care_reminder/core/domain/services/reconciler.dart';

void main() {
  // Initialize the tz database up front (not in setUpAll) because `ny` below is
  // resolved during test registration, before setUpAll would run.
  tz_data.initializeTimeZones();

  const reconciler = Reconciler();
  final ny = tz.getLocation('America/New_York');

  DesiredOccurrence occ(String id, tz.TZDateTime at) =>
      DesiredOccurrence(scheduleId: id, firesAt: at, title: 'Water $id', body: 'Time to water');

  test('schedules a new desired occurrence when the registry is empty', () {
    final plan = reconciler.reconcile(
      desired: [occ('s1', tz.TZDateTime(ny, 2026, 6, 8, 9, 0))],
      current: const [],
    );

    expect(plan.toCancel, isEmpty);
    expect(plan.toSchedule, hasLength(1));
    expect(plan.toSchedule.single.scheduleId, 's1');
    expect(plan.toSchedule.single.firesAt, tz.TZDateTime(ny, 2026, 6, 8, 9, 0));
    expect(plan.toSchedule.single.osId, isPositive);
  });

  RegisteredNotification reg(int osId, String id, tz.TZDateTime at) =>
      RegisteredNotification(
        osId: osId,
        scheduleId: id,
        firesAt: at,
        fingerprint: Reconciler.fingerprintFor(id, at),
      );

  test('is a no-op when the desired set already matches the registry', () {
    final at = tz.TZDateTime(ny, 2026, 6, 8, 9, 0);

    final plan = reconciler.reconcile(
      desired: [occ('s1', at)],
      current: [reg(1, 's1', at)],
    );

    expect(plan.toCancel, isEmpty);
    expect(plan.toSchedule, isEmpty);
  });

  test('caps scheduling at the rolling window, keeping the nearest occurrences', () {
    const windowed = Reconciler(windowSize: 3);

    final plan = windowed.reconcile(
      desired: [
        occ('s1', tz.TZDateTime(ny, 2026, 6, 5, 9, 0)),
        occ('s2', tz.TZDateTime(ny, 2026, 6, 3, 9, 0)),
        occ('s3', tz.TZDateTime(ny, 2026, 6, 1, 9, 0)),
        occ('s4', tz.TZDateTime(ny, 2026, 6, 9, 9, 0)), // furthest — dropped
        occ('s5', tz.TZDateTime(ny, 2026, 6, 7, 9, 0)), // dropped
      ],
      current: const [],
    );

    // Nearest 3 by firesAt: Jun 1 (s3), Jun 3 (s2), Jun 5 (s1).
    expect(plan.toSchedule, hasLength(3));
    expect(plan.toSchedule.map((s) => s.scheduleId).toSet(), {'s1', 's2', 's3'});
  });

  test('cancels a registered notification that has fallen outside the window', () {
    const windowed = Reconciler(windowSize: 1);
    final near = tz.TZDateTime(ny, 2026, 6, 1, 9, 0);
    final far = tz.TZDateTime(ny, 2026, 6, 9, 9, 0);

    // The OS still holds the far one, but it's now outside the window → cancel it,
    // schedule the near one instead.
    final plan = windowed.reconcile(
      desired: [occ('near', near), occ('far', far)],
      current: [reg(42, 'far', far)],
    );

    expect(plan.toCancel, [42]);
    expect(plan.toSchedule.single.scheduleId, 'near');
  });

  test('reschedules when the due time changes: cancel old id, schedule new time', () {
    final oldAt = tz.TZDateTime(ny, 2026, 6, 8, 9, 0);
    final newAt = tz.TZDateTime(ny, 2026, 6, 10, 9, 0);

    final plan = reconciler.reconcile(
      desired: [occ('s1', newAt)],
      current: [reg(7, 's1', oldAt)],
    );

    expect(plan.toCancel, [7]);
    expect(plan.toSchedule.single.firesAt, newAt);
  });

  test('allocates a new id that does not collide with a still-live notification', () {
    final at1 = tz.TZDateTime(ny, 2026, 6, 1, 9, 0);
    final at2 = tz.TZDateTime(ny, 2026, 6, 2, 9, 0);

    // s1 already scheduled as id 1 (kept); s2 is new and must not reuse id 1.
    final plan = reconciler.reconcile(
      desired: [occ('s1', at1), occ('s2', at2)],
      current: [reg(1, 's1', at1)],
    );

    expect(plan.toCancel, isEmpty);
    expect(plan.toSchedule.single.scheduleId, 's2');
    expect(plan.toSchedule.single.osId, isNot(1));
  });
}
