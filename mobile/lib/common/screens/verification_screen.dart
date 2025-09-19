import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Doctor fields
  final _hospitalIdController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _pincodeController = TextEditingController();
  
  // Pharmacy fields
  final _storeNameController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pharmacyPincodeController = TextEditingController();
  
  List<String> _selectedLanguages = ['english'];

  @override
  void dispose() {
    _hospitalIdController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _hospitalNameController.dispose();
    _pincodeController.dispose();
    _storeNameController.dispose();
    _licenseNumberController.dispose();
    _gstNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pharmacyPincodeController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError 
            ? Theme.of(context).colorScheme.error 
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _verifyDoctor() async {
    if (!_formKey.currentState!.validate()) return;

    final request = DoctorVerificationRequest(
      hospitalId: _hospitalIdController.text.trim(),
      specialization: _specializationController.text.trim(),
      experience: int.tryParse(_experienceController.text) ?? 0,
      languages: _selectedLanguages,
      currentHospitalClinic: _hospitalNameController.text.trim(),
      pincode: _pincodeController.text.trim(),
    );

    await ref.read(authStateProvider.notifier).verifyDoctor(request);

    final authState = ref.read(authStateProvider);
    if (authState.error != null) {
      _showSnackBar(authState.error!, isError: true);
    } else if (!authState.needsVerification) {
      _showSnackBar('Verification completed successfully!');
    }
  }

  Future<void> _verifyPharmacy() async {
    if (!_formKey.currentState!.validate()) return;

    final request = PharmacyVerificationRequest(
      storeName: _storeNameController.text.trim(),
      licenseNumber: _licenseNumberController.text.trim().isEmpty ? null : _licenseNumberController.text.trim(),
      gstNumber: _gstNumberController.text.trim().isEmpty ? null : _gstNumberController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pincode: _pharmacyPincodeController.text.trim(),
    );

    await ref.read(authStateProvider.notifier).verifyPharmacy(request);

    final authState = ref.read(authStateProvider);
    if (authState.error != null) {
      _showSnackBar(authState.error!, isError: true);
    } else if (!authState.needsVerification) {
      _showSnackBar('Verification completed successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userRole = authState.user?.role;
    
    if (userRole == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${userRole.capitalize()} Verification'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          userRole == 'doctor' ? Icons.medical_services : Icons.local_pharmacy,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Complete Your Profile',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please provide your professional details to complete verification',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                if (userRole == 'doctor') ..._buildDoctorFields(),
                if (userRole == 'pharmacy') ..._buildPharmacyFields(),
                
                const SizedBox(height: 32),
                
                // Submit Button
                LoadingButton(
                  text: 'Complete Verification',
                  isLoading: authState.isLoading,
                  onPressed: userRole == 'doctor' ? _verifyDoctor : _verifyPharmacy,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDoctorFields() {
    return [
      CustomTextField(
        label: 'Hospital ID',
        hintText: 'Enter your hospital registration ID',
        prefixIcon: Icons.local_hospital,
        controller: _hospitalIdController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Hospital ID is required';
          }
          return null;
        },
      ),
      
      const SizedBox(height: 20),
      
      CustomTextField(
        label: 'Specialization',
        hintText: 'e.g., General Medicine, Cardiology',
        prefixIcon: Icons.medical_services,
        controller: _specializationController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Specialization is required';
          }
          return null;
        },
      ),
      
      const SizedBox(height: 20),
      
      CustomTextField(
        label: 'Years of Experience',
        hintText: 'Enter years of experience',
        prefixIcon: Icons.timeline,
        controller: _experienceController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Experience is required';
          }
          if (int.tryParse(value) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
      ),
      
      const SizedBox(height: 20),
      
      CustomTextField(
        label: 'Current Hospital/Clinic',
        hintText: 'Name of your workplace',
        prefixIcon: Icons.business,
        controller: _hospitalNameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Hospital/Clinic name is required';
          }
          return null;
        },
      ),
      
      const SizedBox(height: 20),
      
      CustomTextField(
        label: 'Pincode',
        hintText: 'Area pincode',
        prefixIcon: Icons.location_on,
        controller: _pincodeController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Pincode is required';
          }
          if (value.length != 6) {
            return 'Enter a valid 6-digit pincode';
          }
          return null;
        },
      ),
      
      const SizedBox(height: 20),
      
      // Languages
      Text(
        'Languages Spoken',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: [
          _buildLanguageChip('english', 'English'),
          _buildLanguageChip('hindi', 'Hindi'),
          _buildLanguageChip('punjabi', 'Punjabi'),
        ],
      ),
    ];
  }

  List<Widget> _buildPharmacyFields() {
    return [
      CustomTextField(
        label: 'Store Name',
        hintText: 'Enter your pharmacy store name',
        prefixIcon: Icons.store,
        controller: _storeNameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Store name is required';
          }
          return null;
        },
      ),
      
      const SizedBox(height: 20),
      
      CustomTextField(
        label: 'License Number',
        hintText: 'Pharmacy license number (optional)',
        prefixIcon: Icons.verified,
        controller: _licenseNumberController,
      ),
      
      const SizedBox(height: 20),
      
      CustomTextField(
        label: 'GST Number',
        hintText: 'GST registration number (optional)',
        prefixIcon: Icons.receipt,
        controller: _gstNumberController,
      ),
      
      const SizedBox(height: 20),
      
      CustomTextField(
        label: 'Address',
        hintText: 'Complete store address',
        prefixIcon: Icons.location_on,
        controller: _addressController,
        maxLines: 3,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Address is required';
          }
          return null;
        },
      ),
      
      const SizedBox(height: 20),
      
      CustomTextField(
        label: 'City',
        hintText: 'City name',
        prefixIcon: Icons.location_city,
        controller: _cityController,
      ),
      
      const SizedBox(height: 20),
      
      CustomTextField(
        label: 'State',
        hintText: 'State name',
        prefixIcon: Icons.map,
        controller: _stateController,
      ),
      
      const SizedBox(height: 20),
      
      CustomTextField(
        label: 'Pincode',
        hintText: 'Area pincode',
        prefixIcon: Icons.pin_drop,
        controller: _pharmacyPincodeController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Pincode is required';
          }
          if (value.length != 6) {
            return 'Enter a valid 6-digit pincode';
          }
          return null;
        },
      ),
    ];
  }

  Widget _buildLanguageChip(String value, String label) {
    final isSelected = _selectedLanguages.contains(value);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            if (!_selectedLanguages.contains(value)) {
              _selectedLanguages.add(value);
            }
          } else {
            _selectedLanguages.remove(value);
            // Always keep at least one language
            if (_selectedLanguages.isEmpty) {
              _selectedLanguages.add('english');
            }
          }
        });
      },
    );
  }
}

extension StringCapitalize on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}