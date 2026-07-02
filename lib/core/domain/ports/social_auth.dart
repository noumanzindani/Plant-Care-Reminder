/// The authenticated session the backend returns from `/auth/social`: a Sanctum bearer token
/// plus the resolved user. `userId` is the server's user id; email/name may be absent (Apple).
class AuthSession {
  const AuthSession({
    required this.token,
    required this.userId,
    this.email,
    this.name,
  });

  final String token;
  final String userId;
  final String? email;
  final String? name;
}

/// Obtains a raw provider id_token to hand to the backend. Real adapters wrap the
/// `google_sign_in` / `sign_in_with_apple` SDKs; returns null if the user cancels.
abstract interface class SocialSignIn {
  /// @param provider 'google' | 'apple'
  Future<String?> obtainToken(String provider);
}

/// Exchanges a verified provider token for an [AuthSession] (the `/auth/social` call). The dio
/// adapter is the concrete implementation; tests fake it.
abstract interface class SocialAuthClient {
  Future<AuthSession> exchange({required String provider, required String token});
}
