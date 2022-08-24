import 'package:infinite_feed/core/api/dio_client.dart';

class AuthAPI {
  const AuthAPI._();

  static Future<dynamic> checkAuth() async {
    final response = await DioClient.client.get('/health-check-auth');
    return response.data;
  }
}
