import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/base_api_service.dart';
import '../models/user.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  needsVerification,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;

  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get needsVerification => _state == AuthState.needsVerification;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      _setState(AuthState.loading);
      
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        _user = await _authService.getCurrentUser();
        if (_user != null) {
          final needsVerif = await _authService.needsVerification();
          _setState(needsVerif ? AuthState.needsVerification : AuthState.authenticated);
        } else {
          _setState(AuthState.unauthenticated);
        }
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setError('Failed to initialize authentication: $e');
    }
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    try {
      _setState(AuthState.loading);
      
      final authResponse = await _authService.login(
        identifier: identifier,
        password: password,
      );
      
      _user = authResponse.user;
      
      final needsVerif = await _authService.needsVerification();
      _setState(needsVerif ? AuthState.needsVerification : AuthState.authenticated);
      
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred during login: $e');
    }
  }

  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String preferredLanguage,
    required String gender,
    required String dateOfBirth,
    required String role,
  }) async {
    try {
      _setState(AuthState.loading);
      
      final authResponse = await _authService.register(
        name: name,
        phone: phone,
        email: email,
        password: password,
        preferredLanguage: preferredLanguage,
        gender: gender,
        dateOfBirth: dateOfBirth,
        role: role,
      );
      
      _user = authResponse.user;
      
      // Patient goes directly to authenticated, others need verification
      if (role.toLowerCase() == 'patient') {
        _setState(AuthState.authenticated);
      } else {
        _setState(AuthState.needsVerification);
      }
      
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred during registration: $e');
    }
  }


  Future<void> verifyDoctor({
    required String hospitalId,
    required String specialization,
    required int experience,
    required List<String> languages,
    required String currentHospitalClinic,
    required String pincode,
  }) async {
    try {
      _setState(AuthState.loading);
      
      await _authService.verifyDoctor(
        hospitalId: hospitalId,
        specialization: specialization,
        experience: experience,
        languages: languages,
        currentHospitalClinic: currentHospitalClinic,
        pincode: pincode,
      );
      
      // Update user verification status
      if (_user != null) {
        _user = _user!.copyWith(isVerified: true, needsVerification: false);
      }
      
      _setState(AuthState.authenticated);
      
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred during verification: $e');
    }
  }

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
    try {
      _setState(AuthState.loading);
      
      await _authService.verifyPharmacy(
        storeName: storeName,
        licenseNumber: licenseNumber,
        gstNumber: gstNumber,
        address: address,
        city: city,
        state: state,
        pincode: pincode,
        workingHours: workingHours,
      );
      
      // Update user verification status
      if (_user != null) {
        _user = _user!.copyWith(isVerified: true, needsVerification: false);
      }
      
      _setState(AuthState.authenticated);
      
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('An unexpected error occurred during verification: $e');
    }
  }

  Future<void> logout() async {
    try {
      _setState(AuthState.loading);
      await _authService.logout();
      _user = null;
      _setState(AuthState.unauthenticated);
    } catch (e) {
      // Even if logout fails on the server, clear local data
      _user = null;
      _setState(AuthState.unauthenticated);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setState(AuthState newState) {
    _state = newState;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String error) {
    _state = AuthState.error;
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    try {
      _user = await _authService.getCurrentUser();
      if (_user != null) {
        final needsVerif = await _authService.needsVerification();
        _setState(needsVerif ? AuthState.needsVerification : AuthState.authenticated);
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }
}
