import { consultationService } from "../services/consultationService.js";

class ConsultationController {
  // Book consultation (Patient)
  async bookConsultation(req, res) {
    try {
      const { doctorId, appointmentDate, startTime, consultationType, symptoms } = req.body;
      const patientId = req.user.id;

      const consultation = await consultationService.bookConsultation({
        patientId,
        doctorId,
        appointmentDate,
        startTime,
        consultationType,
        symptoms
      });

      res.status(201).json({
        status: 'success',
        message: 'Consultation booked successfully',
        data: consultation
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get my consultations (Patient)
  async getMyConsultations(req, res) {
    try {
      const patientId = req.user.id;
      const { status, page = 1, limit = 10 } = req.query;

      const consultations = await consultationService.getPatientConsultations(patientId, {
        status,
        page: parseInt(page),
        limit: parseInt(limit)
      });

      res.json({
        status: 'success',
        data: consultations
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get doctor consultations (Doctor)
  async getDoctorConsultations(req, res) {
    try {
      const doctorId = req.user.id;
      const { status, date, page = 1, limit = 10 } = req.query;

      const consultations = await consultationService.getDoctorConsultations(doctorId, {
        status,
        date,
        page: parseInt(page),
        limit: parseInt(limit)
      });

      res.json({
        status: 'success',
        data: consultations
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get consultation by ID
  async getConsultationById(req, res) {
    try {
      const { id } = req.params;
      const consultation = await consultationService.getConsultationById(id, req.user);

      res.json({
        status: 'success',
        data: consultation
      });
    } catch (error) {
      res.status(404).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Update consultation status (Doctor)
  async updateConsultationStatus(req, res) {
    try {
      const { id } = req.params;
      const { status, notes, diagnosis } = req.body;
      const doctorId = req.user.id;

      const consultation = await consultationService.updateConsultationStatus(id, doctorId, {
        status,
        notes,
        diagnosis
      });

      res.json({
        status: 'success',
        message: 'Consultation status updated successfully',
        data: consultation
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Update consultation notes (Doctor)
  async updateConsultationNotes(req, res) {
    try {
      const { id } = req.params;
      const { notes } = req.body;
      const doctorId = req.user.id;

      const consultation = await consultationService.updateConsultationNotes(id, doctorId, notes);

      res.json({
        status: 'success',
        message: 'Consultation notes updated successfully',
        data: consultation
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Start consultation (Doctor)
  async startConsultation(req, res) {
    try {
      const { id } = req.params;
      const doctorId = req.user.id;

      const consultation = await consultationService.startConsultation(id, doctorId);

      res.json({
        status: 'success',
        message: 'Consultation started successfully',
        data: consultation
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // End consultation (Doctor)
  async endConsultation(req, res) {
    try {
      const { id } = req.params;
      const { notes, diagnosis } = req.body;
      const doctorId = req.user.id;

      const consultation = await consultationService.endConsultation(id, doctorId, {
        notes,
        diagnosis
      });

      res.json({
        status: 'success',
        message: 'Consultation ended successfully',
        data: consultation
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }
}

export const consultationController = new ConsultationController();
