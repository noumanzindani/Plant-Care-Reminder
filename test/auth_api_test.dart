// AuthApi posts a provider token to /auth/social and parses the backend's {token, user}
// response into an AuthSession. Verified against the fake HttpClientAdapter (no backend).

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/auth/auth_api.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.respond);
  final Map<String, dynamic> Function() respond;

  RequestOptions? lastOptions;
  dynamic lastBody;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? _) async {
    lastOptions = options;
    if (requestStream != null) {
      final bytes = (await requestStream.toList()).expand((c) => c).toList();
      lastBody = jsonDecode(utf8.decode(bytes));
    }
    return ResponseBody.fromString(jsonEncode(respond()), 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('exchanges a provider token and parses the session', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://plantner.test/api/v1/'));
    final adapter = _FakeAdapter(() => {
          'token': 'sanctum-abc',
          'user': {'id': 42, 'email': 'fern@example.com', 'name': 'Fern Fan'},
        });
    dio.httpClientAdapter = adapter;

    final session = await AuthApi(dio).exchange(provider: 'google', token: 'google-id-token');

    // Request shape.
    expect(adapter.lastOptions!.path, 'auth/social');
    expect(adapter.lastOptions!.method, 'POST');
    expect(adapter.lastBody, {'provider': 'google', 'token': 'google-id-token'});

    // Parsed session.
    expect(session.token, 'sanctum-abc');
    expect(session.userId, '42');
    expect(session.email, 'fern@example.com');
    expect(session.name, 'Fern Fan');
  });

  test('tolerates a withheld email (Apple relay)', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://plantner.test/api/v1/'));
    dio.httpClientAdapter = _FakeAdapter(() => {
          'token': 'sanctum-xyz',
          'user': {'id': 7, 'email': null, 'name': 'Plant lover'},
        });

    final session = await AuthApi(dio).exchange(provider: 'apple', token: 'apple-token');

    expect(session.userId, '7');
    expect(session.email, isNull);
  });
}
