import { healthRecordService } from "../services/healthRecordService.js";

class HealthRecordController {
  // Get my health records (Patient)
  async getMyRecords(req, res) {
    try {
      const patientId = req.user.id;
      const { recordType, page = 1, limit = 10 } = req.query;

      const records = await healthRecordService.getPatientRecords(patientId, {
        recordType,
        page: parseInt(page),
        limit: parseInt(limit)
      });

      res.json({
        status: 'success',
        data: records
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Upload health record (Patient)
  async uploadRecord(req, res) {
    try {
      const { recordType, title, description, recordDate } = req.body;
      const patientId = req.user.id;

      const record = await healthRecordService.createRecord({
        patientId,
        recordType,
        title,
        description,
        recordDate: new Date(recordDate)
      });

      res.status(201).json({
        status: 'success',
        message: 'Health record uploaded successfully',
        data: record
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get record by ID
  async getRecordById(req, res) {
    try {
      const { id } = req.params;
      const record = await healthRecordService.getRecordById(id, req.user);

      res.json({
        status: 'success',
        data: record
      });
    } catch (error) {
      res.status(404).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Update record (Patient)
  async updateRecord(req, res) {
    try {
      const { id } = req.params;
      const updateData = req.body;
      const patientId = req.user.id;

      const record = await healthRecordService.updateRecord(id, patientId, updateData);

      res.json({
        status: 'success',
        message: 'Health record updated successfully',
        data: record
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Delete record (Patient)
  async deleteRecord(req, res) {
    try {
      const { id } = req.params;
      const patientId = req.user.id;

      await healthRecordService.deleteRecord(id, patientId);

      res.json({
        status: 'success',
        message: 'Health record deleted successfully'
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get patient records (Doctor)
  async getPatientRecords(req, res) {
    try {
      const { patientId } = req.params;
      const { recordType, page = 1, limit = 10 } = req.query;

      const records = await healthRecordService.getPatientRecords(patientId, {
        recordType,
        page: parseInt(page),
        limit: parseInt(limit)
      });

      res.json({
        status: 'success',
        data: records
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }
}

export const healthRecordController = new HealthRecordController();
