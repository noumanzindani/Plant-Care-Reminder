import 'package:timezone/timezone.dart' as tz;

import '../ports/notification_port.dart';

/// A reminder the schedule *wants* the OS to hold, before an OS id is allocated.
class DesiredOccurrence {
  const DesiredOccurrence({
    required this.scheduleId,
    required this.firesAt,
    required this.title,
    required this.body,
    this.payload,
  });

  final String scheduleId;
  final tz.TZDateTime firesAt;
  final String title;
  final String body;
  final String? payload;

  /// Identity for diffing: two occurrences are "the same" iff same schedule + instant.
  String get fingerprint => Reconciler.fingerprintFor(scheduleId, firesAt);
}

/// A reminder the OS currently holds (mirrored in the local NotificationRegistry table).
class RegisteredNotification {
  const RegisteredNotification({
    required this.osId,
    required this.scheduleId,
    required this.firesAt,
    required this.fingerprint,
  });

  final int osId;
  final String scheduleId;
  final DateTime firesAt;
  final String fingerprint;
}

/// The delta the caller applies: cancel these OS ids, schedule these reminders.
class ReconcilePlan {
  const ReconcilePlan({required this.toCancel, required this.toSchedule});

  final List<int> toCancel;
  final List<ScheduledReminder> toSchedule;
}

/// Diffs the desired reminder set against what the OS holds and returns the minimal
/// set of cancels + schedules to bring them into agreement, capped at [windowSize] to
/// stay safely under iOS's 64 pending-notification limit.
///
/// Pure: no side effects, no Flutter, no notification plugin. A thin applier layer maps
/// the returned [ReconcilePlan] onto a [NotificationPort].
class Reconciler {
  const Reconciler({this.windowSize = 56});

  /// The maximum number of reminders held in the OS at once. 56 leaves headroom under
  /// iOS's hard cap of 64 for one-off/system notifications and snooze churn.
  final int windowSize;

  static String fingerprintFor(String scheduleId, DateTime firesAt) =>
      '$scheduleId@${firesAt.millisecondsSinceEpoch}';

  ReconcilePlan reconcile({
    required List<DesiredOccurrence> desired,
    required List<RegisteredNotification> current,
  }) {
    // Only the nearest [windowSize] occurrences are ever resident in the OS; the long
    // tail stays in the DB and materializes as nearer events fire and free slots.
    final window = ([...desired]..sort((a, b) => a.firesAt.compareTo(b.firesAt)))
        .take(windowSize)
        .toList();

    final desiredByFingerprint = {for (final o in window) o.fingerprint: o};
    final currentByFingerprint = {for (final c in current) c.fingerprint: c};

    // Cancel anything the OS holds that is no longer desired; keep matching ones' ids
    // reserved so re-allocation never collides with a live notification.
    final toCancel = <int>[];
    final reservedIds = <int>{};
    for (final c in current) {
      if (desiredByFingerprint.containsKey(c.fingerprint)) {
        reservedIds.add(c.osId);
      } else {
        toCancel.add(c.osId);
      }
    }

    // Schedule desired occurrences the OS doesn't already hold, allocating the smallest
    // free id (a recyclable pool — not a hashCode, which could collide/overflow).
    var candidate = 1;
    int allocateId() {
      while (reservedIds.contains(candidate)) {
        candidate++;
      }
      reservedIds.add(candidate);
      return candidate;
    }

    final toSchedule = [
      for (final o in window)
        if (!currentByFingerprint.containsKey(o.fingerprint))
          ScheduledReminder(
            osId: allocateId(),
            scheduleId: o.scheduleId,
            firesAt: o.firesAt,
            title: o.title,
            body: o.body,
            payload: o.payload,
          ),
    ];

    return ReconcilePlan(toCancel: toCancel, toSchedule: toSchedule);
  }
}
