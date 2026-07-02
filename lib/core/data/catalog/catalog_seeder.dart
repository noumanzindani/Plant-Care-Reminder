import 'package:drift/drift.dart';

import '../db/database.dart';
import 'species_seed.dart';

/// Loads the bundled species seed into the local catalog. Idempotent and version-gated:
/// a normal launch is a single cursor read and no writes. When the Perenual-backed remote
/// catalog lands, its delta sync writes into the same [Species] table behind the same
/// port — this seeder just guarantees a useful catalog exists offline from first run.
class CatalogSeeder {
  CatalogSeeder(this._db);

  final AppDatabase _db;

  /// SyncCursors key holding the last-applied seed version.
  static const cursorKey = 'catalog_seed';

  /// Load the bundled catalog only when [version] is newer than what's stored, so normal
  /// launches don't rewrite the table.
  Future<void> seedIfNeeded({
    List<SpeciesSeedRow> seed = kSpeciesSeed,
    int version = kCatalogSeedVersion,
  }) async {
    final cursor = await (_db.select(_db.syncCursors)
          ..where((c) => c.entity.equals(cursorKey)))
        .getSingleOrNull();
    if (cursor != null && cursor.lastRev >= version) return;

    await seedAll(seed);
    await _db.into(_db.syncCursors).insertOnConflictUpdate(
          SyncCursorsCompanion(entity: const Value(cursorKey), lastRev: Value(version)),
        );
  }

  /// Upsert every row of [seed] into the species table (keyed by id), in one transaction.
  Future<void> seedAll(List<SpeciesSeedRow> seed) async {
    final now = DateTime.now();
    await _db.transaction(() async {
      for (final s in seed) {
        await _db.into(_db.species).insertOnConflictUpdate(
              SpeciesCompanion.insert(
                id: s.id,
                scientificName: s.scientificName,
                commonName: s.commonName,
                wateringIntervalDays: s.wateringIntervalDays,
                updatedAt: now,
                family: Value(s.family),
                fertilizeIntervalDays: Value(s.fertilizeIntervalDays),
                lightLevel: Value(s.light),
                toxicToPets: Value(s.toxicToPets),
              ),
            );
      }
    });
  }
}
