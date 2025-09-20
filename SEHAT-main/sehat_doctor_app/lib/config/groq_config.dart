import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqConfig {
  // Get API key from environment variables
  static String get apiKey => dotenv.env['GROQ_API_KEY'] ?? '';
  
  // Groq API configuration
  static const String baseUrl = 'https://api.groq.com/openai/v1';
  static const String model = 'llama-3.1-8b-instant';
  
  // Request configuration
  static const int maxTokens = 200; // Very reduced to avoid rate limits
  static const double temperature = 0.7;
  static const Duration timeout = Duration(seconds: 30);
  
  // Validation
  static bool get isApiKeyConfigured => apiKey.isNotEmpty;
  
  static String get maskedApiKey {
    if (apiKey.length <= 8) return '***';
    return '${apiKey.substring(0, 4)}...${apiKey.substring(apiKey.length - 4)}';
  }
}