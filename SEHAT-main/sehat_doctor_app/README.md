# SEHAT Doctor App

A comprehensive Flutter application for the SEHAT healthcare platform, specifically designed for doctors to manage their practice, consultations, and patient care.

## Features

### 🔐 Authentication System
- **Doctor Registration**: Complete registration with personal and professional details
- **Login System**: Secure login with email/phone and password
- **Profile Verification**: Multi-step verification process for professional credentials
- **JWT Token Management**: Secure token-based authentication with automatic refresh

### 🏥 Dashboard
- **Welcome Dashboard**: Personalized greeting and quick access to key functions
- **Today's Stats**: Real-time statistics showing appointments, completed consultations, and pending tasks
- **Quick Actions**: Start consultation, toggle availability status
- **Recent Appointments**: Overview of upcoming and recent patient appointments

### 📅 Appointment Management (Coming Soon)
- View all appointments with filtering options
- Update appointment status (scheduled, in-progress, completed, cancelled)
- Join video/audio consultations directly from the app
- Appointment search and filtering capabilities

### 👥 Patient Management (Coming Soon)
- Comprehensive patient profiles
- Medical history and health records
- Patient communication tools
- Treatment tracking and follow-ups

### 💊 Prescription System (Coming Soon)
- Digital prescription creation
- Medicine database integration
- Dosage and frequency management
- Prescription history and tracking

### 📊 Analytics Dashboard (Coming Soon)
- Practice performance metrics
- Patient demographics
- Revenue tracking and reports
- Consultation type breakdown

### 🔔 Notification System (Coming Soon)
- Real-time notifications for appointments
- Patient messages and updates
- System alerts and reminders
- Multi-language notification support

## Technology Stack

### Frontend (Flutter)
- **Flutter 3.x**: Cross-platform mobile development
- **Dart 3.x**: Programming language
- **Provider**: State management solution
- **Dio**: HTTP client for API requests
- **Flutter Secure Storage**: Secure local data storage
- **Loading Animations**: Enhanced user experience
- **Charts (FL Chart)**: Data visualization for analytics
- **Intl**: Internationalization support

### Backend Integration
- **RESTful API**: Integration with Node.js backend
- **JWT Authentication**: Secure token-based authentication
- **Real-time Updates**: WebSocket support for live updates
- **Offline Sync**: Capability to work offline and sync when connected

## Project Structure

```
lib/
├── config/
│   └── api_config.dart          # API endpoints and configuration
├── models/
│   ├── user.dart               # User data model
│   ├── doctor.dart             # Doctor profile model
│   ├── patient.dart            # Patient data model
│   ├── consultation.dart       # Consultation/appointment model
│   ├── prescription.dart       # Prescription data model
│   ├── medicine.dart           # Medicine catalog model
│   └── notification.dart       # Notification model
├── services/
│   ├── base_api_service.dart   # Core API service with interceptors
│   ├── auth_service.dart       # Authentication API calls
│   └── doctor_service.dart     # Doctor-specific API calls
├── providers/
│   └── auth_provider.dart      # Authentication state management
├── screens/
│   ├── auth/
│   │   ├── splash_screen.dart  # App loading screen
│   │   ├── login_screen.dart   # Doctor login
│   │   ├── register_screen.dart # Doctor registration
│   │   └── verification_screen.dart # Profile verification
│   ├── dashboard/
│   │   └── dashboard_screen.dart # Main dashboard with tabs
│   ├── appointments/           # Appointment management (coming soon)
│   ├── patients/              # Patient management (coming soon)
│   ├── prescriptions/         # Prescription system (coming soon)
│   └── analytics/             # Analytics dashboard (coming soon)
├── widgets/                   # Reusable UI components
└── utils/                     # Utility functions and helpers
```

## Backend API Integration

This app integrates with the SEHAT backend API running on `http://localhost:5000`. The key endpoints include:

### Authentication
- `POST /api/auth/register` - Doctor registration
- `POST /api/auth/login` - Doctor login
- `POST /api/auth/verify/doctor` - Profile verification
- `POST /api/auth/logout` - Logout

