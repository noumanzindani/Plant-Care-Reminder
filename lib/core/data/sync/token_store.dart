/// Where the Sanctum bearer token lives. Pure port — no plugin import — so tests fake it and
/// the core never depends on the platform keystore. The production adapter is
/// [SecureTokenStore] (Keychain / Android Keystore), the compliance-mandated store for tokens
/// (never SharedPreferences).
abstract interface class TokenStore {
  Future<String?> read();

  Future<void> write(String token);

  Future<void> clear();
}
