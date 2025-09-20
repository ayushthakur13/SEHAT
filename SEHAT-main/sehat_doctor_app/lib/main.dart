import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/base_api_service.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/language_selection_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/verification_screen.dart';
import 'screens/auth/doctor_verification_screen.dart';
import 'screens/auth/pharmacy_verification_screen.dart';
import 'screens/auth/patient_onboarding_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/dashboard/doctor_dashboard_screen.dart';
import 'screens/dashboard/patient_dashboard_screen.dart';
import 'screens/dashboard/pharmacy_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize API service
  BaseApiService().initialize();

  runApp(const SehatDoctorApp());
}

class SehatDoctorApp extends StatelessWidget {
  const SehatDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'SEHAT - Healthcare Platform',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1976D2), // Blue for healthcare
            brightness: Brightness.light,
            primary: const Color(0xFF1976D2),
            secondary: const Color(0xFF42A5F5),
            tertiary: const Color(0xFF90CAF9),
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black87,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1976D2),
            foregroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 2,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1976D2),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF1976D2),
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            fillColor: Colors.grey.shade50,
            filled: true,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            shadowColor: const Color(0xFF1976D2).withOpacity(0.1),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF1976D2),
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color(0xFF1976D2),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: const Color(0xFF1976D2).withOpacity(0.1),
            labelStyle: const TextStyle(color: Color(0xFF1976D2)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/language': (context) => const LanguageSelectionScreen(),
          '/login': (context) => const LoginScreen(selectedLanguage: 'english'),
          '/register': (context) {
            final args =
                ModalRoute.of(context)?.settings.arguments as String? ??
                    'english';
            return RegisterScreen(selectedLanguage: args);
          },
          '/doctor_verification': (context) => const DoctorVerificationScreen(),
          '/pharmacy_verification': (context) =>
              const PharmacyVerificationScreen(),
          '/patient_onboarding': (context) => const PatientOnboardingScreen(),
          '/verification': (context) => const VerificationScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/doctor_dashboard': (context) => const DoctorDashboardScreen(),
          '/patient_dashboard': (context) => const PatientDashboardScreen(),
          '/pharmacy_dashboard': (context) => const PharmacyDashboardScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        switch (authProvider.state) {
          case AuthState.initial:
          case AuthState.loading:
            return const SplashScreen();
          case AuthState.unauthenticated:
          case AuthState.error:
            return const LoginScreen();
          case AuthState.needsVerification:
            return _getVerificationScreen(authProvider.user?.role);
          case AuthState.authenticated:
            return _getDashboardScreen(authProvider.user?.role);
        }
      },
    );
  }

  Widget _getVerificationScreen(String? role) {
    switch (role?.toLowerCase()) {
      case 'doctor':
        return const DoctorVerificationScreen();
      case 'pharmacy':
        return const PharmacyVerificationScreen();
      case 'patient':
        return const PatientOnboardingScreen();
      default:
        return const VerificationScreen();
    }
  }

  Widget _getDashboardScreen(String? role) {
    switch (role?.toLowerCase()) {
      case 'doctor':
        return const DoctorDashboardScreen();
      case 'patient':
        return const PatientDashboardScreen();
      case 'pharmacy':
        return const PharmacyDashboardScreen();
      default:
        return const DashboardScreen(); // Fallback to generic dashboard
    }
  }
}
