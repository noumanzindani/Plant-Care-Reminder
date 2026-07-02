import 'package:dio/dio.dart';

import 'token_store.dart';

/// Adds `Authorization: Bearer <token>` to every request when a token is stored, and sends
/// nothing when signed out (so the same [Dio] serves the anonymous and authenticated phases).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens);

  final TokenStore _tokens;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokens.read();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
