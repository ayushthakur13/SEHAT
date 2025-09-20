import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../config/groq_config.dart';
import '../models/symptom_checker.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final Dio _dio = Dio();
  bool _isAnalyzing = false; // Prevent multiple simultaneous requests
  
  // Groq API configuration
  static const String _groqApiKey = GroqConfig.apiKey;
  static const String _groqBaseUrl = GroqConfig.baseUrl;
  static const String _groqModel = GroqConfig.model;

  void initialize() {
    if (!GroqConfig.isApiKeyConfigured) {
      throw Exception('Groq API key is not configured. Please set your API key in GroqConfig.');
    }
    
    _dio.options.baseUrl = _groqBaseUrl;
    _dio.options.connectTimeout = GroqConfig.timeout;
    _dio.options.receiveTimeout = GroqConfig.timeout;
    _dio.options.headers = {
      'Authorization': 'Bearer $_groqApiKey',
      'Content-Type': 'application/json',
    };

    // Add error interceptor for better debugging
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        print('🚨 Groq API Error:');
        print('🚨 Status Code: ${error.response?.statusCode}');
        print('🚨 Response Data: ${error.response?.data}');
        print('🚨 Request Data: ${error.requestOptions.data}');
        print('🚨 Request Headers: ${error.requestOptions.headers}');
        handler.next(error);
      },
    ));
  }

  /// Analyze symptoms and provide preliminary health assessment
  Future<SymptomAnalysisResult> analyzeSymptoms({
    required List<String> symptoms,
    required String age,
    required String gender,
    String? additionalInfo,
  }) async {
    // Prevent multiple simultaneous requests
    if (_isAnalyzing) {
      throw Exception('Analysis already in progress');
    }

    _isAnalyzing = true;
    
    try {
      final prompt = _buildSymptomAnalysisPrompt(
        symptoms: symptoms,
        age: age,
        gender: gender,
        additionalInfo: additionalInfo,
      );

      print('🔍 Making API request for symptom analysis...');

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': _groqModel,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful medical AI assistant. Provide preliminary health assessments based on symptoms. Always emphasize that this is not a substitute for professional medical advice and recommend consulting a healthcare provider.',
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': GroqConfig.temperature,
          'max_tokens': GroqConfig.maxTokens,
          'stream': false,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final content = data['choices'][0]['message']['content'];
        print('✅ API analysis completed successfully');
        return _parseSymptomAnalysisResponse(content);
      } else {
        throw Exception('Failed to analyze symptoms: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API failed: $e');
      rethrow;
    } finally {
      _isAnalyzing = false;
    }
  }

  // Removed separate API methods to prevent multiple requests
  // All analysis is now done in a single analyzeSymptoms call

  String _buildSymptomAnalysisPrompt({
    required List<String> symptoms,
    required String age,
    required String gender,
    String? additionalInfo,
  }) {
    final symptomsText = symptoms.join(', ');
    final additionalInfoText = additionalInfo != null ? '\nAdditional Information: $additionalInfo' : '';
    
    return '''
Analyze these symptoms and provide a health assessment:

Patient: $age year old $gender
Symptoms: $symptomsText$additionalInfoText

Please provide:
1. Possible conditions
2. Severity level (mild/moderate/severe)
3. If immediate medical attention is needed (yes/no)
4. Health recommendations

Format as JSON:
{
  "possibleConditions": ["condition1", "condition2"],
  "severity": "mild",
  "needsImmediateAttention": false,
  "assessment": "brief assessment",
  "recommendations": ["recommendation1", "recommendation2"]
}

This is not medical advice. Consult a healthcare provider.
''';
  }

  // Removed unused prompt methods to simplify the service

  SymptomAnalysisResult _parseSymptomAnalysisResponse(String content) {
    try {
      // Try to extract JSON from the response
      final jsonStart = content.indexOf('{');
      final jsonEnd = content.lastIndexOf('}') + 1;
      
      if (jsonStart != -1 && jsonEnd > jsonStart) {
        final jsonString = content.substring(jsonStart, jsonEnd);
        print('🔍 Parsing JSON: $jsonString');
        final jsonData = json.decode(jsonString);
        
        return SymptomAnalysisResult(
          possibleConditions: List<String>.from(jsonData['possibleConditions'] ?? []),
          severity: jsonData['severity'] ?? 'moderate',
          needsImmediateAttention: jsonData['needsImmediateAttention'] ?? false,
          assessment: jsonData['assessment'] ?? content,
          recommendations: List<String>.from(jsonData['recommendations'] ?? []),
        );
      }
    } catch (e) {
      print('❌ JSON parsing error: $e');
      print('❌ Content: $content');
    }
    
    // Fallback parsing - extract information from text
    final lines = content.split('\n');
    final possibleConditions = <String>[];
    String severity = 'moderate';
    bool needsImmediateAttention = false;
    final recommendations = <String>[];
    
    for (final line in lines) {
      final lowerLine = line.toLowerCase();
      if (lowerLine.contains('condition') || lowerLine.contains('could be')) {
        possibleConditions.add(line.trim());
      } else if (lowerLine.contains('mild')) {
        severity = 'mild';
      } else if (lowerLine.contains('severe')) {
        severity = 'severe';
      } else if (lowerLine.contains('emergency') || lowerLine.contains('immediate')) {
        needsImmediateAttention = true;
      } else if (lowerLine.contains('recommend') || lowerLine.contains('advice')) {
        recommendations.add(line.trim());
      }
    }
    
    return SymptomAnalysisResult(
      possibleConditions: possibleConditions.isNotEmpty ? possibleConditions : ['General health concern'],
      severity: severity,
      needsImmediateAttention: needsImmediateAttention,
      assessment: content,
      recommendations: recommendations.isNotEmpty ? recommendations : ['Consult a healthcare provider for proper diagnosis'],
    );
  }

  // Removed unused parsing methods

  EmergencyLevel _parseEmergencyLevel(String content) {
    if (content.contains('HIGH')) {
      return EmergencyLevel.high;
    } else if (content.contains('MODERATE')) {
      return EmergencyLevel.moderate;
    } else {
      return EmergencyLevel.low;
    }
  }

  // Removed retry logic and fallback methods - using direct API calls only
}

