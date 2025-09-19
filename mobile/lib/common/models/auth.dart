import 'user.dart';

class LoginRequest {
  final String identifier; // phone or email
  final String password;

  LoginRequest({
    required this.identifier,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String name;
  final String phone;
  final String? email;
  final String password;
  final String role;
  final String preferredLanguage;
  final String? gender;
  final String? dateOfBirth;

  RegisterRequest({
    required this.name,
    required this.phone,
    this.email,
    required this.password,
    required this.role,
    required this.preferredLanguage,
    this.gender,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'role': role,
      'preferredLanguage': preferredLanguage,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
    };
  }
}

class DoctorVerificationRequest {
  final String hospitalId;
  final String specialization;
  final int experience;
  final List<String> languages;
  final String currentHospitalClinic;
  final String pincode;

  DoctorVerificationRequest({
    required this.hospitalId,
    required this.specialization,
    required this.experience,
    required this.languages,
    required this.currentHospitalClinic,
    required this.pincode,
  });

  Map<String, dynamic> toJson() {
    return {
      'hospitalId': hospitalId,
      'specialization': specialization,
      'experience': experience,
      'languages': languages,
      'currentHospitalClinic': currentHospitalClinic,
      'pincode': pincode,
    };
  }
}

class PharmacyVerificationRequest {
  final String storeName;
  final String? licenseNumber;
  final String? gstNumber;
  final String address;
  final String? city;
  final String? state;
  final String pincode;
  final Map<String, dynamic>? workingHours;

  PharmacyVerificationRequest({
    required this.storeName,
    this.licenseNumber,
    this.gstNumber,
    required this.address,
    this.city,
    this.state,
    required this.pincode,
    this.workingHours,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'licenseNumber': licenseNumber,
      'gstNumber': gstNumber,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'workingHours': workingHours,
    };
  }
}

class AuthResponse {
  final String status;
  final String message;
  final AuthData? data;

  AuthResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }

  bool get isSuccess => status == 'success';
}

class AuthData {
  final String token;
  final User user;

  AuthData({
    required this.token,
    required this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}

class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;
  final String? error;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      error: json['error'],
    );
  }

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';
}