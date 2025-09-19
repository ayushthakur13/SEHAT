import express from "express";
import { authMiddleware, requireRole } from "../middleware/auth.js";
import {
  registerDoctor,
  loginDoctor,
  getDoctorProfile,
  updateDoctorProfile,
  getDoctorAppointments,
  updateAppointmentStatus,
} from "../controllers/doctorController.js";

const router = express.Router();

// Public routes
router.post("/register", registerDoctor);
router.post("/login", loginDoctor);

// Protected routes (Doctor only)
router.use(authMiddleware);
router.use(requireRole(["doctor"]));

router.get("/profile", getDoctorProfile);
router.put("/profile", updateDoctorProfile);
router.get("/appointments", getDoctorAppointments);
router.put("/appointments/:id/status", updateAppointmentStatus);

export default router;
