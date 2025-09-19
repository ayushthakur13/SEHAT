import { Doctor, Consultation, Prescription, Patient, User, HealthRecord, Medicine, PrescriptionMedicine, DoctorNotification, sequelize } from "../models/index.js";
import { Op } from "sequelize";

class DoctorService {
  // ========== PROFILE & DASHBOARD ========== //
  
  async getDoctorProfile(doctorId) {
    const doctor = await Doctor.findByPk(doctorId, {
      attributes: { exclude: ["password"] },
      include: [{
        model: User,
        as: 'user',
        attributes: ['name', 'phone', 'email', 'preferredLanguage']
      }]
    });
    
    if (!doctor) {
      throw new Error("Doctor not found");
    }
    
    return doctor;
  }

  async getDoctorDashboard(doctorId) {
    const doctor = await this.getDoctorProfile(doctorId);
    
    // Get today's appointments
    const today = new Date();
    const todayStart = new Date(today.setHours(0, 0, 0, 0));
    const todayEnd = new Date(today.setHours(23, 59, 59, 999));
    
    const todayAppointments = await Consultation.findAll({
      where: {
        doctorId,
        appointmentDate: {
          [Op.between]: [todayStart, todayEnd]
        }
      },
      include: [{
        model: Patient,
        as: 'patient',
        include: [{
          model: User,
          as: 'user',
          attributes: ['name', 'phone', 'preferredLanguage']
        }]
      }],
      order: [['startTime', 'ASC']]
    });
    
    // Get consultation statistics
    const stats = await this.getDoctorStats(doctorId);
    
    return {
      doctor,
      todayAppointments,
      stats,
      currentStatus: doctor.currentStatus,
      isAvailable: doctor.isAvailable
    };
  }

  async getDoctorStats(doctorId) {
    const today = new Date();
    const thisMonth = new Date(today.getFullYear(), today.getMonth(), 1);
    
    // Get various statistics
    const totalConsultations = await Consultation.count({ where: { doctorId } });
    const monthlyConsultations = await Consultation.count({
      where: {
        doctorId,
        createdAt: { [Op.gte]: thisMonth }
      }
    });
    
    const pendingConsultations = await Consultation.count({
      where: {
        doctorId,
        status: 'scheduled'
      }
    });
    
    const completedToday = await Consultation.count({
      where: {
        doctorId,
        status: 'completed',
        updatedAt: {
          [Op.gte]: new Date(today.setHours(0, 0, 0, 0))
        }
      }
    });
    
    return {
      totalConsultations,
      monthlyConsultations,
      pendingConsultations,
      completedToday
    };
  }

  async updateDoctorProfile(doctorId, updateData) {
    const doctor = await Doctor.findByPk(doctorId);
    
    if (!doctor) {
      throw new Error("Doctor not found");
    }
    
    // Update allowed fields
    const allowedFields = [
      'specialization', 'experience', 'consultationFee', 'languages', 
      'workingHours', 'isAvailable', 'availabilitySchedule', 
      'maxConcurrentConsultations', 'preferredConsultationType',
      'lowBandwidthMode', 'offlineCapable'
    ];
    
    const filteredData = {};
    allowedFields.forEach(field => {
      if (updateData[field] !== undefined) {
        filteredData[field] = updateData[field];
      }
    });
    
    await doctor.update(filteredData);
    return await this.getDoctorProfile(doctorId);
  }

  // ========== AVAILABILITY MANAGEMENT ========== //
  
  async updateAvailability(doctorId, availabilityData) {
    const { status, schedule, workingHours } = availabilityData;
    
    const doctor = await Doctor.findByPk(doctorId);
    if (!doctor) {
      throw new Error("Doctor not found");
    }
    
    const updateFields = {};
    if (status) updateFields.currentStatus = status;
    if (schedule) updateFields.availabilitySchedule = schedule;
    if (workingHours) updateFields.workingHours = workingHours;
    
    await doctor.update(updateFields);
    return { message: "Availability updated successfully", doctor };
  }

  // ========== APPOINTMENT MANAGEMENT ========== //
  
