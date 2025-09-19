import express from "express";
import { authController } from "../controllers/authController.js";
import { authMiddleware, requireRole } from "../middleware/auth.js";

const router = express.Router();

// New unified authentication routes
router.post("/register", authController.register);
router.post("/login", authController.login);

// Verification routes (require authentication)
router.post("/verify/doctor", authMiddleware, requireRole(['doctor']), authController.verifyDoctor);
router.post("/verify/pharmacy", authMiddleware, requireRole(['pharmacy']), authController.verifyPharmacy);

// Other auth routes
router.post("/refresh", authController.refreshToken);
router.post("/logout", authController.logout);

export default router;
