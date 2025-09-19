import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
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
            seedColor: const Color(0xFF2E8B57), // Sea green for healthcare
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2E8B57),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E8B57),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E8B57), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/language': (context) => const LanguageSelectionScreen(),
          '/login': (context) => const LoginScreen(selectedLanguage: 'english'),
          '/register': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as String? ?? 'english';
            return RegisterScreen(selectedLanguage: args);
          },
          '/doctor_verification': (context) => const DoctorVerificationScreen(),
          '/pharmacy_verification': (context) => const PharmacyVerificationScreen(),
          '/patient_onboarding': (context) => const PatientOnboardingScreen(),
          '/verification': (context) => const VerificationScreen(),
          '/dashboard': (context) => const DashboardScreen(),
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
            return const VerificationScreen();
          case AuthState.authenticated:
            return const DashboardScreen();
        }
      },
    );
  }
}