  async getDoctorAppointments(doctorId, queryParams = {}) {
    const { status, date, limit = 20, offset = 0, type } = queryParams;
    
    const whereClause = { doctorId };
    
    if (status) whereClause.status = status;
    if (type) whereClause.consultationType = type;

    if (date) {
      const startDate = new Date(date);
      const endDate = new Date(date);
      endDate.setHours(23, 59, 59, 999);
      
      whereClause.appointmentDate = {
        [Op.between]: [startDate, endDate]
      };
    }
    
    const consultations = await Consultation.findAndCountAll({
      where: whereClause,
      include: [{
        model: Patient,
        as: 'patient',
        include: [{
          model: User,
          as: 'user',
          attributes: ['name', 'phone', 'preferredLanguage', 'gender', 'dateOfBirth']
        }]
      }, {
        model: Prescription,
        as: 'prescription',
        required: false
      }],
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['appointmentDate', 'DESC'], ['startTime', 'DESC']]
    });
    
    return {
      consultations: consultations.rows,
      total: consultations.count,
      totalPages: Math.ceil(consultations.count / limit),
      currentPage: Math.floor(offset / limit) + 1
    };
  }

  async updateAppointmentStatus(appointmentId, doctorId, updateData) {
    const consultation = await Consultation.findOne({
      where: { id: appointmentId, doctorId }
    });
    
    if (!consultation) {
      throw new Error("Consultation not found or access denied");
    }
    
    // Update consultation
    const allowedFields = ['status', 'notes', 'diagnosis', 'endTime'];
    const filteredData = {};
    
    allowedFields.forEach(field => {
      if (updateData[field] !== undefined) {
        filteredData[field] = updateData[field];
      }
    });
    
    // Set end time if completing consultation
    if (updateData.status === 'completed' && !filteredData.endTime) {
      filteredData.endTime = new Date().toTimeString().slice(0, 8);
    }
    
    await consultation.update(filteredData);
    
    // Update doctor's total consultations if completed
    if (updateData.status === 'completed') {
      await Doctor.increment('totalConsultations', { where: { id: doctorId } });
    }
    
    return consultation;
  }

  // ========== CONSULTATION MANAGEMENT ========== //
  
  async createConsultation(doctorId, consultationData) {
    const {
      patientId, appointmentDate, startTime, endTime, 
      consultationType, symptoms, preferredLanguage = 'english'
    } = consultationData;
    
    // Verify doctor exists and is available
    const doctor = await Doctor.findByPk(doctorId);
    if (!doctor || !doctor.isAvailable) {
      throw new Error("Doctor not available");
    }
    
    // Create consultation
    const consultation = await Consultation.create({
      patientId,
      doctorId,
      appointmentDate,
      startTime,
      endTime,
      consultationType,
      symptoms,
      status: 'scheduled'
    });
    
    return consultation;
  }

  async joinConsultation(consultationId, doctorId) {
    const consultation = await Consultation.findOne({
      where: { id: consultationId, doctorId },
      include: [{
        model: Patient,
        as: 'patient',
        include: [{
          model: User,
          as: 'user',
          attributes: ['name', 'preferredLanguage']
        }]
      }]
    });
    
    if (!consultation) {
      throw new Error("Consultation not found or access denied");
    }
    
    // Update status to in_progress
    await consultation.update({ status: 'in_progress' });
    await Doctor.update({ currentStatus: 'in_consultation' }, { where: { id: doctorId } });
    
    // Generate meeting URL (placeholder for video service integration)
    const meetingUrl = `https://meet.sehat.com/room/${consultationId}`;
    await consultation.update({ meetingUrl });
    
    return {
      consultation,
      meetingUrl,
      patientLanguage: consultation.patient?.user?.preferredLanguage || 'english'
    };
  }

  // ========== PATIENT HEALTH RECORDS ========== //
  
  async getPatientHealthRecords(patientId, doctorId) {
    // Verify doctor has permission (has had consultation with patient)
    const hasConsultation = await Consultation.findOne({
      where: { patientId, doctorId }
    });
    
    if (!hasConsultation) {
      throw new Error("Access denied. No consultation history with this patient.");
    }
    
    // Get patient's complete health records
    const healthRecords = await HealthRecord.findAll({
      where: { patientId },
      include: [{
        model: Doctor,
        as: 'doctor',
        include: [{
          model: User,
          as: 'user',
          attributes: ['name']
        }]
      }],
      order: [['createdAt', 'DESC']]
    });
    
    // Get past consultations
    const pastConsultations = await Consultation.findAll({
      where: { patientId },
      include: [{
        model: Doctor,
        as: 'doctor',
        include: [{
          model: User,
          as: 'user',
          attributes: ['name']
        }]
      }, {
        model: Prescription,
        as: 'prescription',
        include: [{
          model: Medicine,
          as: 'medicines'
        }]
      }],
      order: [['appointmentDate', 'DESC']]
    });
    
    // Get patient info
    const patient = await Patient.findByPk(patientId, {
      include: [{
        model: User,
        as: 'user',
        attributes: ['name', 'phone', 'preferredLanguage', 'gender', 'dateOfBirth']
      }]
    });
    
    return {
      patient,
      healthRecords,
      pastConsultations,
      totalConsultations: pastConsultations.length
    };
  }

  async createHealthRecord(doctorId, healthRecordData) {
    const { patientId, recordType, data, notes } = healthRecordData;
    
    const healthRecord = await HealthRecord.create({
      patientId,
      doctorId,
      recordType,
      data,
      notes,
      isOffline: false,
      syncStatus: 'synced'
    });
    
    return healthRecord;
  }

  // ========== PRESCRIPTION MANAGEMENT ========== //
  
  async createPrescription(doctorId, prescriptionData) {
    const {
      patientId, consultationId, medicines, instructions, 
      language = 'english', validUntil, diagnosis
    } = prescriptionData;

    // Generate prescription number
    const prescriptionNumber = `RX${Date.now()}${Math.random().toString(36).substr(2, 5).toUpperCase()}`;

    // Create prescription
    const prescription = await Prescription.create({
      patientId,
      doctorId,
      consultationId,
      prescriptionNumber,
      diagnosis,
      instructions,
      language,
      validUntil,
      isOffline: false,
      syncStatus: 'synced'
    });
    
    // Add medicines to prescription
    if (medicines && medicines.length > 0) {
      const prescriptionMedicines = medicines.map(med => ({
        prescriptionId: prescription.id,
        medicineId: med.medicineId,
        dosage: med.dosage,
        frequency: med.frequency,
        duration: med.duration,
        instructions: med.instructions
      }));
      
      await PrescriptionMedicine.bulkCreate(prescriptionMedicines);
    }
    
    // Update consultation with prescription
    if (consultationId) {
      await Consultation.update(
        { prescriptionId: prescription.id },
        { where: { id: consultationId } }
      );
    }
    
    return prescription;
  }

  // ========== OFFLINE SYNC ========== //
  
  async syncOfflineData(doctorId, offlineData) {
    const { consultations = [], prescriptions = [], healthRecords = [] } = offlineData;
    
    const syncResults = {
      consultations: { success: 0, failed: 0 },
      prescriptions: { success: 0, failed: 0 },
      healthRecords: { success: 0, failed: 0 }
    };
    
    // Sync consultations
    for (const consultation of consultations) {
      try {
        await Consultation.create({ ...consultation, doctorId, syncStatus: 'synced' });
        syncResults.consultations.success++;
      } catch (error) {
        syncResults.consultations.failed++;
      }
    }
    
    // Sync prescriptions
    for (const prescription of prescriptions) {
      try {
        await Prescription.create({ ...prescription, doctorId, syncStatus: 'synced' });
        syncResults.prescriptions.success++;
      } catch (error) {
        syncResults.prescriptions.failed++;
      }
    }
    
    // Sync health records
    for (const record of healthRecords) {
      try {
        await HealthRecord.create({ ...record, doctorId, syncStatus: 'synced' });
        syncResults.healthRecords.success++;
      } catch (error) {
        syncResults.healthRecords.failed++;
      }
    }
    
    // Update doctor's last sync time
    await Doctor.update(
      { lastSyncAt: new Date() },
      { where: { id: doctorId } }
    );
    
    return syncResults;
  }

  async getUnsyncedData(doctorId) {
    const unsyncedConsultations = await Consultation.findAll({
      where: {
        doctorId,
        syncStatus: 'pending'
      }
    });
    
    const unsyncedPrescriptions = await Prescription.findAll({
      where: {
        doctorId,
        syncStatus: 'pending'
      }
    });
    
    const unsyncedHealthRecords = await HealthRecord.findAll({
      where: {
        doctorId,
        syncStatus: 'pending'
      }
    });
    
    return {
      consultations: unsyncedConsultations,
      prescriptions: unsyncedPrescriptions,
      healthRecords: unsyncedHealthRecords,
      totalCount: unsyncedConsultations.length + unsyncedPrescriptions.length + unsyncedHealthRecords.length
    };
  }

  // ========== DOCTOR ANALYTICS & REPORTS ========== //
  
  async getDoctorAnalytics(doctorId, timeRange = '30d') {
    const today = new Date();
    let startDate;
    
    switch(timeRange) {
      case '7d':
        startDate = new Date(today.getTime() - (7 * 24 * 60 * 60 * 1000));
        break;
      case '30d':
        startDate = new Date(today.getTime() - (30 * 24 * 60 * 60 * 1000));
        break;
      case '90d':
        startDate = new Date(today.getTime() - (90 * 24 * 60 * 60 * 1000));
        break;
      case '1y':
        startDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
        break;
      default:
        startDate = new Date(today.getTime() - (30 * 24 * 60 * 60 * 1000));
    }
    
    // Get consultation analytics
    const consultationStats = await Consultation.findAll({
      where: {
        doctorId,
        createdAt: { [Op.gte]: startDate }
      },
      attributes: [
        'status',
        'consultationType',
        [sequelize.fn('COUNT', sequelize.col('id')), 'count']
      ],
      group: ['status', 'consultationType']
    });
    
    // Patient demographics
    const patientDemographics = await Consultation.findAll({
      where: {
        doctorId,
        createdAt: { [Op.gte]: startDate }
      },
      include: [{
        model: Patient,
        as: 'patient',
        include: [{
          model: User,
          as: 'user',
          attributes: ['gender', 'preferredLanguage']
        }]
      }],
      attributes: ['id']
    });
    
    // Revenue analytics (if consultation fees are tracked)
    const revenueStats = await this.calculateRevenue(doctorId, startDate);
    
    // Consultation type breakdown
    const consultationTypeBreakdown = await this.getConsultationTypeBreakdown(doctorId, startDate);
    
    // Rating and feedback summary
    const ratingStats = await this.getRatingStats(doctorId, startDate);
    
    return {
      timeRange,
      consultationStats: this.processConsultationStats(consultationStats),
      patientDemographics: this.processPatientDemographics(patientDemographics),
      revenueStats,
      consultationTypeBreakdown,
      ratingStats
    };
  }
  
  async calculateRevenue(doctorId, startDate) {
    const doctor = await Doctor.findByPk(doctorId);
    if (!doctor || !doctor.consultationFee) {
      return { totalRevenue: 0, totalConsultations: 0, averagePerConsultation: 0 };
    }
    
    const completedConsultations = await Consultation.count({
      where: {
        doctorId,
        status: 'completed',
        createdAt: { [Op.gte]: startDate }
      }
    });
    
    const totalRevenue = completedConsultations * parseFloat(doctor.consultationFee);
    
    return {
      totalRevenue,
      totalConsultations: completedConsultations,
      averagePerConsultation: parseFloat(doctor.consultationFee)
    };
  }
  
  async getConsultationTypeBreakdown(doctorId, startDate) {
    const breakdown = await Consultation.findAll({
      where: {
        doctorId,
        createdAt: { [Op.gte]: startDate }
      },
      attributes: [
        'consultationType',
        [sequelize.fn('COUNT', sequelize.col('id')), 'count']
      ],
      group: ['consultationType']
    });
    
    return breakdown.map(item => ({
      type: item.consultationType,
      count: parseInt(item.dataValues.count)
    }));
  }
  
  async getRatingStats(doctorId, startDate) {
    // This would integrate with a rating system
    // For now, return placeholder data
    const doctor = await Doctor.findByPk(doctorId);
    return {
      averageRating: doctor.rating || 0,
      totalRatings: 0,
      ratingBreakdown: {
        5: 0, 4: 0, 3: 0, 2: 0, 1: 0
      }
    };
  }
  
  processConsultationStats(stats) {
    const processed = {
      byStatus: {},
      byType: {},
      total: 0
    };
    
    stats.forEach(stat => {
      const count = parseInt(stat.dataValues.count);
      processed.total += count;
      
      if (!processed.byStatus[stat.status]) {
        processed.byStatus[stat.status] = 0;
      }
      processed.byStatus[stat.status] += count;
      
      if (!processed.byType[stat.consultationType]) {
        processed.byType[stat.consultationType] = 0;
      }
      processed.byType[stat.consultationType] += count;
    });
    
    return processed;
  }
  
  processPatientDemographics(consultations) {
    const demographics = {
      byGender: { male: 0, female: 0, other: 0 },
      byLanguage: { english: 0, hindi: 0, punjabi: 0 },
      totalUniquePatients: 0
    };
    
    const uniquePatients = new Set();
    
    consultations.forEach(consultation => {
      const patient = consultation.patient;
      if (patient && patient.user) {
        uniquePatients.add(patient.id);
        
        if (patient.user.gender) {
          demographics.byGender[patient.user.gender]++;
        }
        
        if (patient.user.preferredLanguage) {
          demographics.byLanguage[patient.user.preferredLanguage]++;
        }
      }
    });
    
    demographics.totalUniquePatients = uniquePatients.size;
    return demographics;
  }
  
  // ========== COMMUNICATION & NOTIFICATIONS ========== //
  
  async createNotification(doctorId, notificationData) {
    const {
      patientId, consultationId, type, title, message,
      priority = 'medium', language = 'english', actionUrl, actionData
    } = notificationData;
    
    // Create multilingual content if needed
    const titleTranslations = {};
    const messageTranslations = {};
    
    // This would integrate with translation service
    // For now, just store the original content
    titleTranslations[language] = title;
    messageTranslations[language] = message;
    
    const notification = await DoctorNotification.create({
      doctorId,
      patientId,
      consultationId,
      type,
      title,
      message,
      titleTranslations,
      messageTranslations,
      priority,
      language,
      actionUrl,
      actionData,
      syncStatus: 'synced'
    });
    
    return notification;
  }
  
  async getDoctorNotifications(doctorId, queryParams = {}) {
    const { limit = 20, offset = 0, unreadOnly = false, type, priority } = queryParams;
    
    const whereClause = { doctorId };
    
    if (unreadOnly) whereClause.isRead = false;
    if (type) whereClause.type = type;
    if (priority) whereClause.priority = priority;
    
    const notifications = await DoctorNotification.findAndCountAll({
      where: whereClause,
      include: [{
        model: Patient,
        as: 'patient',
        required: false,
        include: [{
          model: User,
          as: 'user',
          attributes: ['name', 'phone']
        }]
      }],
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['createdAt', 'DESC']]
    });
    
    return {
      notifications: notifications.rows,
      total: notifications.count,
      totalPages: Math.ceil(notifications.count / limit),
      currentPage: Math.floor(offset / limit) + 1,
      unreadCount: await DoctorNotification.count({
        where: { doctorId, isRead: false }
      })
    };
  }
  
  async markNotificationAsRead(doctorId, notificationId) {
    const notification = await DoctorNotification.findOne({
      where: { id: notificationId, doctorId }
    });
    
    if (!notification) {
      throw new Error('Notification not found or access denied');
    }
    
    await notification.update({ 
      isRead: true, 
      readAt: new Date() 
    });
    
    return notification;
  }
  
  async sendPatientMessage(doctorId, messageData) {
    const { patientId, message, language = 'english', consultationId } = messageData;
    
    // Create notification for patient (this would typically integrate with a real messaging system)
    const notification = await this.createNotification(doctorId, {
      patientId,
      consultationId,
      type: 'patient_message',
      title: 'Message from Doctor',
      message,
      priority: 'medium',
      language,
      actionUrl: `/consultations/${consultationId}/messages`
    });
    
    return {
      success: true,
      messageId: notification.id,
      sentAt: notification.createdAt
    };
  }
  
  // ========== MULTILINGUAL SUPPORT ========== //
  
  async getMultilingualContent(contentType, contentId, language = 'english') {
    // This would integrate with a translation service or multilingual database
    // For now, return placeholder structure
    const supportedLanguages = ['english', 'hindi', 'punjabi'];
    
    if (!supportedLanguages.includes(language)) {
      language = 'english';
    }
    
    return {
      language,
      contentType,
      contentId,
      // This would contain actual translated content
      translatedContent: null
    };
  }
}

export const doctorService = new DoctorService();
