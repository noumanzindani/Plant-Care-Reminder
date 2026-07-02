// The SyncEngine round-trip against the in-memory FakeSyncApi — the de-risking core of
// Phase 3, all deterministic and backend-free. Exercises the hard cases the architecture
// hinges on: push drains the Outbox and stamps serverRev, pull applies remote changes,
// double-sync is idempotent, a server-wins conflict is surfaced (never silently lost),
// out-of-order foreign keys are tolerated, and tombstones soft-delete.

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/db/database.dart';
import 'package:plant_care_reminder/core/data/repositories/care_repository.dart';
import 'package:plant_care_reminder/core/data/repositories/rooms_repository.dart';
import 'package:plant_care_reminder/core/data/sync/sync_engine.dart';
import 'support/fake_sync_api.dart';

void main() {
  late AppDatabase db;
  late CareRepository care;
  late RoomsRepository rooms;
  late FakeSyncApi api;
  late SyncEngine engine;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    care = CareRepository(db);
    rooms = RoomsRepository(db);
    api = FakeSyncApi();
    engine = SyncEngine(db: db, api: api);
  });
  tearDown(() => db.close());

  Future<UserPlant> plantById(String id) =>
      (db.select(db.userPlants)..where((p) => p.id.equals(id))).getSingle();

  test('sync pushes local mutations, drains the Outbox, and stamps serverRev', () async {
    final plantId = await care.addWateringPlant(
        nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');

    final report = await engine.sync();

    expect(report.pushed, 2); // the plant + its water schedule
    expect(await db.select(db.outboxEntries).get(), isEmpty); // drained
    expect((await plantById(plantId)).serverRev, isNotNull); // server-acknowledged
  });

  test('sync applies a change made on another device', () async {
    // Another device created a room; it exists only on the server.
    api.seedRemote(
      entity: 'rooms',
      uuid: 'remote-room',
      clientUpdatedAt: DateTime.utc(2026, 6, 1),
      attributes: {
        'id': 'remote-room',
        'name': 'Balcony',
        'outdoor': true,
        'sortOrder': 0,
        'createdAt': DateTime.utc(2026, 6, 1).millisecondsSinceEpoch,
        'updatedAt': DateTime.utc(2026, 6, 1).millisecondsSinceEpoch,
        'sync': 'localOnly',
      },
    );

    final report = await engine.sync();

    expect(report.pulled, greaterThanOrEqualTo(1));
    final local = await rooms.watchRooms().first;
    expect(local.map((r) => r.name), contains('Balcony'));
    expect(local.firstWhere((r) => r.id == 'remote-room').serverRev, isNotNull);
  });

  test('a second sync is idempotent — nothing re-pushed, nothing duplicated', () async {
    await care.addWateringPlant(
        nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');
    await engine.sync();

    final report2 = await engine.sync();

    expect(report2.pushed, 0); // Outbox already drained
    expect(report2.pulled, 0); // cursor already past every change
    expect(await db.select(db.userPlants).get(), hasLength(1)); // no duplication
  });

  test('a server-wins conflict is surfaced and the winning row is applied', () async {
    final plantId = await care.addWateringPlant(
        nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');
    await engine.sync(); // now server-known at some rev

    // Another device edited the SAME plant, later — its version must win LWW.
    final serverAttrs = Map<String, dynamic>.from((await plantById(plantId)).toJson())
      ..['nickname'] = 'Server wins';
    api.seedRemote(
      entity: 'user_plants',
      uuid: plantId,
      clientUpdatedAt: DateTime.utc(2030, 1, 1),
      attributes: serverAttrs,
    );

    // Our stale local edit (assigning a room mutates the plant row).
    await rooms.assignPlantToRoom(plantId: plantId, roomId: null);

    final report = await engine.sync();

    expect(report.conflicts, contains(plantId)); // not silently dropped
    expect((await plantById(plantId)).nickname, 'Server wins'); // winner applied
  });

  test('out-of-order foreign keys are tolerated: a schedule applies before its plant',
      () async {
    // Build a real plant + schedule locally to get valid attribute snapshots, then wipe
    // local state and replay them from the server schedule-first (lower rev than plant).
    final plantId = await care.addWateringPlant(
        nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');
    final schedule = (await db.select(db.careSchedules).get()).single;
    final plantAttrs = (await plantById(plantId)).toJson();
    final scheduleAttrs = schedule.toJson();

    await db.delete(db.careSchedules).go();
    await db.delete(db.userPlants).go();
    await db.delete(db.outboxEntries).go();

    api.seedRemote(
      entity: 'care_schedules',
      uuid: schedule.id,
      clientUpdatedAt: DateTime.utc(2026, 6, 1),
      attributes: scheduleAttrs,
    ); // rev 1 — arrives before its plant
    api.seedRemote(
      entity: 'user_plants',
      uuid: plantId,
      clientUpdatedAt: DateTime.utc(2026, 6, 1),
      attributes: plantAttrs,
    ); // rev 2

    await engine.sync();

    expect(await db.select(db.userPlants).get(), hasLength(1));
    expect(await db.select(db.careSchedules).get(), hasLength(1));
  });

  test('a remote tombstone soft-deletes the local row', () async {
    final roomId = await rooms.addRoom(name: 'Old shed');
    await engine.sync(); // room now server-known

    api.seedRemote(
      entity: 'rooms',
      uuid: roomId,
      deleted: true,
      clientUpdatedAt: DateTime.utc(2030, 1, 1),
      attributes: const {},
    );

    await engine.sync();

    final row =
        await (db.select(db.rooms)..where((r) => r.id.equals(roomId))).getSingle();
    expect(row.deletedAt, isNotNull); // tombstoned
    expect(await rooms.watchRooms().first, isEmpty); // gone from the live list
  });
}
