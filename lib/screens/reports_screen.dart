import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Today';
  String _selectedReportType = 'Overview';

  final List<String> _periods = ['Today', 'This Week', 'This Month', 'Last 3 Months'];
  final List<String> _reportTypes = ['Overview', 'Patients', 'Medicines', 'Appointments'];

  final List<Map<String, dynamic>> _dailyStats = [
    {'metric': 'Patients Treated', 'value': 8, 'change': '+2', 'trend': 'up'},
    {'metric': 'Prescriptions Written', 'value': 15, 'change': '+3', 'trend': 'up'},
    {'metric': 'Lab Tests Ordered', 'value': 5, 'change': '-1', 'trend': 'down'},
    {'metric': 'Emergency Cases', 'value': 2, 'change': '+1', 'trend': 'up'},
  ];

  final List<Map<String, dynamic>> _commonIllnesses = [
    {'illness': 'Hypertension', 'count': 12, 'percentage': 35},
    {'illness': 'Diabetes', 'count': 8, 'percentage': 24},
    {'illness': 'Common Cold', 'count': 6, 'percentage': 18},
    {'illness': 'Arthritis', 'count': 4, 'percentage': 12},
    {'illness': 'Other', 'count': 4, 'percentage': 11},
  ];

  final List<Map<String, dynamic>> _medicineUsage = [
    {'medicine': 'Paracetamol', 'usage': 45, 'stock': 100, 'percentage': 45},
    {'medicine': 'Ibuprofen', 'usage': 30, 'stock': 50, 'percentage': 60},
    {'medicine': 'Amoxicillin', 'usage': 20, 'stock': 75, 'percentage': 27},
    {'medicine': 'Lisinopril', 'usage': 15, 'stock': 30, 'percentage': 50},
  ];

  final List<Map<String, dynamic>> _followUpReminders = [
    {'patient': 'John Doe', 'condition': 'Hypertension', 'nextVisit': '2024-01-20', 'daysLeft': 5},
    {'patient': 'Jane Smith', 'condition': 'Diabetes', 'nextVisit': '2024-01-22', 'daysLeft': 7},
    {'patient': 'Mike Johnson', 'condition': 'Chest Pain', 'nextVisit': '2024-01-18', 'daysLeft': 3},
    {'patient': 'Sarah Wilson', 'condition': 'Arthritis', 'nextVisit': '2024-01-25', 'daysLeft': 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReport,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Period',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedPeriod,
                    items: _periods.map((period) {
                      return DropdownMenuItem<String>(
                        value: period,
                        child: Text(period),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value ?? 'Today';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Report Type',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedReportType,
                    items: _reportTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedReportType = value ?? 'Overview';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Report Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedReportType == 'Overview') ...[
                    _buildOverviewReport(),
                  ] else if (_selectedReportType == 'Patients') ...[
                    _buildPatientsReport(),
                  ] else if (_selectedReportType == 'Medicines') ...[
                    _buildMedicinesReport(),
                  ] else if (_selectedReportType == 'Appointments') ...[
                    _buildAppointmentsReport(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewReport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Overview - ${DateFormat('MMMM d, y').format(DateTime.now())}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Daily Stats
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: _dailyStats.length,
          itemBuilder: (context, index) {
            final stat = _dailyStats[index];
            return _buildStatCard(stat);
          },
        ),
        const SizedBox(height: 24),
        
        // Common Illnesses
        Text(
          'Common Illnesses Diagnosed',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: _commonIllnesses.map((illness) => _buildIllnessItem(illness)).toList(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Follow-up Reminders
        Text(
          'Follow-up Reminders',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: _followUpReminders.map((reminder) => _buildFollowUpItem(reminder)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientsReport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patient Analytics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Patient Demographics
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient Demographics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDemographicCard('Total Patients', '156', Icons.people, Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDemographicCard('New Patients', '12', Icons.person_add, Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDemographicCard('Male', '78', Icons.male, Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDemographicCard('Female', '78', Icons.female, Colors.pink),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Age Distribution
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Age Distribution',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAgeGroupItem('0-18', 15, Colors.blue),
                _buildAgeGroupItem('19-35', 35, Colors.green),
                _buildAgeGroupItem('36-50', 45, Colors.orange),
                _buildAgeGroupItem('51-65', 35, Colors.red),
                _buildAgeGroupItem('65+', 26, Colors.purple),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicinesReport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medicine Usage Analytics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Prescribed Medicines',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._medicineUsage.map((medicine) => _buildMedicineUsageItem(medicine)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Stock Alerts
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stock Alerts',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStockAlertItem('Ibuprofen', 15, 20, Colors.orange),
                _buildStockAlertItem('Surgical Gloves', 5, 10, Colors.red),
                _buildStockAlertItem('Lisinopril', 30, 30, Colors.yellow),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentsReport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointment Analytics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Appointment Stats
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final stats = [
              {'title': 'Total Appointments', 'value': '24', 'icon': Icons.calendar_today, 'color': Colors.blue},
              {'title': 'Completed', 'value': '18', 'icon': Icons.check_circle, 'color': Colors.green},
              {'title': 'Cancelled', 'value': '3', 'icon': Icons.cancel, 'color': Colors.red},
              {'title': 'No Show', 'value': '3', 'icon': Icons.person_off, 'color': Colors.orange},
            ];
            return _buildAppointmentStatCard(stats[index]);
          },
        ),
        const SizedBox(height: 16),
        
        // Appointment Types
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment Types',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAppointmentTypeItem('General Consultation', 12, Colors.blue),
                _buildAppointmentTypeItem('Follow-up', 6, Colors.green),
                _buildAppointmentTypeItem('Emergency', 3, Colors.red),
                _buildAppointmentTypeItem('Specialist', 3, Colors.purple),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    final trendColor = stat['trend'] == 'up' ? Colors.green : Colors.red;
    final trendIcon = stat['trend'] == 'up' ? Icons.trending_up : Icons.trending_down;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stat['metric'],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${stat['value']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(trendIcon, size: 16, color: trendColor),
                    Text(
                      stat['change'],
                      style: TextStyle(
                        fontSize: 12,
                        color: trendColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllnessItem(Map<String, dynamic> illness) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(illness['illness']),
          ),
          Text('${illness['count']} cases'),
          const SizedBox(width: 16),
          SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              value: illness['percentage'] / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(width: 8),
          Text('${illness['percentage']}%'),
        ],
      ),
    );
  }

  Widget _buildFollowUpItem(Map<String, dynamic> reminder) {
    final daysLeft = reminder['daysLeft'];
    final isUrgent = daysLeft <= 3;
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isUrgent ? Colors.red : Colors.blue,
        child: Text(
          reminder['patient'][0],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(reminder['patient']),
      subtitle: Text('${reminder['condition']} • Next visit: ${reminder['nextVisit']}'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isUrgent ? Colors.red : Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${daysLeft}d left',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDemographicCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeGroupItem(String ageGroup, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(ageGroup),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: count / 50,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          Text('$count'),
        ],
      ),
    );
  }

  Widget _buildMedicineUsageItem(Map<String, dynamic> medicine) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(medicine['medicine']),
          ),
          Text('${medicine['usage']}/${medicine['stock']}'),
          const SizedBox(width: 16),
          SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              value: medicine['percentage'] / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(width: 8),
          Text('${medicine['percentage']}%'),
        ],
      ),
    );
  }

  Widget _buildStockAlertItem(String medicine, int current, int minimum, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.warning, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(medicine),
          ),
          Text('$current/$minimum'),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              current <= minimum ? 'Low Stock' : 'OK',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentStatCard(Map<String, dynamic> stat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(stat['icon'], size: 32, color: stat['color']),
            const SizedBox(height: 8),
            Text(
              stat['value'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              stat['title'],
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentTypeItem(String type, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(type),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: count / 15,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          Text('$count'),
        ],
      ),
    );
  }

  void _exportReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Report'),
        content: const Text('Report export functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _shareReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Report'),
        content: const Text('Report sharing functionality would be implemented here.'),
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
