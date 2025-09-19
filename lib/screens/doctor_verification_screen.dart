import 'package:flutter/material.dart';

class DoctorVerificationScreen extends StatefulWidget {
  const DoctorVerificationScreen({super.key});

  @override
  State<DoctorVerificationScreen> createState() => _DoctorVerificationScreenState();
}

class _DoctorVerificationScreenState extends State<DoctorVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _hospitalIdController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _currentHospitalController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  
  String _selectedSpecialization = '';
  List<String> _selectedLanguages = [];
  bool _isVerifying = false;

  final List<String> _specializations = [
    'General Physician',
    'Cardiologist',
    'Dermatologist',
    'Neurologist',
    'Orthopedic Surgeon',
    'Pediatrician',
    'Psychiatrist',
    'Gynecologist',
    'Ophthalmologist',
    'ENT Specialist',
    'Gastroenterologist',
    'Pulmonologist',
    'Endocrinologist',
    'Rheumatologist',
    'Oncologist',
    'Urologist',
    'Anesthesiologist',
    'Radiologist',
    'Pathologist',
    'Emergency Medicine',
  ];

  final List<String> _languages = [
    'English',
    'Hindi',
    'Bengali',
    'Tamil',
    'Telugu',
    'Marathi',
    'Gujarati',
    'Kannada',
    'Malayalam',
    'Punjabi',
    'Urdu',
    'Assamese',
    'Odia',
    'Bhojpuri',
    'Sanskrit',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Verification'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 48,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Verify Your Medical Credentials',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please provide your medical credentials for verification',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Hospital/Medical ID
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medical Credentials',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _hospitalIdController,
                        decoration: const InputDecoration(
                          labelText: 'Hospital/Medical ID',
                          hintText: 'Enter your hospital ID or medical license number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your medical ID';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Specialization and Experience
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Professional Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedSpecialization.isEmpty ? null : _selectedSpecialization,
                        decoration: const InputDecoration(
                          labelText: 'Specialization',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.medical_services_outlined),
                        ),
                        items: _specializations.map((spec) {
                          return DropdownMenuItem<String>(
                            value: spec,
                            child: Text(spec),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSpecialization = value ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your specialization';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _experienceController,
                        decoration: const InputDecoration(
                          labelText: 'Years of Experience',
                          hintText: 'Enter years of medical practice',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.timeline),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter years of experience';
                          }
                          final years = int.tryParse(value);
                          if (years == null || years < 0 || years > 50) {
                            return 'Enter valid years (0-50)';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Languages
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Languages Spoken',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select all languages you can communicate in with patients',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _languages.map((language) {
                          final isSelected = _selectedLanguages.contains(language);
                          return FilterChip(
                            label: Text(language),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedLanguages.add(language);
                                } else {
                                  _selectedLanguages.remove(language);
                                }
                              });
                            },
                            selectedColor: const Color(0xFF1976D2).withOpacity(0.2),
                            checkmarkColor: const Color(0xFF1976D2),
                          );
                        }).toList(),
                      ),
                      if (_selectedLanguages.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Please select at least one language',
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Current Hospital/Clinic and Location
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Practice',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _currentHospitalController,
                        decoration: const InputDecoration(
                          labelText: 'Current Hospital/Clinic',
                          hintText: 'Enter your current workplace name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.local_hospital_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your current hospital/clinic';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _pincodeController,
                        decoration: const InputDecoration(
                          labelText: 'Pincode',
                          hintText: 'Enter your practice location pincode',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter pincode';
                          }
                          if (value.length != 6) {
                            return 'Pincode must be 6 digits';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Verification Button
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isVerifying ? null : _submitVerification,
                  icon: _isVerifying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.verified_user),
                  label: Text(_isVerifying ? 'Verifying...' : 'Submit for Verification'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Info Card
              Card(
                color: Colors.amber[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your credentials will be verified within 24-48 hours. You will receive a notification once verified.',
                          style: TextStyle(
                            color: Colors.amber[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitVerification() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    if (_selectedLanguages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one language'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    // Simulate verification process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isVerifying = false;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Verification Submitted'),
            ],
          ),
          content: const Text(
            'Your doctor verification request has been submitted successfully. '
            'You will receive a notification once your credentials are verified.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _hospitalIdController.dispose();
    _experienceController.dispose();
    _currentHospitalController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }
}
