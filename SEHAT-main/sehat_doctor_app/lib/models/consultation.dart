import 'patient.dart';
import 'doctor.dart';
import 'prescription.dart';

enum ConsultationStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
}

enum ConsultationType {
  video,
  audio,
  chat,
}

class Consultation {
  final int id;
  final int patientId;
  final int? doctorId;
  final DateTime appointmentDate;
  final String startTime;
  final String? endTime;
  final ConsultationStatus status;
  final ConsultationType consultationType;
  final String? symptoms;
  final String? diagnosis;
  final String? notes;
  final String? meetingUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Patient? patient;
  final Doctor? doctor;
  final Prescription? prescription;

  Consultation({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.appointmentDate,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.consultationType,
    this.symptoms,
    this.diagnosis,
    this.notes,
    this.meetingUrl,
    required this.createdAt,
    this.updatedAt,
    this.patient,
    this.doctor,
    this.prescription,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] ?? 0,
      patientId: json['patientId'] ?? 0,
      doctorId: json['doctorId'],
      appointmentDate: DateTime.parse(json['appointmentDate'] ?? DateTime.now().toIso8601String()),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'],
      status: _parseStatus(json['status']),
      consultationType: _parseType(json['consultationType']),
      symptoms: json['symptoms'],
      diagnosis: json['diagnosis'],
      notes: json['notes'],
      meetingUrl: json['meetingUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      patient: json['patient'] != null ? Patient.fromJson(json['patient']) : null,
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
      prescription: json['prescription'] != null ? Prescription.fromJson(json['prescription']) : null,
    );
  }

  static ConsultationStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'scheduled':
        return ConsultationStatus.scheduled;
      case 'in_progress':
      case 'inprogress':
        return ConsultationStatus.inProgress;
      case 'completed':
        return ConsultationStatus.completed;
      case 'cancelled':
        return ConsultationStatus.cancelled;
      default:
        return ConsultationStatus.scheduled;
    }
  }

  static ConsultationType _parseType(String? type) {
    switch (type?.toLowerCase()) {
      case 'video':
        return ConsultationType.video;
      case 'audio':
        return ConsultationType.audio;
      case 'chat':
        return ConsultationType.chat;
      default:
        return ConsultationType.video;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'status': status.name,
      'consultationType': consultationType.name,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'notes': notes,
      'meetingUrl': meetingUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'patient': patient?.toJson(),
      'doctor': doctor?.toJson(),
      'prescription': prescription?.toJson(),
    };
  }

  Consultation copyWith({
    int? id,
    int? patientId,
    int? doctorId,
    DateTime? appointmentDate,
    String? startTime,
    String? endTime,
    ConsultationStatus? status,
    ConsultationType? consultationType,
    String? symptoms,
    String? diagnosis,
    String? notes,
    String? meetingUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    Patient? patient,
    Doctor? doctor,
    Prescription? prescription,
  }) {
    return Consultation(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      consultationType: consultationType ?? this.consultationType,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      notes: notes ?? this.notes,
      meetingUrl: meetingUrl ?? this.meetingUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      patient: patient ?? this.patient,
      doctor: doctor ?? this.doctor,
      prescription: prescription ?? this.prescription,
    );
  }

  String get statusString {
    switch (status) {
      case ConsultationStatus.scheduled:
        return 'Scheduled';
      case ConsultationStatus.inProgress:
        return 'In Progress';
      case ConsultationStatus.completed:
        return 'Completed';
      case ConsultationStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get typeString {
    switch (consultationType) {
      case ConsultationType.video:
        return 'Video Call';
      case ConsultationType.audio:
        return 'Audio Call';
      case ConsultationType.chat:
        return 'Chat';
    }
  }
}
