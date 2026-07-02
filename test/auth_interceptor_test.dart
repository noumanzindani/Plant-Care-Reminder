// The auth interceptor attaches the Sanctum bearer token (read from a TokenStore) to every
// request, and stays silent when signed out. Tested with a fake store + capturing adapter.

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/sync/auth_interceptor.dart';
import 'package:plant_care_reminder/core/data/sync/token_store.dart';

class _FakeTokenStore implements TokenStore {
  _FakeTokenStore(this._token);
  String? _token;

  @override
  Future<String?> read() async => _token;
  @override
  Future<void> write(String token) async => _token = token;
  @override
  Future<void> clear() async => _token = null;
}

class _CapturingAdapter implements HttpClientAdapter {
  RequestOptions? lastOptions;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? _, Future<void>? _) async {
    lastOptions = options;
    return ResponseBody.fromString('{}', 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

Dio _dioWith(TokenStore store, _CapturingAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://plantner.test/api/v1/'));
  dio.interceptors.add(AuthInterceptor(store));
  dio.httpClientAdapter = adapter;
  return dio;
}

void main() {
  test('attaches a Bearer header when a token is stored', () async {
    final adapter = _CapturingAdapter();
    await _dioWith(_FakeTokenStore('tok-123'), adapter).get('sync/changes');

    expect(adapter.lastOptions!.headers['Authorization'], 'Bearer tok-123');
  });

  test('sends no Authorization header when signed out', () async {
    final adapter = _CapturingAdapter();
    await _dioWith(_FakeTokenStore(null), adapter).get('sync/changes');

    expect(adapter.lastOptions!.headers.containsKey('Authorization'), isFalse);
  });
}
