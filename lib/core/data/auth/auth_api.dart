import 'package:dio/dio.dart';

import '../../domain/ports/social_auth.dart';

/// The dio-backed [SocialAuthClient]: posts a verified provider token to `/auth/social` and
/// parses the `{token, user}` response into an [AuthSession]. Shares the sync [Dio] (base URL);
/// this call is public, so it runs before any token exists.
class AuthApi implements SocialAuthClient {
  AuthApi(this._dio);

  final Dio _dio;

  @override
  Future<AuthSession> exchange({required String provider, required String token}) async {
    final res = await _dio.post<Map<String, dynamic>>(
      'auth/social',
      data: {'provider': provider, 'token': token},
    );
    final data = res.data!;
    final user = (data['user'] as Map).cast<String, dynamic>();

    return AuthSession(
      token: data['token'] as String,
      userId: user['id'].toString(),
      email: user['email'] as String?,
      name: user['name'] as String?,
    );
  }
}
