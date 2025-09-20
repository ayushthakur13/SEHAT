class SymptomCheckerSession {
  final String id;
  final DateTime createdAt;
  final String patientId;
  final List<String> symptoms;
  final String age;
  final String gender;
  final String? additionalInfo;
  final SymptomAnalysisResult? analysisResult;
  final EmergencyLevel? emergencyLevel;
  final List<String>? recommendations;
  final bool isCompleted;

  SymptomCheckerSession({
    required this.id,
    required this.createdAt,
    required this.patientId,
    required this.symptoms,
    required this.age,
    required this.gender,
    this.additionalInfo,
    this.analysisResult,
    this.emergencyLevel,
    this.recommendations,
    this.isCompleted = false,
  });

  SymptomCheckerSession copyWith({
    String? id,
    DateTime? createdAt,
    String? patientId,
    List<String>? symptoms,
    String? age,
    String? gender,
    String? additionalInfo,
    SymptomAnalysisResult? analysisResult,
    EmergencyLevel? emergencyLevel,
    List<String>? recommendations,
    bool? isCompleted,
  }) {
    return SymptomCheckerSession(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      patientId: patientId ?? this.patientId,
      symptoms: symptoms ?? this.symptoms,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      analysisResult: analysisResult ?? this.analysisResult,
      emergencyLevel: emergencyLevel ?? this.emergencyLevel,
      recommendations: recommendations ?? this.recommendations,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'patientId': patientId,
      'symptoms': symptoms,
      'age': age,
      'gender': gender,
      'additionalInfo': additionalInfo,
      'analysisResult': analysisResult?.toJson(),
      'emergencyLevel': emergencyLevel?.name,
      'recommendations': recommendations,
      'isCompleted': isCompleted,
    };
  }

  factory SymptomCheckerSession.fromJson(Map<String, dynamic> json) {
    return SymptomCheckerSession(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      patientId: json['patientId'],
      symptoms: List<String>.from(json['symptoms']),
      age: json['age'],
      gender: json['gender'],
      additionalInfo: json['additionalInfo'],
      analysisResult: json['analysisResult'] != null 
          ? SymptomAnalysisResult.fromJson(json['analysisResult'])
          : null,
      emergencyLevel: json['emergencyLevel'] != null 
          ? EmergencyLevel.values.firstWhere(
              (e) => e.name == json['emergencyLevel'],
              orElse: () => EmergencyLevel.low,
            )
          : null,
      recommendations: json['recommendations'] != null 
          ? List<String>.from(json['recommendations'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class SymptomAnalysisResult {
  final List<String> possibleConditions;
  final String severity;
  final bool needsImmediateAttention;
  final String assessment;
  final List<String> recommendations;

  SymptomAnalysisResult({
    required this.possibleConditions,
    required this.severity,
    required this.needsImmediateAttention,
    required this.assessment,
    required this.recommendations,
  });

  Map<String, dynamic> toJson() {
    return {
      'possibleConditions': possibleConditions,
      'severity': severity,
      'needsImmediateAttention': needsImmediateAttention,
      'assessment': assessment,
      'recommendations': recommendations,
    };
  }

  factory SymptomAnalysisResult.fromJson(Map<String, dynamic> json) {
    return SymptomAnalysisResult(
      possibleConditions: List<String>.from(json['possibleConditions']),
      severity: json['severity'],
      needsImmediateAttention: json['needsImmediateAttention'],
      assessment: json['assessment'],
      recommendations: List<String>.from(json['recommendations']),
    );
  }
}

enum EmergencyLevel {
  low,
  moderate,
  high,
}

extension EmergencyLevelExtension on EmergencyLevel {
  String get displayName {
    switch (this) {
      case EmergencyLevel.low:
        return 'Low';
      case EmergencyLevel.moderate:
        return 'Moderate';
      case EmergencyLevel.high:
        return 'High';
    }
  }

  String get description {
    switch (this) {
      case EmergencyLevel.low:
        return 'Symptoms are mild and can be monitored at home';
      case EmergencyLevel.moderate:
        return 'Symptoms may require medical attention within 24-48 hours';
      case EmergencyLevel.high:
        return 'Symptoms require immediate medical attention';
    }
  }

  String get colorHex {
    switch (this) {
      case EmergencyLevel.low:
        return '0xFF4CAF50'; // Green
      case EmergencyLevel.moderate:
        return '0xFFFF9800'; // Orange
      case EmergencyLevel.high:
        return '0xFFF44336'; // Red
    }
  }
}

class SymptomCategory {
  final String id;
  final String name;
  final String description;
  final List<String> commonSymptoms;
  final String iconName;

  SymptomCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.commonSymptoms,
    required this.iconName,
  });
}

class PredefinedSymptoms {
  static final List<SymptomCategory> categories = [
    SymptomCategory(
      id: 'general',
      name: 'General',
      description: 'General health symptoms',
      iconName: 'medical_services',
      commonSymptoms: [
        'Fever',
        'Fatigue',
        'Headache',
        'Nausea',
        'Dizziness',
        'Weakness',
        'Loss of appetite',
        'Weight loss',
        'Weight gain',
        'Night sweats',
      ],
    ),
    SymptomCategory(
      id: 'respiratory',
      name: 'Respiratory',
      description: 'Breathing and lung related symptoms',
      iconName: 'air',
      commonSymptoms: [
        'Cough',
        'Shortness of breath',
        'Chest pain',
        'Wheezing',
        'Sore throat',
        'Runny nose',
        'Congestion',
        'Sneezing',
        'Hoarseness',
        'Difficulty breathing',
      ],
    ),
    SymptomCategory(
      id: 'cardiovascular',
      name: 'Cardiovascular',
      description: 'Heart and blood vessel related symptoms',
      iconName: 'favorite',
      commonSymptoms: [
        'Chest pain',
        'Palpitations',
        'Shortness of breath',
        'Swelling in legs',
        'Dizziness',
        'Fainting',
        'Irregular heartbeat',
        'High blood pressure',
        'Low blood pressure',
        'Cold hands and feet',
      ],
    ),
    SymptomCategory(
      id: 'digestive',
      name: 'Digestive',
      description: 'Stomach and digestive system symptoms',
      iconName: 'restaurant',
      commonSymptoms: [
        'Abdominal pain',
        'Nausea',
        'Vomiting',
        'Diarrhea',
        'Constipation',
        'Bloating',
        'Heartburn',
        'Indigestion',
        'Loss of appetite',
        'Blood in stool',
      ],
    ),
    SymptomCategory(
      id: 'neurological',
      name: 'Neurological',
      description: 'Brain and nervous system symptoms',
      iconName: 'psychology',
      commonSymptoms: [
        'Headache',
        'Dizziness',
        'Confusion',
        'Memory problems',
        'Seizures',
        'Numbness',
        'Tingling',
        'Muscle weakness',
        'Tremors',
        'Vision problems',
      ],
    ),
    SymptomCategory(
      id: 'musculoskeletal',
      name: 'Musculoskeletal',
      description: 'Muscles, bones, and joints symptoms',
      iconName: 'accessibility',
      commonSymptoms: [
        'Joint pain',
        'Muscle pain',
        'Back pain',
        'Stiffness',
        'Swelling',
        'Limited mobility',
        'Muscle cramps',
        'Bone pain',
        'Tenderness',
        'Weakness',
      ],
    ),
    SymptomCategory(
      id: 'skin',
      name: 'Skin',
      description: 'Skin and hair related symptoms',
      iconName: 'face',
      commonSymptoms: [
        'Rash',
        'Itching',
        'Dry skin',
        'Hair loss',
        'Skin discoloration',
        'Bumps',
        'Blisters',
        'Scaling',
        'Bruising',
        'Swelling',
      ],
    ),
  ];

  static List<String> getAllSymptoms() {
    return categories.expand((category) => category.commonSymptoms).toList();
  }

  static List<String> getSymptomsByCategory(String categoryId) {
    final category = categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => categories.first,
    );
    return category.commonSymptoms;
  }
}
