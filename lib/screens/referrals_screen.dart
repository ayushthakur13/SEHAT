import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReferralsScreen extends StatefulWidget {
  const ReferralsScreen({super.key});

  @override
  State<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends State<ReferralsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientController = TextEditingController();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedSpecialist = '';
  String _selectedHospital = '';
  String _urgency = 'Normal';
  DateTime _preferredDate = DateTime.now().add(const Duration(days: 1));
  
  final List<String> _specialists = [
    'Cardiologist',
    'Neurologist',
    'Orthopedist',
    'Dermatologist',
    'Gynecologist',
    'Pediatrician',
    'Psychiatrist',
    'Oncologist',
    'Radiologist',
    'Anesthesiologist',
  ];

  final List<String> _hospitals = [
    'City General Hospital',
    'Metro Medical Center',
    'Regional Hospital',
    'Specialist Clinic',
    'University Hospital',
  ];

  final List<String> _urgencyLevels = [
    'Normal',
    'Urgent',
    'Emergency',
  ];

  final List<Map<String, dynamic>> _referrals = [
    {
      'id': 'R001',
      'patient': 'John Doe',
      'patientId': 'P001',
      'specialist': 'Cardiologist',
      'hospital': 'City General Hospital',
      'date': '2024-01-16',
      'urgency': 'Urgent',
      'status': 'Pending',
      'reason': 'Chest pain evaluation',
    },
    {
      'id': 'R002',
      'patient': 'Jane Smith',
      'patientId': 'P002',
      'specialist': 'Dermatologist',
      'hospital': 'Metro Medical Center',
      'date': '2024-01-18',
      'urgency': 'Normal',
      'status': 'Confirmed',
      'reason': 'Skin condition follow-up',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referrals & Telemedicine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: _startTelemedicineCall,
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'New Referral', icon: Icon(Icons.add)),
                Tab(text: 'Referrals', icon: Icon(Icons.list)),
                Tab(text: 'Telemedicine', icon: Icon(Icons.video_call)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildNewReferralTab(),
                  _buildReferralsTab(),
                  _buildTelemedicineTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewReferralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _patientController,
                      decoration: const InputDecoration(
                        labelText: 'Patient Name/ID',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Enter patient name or ID',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter patient information';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Specialist Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Specialist Selection',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Specialist',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.medical_services),
                      ),
                      value: _selectedSpecialist.isEmpty ? null : _selectedSpecialist,
                      items: _specialists.map((specialist) {
                        return DropdownMenuItem<String>(
                          value: specialist,
                          child: Text(specialist),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSpecialist = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a specialist';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hospital Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hospital/Clinic',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Hospital',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.local_hospital),
                      ),
                      value: _selectedHospital.isEmpty ? null : _selectedHospital,
                      items: _hospitals.map((hospital) {
                        return DropdownMenuItem<String>(
                          value: hospital,
                          child: Text(hospital),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedHospital = value ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a hospital';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Urgency and Date
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Urgency',
                              border: OutlineInputBorder(),
                            ),
                            value: _urgency,
                            items: _urgencyLevels.map((level) {
                              return DropdownMenuItem<String>(
                                value: level,
                                child: Text(level),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _urgency = value ?? 'Normal';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: _selectDate,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today),
                                  const SizedBox(width: 8),
                                  Text(DateFormat('MMM d, y').format(_preferredDate)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Reason and Notes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Referral Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Reason for Referral',
                        border: OutlineInputBorder(),
                        hintText: 'Describe the reason for referral...',
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter reason for referral';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Additional Notes',
                        border: OutlineInputBorder(),
                        hintText: 'Any additional notes or recommendations...',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Attach Reports Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attach Reports',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _attachLabResults,
                            icon: const Icon(Icons.science),
                            label: const Text('Lab Results'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _attachXRay,
                            icon: const Icon(Icons.photo_camera),
                            label: const Text('X-Ray'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _attachPrescription,
                            icon: const Icon(Icons.description),
                            label: const Text('Prescription'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _attachOther,
                            icon: const Icon(Icons.attach_file),
                            label: const Text('Other'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitReferral,
                child: const Text(
                  'Submit Referral',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _referrals.length,
      itemBuilder: (context, index) {
        final referral = _referrals[index];
        return _buildReferralCard(referral);
      },
    );
  }

  Widget _buildTelemedicineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Telemedicine Services',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Available Specialists
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available for Telemedicine',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTelemedicineSpecialist('Dr. Sarah Johnson', 'Cardiologist', 'City General Hospital'),
                  _buildTelemedicineSpecialist('Dr. Michael Chen', 'Neurologist', 'Metro Medical Center'),
                  _buildTelemedicineSpecialist('Dr. Emily Davis', 'Dermatologist', 'Regional Hospital'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Schedule Telemedicine Call
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Schedule Telemedicine Call',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _scheduleTelemedicineCall,
                    icon: const Icon(Icons.video_call),
                    label: const Text('Schedule Call'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCard(Map<String, dynamic> referral) {
    final urgencyColor = _getUrgencyColor(referral['urgency']);
    final statusColor = _getStatusColor(referral['status']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor,
                  child: Text(
                    referral['patient'][0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        referral['patient'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'ID: ${referral['patientId']}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: urgencyColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    referral['urgency'],
                    style: const TextStyle(
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
                Icon(Icons.medical_services, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(referral['specialist']),
                const SizedBox(width: 16),
                Icon(Icons.local_hospital, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(child: Text(referral['hospital'])),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(referral['date']),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    referral['status'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Reason: ${referral['reason']}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewReferralDetails(referral),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _trackReferral(referral),
                    icon: const Icon(Icons.track_changes, size: 16),
                    label: const Text('Track'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemedicineSpecialist(String name, String specialty, String hospital) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF1976D2),
            child: Text(
              name.split(' ').map((n) => n[0]).join(''),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$specialty • $hospital',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _startTelemedicineCall(),
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'Emergency':
        return Colors.red;
      case 'Urgent':
        return Colors.orange;
      case 'Normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _preferredDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _preferredDate) {
      setState(() {
        _preferredDate = picked;
      });
    }
  }

  void _submitReferral() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Referral Submitted'),
          content: const Text('Referral has been submitted successfully. The patient will be notified.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _patientController.clear();
      _reasonController.clear();
      _notesController.clear();
      _selectedSpecialist = '';
      _selectedHospital = '';
      _urgency = 'Normal';
      _preferredDate = DateTime.now().add(const Duration(days: 1));
    });
  }

  void _attachLabResults() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lab results attachment functionality would be implemented here')),
    );
  }

  void _attachXRay() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('X-Ray attachment functionality would be implemented here')),
    );
  }

  void _attachPrescription() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prescription attachment functionality would be implemented here')),
    );
  }

  void _attachOther() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Other file attachment functionality would be implemented here')),
    );
  }

  void _viewReferralDetails(Map<String, dynamic> referral) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Referral Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient: ${referral['patient']}'),
            Text('Specialist: ${referral['specialist']}'),
            Text('Hospital: ${referral['hospital']}'),
            Text('Date: ${referral['date']}'),
            Text('Urgency: ${referral['urgency']}'),
            Text('Status: ${referral['status']}'),
            Text('Reason: ${referral['reason']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _trackReferral(Map<String, dynamic> referral) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Track Referral'),
        content: const Text('Referral tracking functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _startTelemedicineCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Telemedicine Call'),
        content: const Text('Telemedicine call functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _scheduleTelemedicineCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Telemedicine Call'),
        content: const Text('Schedule telemedicine call functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _patientController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
