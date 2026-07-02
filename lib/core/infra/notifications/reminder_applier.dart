import '../../domain/ports/notification_port.dart';
import '../../domain/services/reconciler.dart';

/// Executes a [ReconcilePlan] against a [NotificationPort].
///
/// Cancels are applied before schedules so that an id freed by a cancel can be safely
/// reused by a schedule in the same plan without ever being live on two reminders at
/// once.
class ReminderApplier {
  const ReminderApplier(this._port);

  final NotificationPort _port;

  Future<void> apply(ReconcilePlan plan) async {
    for (final osId in plan.toCancel) {
      await _port.cancel(osId);
    }
    for (final reminder in plan.toSchedule) {
      await _port.schedule(reminder);
    }
  }
}
