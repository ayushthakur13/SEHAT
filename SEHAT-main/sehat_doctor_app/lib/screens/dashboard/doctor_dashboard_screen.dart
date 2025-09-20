import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../appointments/appointment_management_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

// Demo data models
class DemoDoctor {
  final String name;
  final String specialization;
  final bool isAvailable;
  final String hospitalId;
  final int experience;

  DemoDoctor({
    required this.name,
    required this.specialization,
    required this.isAvailable,
    required this.hospitalId,
    required this.experience,
  });
}

class DemoStats {
  final int totalConsultations;
  final int completedToday;
  final int pendingConsultations;
  final int monthlyConsultations;

  DemoStats({
    required this.totalConsultations,
    required this.completedToday,
    required this.pendingConsultations,
    required this.monthlyConsultations,
  });
}

class DemoAppointment {
  final String patientName;
  final String time;
  final String status;
  final Color statusColor;
  final IconData statusIcon;
  final String type;

  DemoAppointment({
    required this.patientName,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.statusIcon,
    required this.type,
  });
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  bool _isLoading = true;
  DemoDoctor? _doctor;
  List<DemoAppointment> _todayAppointments = [];
  DemoStats? _stats;

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

    // Demo doctor data
    _doctor = DemoDoctor(
      name: 'Sarah Johnson',
      specialization: 'Cardiologist',
      isAvailable: true,
      hospitalId: 'MED-2024-001',
      experience: 8,
    );

    // Demo stats
    _stats = DemoStats(
      totalConsultations: 156,
      completedToday: 4,
      pendingConsultations: 6,
      monthlyConsultations: 87,
    );

    // Demo appointments
    _todayAppointments = [
      DemoAppointment(
        patientName: 'John Smith',
        time: '10:00 AM',
        status: 'Scheduled',
        statusColor: Colors.blue,
        statusIcon: Icons.schedule,
        type: 'Regular Checkup',
      ),
      DemoAppointment(
        patientName: 'Emma Wilson',
        time: '11:30 AM',
        status: 'In Progress',
        statusColor: const Color(0xFF1976D2),
        statusIcon: Icons.play_circle,
        type: 'Follow-up',
      ),
      DemoAppointment(
        patientName: 'Michael Brown',
        time: '2:00 PM',
        status: 'Scheduled',
        statusColor: Colors.blue,
        statusIcon: Icons.schedule,
        type: 'Emergency Consultation',
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
        title: const Text('Doctor Dashboard'),
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
                    'Dr. ${_doctor?.name ?? 'Doctor'}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1976D2),
                        ),
                  ),
                  Text(
                    _doctor?.specialization ?? 'Specialist',
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
                color: _doctor?.isAvailable == true
                    ? const Color(0xFF1976D2).withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _doctor?.isAvailable == true ? 'Available' : 'Unavailable',
                style: TextStyle(
                  color: _doctor?.isAvailable == true
                      ? const Color(0xFF1976D2)
                      : Colors.red[700],
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
                'Total Consultations',
                '${_stats!.totalConsultations}',
                Icons.medical_services,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Today\'s Completed',
                '${_stats!.completedToday}',
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
                '${_stats!.pendingConsultations}',
                Icons.pending,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'This Month',
                '${_stats!.monthlyConsultations}',
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
              'Consultations',
              Icons.video_call,
              const Color(0xFF1976D2),
              () {
                _showSnackBar('Starting video consultation...');
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
              'Analytics',
              Icons.analytics,
              Colors.purple,
              () {
                _showSnackBar('Loading analytics...');
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
                    appointment.patientName,
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
              leading: const Icon(Icons.notification_important, color: Colors.red),
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
            Text('Name: Dr. ${_doctor?.name}'),
            const SizedBox(height: 8),
            Text('Specialization: ${_doctor?.specialization}'),
            const SizedBox(height: 8),
            Text('Hospital ID: ${_doctor?.hospitalId}'),
            const SizedBox(height: 8),
            Text('Experience: ${_doctor?.experience} years'),
            const SizedBox(height: 8),
            Text('Status: ${_doctor?.isAvailable == true ? "Available" : "Unavailable"}'),
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
            Text('Patient: ${appointment.patientName}'),
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