import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/data/catalog/catalog_seeder.dart';
import '../core/data/catalog/drift_species_catalog.dart';
import '../core/data/db/database.dart';
import '../core/data/db/database_provider.dart';
import '../core/data/reminders/reconcile_coordinator.dart';
import '../core/data/repositories/care_repository.dart';
import '../core/data/repositories/rooms_repository.dart';
import '../core/domain/ports/notification_port.dart';
import '../core/domain/ports/species_catalog_port.dart';
import '../core/infra/notifications/local_notifications_adapter.dart';

/// The concrete notifications adapter (exposes init/requestPermissions for bootstrap).
final notificationAdapterProvider =
    Provider<LocalNotificationsAdapter>((ref) => LocalNotificationsAdapter());

/// The adapter seen through the domain port — what the engine depends on.
final notificationPortProvider =
    Provider<NotificationPort>((ref) => ref.watch(notificationAdapterProvider));

/// Write side of the plant collection.
final careRepositoryProvider =
    Provider<CareRepository>((ref) => CareRepository(ref.watch(appDatabaseProvider)));

/// Rooms (locations plants are grouped by).
final roomsRepositoryProvider =
    Provider<RoomsRepository>((ref) => RoomsRepository(ref.watch(appDatabaseProvider)));

/// The species catalog, behind its port (local Drift-backed adapter for now).
final speciesCatalogProvider = Provider<SpeciesCatalogPort>(
  (ref) => DriftSpeciesCatalog(ref.watch(appDatabaseProvider)),
);

/// Loads the bundled catalog seed on first run (idempotent, version-gated).
final catalogSeederProvider =
    Provider<CatalogSeeder>((ref) => CatalogSeeder(ref.watch(appDatabaseProvider)));

/// The reminder engine's single entry point.
final reconcileCoordinatorProvider = Provider<ReconcileCoordinator>(
  (ref) => ReconcileCoordinator(
    db: ref.watch(appDatabaseProvider),
    port: ref.watch(notificationPortProvider),
  ),
);

/// Live care queue (schedule + plant + next-due), soonest first.
final careQueueProvider = StreamProvider.autoDispose<List<CareQueueItem>>(
  (ref) => ref.watch(careRepositoryProvider).watchCareQueue(),
);

/// Live care journal (every care log, newest first).
final journalProvider = StreamProvider.autoDispose<List<JournalEntry>>(
  (ref) => ref.watch(careRepositoryProvider).watchJournal(),
);

/// A single plant by id (for the detail header).
final plantProvider = StreamProvider.autoDispose.family<UserPlant?, String>(
  (ref, plantId) => ref.watch(plantsDaoProvider).watchPlant(plantId),
);

/// One plant's active care schedules (all its care types), soonest-due first.
final plantSchedulesProvider =
    StreamProvider.autoDispose.family<List<CareQueueItem>, String>(
  (ref, plantId) => ref.watch(careRepositoryProvider).watchPlantSchedules(plantId),
);

/// Full catalog detail for a species id (light need, toxicity, family, default cadences) —
/// what the plant detail screen shows for an identified plant. Null if not in the catalog.
final speciesDetailProvider =
    FutureProvider.autoDispose.family<SpeciesDetail?, String>(
  (ref, speciesId) => ref.watch(speciesCatalogProvider).getById(speciesId),
);

/// Live list of rooms, in display order.
final roomsProvider = StreamProvider.autoDispose<List<Room>>(
  (ref) => ref.watch(roomsRepositoryProvider).watchRooms(),
);
