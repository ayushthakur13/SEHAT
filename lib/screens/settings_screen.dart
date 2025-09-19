import 'package:flutter/material.dart';
import 'doctor_verification_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(text: 'Dr. Smith');
  final TextEditingController _hospitalIdController = TextEditingController(text: 'DOC001');
  final TextEditingController _experienceController = TextEditingController(text: '8');
  final TextEditingController _qualificationsController = TextEditingController(text: 'MBBS, MD');
  final TextEditingController _emailController = TextEditingController(text: 'dr.smith@sehat.com');
  final TextEditingController _phoneController = TextEditingController(text: '+91 98765 43210');
  final TextEditingController _addressController = TextEditingController(text: 'Sehat Hospital, Mumbai');
  final TextEditingController _bioController = TextEditingController(text: 'Passionate about patient care and continuous learning.');

  final List<String> _specializations = <String>[
    'General Physician',
    'Cardiologist',
    'Dermatologist',
    'Neurologist',
    'Orthopedic',
    'Pediatrician',
    'Psychiatrist',
    'Gynecologist',
  ];

  String _selectedSpecialization = 'General Physician';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: const Color(0xFF1976D2),
                        child: Text(
                          _initialsFromName(_nameController.text),
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
                              _nameController.text,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _selectedSpecialization,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Hospital ID: ${_hospitalIdController.text}',
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
                        'Basic Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter full name' : null,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedSpecialization,
                        items: _specializations.map((s) => DropdownMenuItem<String>(value: s, child: Text(s))).toList(),
                        onChanged: (v) => setState(() => _selectedSpecialization = v ?? _selectedSpecialization),
                        decoration: const InputDecoration(
                          labelText: 'Specialization',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.medical_services_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _experienceController,
                        decoration: const InputDecoration(
                          labelText: 'Experience (years)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.timeline),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter years of experience';
                          final n = int.tryParse(v);
                          if (n == null || n < 0 || n > 70) return 'Enter a valid number (0-70)';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _qualificationsController,
                        decoration: const InputDecoration(
                          labelText: 'Qualifications',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.school_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _hospitalIdController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Hospital ID',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                    ],
                  ),
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
                        'Contact',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Please enter email';
                          final regex = RegExp(r'^.+@.+\..+$');
                          if (!regex.hasMatch(v)) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter phone number' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Clinic Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                      ),
                    ],
                  ),
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
                        'About',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _bioController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Short Bio',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Profile'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _verifyCredentials,
                  icon: const Icon(Icons.verified_user),
                  label: const Text('Verify Medical Credentials'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1976D2),
                    side: const BorderSide(color: Color(0xFF1976D2)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initialsFromName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'DR';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].isNotEmpty ? parts[0][0] : 'D').toUpperCase() + (parts[1].isNotEmpty ? parts[1][0] : 'R').toUpperCase();
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );
  }

  void _verifyCredentials() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DoctorVerificationScreen(),
      ),
    );
  }
}
