import express from "express";
import { authController } from "../controllers/authController.js";

const router = express.Router();

// Authentication routes
router.post("/register/patient", authController.registerPatient);
router.post("/register/doctor", authController.registerDoctor);
router.post("/register/pharmacy", authController.registerPharmacy);
router.post("/login/patient", authController.loginPatient);
router.post("/login/doctor", authController.loginDoctor);
router.post("/login/pharmacy", authController.loginPharmacy);
router.post("/refresh", authController.refreshToken);
router.post("/logout", authController.logout);

export default router;
