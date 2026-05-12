import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/app_constants.dart';
import '../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _api = ApiClient.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    String? email,
  }) async {
    final response = await _api.post('/auth/register', data: {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'password': password,
      if (email != null) 'email': email,
    });
    return response.data as Map<String, dynamic>;
  }

  /// Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final response = await _api.post('/auth/verify-otp', data: {
      'phone_number': phoneNumber,
      'otp': otp,
    });
    return response.data as Map<String, dynamic>;
  }

  /// Login with phone and password
  Future<UserModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await _api.post('/auth/login', data: {
      'phone_number': phoneNumber,
      'password': password,
    });

    final data = response.data as Map<String, dynamic>;
    final token = data['access_token'] as String;
    final refreshToken = data['refresh_token'] as String;

    await _storage.write(key: AppConstants.tokenKey, value: token);
    await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);

    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } finally {
      await _storage.delete(key: AppConstants.tokenKey);
      await _storage.delete(key: AppConstants.refreshTokenKey);
    }
  }

  /// Forgot password — sends OTP
  Future<void> forgotPassword(String phoneNumber) async {
    await _api.post('/auth/forgot-password', data: {
      'phone_number': phoneNumber,
    });
  }

  /// Reset password with OTP
  Future<void> resetPassword({
    required String phoneNumber,
    required String otp,
    required String newPassword,
  }) async {
    await _api.post('/auth/reset-password', data: {
      'phone_number': phoneNumber,
      'otp': otp,
      'new_password': newPassword,
    });
  }

  /// Change password (authenticated)
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _api.put('/auth/change-password', data: {
      'current_password': currentPassword,
      'new_password': newPassword,
    });
  }

  /// Resend OTP
  Future<void> resendOtp(String phoneNumber) async {
    await _api.post('/auth/resend-otp', data: {
      'phone_number': phoneNumber,
    });
  }

  /// Get current user profile
  Future<UserModel> getProfile() async {
    final response = await _api.get('/auth/profile');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Update profile
  Future<UserModel> updateProfile({
    String? fullName,
    String? email,
  }) async {
    final response = await _api.put('/auth/profile', data: {
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
    });
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null;
  }

  /// Get stored token
  Future<String?> getToken() async {
    return _storage.read(key: AppConstants.tokenKey);
  }
}
