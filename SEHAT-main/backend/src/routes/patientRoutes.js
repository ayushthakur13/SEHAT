import express from "express";
import { authMiddleware } from "../middleware/auth.js";
import {
  registerPatient,
  loginPatient,
  getPatientProfile,
  updatePatientProfile,
} from "../controllers/patientController.js";

const router = express.Router();

// Public routes
router.post("/register", registerPatient);
router.post("/login", loginPatient);

// Protected routes
router.use(authMiddleware);
router.get("/profile", getPatientProfile);
router.put("/profile", updatePatientProfile);

export default router;
