import 'user.dart';

class Patient {
  final int id;
  final String userId;
  final String? bloodGroup;
  final String? emergencyContact;
  final String? allergies;
  final String? chronicConditions;
  final String? currentMedications;
  final String? insuranceNumber;
  final Map<String, dynamic>? medicalHistory;
  final User? user;

  Patient({
    required this.id,
    required this.userId,
    this.bloodGroup,
    this.emergencyContact,
    this.allergies,
    this.chronicConditions,
    this.currentMedications,
    this.insuranceNumber,
    this.medicalHistory,
    this.user,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      bloodGroup: json['bloodGroup'],
      emergencyContact: json['emergencyContact'],
      allergies: json['allergies'],
      chronicConditions: json['chronicConditions'],
      currentMedications: json['currentMedications'],
      insuranceNumber: json['insuranceNumber'],
      medicalHistory: json['medicalHistory'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bloodGroup': bloodGroup,
      'emergencyContact': emergencyContact,
      'allergies': allergies,
      'chronicConditions': chronicConditions,
      'currentMedications': currentMedications,
      'insuranceNumber': insuranceNumber,
      'medicalHistory': medicalHistory,
      'user': user?.toJson(),
    };
  }

  Patient copyWith({
    int? id,
    String? userId,
    String? bloodGroup,
    String? emergencyContact,
    String? allergies,
    String? chronicConditions,
    String? currentMedications,
    String? insuranceNumber,
    Map<String, dynamic>? medicalHistory,
    User? user,
  }) {
    return Patient(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      currentMedications: currentMedications ?? this.currentMedications,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      user: user ?? this.user,
    );
  }
}
