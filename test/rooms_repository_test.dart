// Pure-Dart data test for the RoomsRepository: creating rooms and assigning plants to
// them (the organizational grouping + the Phase-5 light/weather prior).

import 'package:drift/drift.dart' hide isNull; // keep matcher's isNull
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/db/database.dart';
import 'package:plant_care_reminder/core/data/repositories/care_repository.dart';
import 'package:plant_care_reminder/core/data/repositories/rooms_repository.dart';
import 'package:plant_care_reminder/core/domain/value_objects/enums.dart';

void main() {
  late AppDatabase db;
  late RoomsRepository rooms;
  late CareRepository care;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    rooms = RoomsRepository(db);
    care = CareRepository(db);
  });
  tearDown(() => db.close());

  test('addRoom creates a room that watchRooms surfaces', () async {
    await rooms.addRoom(name: 'Living room', orientation: WindowOrientation.south);

    final list = await rooms.watchRooms().first;
    expect(list, hasLength(1));
    expect(list.single.name, 'Living room');
    expect(list.single.orientation, WindowOrientation.south);
  });

  test('watchRooms excludes soft-deleted rooms', () async {
    final keepId = await rooms.addRoom(name: 'Balcony');
    final dropId = await rooms.addRoom(name: 'Old shed');
    await (db.update(db.rooms)..where((r) => r.id.equals(dropId)))
        .write(RoomsCompanion(deletedAt: Value(DateTime.now())));

    final list = await rooms.watchRooms().first;
    expect(list.map((r) => r.id), [keepId]);
  });

  test('assignPlantToRoom sets the plant\'s roomId', () async {
    final plantId = await care.addWateringPlant(
      nickname: 'Fern',
      intervalDays: 7,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );
    final roomId = await rooms.addRoom(name: 'Living room');

    await rooms.assignPlantToRoom(plantId: plantId, roomId: roomId);

    final plant = await (db.select(db.userPlants)..where((p) => p.id.equals(plantId)))
        .getSingle();
    expect(plant.roomId, roomId);
  });

  test('assignPlantToRoom with null clears the room', () async {
    final plantId = await care.addWateringPlant(
      nickname: 'Fern',
      intervalDays: 7,
      timeOfDayMinutes: 9 * 60,
      tzId: 'America/New_York',
    );
    final roomId = await rooms.addRoom(name: 'Living room');
    await rooms.assignPlantToRoom(plantId: plantId, roomId: roomId);

    await rooms.assignPlantToRoom(plantId: plantId, roomId: null);

    final plant = await (db.select(db.userPlants)..where((p) => p.id.equals(plantId)))
        .getSingle();
    expect(plant.roomId, isNull);
  });

  // --- Slice 3.0: the sync Outbox invariant extends to rooms ----------------------

  test('addRoom enqueues an upsert Outbox entry for the room', () async {
    final id = await rooms.addRoom(name: 'Living room');

    final outbox = await db.select(db.outboxEntries).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entity, 'rooms');
    expect(outbox.single.entityId, id);
    expect(outbox.single.op, 'upsert');
    expect(outbox.single.payload, contains(id));
  });

  test('assignPlantToRoom enqueues an upsert Outbox entry for the plant', () async {
    final plantId = await care.addWateringPlant(
        nickname: 'Fern', intervalDays: 7, timeOfDayMinutes: 540, tzId: 'UTC');
    final roomId = await rooms.addRoom(name: 'Living room');
    await db.delete(db.outboxEntries).go(); // isolate the assignment's entry

    await rooms.assignPlantToRoom(plantId: plantId, roomId: roomId);

    final outbox = await db.select(db.outboxEntries).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entity, 'user_plants'); // assigning a room mutates the plant
    expect(outbox.single.entityId, plantId);
    expect(outbox.single.op, 'upsert');
  });
}
