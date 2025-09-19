import { prescriptionService } from "../services/prescriptionService.js";

class PrescriptionController {
  // Get my prescriptions (Patient)
  async getMyPrescriptions(req, res) {
    try {
      const patientId = req.user.id;
      const { status, page = 1, limit = 10 } = req.query;

      const prescriptions = await prescriptionService.getPatientPrescriptions(patientId, {
        status,
        page: parseInt(page),
        limit: parseInt(limit)
      });

      res.json({
        status: 'success',
        data: prescriptions
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get prescription by ID
  async getPrescriptionById(req, res) {
    try {
      const { id } = req.params;
      const prescription = await prescriptionService.getPrescriptionById(id, req.user);

      res.json({
        status: 'success',
        data: prescription
      });
    } catch (error) {
      res.status(404).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Create prescription (Doctor)
  async createPrescription(req, res) {
    try {
      const { patientId, consultationId, diagnosis, instructions, medicines } = req.body;
      const doctorId = req.user.id;

      const prescription = await prescriptionService.createPrescription({
        patientId,
        doctorId,
        consultationId,
        diagnosis,
        instructions,
        medicines
      });

      res.status(201).json({
        status: 'success',
        message: 'Prescription created successfully',
        data: prescription
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Update prescription (Doctor)
  async updatePrescription(req, res) {
    try {
      const { id } = req.params;
      const updateData = req.body;
      const doctorId = req.user.id;

      const prescription = await prescriptionService.updatePrescription(id, doctorId, updateData);

      res.json({
        status: 'success',
        message: 'Prescription updated successfully',
        data: prescription
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get pharmacy prescriptions (Pharmacy)
  async getPharmacyPrescriptions(req, res) {
    try {
      const pharmacyId = req.user.id;
      const { status, page = 1, limit = 10 } = req.query;

      const prescriptions = await prescriptionService.getPharmacyPrescriptions(pharmacyId, {
        status,
        page: parseInt(page),
        limit: parseInt(limit)
      });

      res.json({
        status: 'success',
        data: prescriptions
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Dispense prescription (Pharmacy)
  async dispensePrescription(req, res) {
    try {
      const { id } = req.params;
      const pharmacyId = req.user.id;

      const prescription = await prescriptionService.dispensePrescription(id, pharmacyId);

      res.json({
        status: 'success',
        message: 'Prescription dispensed successfully',
        data: prescription
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }
}

export const prescriptionController = new PrescriptionController();
