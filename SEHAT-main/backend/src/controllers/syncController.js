import { syncService } from "../services/syncService.js";

class SyncController {
  // Upload offline data
  async uploadOfflineData(req, res) {
    try {
      const { data, lastSyncTime } = req.body;
      const userId = req.user.id;
      const userType = req.userType;

      const result = await syncService.uploadOfflineData(userId, userType, data, lastSyncTime);

      res.json({
        status: 'success',
        message: 'Offline data uploaded successfully',
        data: result
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Download latest data
  async downloadLatestData(req, res) {
    try {
      const { lastSyncTime } = req.query;
      const userId = req.user.id;
      const userType = req.userType;

      const data = await syncService.downloadLatestData(userId, userType, lastSyncTime);

      res.json({
        status: 'success',
        data
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get sync status
  async getSyncStatus(req, res) {
    try {
      const userId = req.user.id;
      const userType = req.userType;

      const status = await syncService.getSyncStatus(userId, userType);

      res.json({
        status: 'success',
        data: status
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Resolve conflicts
  async resolveConflicts(req, res) {
    try {
      const { conflicts } = req.body;
      const userId = req.user.id;
      const userType = req.userType;

      const result = await syncService.resolveConflicts(userId, userType, conflicts);

      res.json({
        status: 'success',
        message: 'Conflicts resolved successfully',
        data: result
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }
}

export const syncController = new SyncController();
