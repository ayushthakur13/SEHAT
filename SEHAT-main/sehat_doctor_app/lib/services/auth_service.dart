import 'dart:convert';
import 'base_api_service.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final BaseApiService _apiService = BaseApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Register a new user
  Future<AuthResponse> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String preferredLanguage,
    required String gender,
    required String dateOfBirth,
    required String role,
  }) async {
    final data = {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'role': role,
      'preferredLanguage': preferredLanguage,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
    };

    final response = await _apiService.post(ApiConfig.registerEndpoint, data: data);
    
    if (response['status'] == 'success' && response['data'] != null) {
      final authResponse = AuthResponse.fromJson(response['data']);
      await _saveAuthData(authResponse);
      return authResponse;
    } else {
      throw ApiException(response['message'] ?? 'Registration failed');
    }
  }

  // Login with existing credentials
  Future<AuthResponse> login({
    required String identifier,
    required String password,
  }) async {
    final data = {
      'identifier': identifier,
      'password': password,
    };

    final response = await _apiService.post(ApiConfig.loginEndpoint, data: data);
    
    if (response['status'] == 'success' && response['data'] != null) {
      final authResponse = AuthResponse.fromJson(response['data']);
      await _saveAuthData(authResponse);
      return authResponse;
    } else {
      throw ApiException(response['message'] ?? 'Login failed');
    }
  }


  // Verify doctor profile
  Future<void> verifyDoctor({
    required String hospitalId,
    required String specialization,
    required int experience,
    required List<String> languages,
    required String currentHospitalClinic,
    required String pincode,
  }) async {
    final data = {
      'hospitalId': hospitalId,
      'specialization': specialization,
      'experience': experience,
      'languages': languages,
      'currentHospitalClinic': currentHospitalClinic,
      'pincode': pincode,
    };

    final response = await _apiService.post(ApiConfig.verifyDoctorEndpoint, data: data);
    
    if (response['status'] != 'success') {
      throw ApiException(response['message'] ?? 'Verification failed');
    }
  }

  // Verify pharmacy profile
  Future<void> verifyPharmacy({
    required String storeName,
    String? licenseNumber,
    String? gstNumber,
    required String address,
    String? city,
    String? state,
    required String pincode,
    String? workingHours,
  }) async {
    final data = {
      'storeName': storeName,
      if (licenseNumber != null && licenseNumber.isNotEmpty) 'licenseNumber': licenseNumber,
      if (gstNumber != null && gstNumber.isNotEmpty) 'gstNumber': gstNumber,
      'address': address,
      if (city != null && city.isNotEmpty) 'city': city,
      if (state != null && state.isNotEmpty) 'state': state,
      'pincode': pincode,
      if (workingHours != null && workingHours.isNotEmpty) 'workingHours': workingHours,
    };

    final response = await _apiService.post(ApiConfig.verifyPharmacyEndpoint, data: data);
    
    if (response['status'] != 'success') {
      throw ApiException(response['message'] ?? 'Verification failed');
    }
  }

  // Refresh JWT token
  Future<String> refreshToken(String refreshToken) async {
    final data = {'refreshToken': refreshToken};

    final response = await _apiService.post(ApiConfig.refreshTokenEndpoint, data: data);
    
    if (response['status'] == 'success' && response['data'] != null) {
      final token = response['data']['token'];
      await _apiService.setAuthToken(token);
      return token;
    } else {
      throw ApiException(response['message'] ?? 'Token refresh failed');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.post(ApiConfig.logoutEndpoint);
    } catch (e) {
      // Continue with logout even if API call fails
    }
    
    await _apiService.clearAuthData();
  }

  // Save authentication data to secure storage
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _apiService.setAuthToken(authResponse.token);
    await _secureStorage.write(
      key: ApiConfig.userKey, 
      value: jsonEncode(authResponse.user.toJson())
    );
  }

  // Get current user from storage
  Future<User?> getCurrentUser() async {
    try {
      final userData = await _secureStorage.read(key: ApiConfig.userKey);
      if (userData != null) {
        return User.fromJson(jsonDecode(userData));
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
    return null;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // Check if doctor needs verification
  Future<bool> needsVerification() async {
    final user = await getCurrentUser();
    return user?.needsVerification ?? false;
  }
}
