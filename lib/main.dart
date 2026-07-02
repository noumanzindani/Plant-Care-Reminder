import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'app/app.dart';
import 'app/providers.dart';
import 'app/router.dart';
import 'core/infra/background/background_reconcile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Timezone database must be initialized before any reminder scheduling. The reminder
  // engine stores wall-clock time + an IANA zone and reconstructs a TZDateTime on every
  // reconcile — this is what keeps reminders DST-correct.
  tz_data.initializeTimeZones();
  try {
    final localZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localZone.identifier));
  } catch (_) {
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  // A single container so we can initialize notifications and run the first reconcile
  // (scheduling any already-due reminders) before the UI appears.
  final container = ProviderContainer();
  try {
    // Populate the bundled species catalog (idempotent + version-gated, so this is a
    // single cursor read on subsequent launches). Enables offline species search.
    await container.read(catalogSeederProvider).seedIfNeeded();

    final router = container.read(routerProvider);
    final notifications = container.read(notificationAdapterProvider);
    // A tap on a reminder while the app is running deep-links to that plant's detail.
    await notifications.init(
      onTap: (payload) {
        final location = notificationRouteFor(payload);
        if (location != null) router.go(location);
      },
    );
    await notifications.requestPermissions();
    await container.read(reconcileCoordinatorProvider).reconcile();
    // Safety-net + post-reboot recovery: a periodic background reconcile (Android).
    await registerBackgroundReconcile();

    // Cold start via a tapped reminder (app was terminated): deep-link to that plant once
    // the first frame is up and the router is attached.
    final launchLocation =
        notificationRouteFor(await notifications.notificationLaunchPayload());
    if (launchLocation != null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => router.go(launchLocation));
    }
  } catch (_) {
    // Never block app launch on notification setup — the offline core still works.
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const PlantCareApp(),
    ),
  );
}
