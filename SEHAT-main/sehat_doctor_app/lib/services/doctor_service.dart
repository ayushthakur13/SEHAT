import 'dart:convert';
import 'base_api_service.dart';
import '../config/api_config.dart';
import '../models/doctor.dart';
import '../models/consultation.dart';
import '../models/prescription.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DashboardResponse {
  final Doctor doctor;
  final List<Consultation> todayAppointments;
  final DoctorStats stats;
  final String currentStatus;
  final bool isAvailable;

  DashboardResponse({
    required this.doctor,
    required this.todayAppointments,
    required this.stats,
    required this.currentStatus,
    required this.isAvailable,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      doctor: Doctor.fromJson(json['doctor'] ?? {}),
      todayAppointments: (json['todayAppointments'] as List? ?? [])
          .map((c) => Consultation.fromJson(c))
          .toList(),
      stats: DoctorStats.fromJson(json['stats'] ?? {}),
      currentStatus: json['currentStatus'] ?? 'unavailable',
      isAvailable: json['isAvailable'] ?? false,
    );
  }
}

class AppointmentsResponse {
  final List<Consultation> consultations;
  final int total;
  final int totalPages;
  final int currentPage;

  AppointmentsResponse({
    required this.consultations,
    required this.total,
    required this.totalPages,
    required this.currentPage,
  });

  factory AppointmentsResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentsResponse(
      consultations: (json['consultations'] as List? ?? [])
          .map((c) => Consultation.fromJson(c))
          .toList(),
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
    );
  }
}

class DoctorService {
  static final DoctorService _instance = DoctorService._internal();
  factory DoctorService() => _instance;
  DoctorService._internal();

  final BaseApiService _apiService = BaseApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Get doctor dashboard
  Future<DashboardResponse> getDashboard() async {
    final response = await _apiService.get(ApiConfig.doctorDashboardEndpoint);
    
    if (response['status'] == 'success' && response['data'] != null) {
      return DashboardResponse.fromJson(response['data']);
    } else {
      throw ApiException(response['message'] ?? 'Failed to load dashboard');
    }
  }

  // Get doctor profile
  Future<Doctor> getProfile() async {
    final response = await _apiService.get(ApiConfig.doctorProfileEndpoint);
    
    if (response['status'] == 'success' && response['data'] != null) {
      final doctor = Doctor.fromJson(response['data']['doctor']);
      await _saveDoctorData(doctor);
      return doctor;
    } else {
      throw ApiException(response['message'] ?? 'Failed to load profile');
    }
  }

  // Update doctor profile
  Future<Doctor> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiService.put(ApiConfig.doctorProfileEndpoint, data: data);
    
