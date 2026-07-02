// Pure-Dart data tests for the offline species catalog: the idempotent seeder and the
// Drift-backed SpeciesCatalogPort adapter (search + getById).

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/catalog/catalog_seeder.dart';
import 'package:plant_care_reminder/core/data/catalog/drift_species_catalog.dart';
import 'package:plant_care_reminder/core/data/catalog/species_seed.dart';
import 'package:plant_care_reminder/core/data/db/database.dart';
import 'package:plant_care_reminder/core/domain/value_objects/enums.dart';

void main() {
  late AppDatabase db;
  late CatalogSeeder seeder;
  late DriftSpeciesCatalog catalog;

  const twoRows = [
    SpeciesSeedRow(
      id: 'monstera-deliciosa',
      scientificName: 'Monstera deliciosa',
      commonName: 'Swiss cheese plant',
      wateringIntervalDays: 7,
      fertilizeIntervalDays: 30,
      light: LightLevel.medium,
      toxicToPets: true,
    ),
    SpeciesSeedRow(
      id: 'aloe-vera',
      scientificName: 'Aloe barbadensis miller',
      commonName: 'Aloe vera',
      wateringIntervalDays: 14,
    ),
  ];

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    seeder = CatalogSeeder(db);
    catalog = DriftSpeciesCatalog(db);
  });
  tearDown(() => db.close());

  group('CatalogSeeder', () {
    test('seedAll inserts every seed row with its values', () async {
      await seeder.seedAll(twoRows);

      final species = await db.select(db.species).get();
      expect(species, hasLength(2));
      final monstera = species.firstWhere((s) => s.id == 'monstera-deliciosa');
      expect(monstera.commonName, 'Swiss cheese plant');
      expect(monstera.wateringIntervalDays, 7);
      expect(monstera.fertilizeIntervalDays, 30);
      expect(monstera.lightLevel, LightLevel.medium);
      expect(monstera.toxicToPets, true);
    });

    test('seedAll is idempotent — re-seeding does not duplicate', () async {
      await seeder.seedAll(twoRows);
      await seeder.seedAll(twoRows);

      expect(await db.select(db.species).get(), hasLength(2));
    });

    test('seedIfNeeded skips when the stored version is already current', () async {
      await seeder.seedIfNeeded(seed: twoRows, version: 1);
      // Tamper with a row, then re-run at the SAME version: it must NOT be overwritten.
      await (db.update(db.species)..where((s) => s.id.equals('aloe-vera')))
          .write(const SpeciesCompanion(commonName: Value('EDITED')));

      await seeder.seedIfNeeded(seed: twoRows, version: 1);

      final aloe =
          await (db.select(db.species)..where((s) => s.id.equals('aloe-vera'))).getSingle();
      expect(aloe.commonName, 'EDITED'); // untouched → seeder correctly skipped
    });

    test('seedIfNeeded re-applies when the seed version is newer', () async {
      await seeder.seedIfNeeded(seed: twoRows, version: 1);
      await (db.update(db.species)..where((s) => s.id.equals('aloe-vera')))
          .write(const SpeciesCompanion(commonName: Value('EDITED')));

      await seeder.seedIfNeeded(seed: twoRows, version: 2);

      final aloe =
          await (db.select(db.species)..where((s) => s.id.equals('aloe-vera'))).getSingle();
      expect(aloe.commonName, 'Aloe vera'); // newer version → re-applied
    });
  });

  group('DriftSpeciesCatalog', () {
    setUp(() => seeder.seedAll(twoRows));

    test('search matches on common name, case-insensitively', () async {
      final results = await catalog.search('cheese');
      expect(results.map((r) => r.id), ['monstera-deliciosa']);
    });

    test('search matches on scientific name', () async {
      final results = await catalog.search('barbadensis');
      expect(results.map((r) => r.id), ['aloe-vera']);
    });

    test('an empty query returns the default set', () async {
      final results = await catalog.search('');
      expect(results, hasLength(2));
    });

    test('getById returns full detail including care defaults', () async {
      final detail = await catalog.getById('monstera-deliciosa');
      expect(detail, isNotNull);
      expect(detail!.commonName, 'Swiss cheese plant');
      expect(detail.care.wateringIntervalDays, 7);
      expect(detail.care.fertilizeIntervalDays, 30);
      expect(detail.light, LightLevel.medium);
    });

    test('getById returns null for an unknown id', () async {
      expect(await catalog.getById('nope'), isNull);
    });
  });
}
