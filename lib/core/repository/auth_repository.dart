import 'package:infinite_feed/core/api/auth_api.dart';
import 'package:infinite_feed/core/models/auth_model.dart';

/// [AuthRepository] for provide data about authentication
class AuthRepository {
  
  /// Check if user authentication in the system
  static Future<CheckAuthModel> checkAuth() async {
    final data = await AuthAPI.checkAuth();
    return CheckAuthModel.fromMap(data);
  }
}
