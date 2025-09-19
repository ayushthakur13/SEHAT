import { doctorService } from "../services/doctorService.js";

class DoctorController {
  // ========== DASHBOARD & PROFILE ========== //
  
  async getDoctorDashboard(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const dashboard = await doctorService.getDoctorDashboard(doctorId);
      
      res.json({
        status: 'success',
        message: 'Dashboard data retrieved successfully',
        data: dashboard
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error fetching dashboard data',
        error: error.message
      });
    }
  }

  async getDoctorProfile(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const doctor = await doctorService.getDoctorProfile(doctorId);
      
      res.json({
        status: 'success',
        data: { doctor }
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error fetching profile',
        error: error.message
      });
    }
  }

  async updateDoctorProfile(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const updatedDoctor = await doctorService.updateDoctorProfile(doctorId, req.body);
      
      res.json({
        status: 'success',
        message: 'Profile updated successfully',
        data: { doctor: updatedDoctor }
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error updating profile',
        error: error.message
      });
    }
  }

  // ========== AVAILABILITY MANAGEMENT ========== //
  
  async updateAvailability(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const result = await doctorService.updateAvailability(doctorId, req.body);
      
      res.json({
        status: 'success',
        message: 'Availability updated successfully',
        data: result
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error updating availability',
        error: error.message
      });
    }
  }

  // ========== APPOINTMENT MANAGEMENT ========== //
  
  async getDoctorAppointments(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const appointments = await doctorService.getDoctorAppointments(doctorId, req.query);
      
      res.json({
        status: 'success',
        data: appointments
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error fetching appointments',
        error: error.message
      });
    }
  }

  async updateAppointmentStatus(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const { id } = req.params;
      const appointment = await doctorService.updateAppointmentStatus(id, doctorId, req.body);
      
      res.json({
        status: 'success',
        message: 'Appointment updated successfully',
        data: { appointment }
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error updating appointment',
        error: error.message
      });
    }
  }

  // ========== CONSULTATION MANAGEMENT ========== //
  
  async createConsultation(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const consultation = await doctorService.createConsultation(doctorId, req.body);
      
      res.status(201).json({
        status: 'success',
        message: 'Consultation created successfully',
        data: { consultation }
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error creating consultation',
        error: error.message
      });
    }
  }

  async joinConsultation(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const { consultationId } = req.params;
      const result = await doctorService.joinConsultation(consultationId, doctorId);
      
      res.json({
        status: 'success',
        message: 'Joined consultation successfully',
        data: result
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error joining consultation',
        error: error.message
      });
    }
  }

  // ========== PATIENT HEALTH RECORDS ========== //
  
  async getPatientHealthRecords(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const { patientId } = req.params;
      const healthRecords = await doctorService.getPatientHealthRecords(patientId, doctorId);
      
      res.json({
        status: 'success',
        data: healthRecords
      });
    } catch (error) {
      res.status(403).json({
        status: 'error',
        message: error.message
      });
    }
  }

  async createHealthRecord(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const healthRecord = await doctorService.createHealthRecord(doctorId, req.body);
      
      res.status(201).json({
        status: 'success',
        message: 'Health record created successfully',
        data: { healthRecord }
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error creating health record',
        error: error.message
      });
    }
  }

  // ========== PRESCRIPTION MANAGEMENT ========== //
  
  async createPrescription(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const prescription = await doctorService.createPrescription(doctorId, req.body);
      
      res.status(201).json({
        status: 'success',
        message: 'Prescription created successfully',
        data: { prescription }
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error creating prescription',
        error: error.message
      });
    }
  }

  // ========== OFFLINE SYNC ========== //
  
  async syncOfflineData(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const syncResults = await doctorService.syncOfflineData(doctorId, req.body);
      
      res.json({
        status: 'success',
        message: 'Data synced successfully',
        data: syncResults
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error syncing data',
        error: error.message
      });
    }
  }

  async getUnsyncedData(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const unsyncedData = await doctorService.getUnsyncedData(doctorId);
      
      res.json({
        status: 'success',
        data: unsyncedData
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error fetching unsynced data',
        error: error.message
      });
    }
  }

  // ========== ANALYTICS & REPORTS ========== //
  
  async getDoctorAnalytics(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const { timeRange } = req.query;
      const analytics = await doctorService.getDoctorAnalytics(doctorId, timeRange);
      
      res.json({
        status: 'success',
        data: analytics
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error fetching analytics',
        error: error.message
      });
    }
  }

  // ========== COMMUNICATION & NOTIFICATIONS ========== //
  
  async getDoctorNotifications(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const notifications = await doctorService.getDoctorNotifications(doctorId, req.query);
      
      res.json({
        status: 'success',
        data: notifications
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error fetching notifications',
        error: error.message
      });
    }
  }

  async markNotificationAsRead(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const { notificationId } = req.params;
      const notification = await doctorService.markNotificationAsRead(doctorId, notificationId);
      
      res.json({
        status: 'success',
        message: 'Notification marked as read',
        data: { notification }
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error updating notification',
        error: error.message
      });
    }
  }

  async sendPatientMessage(req, res) {
    try {
      const doctorId = req.user.doctor?.id;
      if (!doctorId) {
        return res.status(404).json({
          status: 'error',
          message: 'Doctor profile not found'
        });
      }
      
      const result = await doctorService.sendPatientMessage(doctorId, req.body);
      
      res.json({
        status: 'success',
        message: 'Message sent successfully',
        data: result
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error sending message',
        error: error.message
      });
    }
  }

  // ========== MULTILINGUAL SUPPORT ========== //
  
  async getMultilingualContent(req, res) {
    try {
      const { contentType, contentId } = req.params;
      const { language } = req.query;
      
      const content = await doctorService.getMultilingualContent(contentType, contentId, language);
      
      res.json({
        status: 'success',
        data: content
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error fetching multilingual content',
        error: error.message
      });
    }
  }
}

const doctorController = new DoctorController();

// Export individual methods for backward compatibility
export const getDoctorDashboard = doctorController.getDoctorDashboard.bind(doctorController);
export const getDoctorProfile = doctorController.getDoctorProfile.bind(doctorController);
export const updateDoctorProfile = doctorController.updateDoctorProfile.bind(doctorController);
export const updateAvailability = doctorController.updateAvailability.bind(doctorController);
export const getDoctorAppointments = doctorController.getDoctorAppointments.bind(doctorController);
export const updateAppointmentStatus = doctorController.updateAppointmentStatus.bind(doctorController);
export const createConsultation = doctorController.createConsultation.bind(doctorController);
export const joinConsultation = doctorController.joinConsultation.bind(doctorController);
export const getPatientHealthRecords = doctorController.getPatientHealthRecords.bind(doctorController);
export const createHealthRecord = doctorController.createHealthRecord.bind(doctorController);
export const createPrescription = doctorController.createPrescription.bind(doctorController);
export const syncOfflineData = doctorController.syncOfflineData.bind(doctorController);
export const getUnsyncedData = doctorController.getUnsyncedData.bind(doctorController);
// Analytics & Communication
export const getDoctorAnalytics = doctorController.getDoctorAnalytics.bind(doctorController);
export const getDoctorNotifications = doctorController.getDoctorNotifications.bind(doctorController);
export const markNotificationAsRead = doctorController.markNotificationAsRead.bind(doctorController);
export const sendPatientMessage = doctorController.sendPatientMessage.bind(doctorController);
// Multilingual Support
export const getMultilingualContent = doctorController.getMultilingualContent.bind(doctorController);

export default doctorController;
