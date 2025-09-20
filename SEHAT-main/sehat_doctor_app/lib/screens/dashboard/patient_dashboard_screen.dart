import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../appointments/appointment_management_screen.dart';
import '../symptom_checker/symptom_checker_screen.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

// Demo data models
class DemoPatient {
  final String name;
  final String bloodGroup;
  final String age;
  final String gender;
  final String emergencyContact;

  DemoPatient({
    required this.name,
    required this.bloodGroup,
    required this.age,
    required this.gender,
    required this.emergencyContact,
  });
}

class DemoHealthStats {
  final int upcomingAppointments;
  final int currentMedicines;
  final int pendingReminders;
  final int healthRecords;

  DemoHealthStats({
    required this.upcomingAppointments,
    required this.currentMedicines,
    required this.pendingReminders,
    required this.healthRecords,
  });
}

class DemoAppointment {
  final String doctorName;
  final String specialization;
  final String time;
  final String date;
  final String status;
  final Color statusColor;
  final IconData statusIcon;
  final String type;

  DemoAppointment({
    required this.doctorName,
    required this.specialization,
    required this.time,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.statusIcon,
    required this.type,
  });
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  bool _isLoading = true;
  DemoPatient? _patient;
  List<DemoAppointment> _todayAppointments = [];
  DemoHealthStats? _stats;

  @override
  void initState() {
    super.initState();
    _loadDemoData();
  }

  Future<void> _loadDemoData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    // Demo patient data
    _patient = DemoPatient(
      name: 'Emma Thompson',
      bloodGroup: 'O+',
      age: '28',
      gender: 'Female',
      emergencyContact: '+1 234-567-8900',
    );

    // Demo stats
    _stats = DemoHealthStats(
      upcomingAppointments: 2,
      currentMedicines: 3,
      pendingReminders: 4,
      healthRecords: 5,
    );

    // Demo appointments
    _todayAppointments = [
      DemoAppointment(
        doctorName: 'Dr. Sarah Johnson',
        specialization: 'Cardiologist',
        time: '10:00 AM',
        date: 'Today',
        status: 'Confirmed',
        statusColor: Colors.blue,
        statusIcon: Icons.video_call,
        type: 'Video Call',
      ),
      DemoAppointment(
        doctorName: 'Dr. Michael Chen',
        specialization: 'General Medicine',
        time: '2:30 PM',
        date: 'Today',
        status: 'Pending',
        statusColor: Colors.orange,
        statusIcon: Icons.pending,
        type: 'In-Person',
      ),
    ];

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        title: const Text('SEHAT - Patient'),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  _showNotifications(context);
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  _showProfile(context);
                  break;
                case 'settings':
                  _showSettings(context);
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AppointmentManagementScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF1976D2),
        icon: const Icon(Icons.add),
        label: const Text('New Appointment'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDemoData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildTodayAppointments(),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.medical_services,
                color: Color(0xFF1976D2),
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  Text(
                    _patient?.name ?? 'Patient',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1976D2),
                        ),
                  ),
                  Text(
                    'Blood Group: ${_patient?.bloodGroup ?? 'Unknown'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Patient',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    if (_stats == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Appointments',
                '${_stats!.upcomingAppointments}',
                Icons.medical_services,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Current Medicines',
                '${_stats!.currentMedicines}',
                Icons.check_circle,
                const Color(0xFF1976D2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Pending',
                '${_stats!.pendingReminders}',
                Icons.pending,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Health Records',
                '${_stats!.healthRecords}',
                Icons.calendar_month,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              'Appointments',
              Icons.calendar_today,
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppointmentManagementScreen(),
                  ),
                );
              },
            ),
            _buildActionCard(
              'AI Symptom Checker',
              Icons.psychology,
              Colors.purple,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SymptomCheckerScreen(),
                  ),
                );
              },
            ),
            _buildActionCard(
              'Prescriptions',
              Icons.receipt,
              Colors.orange,
              () {
                _showSnackBar('Opening prescriptions...');
              },
            ),
            _buildActionCard(
              'Health Records',
              Icons.analytics,
              const Color(0xFF1976D2),
              () {
                _showSnackBar('Loading health records...');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayAppointments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Appointments',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppointmentManagementScreen(),
                  ),
                );
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_todayAppointments.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No appointments today',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take a well-deserved break!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                _todayAppointments.length > 3 ? 3 : _todayAppointments.length,
            itemBuilder: (context, index) {
              final appointment = _todayAppointments[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: appointment.statusColor.withOpacity(0.1),
                    child: Icon(
                      appointment.statusIcon,
                      color: appointment.statusColor,
                    ),
                  ),
                  title: Text(
                    appointment.doctorName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment.time),
                      const SizedBox(height: 2),
                      Text(
                        appointment.status,
                        style: TextStyle(
                          color: appointment.statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      _showAppointmentDetails(appointment);
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1976D2),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.notification_important, color: Colors.red),
              title: const Text('Emergency Consultation'),
              subtitle: const Text('Patient needs immediate attention'),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.schedule, color: Colors.blue),
              title: const Text('Appointment Reminder'),
              subtitle: const Text('Next appointment in 30 minutes'),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Color(0xFF1976D2)),
              title: const Text('New Message'),
              subtitle: const Text('Prescription inquiry from patient'),
              dense: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Doctor Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_patient?.name}'),
            const SizedBox(height: 8),
            Text('Blood Group: ${_patient?.bloodGroup}'),
            const SizedBox(height: 8),
            Text('Age: ${_patient?.age} years'),
            const SizedBox(height: 8),
            Text('Gender: ${_patient?.gender}'),
            const SizedBox(height: 8),
            Text('Emergency Contact: ${_patient?.emergencyContact}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              subtitle: Text('English'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              subtitle: Text('Enabled'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Privacy'),
              subtitle: Text('Manage privacy settings'),
              dense: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetails(DemoAppointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor: ${appointment.doctorName}'),
            const SizedBox(height: 8),
            Text('Time: ${appointment.time}'),
            const SizedBox(height: 8),
            Text('Type: ${appointment.type}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Status: '),
                Icon(appointment.statusIcon,
                    color: appointment.statusColor, size: 16),
                const SizedBox(width: 4),
                Text(appointment.status,
                    style: TextStyle(color: appointment.statusColor)),
              ],
            ),
          ],
        ),
        actions: [
          if (appointment.status == 'Scheduled')
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSnackBar('Starting consultation...');
              },
              child: const Text('Start Consultation'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
  }
}
