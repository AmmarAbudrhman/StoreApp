import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/core/constants/api_constants.dart';
import 'package:store_app/core/services/api_service.dart';
import 'package:store_app/features/auth/data/models/user_model.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    final data = await _api.post(
      url: '${ApiConstants.baseUrl}${ApiConstants.register}',
      body: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
      },
    );
    final user = UserModel.fromJson(data);
    if (user.token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ApiConstants.authTokenKey, user.token!);
    }
    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final data = await _api.post(
      url: '${ApiConstants.baseUrl}${ApiConstants.login}',
      body: {'email': email, 'password': password},
    );
    final user = UserModel.fromJson(data);
    if (user.token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ApiConstants.authTokenKey, user.token!);
    }
    return user;
  }

  Future<String> forgotPassword({required String email}) async {
    final data = await _api.post(
      url: '${ApiConstants.baseUrl}${ApiConstants.forgotPassword}',
      body: {'email': email},
    );
    return data.toString();
  }

  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    final data = await _api.post(
      url: '${ApiConstants.baseUrl}${ApiConstants.resetPassword}',
      body: {'email': email, 'token': token, 'newPassword': newPassword},
    );
    return data == true;
  }

  Future<UserModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiConstants.authTokenKey);

    final data = await _api.get(
      url: '${ApiConstants.baseUrl}${ApiConstants.profile}',
      token: token,
    );
    return UserModel.fromJson(data);
  }

  Future<UserModel> updateProfile({
    required String fullName,
    required String phone,
    required String address,
    String? imageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiConstants.authTokenKey);

    final data = await _api.put(
      url: '${ApiConstants.baseUrl}${ApiConstants.profile}',
      token: token,
      body: {
        'fullName': fullName,
        'phone': phone,
        'address': address,
        'imageUrl': imageUrl ?? '',
      },
    );
    return UserModel.fromJson(data);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConstants.authTokenKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiConstants.authTokenKey);
  }
}
