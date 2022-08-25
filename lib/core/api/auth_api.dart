import 'package:infinite_feed/core/api/dio_client.dart';

///[AuthAPI] Provide API for work with authentication.
class AuthAPI {
  const AuthAPI._();

  /// Use for review user authentication in the system.
  static Future<dynamic> checkAuth() async {
    final response = await DioClient.client.get('/health-check-auth');
    return response.data;
  }
}
