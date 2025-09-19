import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../utils/language_manager.dart';
import '../utils/theme.dart';
import 'auth/landing_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SEHATTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: SEHATTheme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: SEHATTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.medical_services,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              
              // App Title
              Text(
                'SEHAT',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: SEHATTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              
              Text(
                'Smart E-Health Access for Telemedicine',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: SEHATTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),
              
              // Language Selection
              Text(
                LanguageManager.translate('select_language'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: SEHATTheme.textPrimary,
                ),
              ),
              SizedBox(height: 30),
              
              // Language Options
              _buildLanguageOption('en', 'English', Icons.language),
              SizedBox(height: 16),
              _buildLanguageOption('hi', 'हिंदी', Icons.language),
              SizedBox(height: 16),
              _buildLanguageOption('pa', 'ਪੰਜਾਬੀ', Icons.language),
              SizedBox(height: 40),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedLanguage != null ? _continue : null,
                  child: Text(
                    LanguageManager.translate('continue'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String code, String name, IconData icon) {
    final isSelected = selectedLanguage == code;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = code;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? SEHATTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? SEHATTheme.primaryColor : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : SEHATTheme.primaryColor,
              size: 24,
            ),
            SizedBox(width: 16),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : SEHATTheme.textPrimary,
              ),
            ),
            Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _continue() async {
    if (selectedLanguage != null) {
      await LanguageManager.setLanguage(selectedLanguage!);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingScreen()),
      );
    }
  }
}
