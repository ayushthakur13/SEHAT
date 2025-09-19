import express from "express";
import { authMiddleware } from "../middleware/auth.js";
import { notificationController } from "../controllers/notificationController.js";

const router = express.Router();

// All routes require authentication
router.use(authMiddleware);

// Get notifications
router.get("/", notificationController.getNotifications);
router.put("/:id/read", notificationController.markAsRead);
router.put("/read-all", notificationController.markAllAsRead);
router.delete("/:id", notificationController.deleteNotification);

export default router;
