import express from "express";
import { authMiddleware, requireRole } from "../middleware/auth.js";
import { consultationController } from "../controllers/consultationController.js";

const router = express.Router();

// All routes require authentication
router.use(authMiddleware);

// Patient routes
router.post("/book", requireRole(["patient"]), consultationController.bookConsultation);
router.get("/my-consultations", requireRole(["patient"]), consultationController.getMyConsultations);
router.get("/:id", consultationController.getConsultationById);

// Doctor routes
router.get("/", requireRole(["doctor"]), consultationController.getDoctorConsultations);
router.put("/:id/status", requireRole(["doctor"]), consultationController.updateConsultationStatus);
router.put("/:id/notes", requireRole(["doctor"]), consultationController.updateConsultationNotes);
router.post("/:id/start", requireRole(["doctor"]), consultationController.startConsultation);
router.post("/:id/end", requireRole(["doctor"]), consultationController.endConsultation);

export default router;
