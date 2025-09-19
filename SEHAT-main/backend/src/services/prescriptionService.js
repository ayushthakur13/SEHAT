import { Prescription, Patient, Doctor, Pharmacy, Medicine, PrescriptionMedicine } from "../models/index.js";

class PrescriptionService {
  async getPatientPrescriptions(patientId, filters = {}) {
    const whereClause = { patientId };
    
    if (filters.status) {
      whereClause.status = filters.status;
    }

    const prescriptions = await Prescription.findAll({
      where: whereClause,
      include: [
        { model: Doctor, as: 'doctor', attributes: ['id', 'name', 'specialization'] },
        { model: Pharmacy, as: 'pharmacy', attributes: ['id', 'name', 'address'] },
        { model: Medicine, as: 'medicines', through: { attributes: ['quantity', 'dosage', 'frequency', 'instructions'] } }
      ],
      order: [['createdAt', 'DESC']],
      limit: filters.limit || 10,
      offset: ((filters.page || 1) - 1) * (filters.limit || 10)
    });

    return prescriptions;
  }

  async getPrescriptionById(prescriptionId, user) {
    const prescription = await Prescription.findByPk(prescriptionId, {
      include: [
        { model: Patient, as: 'patient' },
        { model: Doctor, as: 'doctor' },
        { model: Pharmacy, as: 'pharmacy' },
        { model: Medicine, as: 'medicines', through: { attributes: ['quantity', 'dosage', 'frequency', 'instructions'] } }
      ]
    });

    if (!prescription) {
      throw new Error('Prescription not found');
    }

    // Check access permissions
    if (user.userType === 'patient' && prescription.patientId !== user.id) {
      throw new Error('Access denied');
    }
    if (user.userType === 'doctor' && prescription.doctorId !== user.id) {
      throw new Error('Access denied');
    }
    if (user.userType === 'pharmacy' && prescription.pharmacyId !== user.id) {
      throw new Error('Access denied');
    }

    return prescription;
  }

  async createPrescription({ patientId, doctorId, consultationId, diagnosis, instructions, medicines }) {
    // Generate prescription number
    const prescriptionNumber = `RX${Date.now()}${Math.random().toString(36).substr(2, 5).toUpperCase()}`;

    const prescription = await Prescription.create({
      patientId,
      doctorId,
      consultationId,
      prescriptionNumber,
      diagnosis,
      instructions
    });

    // Add medicines to prescription
    if (medicines && medicines.length > 0) {
      for (const medicine of medicines) {
        await PrescriptionMedicine.create({
          prescriptionId: prescription.id,
          medicineId: medicine.medicineId,
          quantity: medicine.quantity,
          dosage: medicine.dosage,
          frequency: medicine.frequency,
          duration: medicine.duration,
          instructions: medicine.instructions
        });
      }
    }

    return await Prescription.findByPk(prescription.id, {
      include: [
        { model: Patient, as: 'patient', attributes: ['id', 'name', 'phone'] },
        { model: Doctor, as: 'doctor', attributes: ['id', 'name', 'specialization'] },
        { model: Medicine, as: 'medicines', through: { attributes: ['quantity', 'dosage', 'frequency', 'instructions'] } }
      ]
    });
  }

  async updatePrescription(prescriptionId, doctorId, updateData) {
    const prescription = await Prescription.findOne({
      where: { id: prescriptionId, doctorId }
    });

    if (!prescription) {
      throw new Error('Prescription not found or unauthorized');
    }

    await prescription.update(updateData);
    return prescription;
  }

  async getPharmacyPrescriptions(pharmacyId, filters = {}) {
    const whereClause = { pharmacyId };
    
    if (filters.status) {
      whereClause.status = filters.status;
    }

    const prescriptions = await Prescription.findAll({
      where: whereClause,
      include: [
        { model: Patient, as: 'patient', attributes: ['id', 'name', 'phone'] },
        { model: Doctor, as: 'doctor', attributes: ['id', 'name', 'specialization'] },
        { model: Medicine, as: 'medicines', through: { attributes: ['quantity', 'dosage', 'frequency', 'instructions'] } }
      ],
      order: [['createdAt', 'DESC']],
      limit: filters.limit || 10,
      offset: ((filters.page || 1) - 1) * (filters.limit || 10)
    });

    return prescriptions;
  }

  async dispensePrescription(prescriptionId, pharmacyId) {
    const prescription = await Prescription.findOne({
      where: { id: prescriptionId, pharmacyId }
    });

    if (!prescription) {
      throw new Error('Prescription not found or unauthorized');
    }

    if (prescription.status !== 'pending') {
      throw new Error('Prescription cannot be dispensed');
    }

    await prescription.update({
      status: 'dispensed',
      dispensedAt: new Date()
    });

    return prescription;
  }
}

export const prescriptionService = new PrescriptionService();
