import express from "express";
import { authMiddleware, requireRole } from "../middleware/auth.js";
import { prescriptionController } from "../controllers/prescriptionController.js";

const router = express.Router();

// All routes require authentication
router.use(authMiddleware);

// Patient routes
router.get("/my-prescriptions", requireRole(["patient"]), prescriptionController.getMyPrescriptions);
router.get("/:id", prescriptionController.getPrescriptionById);

// Doctor routes
router.post("/create", requireRole(["doctor"]), prescriptionController.createPrescription);
router.put("/:id", requireRole(["doctor"]), prescriptionController.updatePrescription);

// Pharmacy routes
router.get("/", requireRole(["pharmacy"]), prescriptionController.getPharmacyPrescriptions);
router.put("/:id/dispense", requireRole(["pharmacy"]), prescriptionController.dispensePrescription);

export default router;
