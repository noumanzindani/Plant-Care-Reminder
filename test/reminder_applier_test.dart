// Pure test for the applier: it executes a ReconcilePlan against a NotificationPort.
// The ordering guarantee (cancel BEFORE schedule) is what makes id recycling safe —
// a cancelled id can be reused in the same plan without ever being live twice.

import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:plant_care_reminder/core/domain/ports/notification_port.dart';
import 'package:plant_care_reminder/core/domain/services/reconciler.dart';
import 'package:plant_care_reminder/core/infra/notifications/reminder_applier.dart';

/// Fake port that records the exact sequence of calls it receives.
class RecordingNotificationPort implements NotificationPort {
  final List<String> calls = [];

  @override
  Future<void> schedule(ScheduledReminder r) async => calls.add('schedule:${r.osId}');

  @override
  Future<void> cancel(int osId) async => calls.add('cancel:$osId');

  @override
  Future<void> cancelAll() async => calls.add('cancelAll');

  @override
  Future<List<int>> pendingIds() async => const [];
}

void main() {
  tz_data.initializeTimeZones();
  final ny = tz.getLocation('America/New_York');

  test('applies cancels before schedules', () async {
    final port = RecordingNotificationPort();
    final applier = ReminderApplier(port);

    final plan = ReconcilePlan(
      toCancel: [7, 8],
      toSchedule: [
        ScheduledReminder(
          osId: 1,
          scheduleId: 's1',
          firesAt: tz.TZDateTime(ny, 2026, 6, 8, 9, 0),
          title: 'Water Monstera',
          body: 'Time to water',
        ),
      ],
    );

    await applier.apply(plan);

    expect(port.calls, ['cancel:7', 'cancel:8', 'schedule:1']);
  });
}
