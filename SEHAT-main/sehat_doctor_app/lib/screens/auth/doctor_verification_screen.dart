import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../providers/auth_provider.dart';
import '../../services/base_api_service.dart';

class DoctorVerificationScreen extends StatefulWidget {
  const DoctorVerificationScreen({super.key});

  @override
  State<DoctorVerificationScreen> createState() => _DoctorVerificationScreenState();
}

class _DoctorVerificationScreenState extends State<DoctorVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hospitalIdController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _clinicNameController = TextEditingController();
  final _pincodeController = TextEditingController();
  
  String? _selectedSpecialization;
  List<String> _selectedLanguages = [];
  bool _isSubmitting = false;
  
  final List<String> _specializations = [
    'General Practice',
    'Cardiology',
    'Dermatology',
    'Endocrinology',
    'Gastroenterology',
    'Gynecology',
    'Neurology',
    'Oncology',
    'Orthopedics',
    'Pediatrics',
    'Psychiatry',
    'Pulmonology',
    'Radiology',
    'Surgery',
    'Urology',
    'Other'
  ];
  
  final List<String> _languages = [
    'English',
    'Hindi',
    'Punjabi',
    'Urdu',
    'Bengali',
    'Tamil',
    'Telugu',
    'Gujarati',
    'Marathi',
    'Kannada'
  ];

  @override
  void dispose() {
    _hospitalIdController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _clinicNameController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // Prevent multiple rapid submissions
    if (_isSubmitting || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Debug: Check auth state before verification
      await BaseApiService().debugAuthState();
      
      // Verify doctor with backend
      await authProvider.verifyDoctor(
        hospitalId: _hospitalIdController.text.trim(),
        specialization: _selectedSpecialization!,
        experience: int.tryParse(_experienceController.text) ?? 0,
        languages: _selectedLanguages,
        currentHospitalClinic: _clinicNameController.text.trim(),
        pincode: _pincodeController.text.trim(),
      );
      
      // Navigate to dashboard after successful verification
      if (authProvider.state == AuthState.authenticated && mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (error) {
      // Error handling is done by the provider
      print('Verification error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Doctor Verification'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF2E8B57),
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
                      'Medical Professional Verification',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E8B57),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please provide your professional details for verification',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Hospital ID
                    TextFormField(
                      controller: _hospitalIdController,
                      decoration: const InputDecoration(
                        labelText: 'Hospital/Medical ID',
                        hintText: 'Enter your hospital or medical ID',
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your hospital/medical ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Specialization
                    DropdownButtonFormField<String>(
                      value: _selectedSpecialization,
                      decoration: const InputDecoration(
                        labelText: 'Specialization',
                        prefixIcon: Icon(Icons.local_hospital),
                      ),
                      items: _specializations.map((spec) {
                        return DropdownMenuItem(
                          value: spec,
                          child: Text(spec),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSpecialization = value;
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
                    
                    // Years of Experience
                    TextFormField(
                      controller: _experienceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Years of Experience',
                        hintText: 'Enter years of experience',
                        prefixIcon: Icon(Icons.timeline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your experience';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Current Hospital/Clinic
                    TextFormField(
                      controller: _clinicNameController,
                      decoration: const InputDecoration(
                        labelText: 'Current Hospital/Clinic',
                        hintText: 'Enter your current workplace',
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your current workplace';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Pincode
                    TextFormField(
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Pincode',
                        hintText: 'Enter your area pincode',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your pincode';
                        }
                        if (value.trim().length != 6) {
                          return 'Please enter a valid 6-digit pincode';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Languages Spoken (optional)
                    const Text(
                      'Languages Spoken (Optional)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
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
                          selectedColor: const Color(0xFF2E8B57).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF2E8B57),
                        );
                      }).toList(),
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
                                authProvider.errorMessage ?? 'Verification failed',
                                style: TextStyle(color: Colors.red[600], fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (authProvider.state == AuthState.loading || _isSubmitting) ? null : _handleSubmit,
                        child: (authProvider.state == AuthState.loading || _isSubmitting)
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 24,
                              )
                            : const Text(
                                'Submit for Verification',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Info text
                    const Text(
                      'Your application will be reviewed within 24-48 hours. You will receive a notification once approved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
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
