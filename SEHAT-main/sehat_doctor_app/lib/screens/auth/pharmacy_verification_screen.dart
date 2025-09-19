import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../providers/auth_provider.dart';
import '../../services/base_api_service.dart';

class PharmacyVerificationScreen extends StatefulWidget {
  const PharmacyVerificationScreen({super.key});

  @override
  State<PharmacyVerificationScreen> createState() => _PharmacyVerificationScreenState();
}

class _PharmacyVerificationScreenState extends State<PharmacyVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _licenseNumberController = TextEditingController();
  final _pharmacyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _operatingHoursController = TextEditingController();
  
  Map<String, dynamic>? registrationData;
  bool _isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (registrationData == null) {
      registrationData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    }
  }

  @override
  void dispose() {
    _licenseNumberController.dispose();
    _pharmacyNameController.dispose();
    _addressController.dispose();
    _pinCodeController.dispose();
    _gstNumberController.dispose();
    _operatingHoursController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // Prevent multiple rapid submissions
    if (_isSubmitting || !_formKey.currentState!.validate()) {
      return;
    }

    // Validate required fields
    final licenseNumber = _licenseNumberController.text.trim();
    final gstNumber = _gstNumberController.text.trim();
    
    if (licenseNumber.isEmpty && gstNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide either license number or GST number')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Debug: Check auth state before verification
      await BaseApiService().debugAuthState();
      
      // Verify pharmacy with backend
      await authProvider.verifyPharmacy(
        storeName: _pharmacyNameController.text.trim(),
        licenseNumber: licenseNumber.isNotEmpty ? licenseNumber : null,
        gstNumber: gstNumber.isNotEmpty ? gstNumber : null,
        address: _addressController.text.trim(),
        city: null, // Not collected in current UI
        state: null, // Not collected in current UI
        pincode: _pinCodeController.text.trim(),
        workingHours: _operatingHoursController.text.trim().isNotEmpty 
            ? _operatingHoursController.text.trim() 
            : null,
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
        title: const Text('Pharmacy Verification'),
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
                      'Pharmacy Verification',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E8B57),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please provide your pharmacy details for verification',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Pharmacy Name (storeName - required)
                    TextFormField(
                      controller: _pharmacyNameController,
                      decoration: const InputDecoration(
                        labelText: 'Pharmacy Name *',
                        hintText: 'Enter pharmacy name',
                        prefixIcon: Icon(Icons.store),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter pharmacy name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // License Number (optional if GST provided)
                    TextFormField(
                      controller: _licenseNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Pharmacy License Number',
                        hintText: 'Enter license number (or GST below)',
                        prefixIcon: Icon(Icons.card_membership),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // GST Number (optional if license provided)
                    TextFormField(
                      controller: _gstNumberController,
                      decoration: const InputDecoration(
                        labelText: 'GST Number',
                        hintText: 'Enter GST registration number',
                        prefixIcon: Icon(Icons.receipt_long),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Address (required)
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Business Address *',
                        hintText: 'Enter complete business address',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter business address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // PIN Code (required)
                    TextFormField(
                      controller: _pinCodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'PIN Code *',
                        hintText: 'Enter area PIN code',
                        prefixIcon: Icon(Icons.pin_drop),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter PIN code';
                        }
                        if (value.length != 6) {
                          return 'Please enter valid 6-digit PIN code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Operating Hours (optional)
                    TextFormField(
                      controller: _operatingHoursController,
                      decoration: const InputDecoration(
                        labelText: 'Operating Hours (Optional)',
                        hintText: 'e.g., 9:00 AM - 9:00 PM',
                        prefixIcon: Icon(Icons.access_time),
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
