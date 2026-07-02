// Pure-Dart data-layer test — runs under the default test binding (real timers), so
// Drift's reactive streams deliver normally. No widget/testWidgets code in this file.

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/db/database.dart';
import 'package:plant_care_reminder/core/domain/value_objects/enums.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('watchActivePlantCount reacts to inserts', () async {
    final dao = db.plantsDao;

    // `.timeout` guards against any future regression hanging the suite.
    expect(
      await dao.watchActivePlantCount().first.timeout(const Duration(seconds: 5)),
      0,
    );

    final now = DateTime.now();
    await dao.insertPlant(
      UserPlantsCompanion.insert(
        id: 'plant-1',
        nickname: 'Monstera',
        createdAt: now,
        updatedAt: now,
      ),
    );

    expect(
      await dao.watchActivePlantCount().first.timeout(const Duration(seconds: 5)),
      1,
    );
  });

  test('watchActivePlants excludes soft-deleted and archived plants', () async {
    final dao = db.plantsDao;
    final now = DateTime.now();

    await dao.insertPlant(UserPlantsCompanion.insert(
      id: 'active', nickname: 'Active', createdAt: now, updatedAt: now,
    ));
    await dao.insertPlant(UserPlantsCompanion.insert(
      id: 'archived', nickname: 'Archived', createdAt: now, updatedAt: now,
      status: const Value(PlantStatus.archived),
    ));
    await dao.insertPlant(UserPlantsCompanion.insert(
      id: 'deleted', nickname: 'Deleted', createdAt: now, updatedAt: now,
      deletedAt: Value(now),
    ));

    final active =
        await dao.watchActivePlants().first.timeout(const Duration(seconds: 5));
    expect(active.map((p) => p.id), ['active']);
  });
}
