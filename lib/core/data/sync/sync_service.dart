import '../../domain/ports/connectivity_port.dart';
import 'sync_engine.dart';
import 'token_store.dart';

/// The connectivity- and auth-gated entry point for running a sync pass. The rest of the app
/// (foreground, connectivity regained, post-sign-in) calls [syncNow] without knowing the
/// gating rules: a sync only runs when the device is online AND the user is signed in — an
/// anonymous user has no account to sync against, so their work stays local until they link one.
class SyncService {
  SyncService({
    required SyncEngine engine,
    required ConnectivityPort connectivity,
    required TokenStore tokens,
  })  : _engine = engine,
        _connectivity = connectivity,
        _tokens = tokens;

  final SyncEngine _engine;
  final ConnectivityPort _connectivity;
  final TokenStore _tokens;

  /// Runs a sync pass, or returns null (a no-op) when offline or anonymous.
  Future<SyncReport?> syncNow() async {
    if (!await _connectivity.isOnline()) return null;
    if (await _tokens.read() == null) return null;
    return _engine.sync();
  }
}
