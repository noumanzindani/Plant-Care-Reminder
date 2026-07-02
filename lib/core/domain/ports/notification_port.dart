/// The seam between the reminder engine and the OS notification system.
///
/// The reconciler (Phase 1) depends on THIS interface, never on
/// `flutter_local_notifications`. That is what lets the scheduling logic run in a
/// background isolate and be unit-tested with a fake implementation.
///
/// Pure Dart: no Flutter, no plugins.
library;

/// One OS-level scheduled reminder. [osId] is a recyclable 32-bit id the
/// [NotificationPort] hands to the platform; [scheduleId] is the domain
/// `CareSchedule` it belongs to (carried as the notification payload so a tap can
/// deep-link back to the plant).
class ScheduledReminder {
  const ScheduledReminder({
    required this.osId,
    required this.scheduleId,
    required this.firesAt,
    required this.title,
    required this.body,
    this.payload,
  });

  final int osId;
  final String scheduleId;
  final DateTime firesAt;
  final String title;
  final String body;
  final String? payload;
}

/// Schedules and cancels local notifications. Implementations mirror what the OS
/// actually holds; the reconciler keeps that mirror in sync with the desired set.
abstract interface class NotificationPort {
  /// Schedule (or replace) a single reminder at [ScheduledReminder.firesAt].
  Future<void> schedule(ScheduledReminder reminder);

  /// Cancel one previously-scheduled reminder by its OS id.
  Future<void> cancel(int osId);

  /// Cancel every pending reminder this app scheduled (used on reset/logout).
  Future<void> cancelAll();

  /// The set of OS ids the platform currently has pending — used to reconcile the
  /// mirror against reality after a reboot or external clear.
  Future<List<int>> pendingIds();
}