### Doctor Operations
- `GET /api/doctors/dashboard` - Dashboard data
- `GET /api/doctors/profile` - Doctor profile
- `PUT /api/doctors/profile` - Update profile
- `GET /api/doctors/appointments` - Get appointments
- `PUT /api/doctors/appointments/:id/status` - Update appointment

### Additional Features
- `GET /api/doctors/notifications` - Get notifications
- `GET /api/doctors/analytics` - Get analytics data
- `POST /api/doctors/prescriptions` - Create prescription
- `GET /api/doctors/patients/:id/health-records` - Patient records

## Setup Instructions

### Prerequisites
- Flutter SDK (3.x or higher)
- Dart SDK (3.x or higher)
- Android Studio or VS Code with Flutter extensions
- Android device/emulator or iOS Simulator
- SEHAT backend server running on localhost:5000

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd sehat_doctor_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure JDK (if needed):**
   ```bash
   flutter config --jdk-dir="C:\Program Files\Microsoft\jdk-17.0.16.8-hotspot"
   ```

4. **Verify setup:**
   ```bash
   flutter doctor
   ```

5. **Run the app:**
   ```bash
   flutter run
   ```

### Backend Setup
Make sure the SEHAT backend server is running on `http://localhost:5000`. If you need to change the backend URL, update it in `lib/config/api_config.dart`:

```dart
static const String baseUrl = 'http://your-backend-url:port';
```

## Configuration

### API Configuration
Update `lib/config/api_config.dart` to match your backend configuration:
- Base URL
- API endpoints
- Timeout settings
- Storage keys

### Theme Customization
The app uses a healthcare-focused theme with sea green primary color. Customize it in `lib/main.dart`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF2E8B57), // Sea green
  brightness: Brightness.light,
),
```

## Development Guidelines

### State Management
- Use Provider for global state management
- Keep state logic in provider classes
- Use Consumer widgets for UI updates

### API Integration
- All API calls go through the BaseApiService
- Handle errors consistently using ApiException
- Implement proper loading states

### UI/UX Guidelines
- Follow Material Design 3 principles
- Ensure accessibility compliance
- Implement proper loading animations
- Handle offline states gracefully

### Code Organization
- Keep business logic separate from UI
- Use proper file naming conventions
- Comment complex logic thoroughly
- Follow Dart/Flutter best practices

## Testing

### Run Tests
```bash
flutter test
```

### Run Integration Tests
```bash
flutter integration_test
```

### Code Analysis
```bash
flutter analyze
```

## Deployment

### Android APK
```bash
flutter build apk --release
```

### iOS App
```bash
flutter build ios --release
```

### Play Store Bundle
```bash
flutter build appbundle --release
```

## Security Features

- **Secure Storage**: Sensitive data encrypted using Flutter Secure Storage
- **JWT Tokens**: Automatic token management and refresh
- **API Security**: Request/response interceptors for security headers
- **Input Validation**: Form validation and sanitization
- **Error Handling**: Secure error messages without sensitive info

## Multilingual Support

The app supports multiple languages:
- English
- Hindi (हिंदी)
- Punjabi (ਪੰਜਾਬੀ)

Language selection is available during registration and can be changed in user preferences.

## Offline Capabilities

- **Local Storage**: Critical data cached locally
- **Sync Mechanism**: Automatic synchronization when online
- **Offline Mode**: Basic functionality available without internet
- **Queue System**: API calls queued when offline

## Contributing

1. Fork the repository
2. Create a feature branch
3. Follow coding standards
4. Add proper tests
5. Submit a pull request

## Support

For technical support or questions:
- Check the API documentation in `backend/docs/API_ROUTES_COMPLETE.md`
- Review the Flutter documentation
- Contact the development team

## License

This project is part of the SEHAT healthcare platform. All rights reserved.

---

**Note**: This is a comprehensive Flutter application designed to work with the SEHAT backend. Ensure both the backend server and mobile app are properly configured for optimal functionality.
