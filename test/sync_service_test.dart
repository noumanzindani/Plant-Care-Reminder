// The sync trigger's gate: SyncEngine runs only when the device is online AND the user is
// signed in (an anonymous user has no account to sync to). Offline or anonymous → provably
// skipped: the Outbox is left intact and the server is never called.

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/db/database.dart';
import 'package:plant_care_reminder/core/data/repositories/care_repository.dart';
import 'package:plant_care_reminder/core/data/sync/sync_engine.dart';
import 'package:plant_care_reminder/core/data/sync/sync_service.dart';
import 'package:plant_care_reminder/core/data/sync/token_store.dart';
import 'package:plant_care_reminder/core/domain/ports/connectivity_port.dart';
import 'support/fake_sync_api.dart';

class _Conn implements ConnectivityPort {
  _Conn(this.online);
  final bool online;
  @override
  Future<bool> isOnline() async => online;
}

class _Tokens implements TokenStore {
  _Tokens(this._t);
  String? _t;
  @override
  Future<String?> read() async => _t;
  @override
  Future<void> write(String token) async => _t = token;
  @override
  Future<void> clear() async => _t = null;
}

void main() {
  late AppDatabase db;
  late CareRepository care;
  late FakeSyncApi api;
  late SyncEngine engine;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    care = CareRepository(db);
    api = FakeSyncApi();
    engine = SyncEngine(db: db, api: api);
  });
  tearDown(() => db.close());

  Future<void> addAPlant() => care.addWateringPlant(
      nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');

  SyncService service(ConnectivityPort conn, TokenStore tokens) =>
      SyncService(engine: engine, connectivity: conn, tokens: tokens);

  test('syncs when online and signed in', () async {
    await addAPlant();

    final report = await service(_Conn(true), _Tokens('tok')).syncNow();

    expect(report, isNotNull);
    expect(await db.select(db.outboxEntries).get(), isEmpty); // drained
  });

  test('skips when offline — the Outbox is left intact', () async {
    await addAPlant();

    final report = await service(_Conn(false), _Tokens('tok')).syncNow();

    expect(report, isNull);
    expect(await db.select(db.outboxEntries).get(), isNotEmpty);
    expect(api.pushCalls, 0); // server never called
  });

  test('skips when anonymous — nothing to sync to', () async {
    await addAPlant();

    final report = await service(_Conn(true), _Tokens(null)).syncNow();

    expect(report, isNull);
    expect(api.pushCalls, 0);
  });
}
