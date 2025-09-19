import { Consultation, Patient, Doctor, Prescription } from "../models/index.js";

class ConsultationService {
  async bookConsultation({ patientId, doctorId, appointmentDate, startTime, consultationType, symptoms }) {
    // Check if doctor exists and is available
    const doctor = await Doctor.findByPk(doctorId);
    if (!doctor || !doctor.isAvailable) {
      throw new Error('Doctor not available');
    }

    // Create consultation
    const consultation = await Consultation.create({
      patientId,
      doctorId,
      appointmentDate: new Date(appointmentDate),
      startTime,
      consultationType,
      symptoms,
      status: 'scheduled'
    });

    // Load related data
    const consultationWithDetails = await Consultation.findByPk(consultation.id, {
      include: [
        { model: Patient, as: 'patient', attributes: ['id', 'name', 'phone'] },
        { model: Doctor, as: 'doctor', attributes: ['id', 'name', 'specialization'] }
      ]
    });

    return consultationWithDetails;
  }

  async getPatientConsultations(patientId, filters = {}) {
    const whereClause = { patientId };
    
    if (filters.status) {
      whereClause.status = filters.status;
    }

    const consultations = await Consultation.findAll({
      where: whereClause,
      include: [
        { model: Doctor, as: 'doctor', attributes: ['id', 'name', 'specialization'] }
      ],
      order: [['appointmentDate', 'DESC']],
      limit: filters.limit || 10,
      offset: ((filters.page || 1) - 1) * (filters.limit || 10)
    });

    return consultations;
  }

  async getDoctorConsultations(doctorId, filters = {}) {
    const whereClause = { doctorId };
    
    if (filters.status) {
      whereClause.status = filters.status;
    }

    if (filters.date) {
      whereClause.appointmentDate = new Date(filters.date);
    }

    const consultations = await Consultation.findAll({
      where: whereClause,
      include: [
        { model: Patient, as: 'patient', attributes: ['id', 'name', 'phone'] }
      ],
      order: [['appointmentDate', 'ASC'], ['startTime', 'ASC']],
      limit: filters.limit || 10,
      offset: ((filters.page || 1) - 1) * (filters.limit || 10)
    });

    return consultations;
  }

  async getConsultationById(consultationId, user) {
    const consultation = await Consultation.findByPk(consultationId, {
      include: [
        { model: Patient, as: 'patient' },
        { model: Doctor, as: 'doctor' }
      ]
    });

    if (!consultation) {
      throw new Error('Consultation not found');
    }

    // Check if user has access to this consultation
    if (user.userType === 'patient' && consultation.patientId !== user.id) {
      throw new Error('Access denied');
    }
    if (user.userType === 'doctor' && consultation.doctorId !== user.id) {
      throw new Error('Access denied');
    }

    return consultation;
  }

  async updateConsultationStatus(consultationId, doctorId, updateData) {
    const consultation = await Consultation.findOne({
      where: { id: consultationId, doctorId }
    });

    if (!consultation) {
      throw new Error('Consultation not found or unauthorized');
    }

    await consultation.update(updateData);

    return await Consultation.findByPk(consultationId, {
      include: [
        { model: Patient, as: 'patient', attributes: ['id', 'name', 'phone'] },
        { model: Doctor, as: 'doctor', attributes: ['id', 'name', 'specialization'] }
      ]
    });
  }

  async updateConsultationNotes(consultationId, doctorId, notes) {
    const consultation = await Consultation.findOne({
      where: { id: consultationId, doctorId }
    });

    if (!consultation) {
      throw new Error('Consultation not found or unauthorized');
    }

    await consultation.update({ notes });

    return consultation;
  }

  async startConsultation(consultationId, doctorId) {
    const consultation = await Consultation.findOne({
      where: { id: consultationId, doctorId }
    });

    if (!consultation) {
      throw new Error('Consultation not found or unauthorized');
    }

    if (consultation.status !== 'scheduled') {
      throw new Error('Consultation cannot be started');
    }

    await consultation.update({
      status: 'in_progress',
      startTime: new Date()
    });

    return consultation;
  }

  async endConsultation(consultationId, doctorId, { notes, diagnosis }) {
    const consultation = await Consultation.findOne({
      where: { id: consultationId, doctorId }
    });

    if (!consultation) {
      throw new Error('Consultation not found or unauthorized');
    }

    if (consultation.status !== 'in_progress') {
      throw new Error('Consultation is not in progress');
    }

    await consultation.update({
      status: 'completed',
      endTime: new Date(),
      notes,
      diagnosis
    });

    return consultation;
  }
}

export const consultationService = new ConsultationService();
