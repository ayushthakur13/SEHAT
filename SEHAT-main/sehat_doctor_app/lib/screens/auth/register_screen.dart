import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  final String selectedLanguage;
  
  const RegisterScreen({super.key, required this.selectedLanguage});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedLanguage = 'english';
  String _selectedGender = 'male';
  String _selectedRole = 'patient';
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  final List<Map<String, String>> _languages = [
    {'value': 'english', 'label': 'English'},
    {'value': 'hindi', 'label': 'हिंदी'},
    {'value': 'punjabi', 'label': 'ਪੰਜਾਬੀ'},
  ];

  final List<Map<String, String>> _genders = [
    {'value': 'male', 'label': 'Male'},
    {'value': 'female', 'label': 'Female'},
    {'value': 'other', 'label': 'Other'},
  ];

  final List<Map<String, String>> _roles = [
    {'value': 'patient', 'label': 'Patient', 'icon': '🤒', 'description': 'Get medical care'},
    {'value': 'doctor', 'label': 'Doctor', 'icon': '👨‍⚕️', 'description': 'Provide medical care'},
    {'value': 'pharmacy', 'label': 'Pharmacy', 'icon': '💊', 'description': 'Manage medicines'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Prevent multiple rapid submissions
    if (_isSubmitting || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      await authProvider.register(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        preferredLanguage: _selectedLanguage,
        gender: _selectedGender,
        dateOfBirth: _selectedDate!.toIso8601String(),
        role: _selectedRole,
      );
      
      if (authProvider.state == AuthState.authenticated) {
        // Patient registration successful, go to dashboard
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      } else if (authProvider.state == AuthState.needsVerification) {
        // Doctor/Pharmacy registration successful, go to verification
        if (mounted) {
          switch (_selectedRole) {
            case 'doctor':
              Navigator.of(context).pushReplacementNamed('/doctor_verification');
              break;
            case 'pharmacy':
              Navigator.of(context).pushReplacementNamed('/pharmacy_verification');
              break;
          }
        }
      }
    } catch (error) {
      // Error is handled by AuthProvider
      print('Registration error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Create Account'),
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
                    // Title
                    Text(
                      'Join SEHAT as ${_roles.firstWhere((r) => r['value'] == _selectedRole)['label']}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please fill in your details to continue',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Role selection
                    const Text(
                      'Select Your Role',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Role cards
                    Row(
                      children: _roles.map((role) {
                        final isSelected = _selectedRole == role['value'];
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRole = role['value']!;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF1976D2).withOpacity(0.1) : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF1976D2) : Colors.grey[300]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      role['icon']!,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      role['label']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? const Color(0xFF1976D2) : Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      role['description']!,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isSelected ? const Color(0xFF1976D2) : Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Name field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Phone field
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+911234567890',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.trim().length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: _selectedRole == 'doctor' 
                            ? 'doctor@example.com' 
                            : _selectedRole == 'pharmacy' 
                                ? 'pharmacy@example.com' 
                                : 'user@example.com',
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email address';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Date of Birth field
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'Select your date of birth',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      onTap: _selectDate,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Gender dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      items: _genders.map((gender) {
                        return DropdownMenuItem(
                          value: gender['value'],
                          child: Text(gender['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Language dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedLanguage,
                      decoration: const InputDecoration(
                        labelText: 'Preferred Language',
                        prefixIcon: Icon(Icons.language_outlined),
                      ),
                      items: _languages.map((language) {
                        return DropdownMenuItem(
                          value: language['value'],
                          child: Text(language['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter a strong password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Confirm Password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
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
                    
                    // Register button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (authProvider.state == AuthState.loading || _isSubmitting) ? null : _handleRegister,
                        child: (authProvider.state == AuthState.loading || _isSubmitting)
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 24,
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Terms and conditions
                    Text(
                      'By creating an account, you agree to our Terms of Service and Privacy Policy',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
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
