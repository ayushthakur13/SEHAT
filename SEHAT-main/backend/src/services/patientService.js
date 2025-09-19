import { Patient, Consultation, Prescription } from "../models/index.js";

class PatientService {
  // Get patient profile with related data
  async getPatientProfile(patientId) {
    try {
      const patient = await Patient.findByPk(patientId, {
        attributes: { exclude: ["password"] },
        include: [
          {
            model: Consultation,
            as: "consultations",
            include: ["doctor"],
            order: [["createdAt", "DESC"]],
            limit: 10,
          },
          {
            model: Prescription,
            as: "prescriptions",
            include: ["doctor", "pharmacy"],
            order: [["createdAt", "DESC"]],
            limit: 10,
          },
        ],
      });

      if (!patient) {
        throw new Error("Patient not found");
      }

      return patient;
    } catch (error) {
      throw error;
    }
  }

  // Update patient profile
  async updatePatientProfile(patientId, updateData) {
    try {
      const allowedFields = [
        "name",
        "phone",
        "dateOfBirth",
        "gender",
        "address",
        "emergencyContact",
        "emergencyPhone",
      ];

      const filteredData = Object.keys(updateData)
        .filter(key => allowedFields.includes(key))
        .reduce((obj, key) => {
          obj[key] = updateData[key];
          return obj;
        }, {});

      const [updatedRowsCount] = await Patient.update(filteredData, {
        where: { id: patientId },
      });

      if (updatedRowsCount === 0) {
        throw new Error("Patient not found or no changes made");
      }

      const updatedPatient = await Patient.findByPk(patientId, {
        attributes: { exclude: ["password"] },
      });

      return updatedPatient;
    } catch (error) {
      throw error;
    }
  }

  // Get patient appointments
  async getPatientAppointments(patientId, filters = {}) {
    try {
      const whereClause = { patientId };
      
      if (filters.status) {
        whereClause.status = filters.status;
      }

      const appointments = await Consultation.findAll({
        where: whereClause,
        include: ["doctor"],
        order: [["appointmentDate", "DESC"]],
        limit: filters.limit || 50,
      });

      return appointments;
    } catch (error) {
      throw error;
    }
  }

  // Get patient prescriptions
  async getPatientPrescriptions(patientId, filters = {}) {
    try {
      const whereClause = { patientId };
      
      if (filters.status) {
        whereClause.status = filters.status;
      }

      const prescriptions = await Prescription.findAll({
        where: whereClause,
        include: ["doctor", "pharmacy", "medicines"],
        order: [["createdAt", "DESC"]],
        limit: filters.limit || 50,
      });

      return prescriptions;
    } catch (error) {
      throw error;
    }
  }
}

export const patientService = new PatientService();
