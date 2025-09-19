class User {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String role;
  final String preferredLanguage;
  final String? gender;
  final DateTime? dateOfBirth;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.role,
    required this.preferredLanguage,
    this.gender,
    this.dateOfBirth,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      role: json['role'],
      preferredLanguage: json['preferredLanguage'] ?? 'english',
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'preferredLanguage': preferredLanguage,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'isVerified': isVerified,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? role,
    String? preferredLanguage,
    String? gender,
    DateTime? dateOfBirth,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class Doctor {
  final int id;
  final String userId;
  final String? hospitalId;
  final String? licenseNumber;
  final String? specialization;
  final int? experience;
  final String? consultationFee;
  final List<String>? languages;
  final String? currentHospitalClinic;
  final String? pincode;
  final bool isAvailable;
  final String currentStatus;
  final User user;

  Doctor({
    required this.id,
    required this.userId,
    this.hospitalId,
    this.licenseNumber,
    this.specialization,
    this.experience,
    this.consultationFee,
    this.languages,
    this.currentHospitalClinic,
    this.pincode,
    required this.isAvailable,
    required this.currentStatus,
    required this.user,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      userId: json['userId'],
      hospitalId: json['hospitalId'],
      licenseNumber: json['licenseNumber'],
      specialization: json['specialization'],
      experience: json['experience'],
      consultationFee: json['consultationFee'],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      currentHospitalClinic: json['currentHospitalClinic'],
      pincode: json['pincode'],
      isAvailable: json['isAvailable'] ?? false,
      currentStatus: json['currentStatus'] ?? 'unavailable',
      user: User.fromJson(json['user']),
    );
  }
}

class Patient {
  final int id;
  final String userId;
  final User user;

  Patient({
    required this.id,
    required this.userId,
    required this.user,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      userId: json['userId'],
      user: User.fromJson(json['user']),
    );
  }
}

class Pharmacy {
  final int id;
  final String userId;
  final String? storeName;
  final String? licenseNumber;
  final String? gstNumber;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final bool isVerified;
  final User user;

  Pharmacy({
    required this.id,
    required this.userId,
    this.storeName,
    this.licenseNumber,
    this.gstNumber,
    this.address,
    this.city,
    this.state,
    this.pincode,
    required this.isVerified,
    required this.user,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'],
      userId: json['userId'],
      storeName: json['storeName'],
      licenseNumber: json['licenseNumber'],
      gstNumber: json['gstNumber'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      isVerified: json['isVerified'] ?? false,
      user: User.fromJson(json['user']),
    );
  }
}