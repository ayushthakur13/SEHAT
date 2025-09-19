import { notificationService } from "../services/notificationService.js";

class NotificationController {
  // Get notifications
  async getNotifications(req, res) {
    try {
      const { page = 1, limit = 20, unreadOnly = false } = req.query;
      const userId = req.user.id;
      const userType = req.userType;

      const notifications = await notificationService.getNotifications(userId, userType, {
        page: parseInt(page),
        limit: parseInt(limit),
        unreadOnly: unreadOnly === 'true'
      });

      res.json({
        status: 'success',
        data: notifications
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Mark notification as read
  async markAsRead(req, res) {
    try {
      const { id } = req.params;
      const userId = req.user.id;

      await notificationService.markAsRead(id, userId);

      res.json({
        status: 'success',
        message: 'Notification marked as read'
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Mark all notifications as read
  async markAllAsRead(req, res) {
    try {
      const userId = req.user.id;
      const userType = req.userType;

      await notificationService.markAllAsRead(userId, userType);

      res.json({
        status: 'success',
        message: 'All notifications marked as read'
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Delete notification
  async deleteNotification(req, res) {
    try {
      const { id } = req.params;
      const userId = req.user.id;

      await notificationService.deleteNotification(id, userId);

      res.json({
        status: 'success',
        message: 'Notification deleted successfully'
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }
}

export const notificationController = new NotificationController();
