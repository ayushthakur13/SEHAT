import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add request interceptor to include auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired or invalid
            await clearAuthData();
            // You might want to navigate to login screen here
          }
          handler.next(error);
        },
      ),
    );
  }

  // Storage methods
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: 'user_data', value: jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userData = await _storage.read(key: 'user_data');
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  Future<void> clearAuthData() async {
    await _storage.deleteAll();
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null;
  }

  // API Methods
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post('/api/auth/register', data: request.toJson());
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return AuthResponse.fromJson(e.response!.data);
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/api/auth/login', data: request.toJson());
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return AuthResponse.fromJson(e.response!.data);
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyDoctor(
      DoctorVerificationRequest request) async {
    try {
      final response = await _dio.post('/api/auth/verify/doctor', data: request.toJson());
      return ApiResponse.fromJson(response.data, (data) => data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse.fromJson(e.response!.data, (data) => data);
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyPharmacy(
      PharmacyVerificationRequest request) async {
    try {
      final response = await _dio.post('/api/auth/verify/pharmacy', data: request.toJson());
      return ApiResponse.fromJson(response.data, (data) => data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse.fromJson(e.response!.data, (data) => data);
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> logout() async {
    try {
      final response = await _dio.post('/api/auth/logout');
      await clearAuthData();
      return ApiResponse.fromJson(response.data, (data) => data);
    } on DioException catch (e) {
      await clearAuthData(); // Clear local data even if logout fails
      if (e.response != null) {
        return ApiResponse.fromJson(e.response!.data, (data) => data);
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return ApiResponse.fromJson(response.data, (data) => data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse.fromJson(e.response!.data, (data) => data);
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}