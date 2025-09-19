import 'package:flutter/material.dart';
import 'consultation_screen.dart';

class PatientManagementScreen extends StatefulWidget {
  const PatientManagementScreen({super.key});

  @override
  State<PatientManagementScreen> createState() => _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Today', 'This Week', 'Emergency'];

  final List<Map<String, dynamic>> _patients = [
    {
      'id': 'P001',
      'name': 'John Doe',
      'age': 45,
      'gender': 'Male',
      'condition': 'Hypertension',
      'lastVisit': '2024-01-15',
      'status': 'Active',
      'isEmergency': false,
    },
    {
      'id': 'P002',
      'name': 'Jane Smith',
      'age': 32,
      'gender': 'Female',
      'condition': 'Diabetes',
      'lastVisit': '2024-01-14',
      'status': 'Active',
      'isEmergency': false,
    },
    {
      'id': 'P003',
      'name': 'Mike Johnson',
      'age': 28,
      'gender': 'Male',
      'condition': 'Chest Pain',
      'lastVisit': '2024-01-15',
      'status': 'Emergency',
      'isEmergency': true,
    },
    {
      'id': 'P004',
      'name': 'Sarah Wilson',
      'age': 55,
      'gender': 'Female',
      'condition': 'Arthritis',
      'lastVisit': '2024-01-13',
      'status': 'Follow-up',
      'isEmergency': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanQRCode,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by ID, Name, or QR Code',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          selectedColor: const Color(0xFF1976D2).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF1976D2),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Patient List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _getFilteredPatients().length,
              itemBuilder: (context, index) {
                final patient = _getFilteredPatients()[index];
                return _buildPatientCard(patient);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPatient,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredPatients() {
    List<Map<String, dynamic>> filtered = _patients;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((patient) {
        return patient['id'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
               patient['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((patient) {
        switch (_selectedFilter) {
          case 'Today':
            return patient['lastVisit'] == '2024-01-15';
          case 'This Week':
            return patient['lastVisit'] == '2024-01-15' || patient['lastVisit'] == '2024-01-14';
          case 'Emergency':
            return patient['isEmergency'] == true;
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  Widget _buildPatientCard(Map<String, dynamic> patient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _viewPatientProfile(patient),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: patient['isEmergency'] ? Colors.red : const Color(0xFF1976D2),
                    child: Text(
                      patient['name'][0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient['name'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ID: ${patient['id']} • ${patient['age']} years • ${patient['gender']}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (patient['isEmergency'])
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'EMERGENCY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.medical_services,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    patient['condition'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Last visit: ${patient['lastVisit']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewMedicalHistory(patient),
                      icon: const Icon(Icons.history, size: 16),
                      label: const Text('History'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _startConsultation(patient),
                      icon: const Icon(Icons.medical_services, size: 16),
                      label: const Text('Consult'),
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

  void _scanQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scanner'),
        content: const Text('QR Code scanner functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addNewPatient() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Patient'),
        content: const Text('Add new patient functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _viewPatientProfile(Map<String, dynamic> patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientProfileScreen(patient: patient),
      ),
    );
  }

  void _viewMedicalHistory(Map<String, dynamic> patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicalHistoryScreen(patient: patient),
      ),
    );
  }

  void _startConsultation(Map<String, dynamic> patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConsultationScreen(patient: patient),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class PatientProfileScreen extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientProfileScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${patient['name']} - Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF1976D2),
                          child: Text(
                            patient['name'][0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patient['name'],
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Patient ID: ${patient['id']}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Age', '${patient['age']} years'),
                    _buildInfoRow('Gender', patient['gender']),
                    _buildInfoRow('Current Condition', patient['condition']),
                    _buildInfoRow('Last Visit', patient['lastVisit']),
                    _buildInfoRow('Status', patient['status']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Medical History
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medical History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHistoryItem('2024-01-15', 'Hypertension Checkup', 'Dr. Smith'),
                    _buildHistoryItem('2024-01-10', 'Blood Test', 'Dr. Johnson'),
                    _buildHistoryItem('2024-01-05', 'General Consultation', 'Dr. Smith'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Current Medications
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Medications',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMedicationItem('Lisinopril', '10mg', 'Once daily'),
                    _buildMedicationItem('Metformin', '500mg', 'Twice daily'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String date, String procedure, String doctor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF1976D2),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  procedure,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$date • $doctor',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationItem(String name, String dosage, String frequency) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.medication, size: 16, color: Color(0xFF1976D2)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$name ($dosage) - $frequency',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class MedicalHistoryScreen extends StatelessWidget {
  final Map<String, dynamic> patient;

  const MedicalHistoryScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${patient['name']} - Medical History'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHistoryCard(
            '2024-01-15',
            'Hypertension Checkup',
            'Dr. Smith',
            'Blood pressure: 140/90. Prescribed Lisinopril 10mg.',
            ['Blood Pressure Reading', 'Medication Prescribed'],
          ),
          _buildHistoryCard(
            '2024-01-10',
            'Blood Test',
            'Dr. Johnson',
            'Complete blood count and lipid profile. Results within normal range.',
            ['CBC', 'Lipid Profile'],
          ),
          _buildHistoryCard(
            '2024-01-05',
            'General Consultation',
            'Dr. Smith',
            'Routine checkup. Patient reports feeling well.',
            ['Physical Examination'],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String date, String title, String doctor, String notes, List<String> tests) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  doctor,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(notes),
            if (tests.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Tests/Procedures:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: tests.map((test) => Chip(
                  label: Text(test),
                  backgroundColor: Colors.blue[50],
                  labelStyle: const TextStyle(fontSize: 12),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Removed duplicate placeholder ConsultationScreen to avoid name clash with
// the actual implementation in consultation_screen.dart
