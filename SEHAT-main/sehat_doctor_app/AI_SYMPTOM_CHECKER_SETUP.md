# AI Symptom Checker Setup Guide

This guide will help you set up the AI Symptom Checker feature in your SEHAT Doctor App using the Groq API.

## Prerequisites

1. **Groq API Key**: You need a Groq API key to use this feature.
   - Visit [Groq Console](https://console.groq.com/keys)
   - Sign up or log in to your account
   - Create a new API key

## Setup Instructions

### 1. Configure Groq API Key

1. Open `lib/config/groq_config.dart`
2. Replace `YOUR_GROQ_API_KEY_HERE` with your actual Groq API key:

```dart
static const String apiKey = 'your_actual_groq_api_key_here';
```

### 2. Install Dependencies

Run the following command in your Flutter project directory:

```bash
flutter pub get
```

### 3. Update Dependencies (if needed)

The AI Symptom Checker uses the following dependencies that should already be in your `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.7.0
  # ... other dependencies
```

If you need to add the Groq Dart package specifically, you can add:

```yaml
dependencies:
  groq_dart: ^0.0.1
```

## Features

### AI Symptom Checker

The AI Symptom Checker provides the following features:

1. **Personal Information Collection**
   - Age input
   - Gender selection
   - Basic patient information

2. **Symptom Selection**
   - Categorized symptom selection
   - Multiple symptom categories:
     - General (fever, fatigue, headache, etc.)
     - Respiratory (cough, shortness of breath, etc.)
     - Cardiovascular (chest pain, palpitations, etc.)
     - Digestive (abdominal pain, nausea, etc.)
     - Neurological (headache, dizziness, etc.)
     - Musculoskeletal (joint pain, muscle pain, etc.)
     - Skin (rash, itching, etc.)

3. **AI Analysis**
   - Symptom analysis using Groq's Llama model
   - Emergency level assessment (Low, Moderate, High)
   - Possible conditions identification
   - Severity assessment
   - Health recommendations

4. **Results Display**
   - Emergency alerts for high-priority symptoms
   - Detailed analysis summary
   - Possible conditions list
   - Personalized recommendations
   - Medical disclaimer

## Usage

### Accessing the Feature

1. Open the Patient Dashboard
2. Tap on "AI Symptom Checker" in the Quick Actions section
3. Follow the step-by-step process:
   - Enter personal information
   - Select symptoms from categories
   - Add additional information (optional)
   - Review and analyze symptoms
   - View results and recommendations

### API Integration

The AI service integrates with Groq's API using the following endpoints:

- **Symptom Analysis**: Analyzes symptoms and provides health assessment
- **Emergency Check**: Determines if symptoms require immediate attention
- **Health Recommendations**: Provides personalized health advice

## Configuration

### Groq API Settings

You can modify the following settings in `lib/config/groq_config.dart`:

```dart
class GroqConfig {
  static const String apiKey = 'your_api_key';
  static const String baseUrl = 'https://api.groq.com/openai/v1';
  static const String model = 'llama3-8b-8192';
  static const int maxTokens = 1000;
  static const double temperature = 0.7;
  static const Duration timeout = Duration(seconds: 30);
}
```

### Model Configuration

The default model is `llama3-8b-8192`. You can change this to other available Groq models:

- `llama3-8b-8192` (default)
- `llama3-70b-8192`
- `mixtral-8x7b-32768`

## Error Handling

The AI service includes comprehensive error handling:

- API key validation
- Network error handling
- Timeout handling
- Response parsing errors
- Fallback responses for failed requests

## Security Considerations

1. **API Key Security**: Never commit your API key to version control
2. **Data Privacy**: Patient data is sent to Groq's servers for analysis
3. **Medical Disclaimer**: Always display appropriate medical disclaimers

## Troubleshooting

### Common Issues

1. **API Key Not Configured**
   - Error: "Groq API key is not configured"
   - Solution: Set your API key in `groq_config.dart`

2. **Network Errors**
   - Check internet connection
   - Verify API key is valid
   - Check Groq service status

3. **Timeout Errors**
   - Increase timeout duration in `GroqConfig`
   - Check network stability

### Debug Mode

Enable debug logging by checking the console output when running the app. The AI service logs all API requests and responses.

## Support

For issues related to:

- **Groq API**: Visit [Groq Documentation](https://console.groq.com/docs)
- **Flutter App**: Check the app logs and error messages
- **Feature Implementation**: Review the source code in `lib/services/ai_service.dart`

## Important Notes

⚠️ **Medical Disclaimer**: This AI symptom checker is for informational purposes only and should not replace professional medical advice. Always consult with a qualified healthcare provider for proper diagnosis and treatment.

🔒 **Privacy**: Patient data is processed by Groq's AI models. Ensure compliance with your local data protection regulations.

📱 **Testing**: Test the feature thoroughly before deploying to production, especially the emergency level detection and recommendations.
