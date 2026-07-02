import 'package:drift/drift.dart';

import '../../../domain/value_objects/enums.dart';
import '../database.dart';
import '../tables.dart';

part 'plants_dao.g.dart';

/// Data-access for a user's plant collection.
///
/// Everything the UI needs is exposed as a reactive `Stream` (Drift `.watch()`),
/// so screens rebuild automatically when the underlying rows change — no manual
/// refresh calls. Mutations are the entry points that (in Phase 1+) will also append
/// to the Outbox and trigger a reconcile.
@DriftAccessor(tables: [UserPlants, Rooms])
class PlantsDao extends DatabaseAccessor<AppDatabase> with _$PlantsDaoMixin {
  PlantsDao(super.db);

  /// Live list of non-deleted, active plants, newest first.
  Stream<List<UserPlant>> watchActivePlants() {
    return (select(userPlants)
          ..where((p) => p.deletedAt.isNull() & p.status.equalsValue(PlantStatus.active))
          ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
        .watch();
  }

  /// Live count of active plants — used by the free-tier plant cap and the home header.
  Stream<int> watchActivePlantCount() {
    final count = userPlants.id.count();
    final query = selectOnly(userPlants)
      ..addColumns([count])
      ..where(userPlants.deletedAt.isNull() &
          userPlants.status.equalsValue(PlantStatus.active));
    return query.map((row) => row.read(count) ?? 0).watchSingle();
  }

  /// Live single plant by id (null once soft-deleted or absent). Drives the plant detail
  /// header — kept independent of the schedule list so a plant with zero active care
  /// types still shows its name.
  Stream<UserPlant?> watchPlant(String id) {
    return (select(userPlants)
          ..where((p) => p.id.equals(id) & p.deletedAt.isNull())
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Insert a new plant row. Callers pass a fully-formed companion (with a
  /// client-generated UUID id and timestamps).
  Future<void> insertPlant(UserPlantsCompanion plant) =>
      into(userPlants).insert(plant);
}
