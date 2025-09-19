import express from "express";
import { authMiddleware, requireRole } from "../middleware/auth.js";
import { healthRecordController } from "../controllers/healthRecordController.js";

const router = express.Router();

// All routes require authentication
router.use(authMiddleware);

// Patient routes
router.get("/my-records", requireRole(["patient"]), healthRecordController.getMyRecords);
router.post("/upload", requireRole(["patient"]), healthRecordController.uploadRecord);
router.get("/:id", healthRecordController.getRecordById);
router.put("/:id", requireRole(["patient"]), healthRecordController.updateRecord);
router.delete("/:id", requireRole(["patient"]), healthRecordController.deleteRecord);

// Doctor routes
router.get("/patient/:patientId", requireRole(["doctor"]), healthRecordController.getPatientRecords);

export default router;
