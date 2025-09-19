class AIService {
  // Simple rule-based symptom checker
  async symptomChecker(symptoms, age, gender, language = 'english') {
    // This is a placeholder for a simple rule-based system
    // In a real implementation, you would have a more sophisticated AI model
    
    const commonConditions = {
      fever: {
        conditions: ['Common Cold', 'Flu', 'Viral Infection'],
        severity: 'moderate',
        advice: 'Rest, stay hydrated, monitor temperature. Consult doctor if fever persists.',
        urgency: 'low'
      },
      headache: {
        conditions: ['Tension Headache', 'Migraine', 'Sinusitis'],
        severity: 'mild',
        advice: 'Rest in a dark room, apply cold compress. Consult doctor if severe.',
        urgency: 'low'
      },
      chest_pain: {
        conditions: ['Heart Condition', 'Muscle Strain', 'Acid Reflux'],
        severity: 'high',
        advice: 'Seek immediate medical attention. This could be serious.',
        urgency: 'high'
      },
      cough: {
        conditions: ['Common Cold', 'Bronchitis', 'Allergies'],
        severity: 'mild',
        advice: 'Stay hydrated, avoid irritants. Consult doctor if persistent.',
        urgency: 'low'
      }
    };

    // Simple matching logic
    const matchedSymptoms = symptoms.filter(symptom => 
      Object.keys(commonConditions).some(key => 
        symptom.toLowerCase().includes(key) || key.includes(symptom.toLowerCase())
      )
    );

    if (matchedSymptoms.length === 0) {
      return {
        possibleConditions: ['General Health Check Recommended'],
        severity: 'unknown',
        advice: 'Please consult a doctor for proper diagnosis.',
        urgency: 'medium',
        recommendations: [
          'Schedule a consultation with a doctor',
          'Monitor symptoms closely',
          'Maintain a healthy lifestyle'
        ]
      };
    }

    const primarySymptom = matchedSymptoms[0];
    const condition = commonConditions[primarySymptom];

    return {
      possibleConditions: condition.conditions,
      severity: condition.severity,
      advice: condition.advice,
      urgency: condition.urgency,
      recommendations: [
        'Monitor symptoms closely',
        'Follow general health guidelines',
        condition.urgency === 'high' ? 'Seek immediate medical attention' : 'Schedule consultation if symptoms persist'
      ]
    };
  }

  // Get health tips based on category
  async getHealthTips(category, language = 'english') {
    const tips = {
      general: [
        'Maintain a balanced diet with fruits and vegetables',
        'Exercise regularly for at least 30 minutes daily',
        'Get 7-8 hours of sleep each night',
        'Stay hydrated by drinking plenty of water',
        'Avoid smoking and excessive alcohol consumption'
      ],
      nutrition: [
        'Include a variety of colorful fruits and vegetables',
        'Choose whole grains over refined grains',
        'Limit processed and sugary foods',
        'Eat lean proteins like fish, chicken, and legumes',
        'Control portion sizes'
      ],
      exercise: [
        'Start with light exercises if you are new to fitness',
        'Include both cardio and strength training',
        'Take breaks during long periods of sitting',
        'Stretch regularly to maintain flexibility',
        'Listen to your body and don\'t overexert'
      ],
      mental_health: [
        'Practice mindfulness and meditation',
        'Maintain social connections',
        'Take breaks from work and technology',
        'Engage in hobbies and activities you enjoy',
        'Seek professional help if needed'
      ]
    };

    return {
      category,
      tips: tips[category] || tips.general,
      language
    };
  }

  // Get common illnesses information
  async getCommonIllnesses(language = 'english') {
    const illnesses = [
      {
        name: 'Common Cold',
        symptoms: ['Runny nose', 'Sneezing', 'Sore throat', 'Cough'],
        prevention: ['Wash hands frequently', 'Avoid close contact with sick people', 'Get adequate rest'],
        treatment: ['Rest', 'Stay hydrated', 'Use saline nasal spray', 'Over-the-counter medications']
      },
      {
        name: 'Fever',
        symptoms: ['High body temperature', 'Chills', 'Sweating', 'Headache'],
        prevention: ['Maintain good hygiene', 'Stay hydrated', 'Get adequate rest'],
        treatment: ['Rest', 'Stay hydrated', 'Use fever-reducing medications', 'Cool compresses']
      },
      {
        name: 'Headache',
        symptoms: ['Pain in head or neck', 'Sensitivity to light', 'Nausea'],
        prevention: ['Maintain regular sleep schedule', 'Stay hydrated', 'Manage stress'],
        treatment: ['Rest in dark room', 'Apply cold compress', 'Over-the-counter pain relievers']
      },
      {
        name: 'Cough',
        symptoms: ['Persistent coughing', 'Throat irritation', 'Chest congestion'],
        prevention: ['Avoid irritants', 'Stay hydrated', 'Maintain good air quality'],
        treatment: ['Stay hydrated', 'Use cough drops', 'Steam inhalation', 'Rest']
      }
    ];

    return {
      illnesses,
      language
    };
  }
}

export const aiService = new AIService();
