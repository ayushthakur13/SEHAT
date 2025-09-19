import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth.dart';
import '../models/user.dart';
import 'api_service.dart';

// Providers
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(apiServiceProvider));
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

// Auth State
class AuthState {
  final bool isAuthenticated;
  final User? user;
  final String? error;
  final bool isLoading;
  final bool needsVerification;

  AuthState({
    this.isAuthenticated = false,
    this.user,
    this.error,
    this.isLoading = false,
    this.needsVerification = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    User? user,
    String? error,
    bool? isLoading,
    bool? needsVerification,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
      isLoading: isLoading ?? this.isLoading,
      needsVerification: needsVerification ?? this.needsVerification,
    );
  }
}

// Auth Service
class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _apiService.register(request);
    if (response.isSuccess && response.data != null) {
      await _apiService.saveAuthToken(response.data!.token);
      await _apiService.saveUserData(response.data!.user.toJson());
    }
    return response;
  }

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiService.login(request);
    if (response.isSuccess && response.data != null) {
      await _apiService.saveAuthToken(response.data!.token);
      await _apiService.saveUserData(response.data!.user.toJson());
    }
    return response;
  }

  Future<bool> isAuthenticated() async {
    return await _apiService.isAuthenticated();
  }

  Future<User?> getCurrentUser() async {
    final userData = await _apiService.getUserData();
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }

  Future<void> logout() async {
    await _apiService.logout();
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyDoctor(
      DoctorVerificationRequest request) async {
    return await _apiService.verifyDoctor(request);
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyPharmacy(
      PharmacyVerificationRequest request) async {
    return await _apiService.verifyPharmacy(request);
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        final user = await _authService.getCurrentUser();
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
          needsVerification: user != null && !user.isVerified,
        );
      } else {
        state = state.copyWith(isAuthenticated: false, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        isAuthenticated: false,
      );
    }
  }

  Future<void> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.register(request);
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          isAuthenticated: true,
          user: response.data!.user,
          isLoading: false,
          needsVerification: !response.data!.user.isVerified,
        );
      } else {
        state = state.copyWith(
          error: response.message,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> login(LoginRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.login(request);
      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          isAuthenticated: true,
          user: response.data!.user,
          isLoading: false,
          needsVerification: !response.data!.user.isVerified,
        );
      } else {
        state = state.copyWith(
          error: response.message,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.logout();
      state = AuthState(); // Reset to initial state
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> verifyDoctor(DoctorVerificationRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.verifyDoctor(request);
      if (response.isSuccess) {
        // Update user verification status
        if (state.user != null) {
          final updatedUser = state.user!.copyWith(isVerified: true);
          state = state.copyWith(
            user: updatedUser,
            needsVerification: false,
            isLoading: false,
          );
        }
      } else {
        state = state.copyWith(
          error: response.message,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> verifyPharmacy(PharmacyVerificationRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.verifyPharmacy(request);
      if (response.isSuccess) {
        // Update user verification status
        if (state.user != null) {
          final updatedUser = state.user!.copyWith(isVerified: true);
          state = state.copyWith(
            user: updatedUser,
            needsVerification: false,
            isLoading: false,
          );
        }
      } else {
        state = state.copyWith(
          error: response.message,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}