class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String preferredLanguage;
  final String? gender;
  final DateTime? dateOfBirth;
  final bool isVerified;
  final bool? needsVerification;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.preferredLanguage,
    this.gender,
    this.dateOfBirth,
    required this.isVerified,
    this.needsVerification,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      preferredLanguage: json['preferredLanguage'] ?? 'english',
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      isVerified: json['isVerified'] ?? false,
      needsVerification: json['needsVerification'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'preferredLanguage': preferredLanguage,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'isVerified': isVerified,
      'needsVerification': needsVerification,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? preferredLanguage,
    String? gender,
    DateTime? dateOfBirth,
    bool? isVerified,
    bool? needsVerification,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isVerified: isVerified ?? this.isVerified,
      needsVerification: needsVerification ?? this.needsVerification,
    );
  }
}
