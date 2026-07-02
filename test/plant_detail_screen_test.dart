// Widget test for the plant detail View: renders a plant's care types (or an empty
// state). Family providers are overridden with timer-free `Stream.value` stubs so the
// View never touches the real Drift database.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/app/providers.dart';
import 'package:plant_care_reminder/core/data/db/database.dart';
import 'package:plant_care_reminder/core/data/repositories/care_repository.dart';
import 'package:plant_care_reminder/core/domain/ports/species_catalog_port.dart';
import 'package:plant_care_reminder/core/domain/value_objects/enums.dart';
import 'package:plant_care_reminder/features/plants/presentation/plant_detail_screen.dart';

void main() {
  testWidgets('plant detail lists the plant\'s care types', (tester) async {
    final items = [
      CareQueueItem(
        plantId: 'p1',
        scheduleId: 's1',
        nickname: 'Monstera',
        type: CareType.water,
        nextDueAt: DateTime.now(),
      ),
      CareQueueItem(
        plantId: 'p1',
        scheduleId: 's2',
        nickname: 'Monstera',
        type: CareType.fertilize,
        nextDueAt: DateTime.now().add(const Duration(days: 20)),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          plantProvider('p1').overrideWith((ref) => Stream<UserPlant?>.value(null)),
          plantSchedulesProvider('p1').overrideWith((ref) => Stream.value(items)),
          roomsProvider.overrideWith((ref) => Stream.value(const <Room>[])),
        ],
        child: const MaterialApp(home: PlantDetailScreen(plantId: 'p1')),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Water'), findsOneWidget);
    expect(find.text('Fertilize'), findsOneWidget);
    expect(find.text('Add care type'), findsOneWidget);
    // Room row is present and unassigned.
    expect(find.text('Room'), findsOneWidget);
    expect(find.text('None'), findsOneWidget);
  });

  testWidgets('plant detail shows the empty state with no care types', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          plantProvider('p1').overrideWith((ref) => Stream<UserPlant?>.value(null)),
          plantSchedulesProvider('p1')
              .overrideWith((ref) => Stream.value(const <CareQueueItem>[])),
          roomsProvider.overrideWith((ref) => Stream.value(const <Room>[])),
        ],
        child: const MaterialApp(home: PlantDetailScreen(plantId: 'p1')),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('No care types yet'), findsOneWidget);
  });

  testWidgets('plant detail shows the linked species care facts', (tester) async {
    final plant = UserPlant(
      id: 'p1',
      nickname: 'My Monstera',
      speciesId: 'monstera-deliciosa',
      status: PlantStatus.active,
      version: 0,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
      sync: SyncState.localOnly,
    );
    const detail = SpeciesDetail(
      id: 'monstera-deliciosa',
      scientificName: 'Monstera deliciosa',
      commonName: 'Swiss cheese plant',
      care: CareDefaults(wateringIntervalDays: 7, fertilizeIntervalDays: 30),
      family: 'Araceae',
      light: LightLevel.bright,
      toxicToPets: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          plantProvider('p1').overrideWith((ref) => Stream<UserPlant?>.value(plant)),
          plantSchedulesProvider('p1')
              .overrideWith((ref) => Stream.value(const <CareQueueItem>[])),
          roomsProvider.overrideWith((ref) => Stream.value(const <Room>[])),
          speciesDetailProvider('monstera-deliciosa').overrideWith((ref) => detail),
        ],
        child: const MaterialApp(home: PlantDetailScreen(plantId: 'p1')),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Monstera deliciosa'), findsOneWidget); // scientific name
    expect(find.text('Bright light'), findsOneWidget);
    expect(find.text('Toxic to pets'), findsOneWidget);
    expect(find.text('Araceae'), findsOneWidget);
  });

  testWidgets('plant detail shows no species card for an unidentified plant',
      (tester) async {
    final plant = UserPlant(
      id: 'p1',
      nickname: 'Mystery plant',
      status: PlantStatus.active,
      version: 0,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
      sync: SyncState.localOnly,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          plantProvider('p1').overrideWith((ref) => Stream<UserPlant?>.value(plant)),
          plantSchedulesProvider('p1')
              .overrideWith((ref) => Stream.value(const <CareQueueItem>[])),
          roomsProvider.overrideWith((ref) => Stream.value(const <Room>[])),
        ],
        child: const MaterialApp(home: PlantDetailScreen(plantId: 'p1')),
      ),
    );
    await tester.pump();
    await tester.pump();

    // No species linked → no care-facts chips.
    expect(find.text('Bright light'), findsNothing);
    expect(find.text('Pet-safe'), findsNothing);
  });
}
