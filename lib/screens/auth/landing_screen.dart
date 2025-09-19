import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/language_manager.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SEHATTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(color: SEHATTheme.primaryColor, shape: BoxShape.circle),
                    child: Icon(Icons.medical_services, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SEHAT', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: SEHATTheme.primaryColor)),
                      Text(LanguageManager.translate('app_subtitle'), style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text('Smart E-Health Access for Telemedicine', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: SEHATTheme.textPrimary)),
              SizedBox(height: 8),
              Text('Access doctors, medicines, and your health records anywhere.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: SEHATTheme.textSecondary)),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreen())),
                  child: Text('Sign Up'),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen())),
                  child: Text('Login'),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}


