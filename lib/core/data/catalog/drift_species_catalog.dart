import 'package:drift/drift.dart';

import '../../domain/ports/species_catalog_port.dart';
import '../db/database.dart';

/// The local, Drift-backed implementation of [SpeciesCatalogPort]. Searches the seeded
/// [Species] table by common or scientific name. The remote Perenual-backed adapter will
/// implement the same interface, so swapping catalogs is a provider change, not a rewrite.
class DriftSpeciesCatalog implements SpeciesCatalogPort {
  DriftSpeciesCatalog(this._db);

  final AppDatabase _db;

  @override
  Future<List<SpeciesSummary>> search(String query, {int limit = 20}) async {
    final q = query.trim().toLowerCase();
    final select = _db.select(_db.species);
    if (q.isNotEmpty) {
      final pattern = '%$q%';
      select.where((s) =>
          s.commonName.lower().like(pattern) |
          s.scientificName.lower().like(pattern));
    }
    select
      ..orderBy([(s) => OrderingTerm(expression: s.commonName)])
      ..limit(limit);

    final rows = await select.get();
    return [
      for (final r in rows)
        SpeciesSummary(
          id: r.id,
          scientificName: r.scientificName,
          commonName: r.commonName,
        ),
    ];
  }

  @override
  Future<SpeciesDetail?> getById(String id) async {
    final row = await (_db.select(_db.species)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return SpeciesDetail(
      id: row.id,
      scientificName: row.scientificName,
      commonName: row.commonName,
      family: row.family,
      care: CareDefaults(
        wateringIntervalDays: row.wateringIntervalDays,
        fertilizeIntervalDays: row.fertilizeIntervalDays,
      ),
      light: row.lightLevel,
      toxicToPets: row.toxicToPets,
    );
  }
}
