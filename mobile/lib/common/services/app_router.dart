import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/verification_screen.dart';
import '../../patient/patient_home_screen.dart';
import '../../doctor/doctor_home_screen.dart';
import '../../pharmacy/pharmacy_home_screen.dart';
import 'auth_service.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final needsVerification = authState.needsVerification;
      final userRole = authState.user?.role;
      
      // If loading, stay on current route
      if (authState.isLoading) {
        return null;
      }
      
      // If not authenticated, redirect to login
      if (!isAuthenticated) {
        if (state.location != '/login' && state.location != '/register') {
          return '/login';
        }
        return null;
      }
      
      // If authenticated but needs verification
      if (needsVerification) {
        if (state.location != '/verification') {
          return '/verification';
        }
        return null;
      }
      
      // If authenticated and verified, redirect to appropriate home
      if (isAuthenticated && !needsVerification) {
        if (state.location == '/login' || 
            state.location == '/register' || 
            state.location == '/verification' ||
            state.location == '/') {
          switch (userRole) {
            case 'patient':
              return '/patient';
            case 'doctor':
              return '/doctor';
            case 'pharmacy':
              return '/pharmacy';
            default:
              return '/login';
          }
        }
      }
      
      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
                ),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/verification',
        builder: (context, state) => const VerificationScreen(),
      ),
      
      // Patient Routes
      GoRoute(
        path: '/patient',
        builder: (context, state) => const PatientHomeScreen(),
      ),
      
      // Doctor Routes
      GoRoute(
        path: '/doctor',
        builder: (context, state) => const DoctorHomeScreen(),
      ),
      
      // Pharmacy Routes
      GoRoute(
        path: '/pharmacy',
        builder: (context, state) => const PharmacyHomeScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Splash Screen
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E8B57),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.health_and_safety,
                size: 64,
                color: Color(0xFF2E8B57),
              ),
            ),
            const SizedBox(height: 32),
            
            // App Name
            const Text(
              'SEHAT',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            
            // Tagline
            const Text(
              'Healthcare for Everyone',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 48),
            
            // Loading Indicator
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}