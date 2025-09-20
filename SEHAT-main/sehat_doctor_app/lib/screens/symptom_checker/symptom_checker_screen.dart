import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/ai_service.dart';
import '../../models/symptom_checker.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen>
    with TickerProviderStateMixin {
  final AIService _aiService = AIService();
  final PageController _pageController = PageController();
  
  int _currentStep = 0;
  bool _isLoading = false;
  String _selectedCategory = 'general';
  final List<String> _selectedSymptoms = [];
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();
  String _selectedGender = 'Male';
  
  SymptomAnalysisResult? _analysisResult;
  EmergencyLevel? _emergencyLevel;
  List<String> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _aiService.initialize();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _ageController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        title: const Text('AI Symptom Checker'),
        elevation: 0,
        actions: [
          if (_currentStep > 0)
            TextButton(
              onPressed: _previousStep,
              child: const Text(
                'Back',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPersonalInfoStep(),
                _buildSymptomSelectionStep(),
                _buildAdditionalInfoStep(),
                _buildAnalysisStep(),
                _buildResultsStep(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(5, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? const Color(0xFF1976D2)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please provide your basic information to help us give you more accurate health insights.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          _buildInputField(
            controller: _ageController,
            label: 'Age',
            hint: 'Enter your age',
            keyboardType: TextInputType.number,
            icon: Icons.cake,
          ),
          const SizedBox(height: 24),
          _buildGenderSelector(),
          const SizedBox(height: 32),
          const Text(
            'Note: This AI symptom checker is for informational purposes only and should not replace professional medical advice.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomSelectionStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Your Symptoms',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose the symptoms you are currently experiencing. You can select multiple symptoms.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          _buildCategorySelector(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildSymptomList(),
          ),
          if (_selectedSymptoms.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSelectedSymptomsChips(),
          ],
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Provide any additional details about your symptoms (optional).',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          _buildInputField(
            controller: _additionalInfoController,
            label: 'Additional Information',
            hint: 'Describe your symptoms in more detail...',
            maxLines: 5,
            icon: Icons.note_add,
          ),
          const SizedBox(height: 32),
          const Text(
            'Selected Symptoms:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildSelectedSymptomsChips(),
        ],
      ),
    );
  }

  Widget _buildAnalysisStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading) ...[
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Analyzing your symptoms...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This may take a few moments',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ] else ...[
            const Icon(
              Icons.analytics,
              size: 64,
              color: Color(0xFF1976D2),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ready to Analyze',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Click "Analyze Symptoms" to get your health insights',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultsStep() {
    if (_analysisResult == null) {
      return const Center(
        child: Text('No analysis results available'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmergencyAlert(),
          const SizedBox(height: 24),
          _buildAnalysisSummary(),
          const SizedBox(height: 24),
          _buildPossibleConditions(),
          const SizedBox(height: 24),
          _buildRecommendations(),
          const SizedBox(height: 24),
          _buildDisclaimer(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1976D2)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Male'),
                value: 'Male',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                activeColor: const Color(0xFF1976D2),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Female'),
                value: 'Female',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                activeColor: const Color(0xFF1976D2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: PredefinedSymptoms.categories.length,
        itemBuilder: (context, index) {
          final category = PredefinedSymptoms.categories[index];
          final isSelected = _selectedCategory == category.id;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category.id;
                });
              },
              selectedColor: const Color(0xFF1976D2).withOpacity(0.2),
              checkmarkColor: const Color(0xFF1976D2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSymptomList() {
    final symptoms = PredefinedSymptoms.getSymptomsByCategory(_selectedCategory);
    
    return ListView.builder(
      itemCount: symptoms.length,
      itemBuilder: (context, index) {
        final symptom = symptoms[index];
        final isSelected = _selectedSymptoms.contains(symptom);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            title: Text(symptom),
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedSymptoms.add(symptom);
                } else {
                  _selectedSymptoms.remove(symptom);
                }
              });
            },
            activeColor: const Color(0xFF1976D2),
          ),
        );
      },
    );
  }

  Widget _buildSelectedSymptomsChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _selectedSymptoms.map((symptom) {
        return Chip(
          label: Text(symptom),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() {
              _selectedSymptoms.remove(symptom);
            });
          },
          backgroundColor: const Color(0xFF1976D2).withOpacity(0.1),
          deleteIconColor: const Color(0xFF1976D2),
        );
      }).toList(),
    );
  }

  Widget _buildEmergencyAlert() {
    if (_emergencyLevel == EmergencyLevel.high) {
      return Card(
        color: Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.warning, color: Colors.red),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'High Priority: Please seek immediate medical attention',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_emergencyLevel == EmergencyLevel.moderate) {
      return Card(
        color: Colors.orange[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.orange),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Moderate Priority: Consider consulting a healthcare provider',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildAnalysisSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analysis Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _analysisResult!.assessment,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Severity: '),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeverityColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _analysisResult!.severity.toUpperCase(),
                    style: TextStyle(
                      color: _getSeverityColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPossibleConditions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Possible Conditions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._analysisResult!.possibleConditions.map((condition) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_forward_ios, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(condition)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommendations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._analysisResult!.recommendations.map((recommendation) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: Color(0xFF1976D2)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(recommendation)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Important Disclaimer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'This AI symptom checker is for informational purposes only and should not replace professional medical advice. Always consult with a qualified healthcare provider for proper diagnosis and treatment.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Previous'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(_getNextButtonText()),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _ageController.text.isNotEmpty && !_isLoading;
      case 1:
        return _selectedSymptoms.isNotEmpty && !_isLoading;
      case 2:
        return !_isLoading; // Additional info is optional
      case 3:
        return !_isLoading;
      case 4:
        return false; // Last step
      default:
        return false;
    }
  }

  String _getNextButtonText() {
    switch (_currentStep) {
      case 0:
        return 'Next';
      case 1:
        return 'Next';
      case 2:
        return 'Analyze Symptoms';
      case 3:
        return _isLoading ? 'Analyzing...' : 'Analyze Symptoms';
      case 4:
        return 'Start New Check';
      default:
        return 'Next';
    }
  }

  void _nextStep() async {
    if (_currentStep == 3) {
      await _analyzeSymptoms();
    } else if (_currentStep < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    } else {
      _resetForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    }
  }

Future<void> _analyzeSymptoms() async {
  if (_isLoading) {
    print('⚠️ Analysis already in progress, ignoring duplicate request');
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final analysisResult = await _aiService.analyzeSymptoms(
      symptoms: _selectedSymptoms,
      age: _ageController.text,
      gender: _selectedGender,
      additionalInfo: _additionalInfoController.text.isNotEmpty 
          ? _additionalInfoController.text 
          : null,
    );

    EmergencyLevel emergencyLevel;
    if (analysisResult.needsImmediateAttention) {
      emergencyLevel = EmergencyLevel.high;
    } else if (analysisResult.severity == 'severe') {
      emergencyLevel = EmergencyLevel.moderate;
    } else {
      emergencyLevel = EmergencyLevel.low;
    }

    setState(() {
      _analysisResult = analysisResult;
      _emergencyLevel = emergencyLevel;
      _recommendations = analysisResult.recommendations;
      _isLoading = false;
      _currentStep = 4;  // jump directly to results step
    });

    _pageController.animateToPage(
      4,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error analyzing symptoms: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _selectedSymptoms.clear();
      _ageController.clear();
      _additionalInfoController.clear();
      _selectedGender = 'Male';
      _selectedCategory = 'general';
      _analysisResult = null;
      _emergencyLevel = null;
      _recommendations.clear();
    });
    
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Color _getSeverityColor() {
    switch (_analysisResult?.severity.toLowerCase()) {
      case 'mild':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'severe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
