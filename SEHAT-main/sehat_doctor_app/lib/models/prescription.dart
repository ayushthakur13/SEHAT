import 'medicine.dart';

class Prescription {
  final int id;
  final int patientId;
  final int doctorId;
  final int? consultationId;
  final String prescriptionNumber;
  final String? diagnosis;
  final String? instructions;
  final String language;
  final DateTime? validUntil;
  final bool isEmergency;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<Medicine>? medicines;

  Prescription({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.consultationId,
    required this.prescriptionNumber,
    this.diagnosis,
    this.instructions,
    required this.language,
    this.validUntil,
    required this.isEmergency,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.medicines,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] ?? 0,
      patientId: json['patientId'] ?? 0,
      doctorId: json['doctorId'] ?? 0,
      consultationId: json['consultationId'],
      prescriptionNumber: json['prescriptionNumber'] ?? '',
      diagnosis: json['diagnosis'],
      instructions: json['instructions'],
      language: json['language'] ?? 'english',
      validUntil: json['validUntil'] != null ? DateTime.parse(json['validUntil']) : null,
      isEmergency: json['isEmergency'] ?? false,
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      medicines: json['medicines'] != null
          ? (json['medicines'] as List).map((m) => Medicine.fromJson(m)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'consultationId': consultationId,
      'prescriptionNumber': prescriptionNumber,
      'diagnosis': diagnosis,
      'instructions': instructions,
      'language': language,
      'validUntil': validUntil?.toIso8601String(),
      'isEmergency': isEmergency,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'medicines': medicines?.map((m) => m.toJson()).toList(),
    };
  }

  Prescription copyWith({
    int? id,
    int? patientId,
    int? doctorId,
    int? consultationId,
    String? prescriptionNumber,
    String? diagnosis,
    String? instructions,
    String? language,
    DateTime? validUntil,
    bool? isEmergency,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Medicine>? medicines,
  }) {
    return Prescription(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      consultationId: consultationId ?? this.consultationId,
      prescriptionNumber: prescriptionNumber ?? this.prescriptionNumber,
      diagnosis: diagnosis ?? this.diagnosis,
      instructions: instructions ?? this.instructions,
      language: language ?? this.language,
      validUntil: validUntil ?? this.validUntil,
      isEmergency: isEmergency ?? this.isEmergency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      medicines: medicines ?? this.medicines,
    );
  }
}
