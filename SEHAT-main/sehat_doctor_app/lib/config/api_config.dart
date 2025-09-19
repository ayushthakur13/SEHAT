class ApiConfig {
  static const String baseUrl = 'http://localhost:5000';
  static const String apiVersion = '/api';
  
  // Auth endpoints
  static const String loginEndpoint = '$apiVersion/auth/login';
  static const String registerEndpoint = '$apiVersion/auth/register';
  static const String verifyDoctorEndpoint = '$apiVersion/auth/verify/doctor';
  static const String verifyPharmacyEndpoint = '$apiVersion/auth/verify/pharmacy';
  static const String refreshTokenEndpoint = '$apiVersion/auth/refresh';
  static const String logoutEndpoint = '$apiVersion/auth/logout';
  
  // Doctor endpoints
  static const String doctorDashboardEndpoint = '$apiVersion/doctors/dashboard';
  static const String doctorProfileEndpoint = '$apiVersion/doctors/profile';
  static const String doctorAvailabilityEndpoint = '$apiVersion/doctors/availability';
  static const String doctorAppointmentsEndpoint = '$apiVersion/doctors/appointments';
  static const String doctorConsultationsEndpoint = '$apiVersion/doctors/consultations';
  static const String doctorNotificationsEndpoint = '$apiVersion/doctors/notifications';
  static const String doctorAnalyticsEndpoint = '$apiVersion/doctors/analytics';
  static const String doctorSyncEndpoint = '$apiVersion/doctors/sync';
  static const String doctorPrescriptionsEndpoint = '$apiVersion/doctors/prescriptions';
  static const String doctorHealthRecordsEndpoint = '$apiVersion/doctors/health-records';
  static const String doctorMessagesEndpoint = '$apiVersion/doctors/messages';
  
  // Patient endpoints
  static const String patientHealthRecordsEndpoint = '$apiVersion/doctors/patients';
  
  // Medicine endpoints  
  static const String medicinesEndpoint = '$apiVersion/medicines';
  
  // Health check
  static const String healthCheckEndpoint = '/health';
  
  // Request timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'Accept';
  
  static const String contentTypeJson = 'application/json';
  static const String bearerPrefix = 'Bearer ';
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String doctorKey = 'doctor_data';
}
