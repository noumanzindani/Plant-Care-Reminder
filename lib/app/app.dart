import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Root widget. Wires the router + theme, and reconciles reminders whenever the app
/// returns to the foreground (the user may have completed tasks elsewhere, time has
/// passed, or the OS dropped scheduled alarms).
class PlantCareApp extends ConsumerStatefulWidget {
  const PlantCareApp({super.key});

  @override
  ConsumerState<PlantCareApp> createState() => _PlantCareAppState();
}

class _PlantCareAppState extends ConsumerState<PlantCareApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Fire-and-forget: recompute next-due and refill the rolling notification window.
      ref.read(reconcileCoordinatorProvider).reconcile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Plantner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