    if (response['status'] == 'success' && response['data'] != null) {
      final doctor = Doctor.fromJson(response['data']['doctor']);
      await _saveDoctorData(doctor);
      return doctor;
    } else {
      throw ApiException(response['message'] ?? 'Failed to update profile');
    }
  }

  // Update availability
  Future<void> updateAvailability({
    required String status,
    required Map<String, dynamic> schedule,
    required Map<String, Map<String, String>> workingHours,
  }) async {
    final data = {
      'status': status,
      'schedule': schedule,
      'workingHours': workingHours,
    };

    final response = await _apiService.put(ApiConfig.doctorAvailabilityEndpoint, data: data);
    
    if (response['status'] != 'success') {
      throw ApiException(response['message'] ?? 'Failed to update availability');
    }
  }

  // Get appointments
  Future<AppointmentsResponse> getAppointments({
    String? status,
    String? date,
    String? type,
    int limit = 20,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };

    if (status != null) queryParams['status'] = status;
    if (date != null) queryParams['date'] = date;
    if (type != null) queryParams['type'] = type;

    final response = await _apiService.get(
      ApiConfig.doctorAppointmentsEndpoint,
      queryParams: queryParams,
    );
    
    if (response['status'] == 'success' && response['data'] != null) {
      return AppointmentsResponse.fromJson(response['data']);
    } else {
      throw ApiException(response['message'] ?? 'Failed to load appointments');
    }
  }

  // Update appointment status
  Future<Consultation> updateAppointmentStatus(
    int appointmentId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiService.put(
      '${ApiConfig.doctorAppointmentsEndpoint}/$appointmentId/status',
      data: data,
    );
    
    if (response['status'] == 'success' && response['data'] != null) {
      return Consultation.fromJson(response['data']['appointment']);
    } else {
      throw ApiException(response['message'] ?? 'Failed to update appointment');
    }
  }

  // Create consultation
  Future<Consultation> createConsultation(Map<String, dynamic> data) async {
    final response = await _apiService.post(ApiConfig.doctorConsultationsEndpoint, data: data);
    
    if (response['status'] == 'success' && response['data'] != null) {
      return Consultation.fromJson(response['data']['consultation']);
    } else {
      throw ApiException(response['message'] ?? 'Failed to create consultation');
    }
  }

  // Join consultation
  Future<Map<String, dynamic>> joinConsultation(int consultationId) async {
    final response = await _apiService.post(
      '${ApiConfig.doctorConsultationsEndpoint}/$consultationId/join',
    );
    
    if (response['status'] == 'success' && response['data'] != null) {
      return response['data'];
    } else {
      throw ApiException(response['message'] ?? 'Failed to join consultation');
    }
  }

  // Get patient health records
  Future<Map<String, dynamic>> getPatientHealthRecords(int patientId) async {
    final response = await _apiService.get(
      '${ApiConfig.patientHealthRecordsEndpoint}/$patientId/health-records',
    );
    
    if (response['status'] == 'success' && response['data'] != null) {
      return response['data'];
    } else {
      throw ApiException(response['message'] ?? 'Failed to load patient records');
    }
  }

  // Create health record
  Future<void> createHealthRecord(Map<String, dynamic> data) async {
    final response = await _apiService.post(ApiConfig.doctorHealthRecordsEndpoint, data: data);
    
    if (response['status'] != 'success') {
      throw ApiException(response['message'] ?? 'Failed to create health record');
    }
  }

  // Create prescription
  Future<Prescription> createPrescription(Map<String, dynamic> data) async {
    final response = await _apiService.post(ApiConfig.doctorPrescriptionsEndpoint, data: data);
    
    if (response['status'] == 'success' && response['data'] != null) {
      return Prescription.fromJson(response['data']['prescription']);
    } else {
      throw ApiException(response['message'] ?? 'Failed to create prescription');
    }
  }

  // Get notifications
  Future<Map<String, dynamic>> getNotifications({
    int limit = 20,
    int offset = 0,
    bool? unreadOnly,
    String? type,
    String? priority,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };

    if (unreadOnly != null) queryParams['unreadOnly'] = unreadOnly;
    if (type != null) queryParams['type'] = type;
    if (priority != null) queryParams['priority'] = priority;

    final response = await _apiService.get(
      ApiConfig.doctorNotificationsEndpoint,
      queryParams: queryParams,
    );
    
    if (response['status'] == 'success' && response['data'] != null) {
      return response['data'];
    } else {
      throw ApiException(response['message'] ?? 'Failed to load notifications');
    }
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
    final response = await _apiService.put(
      '${ApiConfig.doctorNotificationsEndpoint}/$notificationId/read',
    );
    
    if (response['status'] != 'success') {
      throw ApiException(response['message'] ?? 'Failed to mark notification as read');
    }
  }

  // Send message to patient
  Future<void> sendMessageToPatient(Map<String, dynamic> data) async {
    final response = await _apiService.post(ApiConfig.doctorMessagesEndpoint, data: data);
    
    if (response['status'] != 'success') {
      throw ApiException(response['message'] ?? 'Failed to send message');
    }
  }

  // Get analytics
  Future<Map<String, dynamic>> getAnalytics({String timeRange = '30d'}) async {
    final response = await _apiService.get(
      ApiConfig.doctorAnalyticsEndpoint,
      queryParams: {'timeRange': timeRange},
    );
    
    if (response['status'] == 'success' && response['data'] != null) {
      return response['data'];
    } else {
      throw ApiException(response['message'] ?? 'Failed to load analytics');
    }
  }

  // Sync offline data
  Future<Map<String, dynamic>> syncOfflineData(Map<String, dynamic> data) async {
    final response = await _apiService.post(ApiConfig.doctorSyncEndpoint, data: data);
    
    if (response['status'] == 'success' && response['data'] != null) {
      return response['data'];
    } else {
      throw ApiException(response['message'] ?? 'Failed to sync data');
    }
  }

  // Get unsynced data
  Future<Map<String, dynamic>> getUnsyncedData() async {
    final response = await _apiService.get('${ApiConfig.doctorSyncEndpoint}/unsynced');
    
    if (response['status'] == 'success' && response['data'] != null) {
      return response['data'];
    } else {
      throw ApiException(response['message'] ?? 'Failed to get unsynced data');
    }
  }

  // Save doctor data to secure storage
  Future<void> _saveDoctorData(Doctor doctor) async {
    await _secureStorage.write(
      key: ApiConfig.doctorKey,
      value: jsonEncode(doctor.toJson()),
    );
  }

  // Get current doctor from storage
  Future<Doctor?> getCurrentDoctor() async {
    try {
      final doctorData = await _secureStorage.read(key: ApiConfig.doctorKey);
      if (doctorData != null) {
        return Doctor.fromJson(jsonDecode(doctorData));
      }
    } catch (e) {
      print('Error getting current doctor: $e');
    }
    return null;
  }
}
