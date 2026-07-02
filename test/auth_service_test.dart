// AuthService orchestrates sign-in: obtain a provider token, exchange it for a Sanctum token,
// store it, then flush the anonymous library into the new account. A cancel is a clean no-op.
// SocialSignIn + SocialAuthClient are faked; the flush runs for real against FakeSyncApi so we
// can prove the offline library actually reaches the server.

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/auth/auth_service.dart';
import 'package:plant_care_reminder/core/data/db/database.dart';
import 'package:plant_care_reminder/core/data/repositories/care_repository.dart';
import 'package:plant_care_reminder/core/data/sync/anon_auth_flush.dart';
import 'package:plant_care_reminder/core/data/sync/sync_engine.dart';
import 'package:plant_care_reminder/core/data/sync/token_store.dart';
import 'package:plant_care_reminder/core/domain/ports/social_auth.dart';
import 'support/fake_sync_api.dart';

class _FakeSignIn implements SocialSignIn {
  _FakeSignIn(this._token);
  final String? _token;
  @override
  Future<String?> obtainToken(String provider) async => _token;
}

class _FakeAuthClient implements SocialAuthClient {
  _FakeAuthClient(this._session);
  final AuthSession _session;
  String? sentToken;
  @override
  Future<AuthSession> exchange({required String provider, required String token}) async {
    sentToken = token;
    return _session;
  }
}

class _FakeTokens implements TokenStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String token) async => value = token;
  @override
  Future<void> clear() async => value = null;
}

void main() {
  late AppDatabase db;
  late CareRepository care;
  late FakeSyncApi api;
  late AnonAuthFlush flush;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    care = CareRepository(db);
    api = FakeSyncApi();
    flush = AnonAuthFlush(db: db, engine: SyncEngine(db: db, api: api));
  });
  tearDown(() => db.close());

  Future<String> addAnonPlant() => care.addWateringPlant(
      nickname: 'Fern', intervalDays: 5, timeOfDayMinutes: 540, tzId: 'UTC');

  test('sign-in exchanges the token, stores it, and flushes the anon library', () async {
    final plantId = await addAnonPlant();
    final tokens = _FakeTokens();
    final client = _FakeAuthClient(const AuthSession(token: 'sanctum-tok', userId: '42'));
    final service = AuthService(
        signIn: _FakeSignIn('provider-tok'), authClient: client, tokens: tokens, flush: flush);

    final session = await service.signIn('google');

    expect(session!.token, 'sanctum-tok');
    expect(client.sentToken, 'provider-tok'); // provider token forwarded to exchange
    expect(tokens.value, 'sanctum-tok'); // token persisted

    // Flushed: the anonymous plant reached the server.
    final serverUuids =
        (await api.pull(since: 0, limit: 9999)).changes.map((c) => c.uuid);
    expect(serverUuids, contains(plantId));
  });

  test('a cancelled sign-in stores nothing and does not flush', () async {
    await addAnonPlant();
    final tokens = _FakeTokens();
    final service = AuthService(
        signIn: _FakeSignIn(null), // user cancelled
        authClient: _FakeAuthClient(const AuthSession(token: 'x', userId: '1')),
        tokens: tokens,
        flush: flush);

    final session = await service.signIn('google');

    expect(session, isNull);
    expect(tokens.value, isNull);
    expect((await api.pull(since: 0, limit: 9999)).changes, isEmpty);
  });

  test('signOut clears the stored token', () async {
    final tokens = _FakeTokens()..value = 'tok';
    final service = AuthService(
        signIn: _FakeSignIn(null),
        authClient: _FakeAuthClient(const AuthSession(token: 'x', userId: '1')),
        tokens: tokens,
        flush: flush);

    await service.signOut();

    expect(tokens.value, isNull);
  });
}
