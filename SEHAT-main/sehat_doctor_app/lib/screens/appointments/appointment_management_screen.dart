import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../services/video_call_service.dart';

class AppointmentManagementScreen extends StatefulWidget {
  const AppointmentManagementScreen({super.key});

  @override
  State<AppointmentManagementScreen> createState() => _AppointmentManagementScreenState();
}

class _AppointmentManagementScreenState extends State<AppointmentManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'All';
  
  final List<String> _statusFilters = ['All', 'Scheduled', 'Completed', 'Cancelled', 'Rescheduled'];
  final VideoCallService _videoCallService = VideoCallService();

  // Mock appointment data
  final List<Map<String, dynamic>> _appointments = [
    {
      'id': '1',
      'patientName': 'Rajesh Kumar',
      'patientAge': 45,
      'time': '09:00 AM',
      'date': DateTime.now().add(const Duration(days: 0)),
      'type': 'General Consultation',
      'status': 'Scheduled',
      'avatar': null,
      'reason': 'Regular checkup and blood pressure monitoring',
      'duration': 30,
      'isOnline': false,
    },
    {
      'id': '2',
      'patientName': 'Priya Sharma',
      'patientAge': 32,
      'time': '10:30 AM',
      'date': DateTime.now().add(const Duration(days: 0)),
      'type': 'Video Consultation',
      'status': 'Scheduled',
      'avatar': null,
      'reason': 'Follow-up for diabetes management',
      'duration': 20,
      'isOnline': true,
    },
    {
      'id': '3',
      'patientName': 'Arjun Patel',
      'patientAge': 28,
      'time': '02:00 PM',
      'date': DateTime.now().add(const Duration(days: 1)),
      'type': 'Specialist Consultation',
      'status': 'Scheduled',
      'avatar': null,
      'reason': 'Chest pain and breathing issues',
      'duration': 45,
      'isOnline': false,
    },
    {
      'id': '4',
      'patientName': 'Meera Singh',
      'patientAge': 55,
      'time': '11:00 AM',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'General Consultation',
      'status': 'Completed',
      'avatar': null,
      'reason': 'Thyroid test results discussion',
      'duration': 25,
      'isOnline': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAppointments {
    return _appointments.where((appointment) {
      final matchesStatus = _selectedStatus == 'All' || appointment['status'] == _selectedStatus;
      final appointmentDate = appointment['date'] as DateTime;
      final matchesDate = DateUtils.isSameDay(appointmentDate, _selectedDate);
      
      switch (_tabController.index) {
        case 0: // Today
          return matchesStatus && DateUtils.isSameDay(appointmentDate, DateTime.now());
        case 1: // Upcoming
          return matchesStatus && appointmentDate.isAfter(DateTime.now().subtract(const Duration(days: 1)));
        case 2: // Past
          return matchesStatus && appointmentDate.isBefore(DateTime.now());
        default:
          return matchesStatus;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1976D2),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showDatePicker(),
            icon: const Icon(Icons.calendar_today),
          ),
          IconButton(
            onPressed: () => _showFilterDialog(),
            icon: const Icon(Icons.filter_list),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF1976D2),
          labelColor: const Color(0xFF1976D2),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _buildStatCard('Today', _getTodayCount(), Icons.today)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('This Week', _getWeekCount(), Icons.date_range)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('This Month', _getMonthCount(), Icons.calendar_month)),
              ],
            ),
          ),
          
          // Appointments List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentsList('today'),
                _buildAppointmentsList('upcoming'),
                _buildAppointmentsList('past'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewAppointmentDialog,
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF1976D2), size: 24),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(String type) {
    final appointments = _filteredAppointments;
    
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No appointments found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to schedule a new appointment',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final status = appointment['status'] as String;
    final isOnline = appointment['isOnline'] as bool;
    
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'Scheduled':
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        break;
      case 'Completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'Rescheduled':
        statusColor = Colors.orange;
        statusIcon = Icons.update;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showAppointmentDetails(appointment),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF1976D2).withOpacity(0.1),
                    child: Text(
                      appointment['patientName'].toString().split(' ').map((e) => e[0]).join(''),
                      style: const TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment['patientName'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${appointment['patientAge']} years • ${appointment['type']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isOnline)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.videocam, size: 12, color: Colors.blue[700]),
                          const SizedBox(width: 4),
                          Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${appointment['time']} • ${appointment['duration']} min',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 12, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                appointment['reason'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Action buttons for scheduled appointments
              if (status == 'Scheduled' && isOnline) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _startVideoCall(appointment),
                        icon: const Icon(Icons.videocam, size: 18),
                        label: const Text('Start Video Call'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showAppointmentDetails(appointment),
                        icon: const Icon(Icons.info_outline, size: 18),
                        label: const Text('Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1976D2),
                          side: const BorderSide(color: Color(0xFF1976D2)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (status == 'Scheduled') ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showAppointmentDetails(appointment),
                        icon: const Icon(Icons.info_outline, size: 18),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1976D2),
                          side: const BorderSide(color: Color(0xFF1976D2)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Appointments'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _statusFilters.map((status) {
            return RadioListTile<String>(
              title: Text(status),
              value: status,
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Patient details
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF1976D2).withOpacity(0.1),
                    child: Text(
                      appointment['patientName'].toString().split(' ').map((e) => e[0]).join(''),
                      style: const TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment['patientName'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${appointment['patientAge']} years old',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Appointment details
              _buildDetailRow('Type', appointment['type']),
              _buildDetailRow('Date', DateFormat('MMM dd, yyyy').format(appointment['date'])),
              _buildDetailRow('Time', appointment['time']),
              _buildDetailRow('Duration', '${appointment['duration']} minutes'),
              _buildDetailRow('Mode', appointment['isOnline'] ? 'Online Video Call' : 'In-Person'),
              _buildDetailRow('Status', appointment['status']),
              
              const SizedBox(height: 16),
              
              const Text(
                'Reason for Visit:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appointment['reason'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              
              const Spacer(),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Implement reschedule
                      },
                      child: const Text('Reschedule'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (appointment['isOnline']) {
                          _startVideoCall(appointment);

                        } else {
                          // TODO: Mark as completed or start consultation
                        }
                      },
                      child: Text(
                        appointment['isOnline'] ? 'Start Call' : 'Start Consultation',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNewAppointmentDialog() {
    // TODO: Implement new appointment booking dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Appointment'),
        content: const Text('Appointment booking feature will be implemented next.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  int _getTodayCount() {
    return _appointments.where((apt) => 
      DateUtils.isSameDay(apt['date'] as DateTime, DateTime.now())
    ).length;
  }

  int _getWeekCount() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    return _appointments.where((apt) {
      final date = apt['date'] as DateTime;
      return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
             date.isBefore(weekEnd.add(const Duration(days: 1)));
    }).length;
  }

  int _getMonthCount() {
    final now = DateTime.now();
    return _appointments.where((apt) {
      final date = apt['date'] as DateTime;
      return date.month == now.month && date.year == now.year;
    }).length;
  }

  /// Start video call for the appointment
  Future<void> _startVideoCall(Map<String, dynamic> appointment) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Get current user info
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.user;
      
      if (currentUser == null) {
        Navigator.pop(context); // Close loading dialog
        _showErrorDialog('Please login to start video call');
        return;
      }

      // Generate room code for the appointment
      final roomCode = _videoCallService.generateAppointmentRoomCode(appointment['id']);
      
      // Join the video meeting
      await _videoCallService.joinMeeting(
        roomCode: roomCode,
        userName: currentUser.name ?? 'Doctor',
        userEmail: currentUser.email,
        isAudioMuted: false,
        isVideoMuted: false,
      );

      // Close loading dialog
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening video call with ${appointment['patientName']} in new tab'),
          backgroundColor: const Color(0xFF1976D2),
          duration: const Duration(seconds: 3),
        ),
      );
      
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error message
      _showErrorDialog('Failed to start video call: ${e.toString()}');
    }
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
