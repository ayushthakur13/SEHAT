import express from "express";
import { authMiddleware, requireRole } from "../middleware/auth.js";
import {
  // Dashboard & Profile
  getDoctorDashboard,
  getDoctorProfile,
  updateDoctorProfile,
  // Availability Management
  updateAvailability,
  // Appointment Management
  getDoctorAppointments,
  updateAppointmentStatus,
  // Consultation Management
  createConsultation,
  joinConsultation,
  // Patient Health Records
  getPatientHealthRecords,
  createHealthRecord,
  // Prescription Management
  createPrescription,
  // Offline Sync
  syncOfflineData,
  getUnsyncedData,
  // Analytics & Communication
  getDoctorAnalytics,
  getDoctorNotifications,
  markNotificationAsRead,
  sendPatientMessage,
  // Multilingual Support
  getMultilingualContent,
} from "../controllers/doctorController.js";

const router = express.Router();

// All routes require authentication and doctor role
router.use(authMiddleware);
router.use(requireRole(["doctor"]));

// ========== DASHBOARD & PROFILE ========== //
router.get("/dashboard", getDoctorDashboard);
router.get("/profile", getDoctorProfile);
router.put("/profile", updateDoctorProfile);

// ========== AVAILABILITY MANAGEMENT ========== //
router.put("/availability", updateAvailability);

// ========== APPOINTMENT MANAGEMENT ========== //
router.get("/appointments", getDoctorAppointments);
router.put("/appointments/:id/status", updateAppointmentStatus);

// ========== CONSULTATION MANAGEMENT ========== //
router.post("/consultations", createConsultation);
router.post("/consultations/:consultationId/join", joinConsultation);

// ========== PATIENT HEALTH RECORDS ========== //
router.get("/patients/:patientId/health-records", getPatientHealthRecords);
router.post("/health-records", createHealthRecord);

// ========== PRESCRIPTION MANAGEMENT ========== //
router.post("/prescriptions", createPrescription);

// ========== OFFLINE SYNC ========== //
router.post("/sync", syncOfflineData);
router.get("/sync/unsynced", getUnsyncedData);

// ========== ANALYTICS & REPORTS ========== //
router.get("/analytics", getDoctorAnalytics);

// ========== COMMUNICATION & NOTIFICATIONS ========== //
router.get("/notifications", getDoctorNotifications);
router.put("/notifications/:notificationId/read", markNotificationAsRead);
router.post("/messages", sendPatientMessage);

// ========== MULTILINGUAL SUPPORT ========== //
router.get("/content/:contentType/:contentId", getMultilingualContent);

export default router;
