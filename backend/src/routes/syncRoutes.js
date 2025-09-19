import express from "express";
import { authMiddleware } from "../middleware/auth.js";
import { syncController } from "../controllers/syncController.js";

const router = express.Router();

// All routes require authentication
router.use(authMiddleware);

// Sync routes for offline-first functionality
router.post("/upload", syncController.uploadOfflineData);
router.post("/download", syncController.downloadLatestData);
router.get("/status", syncController.getSyncStatus);
router.post("/conflict-resolve", syncController.resolveConflicts);

export default router;
