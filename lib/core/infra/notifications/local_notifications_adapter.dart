import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/ports/notification_port.dart';

/// The one place the app talks to `flutter_local_notifications`.
///
/// Implements the domain [NotificationPort] so the reminder engine (which depends only
/// on the interface) never sees the plugin. This is also the only component in the
/// engine that requires a real device to exercise — everything upstream is unit-tested.
class LocalNotificationsAdapter implements NotificationPort {
  LocalNotificationsAdapter([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const _channelId = 'care_reminders';
  static const _channelName = 'Care reminders';
  static const _channelDescription = 'Watering, fertilizing and other plant care reminders';

  bool _initialized = false;

  /// Initialize the plugin and create the Android notification channel. Idempotent.
  ///
  /// [onTap] is invoked (on the main isolate) with a tapped reminder's payload when the
  /// user taps a notification while the app is running. Cold-start taps (app launched by
  /// the tap) are delivered separately via [notificationLaunchPayload].
  Future<void> init({void Function(String? payload)? onTap}) async {
    if (_initialized) return;

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        // Defer the prompt — we request permission explicitly at a good moment.
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse:
          onTap == null ? null : (response) => onTap(response.payload),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );

    _initialized = true;
  }

  /// Ask the OS for permission to post notifications (and exact alarms on Android).
  /// Returns true if notifications are permitted.
  Future<bool> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission() ?? false;
      // Exact-alarm permission is best-effort; scheduling falls back to inexact.
      await android.requestExactAlarmsPermission();
      return granted;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return true;
  }

  @override
  Future<void> schedule(ScheduledReminder reminder) async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    // Prefer exact; degrade to inexact if the user hasn't granted exact alarms.
    final canExact = await android?.canScheduleExactNotifications() ?? true;
    final mode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    await _plugin.zonedSchedule(
      id: reminder.osId,
      title: reminder.title,
      body: reminder.body,
      scheduledDate: tz.TZDateTime.from(reminder.firesAt, tz.local),
      androidScheduleMode: mode,
      payload: reminder.payload,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// If the app was launched by tapping a reminder while it was terminated, the payload
  /// of that reminder (the plant's id); otherwise null. Read once at bootstrap to
  /// deep-link straight to the plant.
  Future<String?> notificationLaunchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return details!.notificationResponse?.payload;
    }
    return null;
  }

  @override
  Future<void> cancel(int osId) => _plugin.cancel(id: osId);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  @override
  Future<List<int>> pendingIds() async {
    final pending = await _plugin.pendingNotificationRequests();
    return [for (final p in pending) p.id];
  }
}
