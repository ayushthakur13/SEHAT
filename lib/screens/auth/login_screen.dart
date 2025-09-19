import 'package:flutter/material.dart';
import '../../utils/user_storage.dart';
import '../home_shell.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String method = 'phone';
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            if (method == 'email')
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              )
            else
              TextField(
                controller: phoneCtrl,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
              ),
            Spacer(),
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
    );
  }

  void _sendOtp() {
    final target = method == 'phone' ? phoneCtrl.text : emailCtrl.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          destination: target,
          onVerified: () async {
            // In a real app, fetch user from backend. Here we persist minimal user.
            await UserStorage.saveUser({
              'email': emailCtrl.text.trim(),
              'phone': phoneCtrl.text.trim(),
              'preferredMethod': method,
            });
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomeShell()),
              (r) => false,
            );
          },
        ),
      ),
    );
  }
}


