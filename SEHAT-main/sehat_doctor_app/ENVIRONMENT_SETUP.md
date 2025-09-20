# Environment Setup

This document explains how to set up environment variables for the SEHAT Healthcare Platform.

## Required Environment Variables

### 1. Groq API Key
- **Variable**: `GROQ_API_KEY`
- **Description**: API key for Groq AI service used in symptom checker
- **How to get**: Visit [Groq Console](https://console.groq.com/keys) and create a new API key

## Setup Instructions

### 1. Copy Environment Template
```bash
cp .env.example .env
```

### 2. Edit .env File
Open the `.env` file and add your actual API keys:

```env
# Groq API Configuration
GROQ_API_KEY=your_actual_groq_api_key_here

# Add other environment variables here as needed
# BACKEND_URL=http://localhost:5000
```

### 3. Security Notes
- **Never commit the `.env` file** to version control
- The `.env` file is already added to `.gitignore`
- Use `.env.example` as a template for other developers
- Keep your API keys secure and don't share them

### 4. Running the App
After setting up the environment variables, run the app normally:

```bash
flutter run
```

The app will automatically load the environment variables from the `.env` file.

## Troubleshooting

### API Key Not Working
1. Verify the API key is correct in the `.env` file
2. Check that the `.env` file is in the root directory of the Flutter project
3. Ensure there are no extra spaces or quotes around the API key
4. Restart the app after making changes to the `.env` file

### Environment Variables Not Loading
1. Make sure `flutter_dotenv` is added to `pubspec.yaml`
2. Verify the `.env` file is listed in the `assets` section of `pubspec.yaml`
3. Check that `dotenv.load()` is called in `main.dart` before running the app
