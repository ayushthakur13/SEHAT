import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utils/theme.dart';
import '../../utils/user_storage.dart';
import '../../utils/language_manager.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  String gender = '';
  String bloodGroup = '';
  String lang = 'en';
  String? profileImagePath;
  bool notifySms = true;
  bool notifyEmail = true;
  bool notifyPush = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await UserStorage.getUser();
    final l = await LanguageManager.getLanguage();
    setState(() {
      user = u ?? {};
      lang = l;
      nameCtrl.text = (u?['name'] ?? '').toString();
      phoneCtrl.text = (u?['phone'] ?? '').toString();
      emailCtrl.text = (u?['email'] ?? '').toString();
      ageCtrl.text = (u?['age'] ?? '').toString();
      gender = (u?['gender'] ?? '').toString();
      bloodGroup = (u?['bloodGroup'] ?? '').toString();
      profileImagePath = (u?['profileImagePath'] ?? '').toString().isEmpty ? null : (u?['profileImagePath'] as String);
      notifySms = (u?['notifySms'] ?? true) == true;
      notifyEmail = (u?['notifyEmail'] ?? true) == true;
      notifyPush = (u?['notifyPush'] ?? true) == true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // User Information
            Align(
              alignment: Alignment.centerLeft,
              child: Text('User Information', style: TextStyle(fontWeight: FontWeight.w600, color: SEHATTheme.textPrimary)),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))]),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: SEHATTheme.primaryColor.withOpacity(0.15),
                          backgroundImage: profileImagePath != null ? FileImage(File(profileImagePath!)) : null,
                          child: profileImagePath == null ? Icon(Icons.person, color: SEHATTheme.primaryColor, size: 40) : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(color: SEHATTheme.primaryColor, shape: BoxShape.circle),
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.edit, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Full Name')),
                  SizedBox(height: 12),
                  TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone),
                  SizedBox(height: 12),
                  TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
                  SizedBox(height: 12),
                  TextField(controller: ageCtrl, decoration: InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: gender.isEmpty ? null : gender,
                    decoration: InputDecoration(labelText: 'Gender'),
                    items: ['Male', 'Female', 'Other'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => gender = v ?? ''),
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: bloodGroup.isEmpty ? null : bloodGroup,
                    decoration: InputDecoration(labelText: 'Blood Group'),
                    items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => bloodGroup = v ?? ''),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: lang,
              decoration: InputDecoration(labelText: 'Language'),
              items: [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
                DropdownMenuItem(value: 'pa', child: Text('ਪੰਜਾਬੀ')),
              ],
              onChanged: (v) => setState(() => lang = v ?? 'en'),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Notifications', style: TextStyle(fontWeight: FontWeight.w600, color: SEHATTheme.textPrimary)),
            ),
            SwitchListTile(
              value: notifySms,
              onChanged: (v) => setState(() => notifySms = v),
              title: Text('SMS Notifications'),
            ),
            SwitchListTile(
              value: notifyEmail,
              onChanged: (v) => setState(() => notifyEmail = v),
              title: Text('Email Alerts'),
            ),
            SwitchListTile(
              value: notifyPush,
              onChanged: (v) => setState(() => notifyPush = v),
              title: Text('Push Notifications'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _logout,
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Support & Help', style: TextStyle(fontWeight: FontWeight.w600, color: SEHATTheme.textPrimary)),
            ),
            SizedBox(height: 8),
            _supportTile(Icons.help_center, 'Help Center / FAQ', _openHelpCenter),
            _supportTile(Icons.chat_bubble, 'Chat with Support', _openChat),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    await UserStorage.updateUser({
      'name': nameCtrl.text.trim(),
      'phone': phoneCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'age': ageCtrl.text.trim(),
      'gender': gender,
      'bloodGroup': bloodGroup,
      'profileImagePath': profileImagePath ?? '',
      'notifySms': notifySms,
      'notifyEmail': notifyEmail,
      'notifyPush': notifyPush,
    });
    await LanguageManager.setLanguage(lang);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated')));
  }

  Future<void> _logout() async {
    await UserStorage.clear();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/language', (route) => false);
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x != null) {
      setState(() => profileImagePath = x.path);
    }
  }

  Widget _supportTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: SEHATTheme.primaryColor),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _openHelpCenter() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Help Center / FAQ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• How to book a consultation?\nGo to Home → Book Consultation.'),
              SizedBox(height: 8),
              Text('• How to upload prescriptions?\nPrescriptions are saved automatically after consultation.'),
              SizedBox(height: 8),
              Text('• How to change language?\nUse Profile → Language setting.'),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
      ),
    );
  }

  void _openChat() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Live chat coming soon.'),
            SizedBox(height: 12),
            Text('Email: support@sehat.com'),
            Text('Phone: 1800-000-SEHAT'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
        ],
      ),
    );
  }

  void _sendEmail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email: support@sehat.com')));
  }

  void _callSupport() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Helpline: 1800-000-SEHAT')));
  }
}


