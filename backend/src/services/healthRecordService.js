import { HealthRecord, Patient, Doctor } from "../models/index.js";

class HealthRecordService {
  async getPatientRecords(patientId, filters = {}) {
    const whereClause = { patientId };
    
    if (filters.recordType) {
      whereClause.recordType = filters.recordType;
    }

    const records = await HealthRecord.findAll({
      where: whereClause,
      include: [
        { model: Doctor, as: 'doctor', attributes: ['id', 'name', 'specialization'] }
      ],
      order: [['recordDate', 'DESC']],
      limit: filters.limit || 10,
      offset: ((filters.page || 1) - 1) * (filters.limit || 10)
    });

    return records;
  }

  async createRecord({ patientId, recordType, title, description, recordDate }) {
    const record = await HealthRecord.create({
      patientId,
      recordType,
      title,
      description,
      recordDate
    });

    return record;
  }

  async getRecordById(recordId, user) {
    const record = await HealthRecord.findByPk(recordId, {
      include: [
        { model: Patient, as: 'patient' },
        { model: Doctor, as: 'doctor' }
      ]
    });

    if (!record) {
      throw new Error('Health record not found');
    }

    // Check access permissions
    if (user.userType === 'patient' && record.patientId !== user.id) {
      throw new Error('Access denied');
    }

    return record;
  }

  async updateRecord(recordId, patientId, updateData) {
    const record = await HealthRecord.findOne({
      where: { id: recordId, patientId }
    });

    if (!record) {
      throw new Error('Health record not found or unauthorized');
    }

    await record.update(updateData);
    return record;
  }

  async deleteRecord(recordId, patientId) {
    const record = await HealthRecord.findOne({
      where: { id: recordId, patientId }
    });

    if (!record) {
      throw new Error('Health record not found or unauthorized');
    }

    await record.destroy();
  }
}

export const healthRecordService = new HealthRecordService();
