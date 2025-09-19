# SEHAT Mobile App

A comprehensive Flutter mobile application for healthcare management, serving patients, doctors, and pharmacies.

## Overview

SEHAT Mobile is a unified Flutter application that provides different user experiences based on the user's role (Patient, Doctor, or Pharmacy). The app includes authentication, role-based navigation, and dedicated dashboards for each user type.

## Features

### Common Features
- **Multi-language support** (English, Hindi, Punjabi)
- **Secure authentication** with JWT tokens
- **Role-based routing** and access control
- **Beautiful Material Design 3 UI**
- **State management** using Riverpod
- **Secure storage** for sensitive data
- **Responsive design** for various screen sizes

### Patient Features
- Find and book appointments with doctors
- View medical history and health records
- Access prescriptions and medication details
- Manage personal profile

### Doctor Features
- Manage patient appointments and consultations
- Create and manage prescriptions
- View patient health records
- Analytics and performance metrics
- Availability management
- Video consultations

### Pharmacy Features
- Process prescription orders
- Inventory management
- Order tracking and fulfillment
- Sales reports and analytics
- Stock level monitoring

## Architecture

### Project Structure
```
lib/
├── common/           # Shared components and services
│   ├── models/      # Data models (User, Auth, etc.)
│   ├── services/    # API, Auth, Theme services
│   ├── screens/     # Common screens (Login, Register, Verification)
│   └── widgets/     # Reusable UI components
├── patient/         # Patient-specific features
├── doctor/          # Doctor-specific features
└── pharmacy/        # Pharmacy-specific features
```

### Technology Stack
- **Framework**: Flutter 3.10+
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Secure Storage**: Flutter Secure Storage
- **UI Framework**: Material Design 3
- **Language**: Dart

## Getting Started

### Prerequisites
- Flutter SDK 3.10.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- SEHAT Backend server running on `http://localhost:5000`

### Installation

1. **Clone the repository** (if not already done)
2. **Navigate to the mobile directory**
   ```bash
   cd mobile
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

The app is configured to connect to the backend server at `http://localhost:5000`. If your backend is running on a different URL, update the `baseUrl` in `lib/common/services/api_service.dart`.

## User Flow

### Authentication Flow
1. **Splash Screen** - App initialization
2. **Login/Register** - User authentication
3. **Verification** - Professional verification (for doctors/pharmacies)
4. **Role-based Home** - Redirect to appropriate dashboard

### Navigation
- Automatic role-based routing after authentication
- Deep linking support
- Protected routes based on user permissions

## API Integration

The app integrates with the SEHAT backend API for:
- User authentication (login, register, verify)
- User profile management
- Role-specific data retrieval
- Real-time updates and notifications

### API Endpoints Used
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/verify/doctor` - Doctor verification
- `POST /api/auth/verify/pharmacy` - Pharmacy verification
- `POST /api/auth/logout` - User logout

## State Management

Using Riverpod for state management:
- **AuthStateProvider** - Manages authentication state
- **ApiServiceProvider** - Handles API communications
- **ThemeProvider** - Manages app theming

## Security Features

- JWT token-based authentication
- Secure storage for sensitive data
- API request/response encryption
- Role-based access control
- Automatic token refresh handling

## Customization

### Theming
The app uses a custom healthcare-themed design with:
- Primary color: Sea Green (#2E8B57)
- Material Design 3 components
- Support for light and dark themes

### Localization
The app supports multiple languages with easy extensibility for new languages.

## Development

### Adding New Features
1. Create feature-specific widgets in the appropriate folder
2. Update routing in `app_router.dart`
3. Add API methods in `api_service.dart`
4. Update state management if needed

### Testing
```bash
flutter test
```

### Building for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Screenshots

(Screenshots would go here showing the different user interfaces)

## Contributing

1. Follow Flutter best practices
2. Use proper state management patterns
3. Write comprehensive documentation
4. Test on multiple devices and screen sizes
5. Maintain consistent UI/UX across all user types

## License

This project is part of the SEHAT healthcare platform.

## Support

For technical support or feature requests, please refer to the main SEHAT project documentation.

---

**Note**: This is a work in progress. The app currently includes authentication and basic UI screens. Additional features like video consultations, prescription management, and real-time notifications will be implemented in future iterations.