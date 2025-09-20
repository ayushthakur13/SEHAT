import 'package:flutter/material.dart';
import '../../config/groq_config.dart';
import '../../services/ai_service.dart';

class SymptomCheckerTestScreen extends StatefulWidget {
  const SymptomCheckerTestScreen({super.key});

  @override
  State<SymptomCheckerTestScreen> createState() => _SymptomCheckerTestScreenState();
}

class _SymptomCheckerTestScreenState extends State<SymptomCheckerTestScreen> {
  final AIService _aiService = AIService();
  bool _isLoading = false;
  String _testResult = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _aiService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Service Test'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Service Configuration Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildConfigStatus(),
            const SizedBox(height: 24),
            _buildTestButton(),
            const SizedBox(height: 24),
            if (_testResult.isNotEmpty) _buildTestResult(),
            if (_errorMessage.isNotEmpty) _buildErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuration Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  GroqConfig.isApiKeyConfigured ? Icons.check_circle : Icons.error,
                  color: GroqConfig.isApiKeyConfigured ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  GroqConfig.isApiKeyConfigured 
                      ? 'API Key Configured' 
                      : 'API Key Not Configured',
                  style: TextStyle(
                    color: GroqConfig.isApiKeyConfigured ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (GroqConfig.isApiKeyConfigured) ...[
              const SizedBox(height: 8),
              Text('API Key: ${GroqConfig.maskedApiKey}'),
              Text('Model: ${GroqConfig.model}'),
              Text('Base URL: ${GroqConfig.baseUrl}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _runTest,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Testing...'),
                ],
              )
            : const Text('Run Test'),
      ),
    );
  }

  Widget _buildTestResult() {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Test Successful',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_testResult),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Test Failed',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_errorMessage),
          ],
        ),
      ),
    );
  }

  Future<void> _runTest() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
      _errorMessage = '';
    });

    try {
      // Test with sample symptoms
      final result = await _aiService.analyzeSymptoms(
        symptoms: ['headache', 'fever'],
        age: '30',
        gender: 'Male',
        additionalInfo: 'Test analysis',
      );

      setState(() {
        _testResult = '''
Analysis completed successfully!

Severity: ${result.severity}
Needs Immediate Attention: ${result.needsImmediateAttention}
Possible Conditions: ${result.possibleConditions.join(', ')}
Assessment: ${result.assessment.substring(0, 100)}...
        ''';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }
}
