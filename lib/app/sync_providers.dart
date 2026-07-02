import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/data/db/database_provider.dart';
import '../core/data/sync/auth_interceptor.dart';
import '../core/data/sync/dio_sync_api.dart';
import '../core/data/sync/secure_token_store.dart';
import '../core/data/sync/sync_engine.dart';
import '../core/data/sync/sync_service.dart';
import '../core/data/sync/token_store.dart';
import '../core/domain/ports/connectivity_port.dart';
import '../core/domain/ports/sync_api_port.dart';
import '../core/infra/network/connectivity_plus_adapter.dart';

/// The backend's `/api/v1` root. Overridable per build: `--dart-define=SYNC_BASE_URL=…`.
/// Default targets a local `php artisan serve` from the Android emulator (10.0.2.2 = host).
const _syncBaseUrl = String.fromEnvironment(
  'SYNC_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000/api/v1/',
);

/// The bearer token, in the platform secure enclave.
final tokenStoreProvider = Provider<TokenStore>((ref) => SecureTokenStore());

/// The HTTP client for sync: base URL + the auth interceptor that attaches the token.
final syncDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: _syncBaseUrl));
  dio.interceptors.add(AuthInterceptor(ref.watch(tokenStoreProvider)));
  return dio;
});

/// The live delta-sync port (swap point: this is where the fake gives way to real HTTP).
final syncApiProvider =
    Provider<SyncApiPort>((ref) => DioSyncApi(ref.watch(syncDioProvider)));

final connectivityProvider =
    Provider<ConnectivityPort>((ref) => ConnectivityPlusAdapter());

final syncEngineProvider = Provider<SyncEngine>(
  (ref) => SyncEngine(
    db: ref.watch(appDatabaseProvider),
    api: ref.watch(syncApiProvider),
  ),
);

/// The connectivity- and auth-gated sync trigger the app lifecycle calls.
final syncServiceProvider = Provider<SyncService>(
  (ref) => SyncService(
    engine: ref.watch(syncEngineProvider),
    connectivity: ref.watch(connectivityProvider),
    tokens: ref.watch(tokenStoreProvider),
  ),
);
