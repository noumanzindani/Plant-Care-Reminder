import 'dart:io';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '../../data/db/database.dart';
import '../../data/reminders/reconcile_coordinator.dart';
import '../notifications/local_notifications_adapter.dart';

/// Background reconcile: keeps reminders correct even when the app is not open.
///
/// On Android, scheduled alarms are dropped on reboot and the OS may kill the app, so a
/// periodic WorkManager job re-runs the reconciler — which rebuilds the OS notification
/// set from the Drift source of truth. WorkManager also re-registers this job after a
/// reboot, so it doubles as the post-reboot recovery path.
///
/// The callback runs in a **separate isolate** with no Riverpod/UI, so everything here
/// is cold-initialized from scratch.

const _uniqueName = 'plantner.reconcile.periodic';
const _taskName = 'reconcile';

/// Entry point WorkManager invokes in the background isolate. Must be a top-level
/// function marked as a VM entry point so tree-shaking keeps it.
@pragma('vm:entry-point')
void reminderCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await runBackgroundReconcile();
    return true;
  });
}

/// Cold-initialize the minimum stack and run one reconcile pass. Safe to call from a
/// fresh isolate: no shared singletons are assumed.
Future<void> runBackgroundReconcile() async {
  tz_data.initializeTimeZones();
  try {
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
  } catch (_) {
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  final db = AppDatabase();
  try {
    final notifications = LocalNotificationsAdapter();
    await notifications.init();
    await ReconcileCoordinator(db: db, port: notifications).reconcile();
  } finally {
    await db.close();
  }
}

/// Initialize WorkManager and register the periodic reconcile job.
///
/// Android only for now: iOS keeps scheduled notifications across reboot, and a proper
/// iOS BGTaskScheduler setup (Info.plist identifiers) is a separate follow-up.
Future<void> registerBackgroundReconcile() async {
  if (!Platform.isAndroid) return;
  await Workmanager().initialize(reminderCallbackDispatcher);
  await Workmanager().registerPeriodicTask(
    _uniqueName,
    _taskName,
    frequency: const Duration(hours: 6),
    // Keep the existing schedule across app launches; don't stack duplicates.
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    constraints: Constraints(networkType: NetworkType.notRequired),
  );
}
