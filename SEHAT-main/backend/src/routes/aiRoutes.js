import express from "express";
import { authMiddleware, requireRole } from "../middleware/auth.js";
import { aiLimiter } from "../middleware/rateLimiter.js";
import { aiController } from "../controllers/aiController.js";

const router = express.Router();

// All routes require authentication and rate limiting
router.use(authMiddleware);
router.use(aiLimiter);

// Patient routes
router.post("/symptom-checker", requireRole(["patient"]), aiController.symptomChecker);
router.post("/health-tips", requireRole(["patient"]), aiController.getHealthTips);
router.get("/common-illnesses", aiController.getCommonIllnesses);

export default router;
