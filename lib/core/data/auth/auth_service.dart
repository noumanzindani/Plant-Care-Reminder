import '../../domain/ports/social_auth.dart';
import '../sync/anon_auth_flush.dart';
import '../sync/token_store.dart';

/// Drives the whole sign-in flow: obtain a provider token, exchange it for a Sanctum token,
/// persist it, then flush the anonymous library into the freshly-linked account. Storing the
/// token *before* the flush matters — the flush syncs over HTTP, which needs the bearer token
/// already in place. A cancelled sign-in is a clean no-op.
class AuthService {
  AuthService({
    required SocialSignIn signIn,
    required SocialAuthClient authClient,
    required TokenStore tokens,
    required AnonAuthFlush flush,
  })  : _signIn = signIn,
        _authClient = authClient,
        _tokens = tokens,
        _flush = flush;

  final SocialSignIn _signIn;
  final SocialAuthClient _authClient;
  final TokenStore _tokens;
  final AnonAuthFlush _flush;

  /// Returns the session, or null if the user cancelled the provider prompt.
  Future<AuthSession?> signIn(String provider) async {
    final providerToken = await _signIn.obtainToken(provider);
    if (providerToken == null) return null;

    final session = await _authClient.exchange(provider: provider, token: providerToken);
    await _tokens.write(session.token);
    await _flush.flush();

    return session;
  }

  Future<void> signOut() => _tokens.clear();
}
