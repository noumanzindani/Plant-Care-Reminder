import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_store.dart';

/// The production [TokenStore]: persists the bearer token in the platform secure enclave
/// (iOS Keychain / Android Keystore-backed EncryptedSharedPreferences), never in plain prefs.
class SecureTokenStore implements TokenStore {
  // v10+ secures Android storage automatically (Keystore-backed ciphers) — no options needed.
  SecureTokenStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'sanctum_token';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String token) => _storage.write(key: _key, value: token);

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
