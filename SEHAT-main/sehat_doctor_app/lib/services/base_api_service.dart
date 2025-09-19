import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class BaseApiService {
  static final BaseApiService _instance = BaseApiService._internal();
  factory BaseApiService() => _instance;
  BaseApiService._internal();

  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  void initialize() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = ApiConfig.connectTimeout;
    _dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    _dio.options.headers = {
      ApiConfig.contentTypeHeader: ApiConfig.contentTypeJson,
      ApiConfig.acceptHeader: ApiConfig.contentTypeJson,
    };

    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));

    // Add logging in debug mode
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add auth token to requests
    final token = await getAuthToken();
    if (token != null) {
      options.headers[ApiConfig.authorizationHeader] = '${ApiConfig.bearerPrefix}$token';
    }

    print('🔗 ${options.method} ${options.path}');
    print('📤 Headers: ${options.headers}');
    if (options.data != null) {
      print('📤 Body: ${options.data}');
    }

    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    print('📥 ${response.statusCode} ${response.requestOptions.path}');
    print('📥 Response: ${response.data}');
    handler.next(response);
  }

  void _onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ${err.response?.statusCode} ${err.requestOptions.path}');
    print('❌ Error: ${err.response?.data ?? err.message}');

    // Handle token expiration
    if (err.response?.statusCode == 401) {
      _handleUnauthorized();
    }

    handler.next(err);
  }

  void _handleUnauthorized() {
    // Clear stored auth data and redirect to login
    clearAuthData();
    // You might want to emit an event or use a global navigation here
  }

  // Auth token management
  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: ApiConfig.tokenKey);
  }

  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(key: ApiConfig.tokenKey, value: token);
  }

  Future<void> clearAuthData() async {
    await _secureStorage.delete(key: ApiConfig.tokenKey);
    await _secureStorage.delete(key: ApiConfig.userKey);
    await _secureStorage.delete(key: ApiConfig.doctorKey);
  }

  // Generic HTTP methods
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else {
      throw ApiException('Invalid response format');
    }
  }

  ApiException _handleDioException(DioException e) {
    String message = 'Network error occurred';
    int? statusCode;

    if (e.response != null) {
      statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      // Special handling for 429 errors to provide better debugging info
      if (statusCode == 429) {
        print('🚫 Rate limit exceeded (429)');
        print('🔍 Request headers: ${e.requestOptions.headers}');
        print('🔍 Request endpoint: ${e.requestOptions.path}');
        print('🔍 Response headers: ${e.response?.headers?.map}');
        message = 'Too many requests. Please wait a moment before trying again.';
      }

      if (responseData is Map<String, dynamic>) {
        message = responseData['message'] ?? responseData['error'] ?? message;
      } else if (responseData is String) {
        message = responseData;
      }
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Request timeout. Please check your internet connection.';
          break;
        case DioExceptionType.connectionError:
          message = 'Unable to connect to server. Please check your internet connection.';
          break;
        case DioExceptionType.cancel:
          message = 'Request was cancelled';
          break;
        default:
          message = 'Network error: ${e.message}';
      }
    }

    return ApiException(message, statusCode: statusCode, data: e.response?.data);
  }

  // Debug method to inspect current auth token state
  Future<void> debugAuthState() async {
    final token = await getAuthToken();
    print('🔑 Auth Token Debug:');
    print('🔑 Token exists: ${token != null}');
    if (token != null) {
      print('🔑 Token length: ${token.length}');
      print('🔑 Token starts with: ${token.substring(0, math.min(20, token.length))}...');
    } else {
      print('🔑 No auth token found in secure storage');
    }
  }

  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get(ApiConfig.healthCheckEndpoint);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
