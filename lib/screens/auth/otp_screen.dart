import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  final String destination; // email or phone shown to user
  final Future<void> Function() onVerified;

  const OtpScreen({Key? key, required this.destination, required this.onVerified}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpCtrl = TextEditingController();
  bool sending = false;
  bool verifying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter the 6-digit code sent to'),
            SizedBox(height: 4),
            Text(widget.destination, style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            TextField(
              controller: otpCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(hintText: '123456', counterText: ''),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                TextButton(onPressed: sending ? null : _resend, child: Text("Didn't get OTP? Resend")),
                Spacer(),
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Use another method')),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: verifying ? null : _verify,
                child: Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resend() async {
    setState(() => sending = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() => sending = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP resent')));
  }

  Future<void> _verify() async {
    if (otpCtrl.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid OTP')));
      return;
    }
    setState(() => verifying = true);
    await Future.delayed(Duration(milliseconds: 800));
    await widget.onVerified();
  }
}


