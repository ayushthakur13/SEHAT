import { aiService } from "../services/aiService.js";

class AIController {
  // Symptom checker (Patient)
  async symptomChecker(req, res) {
    try {
      const { symptoms, age, gender, language = 'english' } = req.body;
      const result = await aiService.symptomChecker(symptoms, age, gender, language);

      res.json({
        status: 'success',
        data: result
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get health tips (Patient)
  async getHealthTips(req, res) {
    try {
      const { category, language = 'english' } = req.body;
      const tips = await aiService.getHealthTips(category, language);

      res.json({
        status: 'success',
        data: tips
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get common illnesses (Public)
  async getCommonIllnesses(req, res) {
    try {
      const { language = 'english' } = req.query;
      const illnesses = await aiService.getCommonIllnesses(language);

      res.json({
        status: 'success',
        data: illnesses
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }
}

export const aiController = new AIController();
