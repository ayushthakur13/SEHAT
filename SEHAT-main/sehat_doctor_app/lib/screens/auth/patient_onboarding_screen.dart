import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../providers/auth_provider.dart';

class PatientOnboardingScreen extends StatefulWidget {
  const PatientOnboardingScreen({super.key});

  @override
  State<PatientOnboardingScreen> createState() => _PatientOnboardingScreenState();
}

class _PatientOnboardingScreenState extends State<PatientOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyRelationController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _currentMedicationsController = TextEditingController();
  
  Map<String, dynamic>? registrationData;
  String _bloodGroup = 'A+';
  List<String> _selectedConditions = [];
  
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  
  final List<String> _conditions = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Asthma',
    'Arthritis',
    'Kidney Disease',
    'Liver Disease',
    'Thyroid Disorder',
    'Depression',
    'Anxiety',
    'Migraine',
    'Obesity',
    'Cancer History',
    'Stroke History',
    'None'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (registrationData == null) {
      registrationData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    _medicalHistoryController.dispose();
    _allergiesController.dispose();
    _currentMedicationsController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Prepare complete patient registration data
      final patientData = {
        ...registrationData!,
        'height': double.tryParse(_heightController.text) ?? 0.0,
        'weight': double.tryParse(_weightController.text) ?? 0.0,
        'bloodGroup': _bloodGroup,
        'medicalConditions': _selectedConditions,
        'medicalHistory': _medicalHistoryController.text.trim(),
        'allergies': _allergiesController.text.trim(),
        'currentMedications': _currentMedicationsController.text.trim(),
        'emergencyContact': {
          'name': _emergencyNameController.text.trim(),
          'phone': _emergencyPhoneController.text.trim(),
          'relationship': _emergencyRelationController.text.trim(),
        },
      };

      // TODO: Save patient health profile to backend
      // For now, just navigate to dashboard since patient registration is already complete
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1976D2),
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const Text(
                      'Health Profile Setup',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Help us provide better care by sharing your health information',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Basic Health Info
                    const Text(
                      'Basic Health Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Height and Weight in a row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Height (cm)',
                              hintText: '170',
                              prefixIcon: Icon(Icons.height),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter height';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Invalid height';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Weight (kg)',
                              hintText: '70',
                              prefixIcon: Icon(Icons.monitor_weight),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter weight';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Invalid weight';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Blood Group
                    DropdownButtonFormField<String>(
                      value: _bloodGroup,
                      decoration: const InputDecoration(
                        labelText: 'Blood Group',
                        prefixIcon: Icon(Icons.bloodtype),
                      ),
                      items: _bloodGroups.map((group) {
                        return DropdownMenuItem(
                          value: group,
                          child: Text(group),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _bloodGroup = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Medical Conditions
                    const Text(
                      'Medical Conditions',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select any conditions you currently have or have had:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _conditions.map((condition) {
                        final isSelected = _selectedConditions.contains(condition);
                        return FilterChip(
                          label: Text(condition),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (condition == 'None') {
                                if (selected) {
                                  _selectedConditions.clear();
                                  _selectedConditions.add('None');
                                } else {
                                  _selectedConditions.remove('None');
                                }
                              } else {
                                _selectedConditions.remove('None');
                                if (selected) {
                                  _selectedConditions.add(condition);
                                } else {
                                  _selectedConditions.remove(condition);
                                }
                              }
                            });
                          },
                          selectedColor: const Color(0xFF1976D2).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF1976D2),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Medical History
                    TextFormField(
                      controller: _medicalHistoryController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Medical History (Optional)',
                        hintText: 'Any surgeries, hospitalizations, or significant medical events',
                        prefixIcon: Icon(Icons.history),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Allergies
                    TextFormField(
                      controller: _allergiesController,
                      decoration: const InputDecoration(
                        labelText: 'Allergies (Optional)',
                        hintText: 'Food, drug, or environmental allergies',
                        prefixIcon: Icon(Icons.warning),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Current Medications
                    TextFormField(
                      controller: _currentMedicationsController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Current Medications (Optional)',
                        hintText: 'List any medications you are currently taking',
                        prefixIcon: Icon(Icons.medication),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Emergency Contact
                    const Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Emergency Contact Name
                    TextFormField(
                      controller: _emergencyNameController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Name',
                        hintText: 'Full name of emergency contact',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter emergency contact name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Emergency Contact Phone
                    TextFormField(
                      controller: _emergencyPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Contact Phone',
                        hintText: 'Emergency contact phone number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter emergency contact phone';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Relationship
                    TextFormField(
                      controller: _emergencyRelationController,
                      decoration: const InputDecoration(
                        labelText: 'Relationship',
                        hintText: 'e.g., Spouse, Parent, Sibling',
                        prefixIcon: Icon(Icons.family_restroom),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter relationship';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Privacy Notice
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2).withOpacity(0.1),
                        border: Border.all(color: const Color(0xFF1976D2).withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.security,
                            color: Color(0xFF1976D2),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your health information is encrypted and secure. It will only be shared with healthcare providers you choose.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Error message
                    if (authProvider.state == AuthState.error)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          border: Border.all(color: Colors.red[200]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                authProvider.errorMessage ?? 'Registration failed',
                                style: TextStyle(color: Colors.red[600], fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Complete Registration button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: authProvider.state == AuthState.loading ? null : _handleSubmit,
                        child: authProvider.state == AuthState.loading
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 24,
                              )
                            : const Text(
                                'Complete Registration',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Skip option
                    TextButton(
                      onPressed: () {
                        // Allow users to skip detailed health info and go to dashboard
                        Navigator.of(context).pushReplacementNamed('/dashboard');
                      },
                      child: const Text(
                        'Skip for now (you can complete this later)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
