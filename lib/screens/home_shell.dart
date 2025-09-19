import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'home_screen.dart';
import 'consultation/doctor_list_screen.dart';
import 'medicine/medicine_search_screen.dart';
import 'records/health_records_screen.dart';
import 'profile/profile_screen.dart';

class HomeShell extends StatefulWidget {
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int idx = 0;

  final pages = [
    HomeScreen(),
    DoctorListScreen(), // Appointments placeholder can be separate later
    MedicineSearchScreen(),
    HealthRecordsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => setState(() => idx = i),
        indicatorColor: SEHATTheme.primaryColor.withOpacity(0.2),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event_note_outlined), selectedIcon: Icon(Icons.event_note), label: 'Appointment'),
          NavigationDestination(icon: Icon(Icons.local_pharmacy_outlined), selectedIcon: Icon(Icons.local_pharmacy), label: 'Pharmacy'),
          NavigationDestination(icon: Icon(Icons.folder_copy_outlined), selectedIcon: Icon(Icons.folder_copy), label: 'Records'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}


