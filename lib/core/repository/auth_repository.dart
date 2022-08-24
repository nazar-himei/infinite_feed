import 'package:infinite_feed/core/api/auth_api.dart';
import 'package:infinite_feed/core/models/auth_model.dart';

class AuthRepository {
  static Future<AuthCheck> checkAuth() async {
    final data = await AuthAPI.checkAuth();
    return AuthCheck.fromMap(data);
  }
}
