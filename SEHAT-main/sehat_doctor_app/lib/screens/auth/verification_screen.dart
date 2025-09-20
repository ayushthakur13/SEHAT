import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../providers/auth_provider.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hospitalIdController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _pincodeController = TextEditingController();
  
  List<String> _selectedLanguages = ['english'];
  
  final List<Map<String, String>> _availableLanguages = [
    {'value': 'english', 'label': 'English'},
    {'value': 'hindi', 'label': 'हिंदी'},
    {'value': 'punjabi', 'label': 'ਪੰਜਾਬੀ'},
  ];

  final List<String> _specializations = [
    'General Medicine',
    'Cardiology',
    'Dermatology',
    'Neurology',
    'Orthopedics',
    'Pediatrics',
    'Psychiatry',
    'Gynecology',
    'ENT',
    'Ophthalmology',
    'Radiology',
    'Anesthesiology',
    'Emergency Medicine',
    'Family Medicine',
    'Other',
  ];

  @override
  void dispose() {
    _hospitalIdController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _hospitalNameController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _handleVerification() {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.verifyDoctor(
        hospitalId: _hospitalIdController.text.trim(),
        specialization: _specializationController.text.trim(),
        experience: int.parse(_experienceController.text.trim()),
        languages: _selectedLanguages,
        currentHospitalClinic: _hospitalNameController.text.trim(),
        pincode: _pincodeController.text.trim(),
      );
    }
  }

  void _toggleLanguage(String language) {
    setState(() {
      if (_selectedLanguages.contains(language)) {
        if (_selectedLanguages.length > 1) {
          _selectedLanguages.remove(language);
        }
      } else {
        _selectedLanguages.add(language);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1976D2),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => authProvider.logout(),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome message
              Card(
                color: const Color(0xFF1976D2).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 48,
                        color: Color(0xFF1976D2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome, ${authProvider.user?.name ?? 'Doctor'}!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please complete your professional profile to start using SEHAT Doctor app',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Verification form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hospital ID
                    TextFormField(
                      controller: _hospitalIdController,
                      decoration: const InputDecoration(
                        labelText: 'Hospital/Clinic ID',
                        hintText: 'Enter your hospital or clinic ID',
                        prefixIcon: Icon(Icons.local_hospital_outlined),
                        helperText: 'Your official medical institution identifier',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your hospital/clinic ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Hospital/Clinic Name
                    TextFormField(
                      controller: _hospitalNameController,
                      decoration: const InputDecoration(
                        labelText: 'Current Hospital/Clinic',
                        hintText: 'Enter the name of your workplace',
                        prefixIcon: Icon(Icons.business_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your current workplace';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Specialization dropdown
                    DropdownButtonFormField<String>(
                      value: _specializations.contains(_specializationController.text) 
                          ? _specializationController.text 
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Specialization',
                        prefixIcon: Icon(Icons.medical_services_outlined),
                      ),
                      items: _specializations.map((specialization) {
                        return DropdownMenuItem(
                          value: specialization,
                          child: Text(specialization),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _specializationController.text = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your specialization';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Experience
                    TextFormField(
                      controller: _experienceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Years of Experience',
                        hintText: 'Enter your years of medical practice',
                        prefixIcon: Icon(Icons.timeline_outlined),
                        suffixText: 'years',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your years of experience';
                        }
                        final experience = int.tryParse(value.trim());
                        if (experience == null || experience < 0) {
                          return 'Please enter a valid number of years';
                        }
                        if (experience > 60) {
                          return 'Please enter a realistic number of years';
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
                        hintText: 'Enter your practice location pincode',
                        prefixIcon: Icon(Icons.location_on_outlined),
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
                    const SizedBox(height: 24),
                    
                    // Languages selection
                    const Text(
                      'Languages You Speak',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select at least one language',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableLanguages.map((language) {
                        final isSelected = _selectedLanguages.contains(language['value']);
                        return FilterChip(
                          label: Text(language['label']!),
                          selected: isSelected,
                          onSelected: (selected) => _toggleLanguage(language['value']!),
                          selectedColor: const Color(0xFF1976D2).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF1976D2),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                    
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
                    
                    // Complete Profile button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: authProvider.state == AuthState.loading 
                            ? null 
                            : _handleVerification,
                        child: authProvider.state == AuthState.loading
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 24,
                              )
                            : const Text(
                                'Complete Profile',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(color: Colors.blue[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your profile will be reviewed for verification. This may take up to 24 hours.',
                        style: TextStyle(color: Colors.blue[600], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
