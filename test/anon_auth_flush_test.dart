// The anon→auth Outbox flush: when a previously-anonymous user first signs in, every row
// they created offline must reach their new account — completely, and with no duplicates
// on replay. All exercised against the in-memory FakeSyncApi (no backend).

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/db/database.dart';
import 'package:plant_care_reminder/core/data/repositories/care_repository.dart';
import 'package:plant_care_reminder/core/data/repositories/rooms_repository.dart';
import 'package:plant_care_reminder/core/data/sync/anon_auth_flush.dart';
import 'package:plant_care_reminder/core/data/sync/sync_engine.dart';
import 'support/fake_sync_api.dart';

void main() {
  late AppDatabase db;
  late CareRepository care;
  late RoomsRepository rooms;
  late FakeSyncApi api;
  late AnonAuthFlush flush;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    care = CareRepository(db);
    rooms = RoomsRepository(db);
    api = FakeSyncApi();
    flush = AnonAuthFlush(db: db, engine: SyncEngine(db: db, api: api));
  });
  tearDown(() => db.close());

  Future<Set<String>> serverUuids() async =>
      (await api.pull(since: 0, limit: 9999)).changes.map((c) => c.uuid).toSet();

  Future<UserPlant> plantById(String id) =>
      (db.select(db.userPlants)..where((p) => p.id.equals(id))).getSingle();

  test('flushes every anonymous row to the newly-linked account', () async {
    final plantId = await care.addWateringPlant(
        nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');
    final scheduleId = (await db.select(db.careSchedules).get()).single.id;
    final roomId = await rooms.addRoom(name: 'Balcony');

    final report = await flush.flush();

    expect(await serverUuids(), containsAll([plantId, scheduleId, roomId]));
    expect(await db.select(db.outboxEntries).get(), isEmpty); // drained
    expect((await plantById(plantId)).serverRev, isNotNull); // acknowledged
    expect(report.pushed, 3); // plant + schedule + room
  });

  test('re-stages an unsynced row even if its Outbox entry was lost', () async {
    final plantId = await care.addWateringPlant(
        nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');
    // Simulate a pruned/lost Outbox: the row exists but has nothing queued.
    await db.delete(db.outboxEntries).go();

    await flush.flush();

    expect(await serverUuids(), contains(plantId)); // completeness, not Outbox-trust
    expect((await plantById(plantId)).serverRev, isNotNull);
  });

  test('is idempotent — a repeated flush pushes no duplicates', () async {
    final plantId = await care.addWateringPlant(
        nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');
    await flush.flush();

    final report2 = await flush.flush();

    expect(report2.pushed, 0); // everything already synced
    final onServer = (await api.pull(since: 0, limit: 9999)).changes;
    expect(onServer.where((c) => c.uuid == plantId), hasLength(1)); // no dup
  });

  test('does not re-push rows the server already acknowledged', () async {
    final firstId = await care.addWateringPlant(
        nickname: 'First', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');
    await flush.flush();
    final firstRevAfter1 = (await plantById(firstId)).serverRev;

    // New offline work after the first sign-in sync.
    await care.addWateringPlant(
        nickname: 'Second', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');

    final report = await flush.flush();

    expect(report.pushed, 2); // only the second plant + its schedule
    expect((await plantById(firstId)).serverRev, firstRevAfter1); // untouched
  });
}
