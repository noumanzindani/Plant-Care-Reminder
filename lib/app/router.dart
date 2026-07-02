import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/journal/presentation/journal_screen.dart';
import '../features/plants/presentation/add_plant_screen.dart';
import '../features/plants/presentation/home_screen.dart';
import '../features/plants/presentation/plant_detail_screen.dart';

/// Route name constants — referenced instead of raw path strings so renames are safe.
abstract class Routes {
  static const home = '/';
  static const addPlant = '/add-plant';
  static const journal = '/journal';

  /// Path pattern for the plant detail route (has an `:id` parameter).
  static const plantPattern = '/plant/:id';

  /// Build a concrete plant-detail location for [plantId].
  static String plant(String plantId) => '/plant/$plantId';
}

/// The in-app location a tapped care notification should open, or null if [payload]
/// carries no navigable target. A reminder's payload is the plant's id (stamped by the
/// OccurrenceBuilder), so a tap deep-links to that plant's detail screen. A missing or
/// blank payload yields null — the caller then simply doesn't navigate.
String? notificationRouteFor(String? payload) {
  final id = payload?.trim() ?? '';
  if (id.isEmpty) return null;
  return Routes.plant(id);
}

/// The app's [GoRouter], exposed as a provider so route guards (auth, paywall — later
/// phases) can read other providers. Deep links from a tapped care notification will
/// resolve here.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.addPlant,
        builder: (context, state) => const AddPlantScreen(),
      ),
      GoRoute(
        path: Routes.journal,
        builder: (context, state) => const JournalScreen(),
      ),
      GoRoute(
        path: Routes.plantPattern,
        builder: (context, state) =>
            PlantDetailScreen(plantId: state.pathParameters['id']!),
      ),
    ],
  );
});
