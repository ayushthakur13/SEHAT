import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/user_storage.dart';
import '../home_shell.dart';
import 'otp_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  String method = 'phone'; // 'email' or 'phone'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ToggleButtons(
                isSelected: [method == 'phone', method == 'email'],
                borderRadius: BorderRadius.circular(12),
                onPressed: (i) => setState(() => method = i == 0 ? 'phone' : 'email'),
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Mobile')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Email')),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: phoneCtrl,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: passwordCtrl,
                decoration: InputDecoration(labelText: 'Password (optional)'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _sendOtp,
                  child: Text('Send OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final target = method == 'phone' ? phoneCtrl.text : emailCtrl.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          destination: target,
          onVerified: () async {
            await UserStorage.saveUser({
              'name': nameCtrl.text.trim(),
              'email': emailCtrl.text.trim(),
              'phone': phoneCtrl.text.trim(),
              'preferredMethod': method,
            });
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomeShell()),
              (route) => false,
            );
          },
        ),
      ),
    );
  }
}


