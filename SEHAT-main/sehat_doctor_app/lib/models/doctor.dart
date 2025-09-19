import 'user.dart';

class Doctor {
  final int id;
  final String userId;
  final String? hospitalId;
  final String? licenseNumber;
  final String? currentHospitalClinic;
  final String? pincode;
  final String specialization;
  final int experience;
  final String consultationFee;
  final List<String> languages;
  final Map<String, Map<String, String>>? workingHours;
  final bool isAvailable;
  final String currentStatus;
  final String? preferredConsultationType;
  final bool? lowBandwidthMode;
  final bool? offlineCapable;
  final int? totalConsultations;
  final String? rating;
  final int? maxConcurrentConsultations;
  final Map<String, dynamic>? availabilitySchedule;
  final User? user;

  Doctor({
    required this.id,
    required this.userId,
    this.hospitalId,
    this.licenseNumber,
    this.currentHospitalClinic,
    this.pincode,
    required this.specialization,
    required this.experience,
    required this.consultationFee,
    required this.languages,
    this.workingHours,
    required this.isAvailable,
    required this.currentStatus,
    this.preferredConsultationType,
    this.lowBandwidthMode,
    this.offlineCapable,
    this.totalConsultations,
    this.rating,
    this.maxConcurrentConsultations,
    this.availabilitySchedule,
    this.user,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      hospitalId: json['hospitalId'],
      licenseNumber: json['licenseNumber'],
      currentHospitalClinic: json['currentHospitalClinic'],
      pincode: json['pincode'],
      specialization: json['specialization'] ?? '',
      experience: json['experience'] ?? 0,
      consultationFee: json['consultationFee'] ?? '0',
      languages: List<String>.from(json['languages'] ?? []),
      workingHours: json['workingHours'] != null
          ? Map<String, Map<String, String>>.from(
              json['workingHours'].map((key, value) =>
                  MapEntry(key, Map<String, String>.from(value))))
          : null,
      isAvailable: json['isAvailable'] ?? false,
      currentStatus: json['currentStatus'] ?? 'unavailable',
      preferredConsultationType: json['preferredConsultationType'],
      lowBandwidthMode: json['lowBandwidthMode'],
      offlineCapable: json['offlineCapable'],
      totalConsultations: json['totalConsultations'],
      rating: json['rating'],
      maxConcurrentConsultations: json['maxConcurrentConsultations'],
      availabilitySchedule: json['availabilitySchedule'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'hospitalId': hospitalId,
      'licenseNumber': licenseNumber,
      'currentHospitalClinic': currentHospitalClinic,
      'pincode': pincode,
      'specialization': specialization,
      'experience': experience,
      'consultationFee': consultationFee,
      'languages': languages,
      'workingHours': workingHours,
      'isAvailable': isAvailable,
      'currentStatus': currentStatus,
      'preferredConsultationType': preferredConsultationType,
      'lowBandwidthMode': lowBandwidthMode,
      'offlineCapable': offlineCapable,
      'totalConsultations': totalConsultations,
      'rating': rating,
      'maxConcurrentConsultations': maxConcurrentConsultations,
      'availabilitySchedule': availabilitySchedule,
      'user': user?.toJson(),
    };
  }

  Doctor copyWith({
    int? id,
    String? userId,
    String? hospitalId,
    String? licenseNumber,
    String? currentHospitalClinic,
    String? pincode,
    String? specialization,
    int? experience,
    String? consultationFee,
    List<String>? languages,
    Map<String, Map<String, String>>? workingHours,
    bool? isAvailable,
    String? currentStatus,
    String? preferredConsultationType,
    bool? lowBandwidthMode,
    bool? offlineCapable,
    int? totalConsultations,
    String? rating,
    int? maxConcurrentConsultations,
    Map<String, dynamic>? availabilitySchedule,
    User? user,
  }) {
    return Doctor(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      hospitalId: hospitalId ?? this.hospitalId,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      currentHospitalClinic: currentHospitalClinic ?? this.currentHospitalClinic,
      pincode: pincode ?? this.pincode,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      consultationFee: consultationFee ?? this.consultationFee,
      languages: languages ?? this.languages,
      workingHours: workingHours ?? this.workingHours,
      isAvailable: isAvailable ?? this.isAvailable,
      currentStatus: currentStatus ?? this.currentStatus,
      preferredConsultationType: preferredConsultationType ?? this.preferredConsultationType,
      lowBandwidthMode: lowBandwidthMode ?? this.lowBandwidthMode,
      offlineCapable: offlineCapable ?? this.offlineCapable,
      totalConsultations: totalConsultations ?? this.totalConsultations,
      rating: rating ?? this.rating,
      maxConcurrentConsultations: maxConcurrentConsultations ?? this.maxConcurrentConsultations,
      availabilitySchedule: availabilitySchedule ?? this.availabilitySchedule,
      user: user ?? this.user,
    );
  }
}

class DoctorStats {
  final int totalConsultations;
  final int monthlyConsultations;
  final int pendingConsultations;
  final int completedToday;

  DoctorStats({
    required this.totalConsultations,
    required this.monthlyConsultations,
    required this.pendingConsultations,
    required this.completedToday,
  });

  factory DoctorStats.fromJson(Map<String, dynamic> json) {
    return DoctorStats(
      totalConsultations: json['totalConsultations'] ?? 0,
      monthlyConsultations: json['monthlyConsultations'] ?? 0,
      pendingConsultations: json['pendingConsultations'] ?? 0,
      completedToday: json['completedToday'] ?? 0,
    );
  }
}
