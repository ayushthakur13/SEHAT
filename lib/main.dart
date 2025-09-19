import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/language_selection_screen.dart';
import 'screens/home_shell.dart';
import 'utils/theme.dart';
import 'utils/language_manager.dart';

void main() {
  runApp(SEHATApp());
}

class SEHATApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SEHAT - Smart E-Health Access for Telemedicine",
      debugShowCheckedModeBanner: false,
      theme: SEHATTheme.lightTheme,
      home: LanguageSelectionScreen(),
      routes: {
        '/language': (_) => LanguageSelectionScreen(),
        '/home': (_) => HomeShell(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('hi', ''),
        Locale('pa', ''),
      ],
    );
  }
}

