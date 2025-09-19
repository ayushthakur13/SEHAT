import { Doctor, Consultation, Prescription, Patient } from "../models/index.js";

class DoctorService {
  // Get doctor profile with related data
  async getDoctorProfile(doctorId) {
    try {
      const doctor = await Doctor.findByPk(doctorId, {
        attributes: { exclude: ["password"] },
        include: [
          {
            model: Consultation,
            as: "appointments",
            include: ["patient"],
            order: [["createdAt", "DESC"]],
            limit: 10,
          },
          {
            model: Prescription,
            as: "prescriptions",
            include: ["patient", "pharmacy"],
            order: [["createdAt", "DESC"]],
            limit: 10,
          },
        ],
      });

      if (!doctor) {
        throw new Error("Doctor not found");
      }

      return doctor;
    } catch (error) {
      throw error;
    }
  }

  // Update doctor profile
  async updateDoctorProfile(doctorId, updateData) {
    try {
      const allowedFields = [
        "name",
        "phone",
        "specialization",
        "experience",
        "consultationFee",
        "isAvailable",
      ];

      const filteredData = Object.keys(updateData)
        .filter(key => allowedFields.includes(key))
        .reduce((obj, key) => {
          obj[key] = updateData[key];
          return obj;
        }, {});

      const [updatedRowsCount] = await Doctor.update(filteredData, {
        where: { id: doctorId },
      });

      if (updatedRowsCount === 0) {
        throw new Error("Doctor not found or no changes made");
      }

      const updatedDoctor = await Doctor.findByPk(doctorId, {
        attributes: { exclude: ["password"] },
      });

      return updatedDoctor;
    } catch (error) {
      throw error;
    }
  }

  // Get doctor appointments
  async getDoctorAppointments(doctorId, filters = {}) {
    try {
      const whereClause = { doctorId };
      
      if (filters.status) {
        whereClause.status = filters.status;
      }

      if (filters.date) {
        whereClause.appointmentDate = filters.date;
      }

      const appointments = await Consultation.findAll({
        where: whereClause,
        include: ["patient"],
        order: [["appointmentDate", "ASC"], ["startTime", "ASC"]],
        limit: filters.limit || 50,
      });

      return appointments;
    } catch (error) {
      throw error;
    }
  }

  // Update appointment status
  async updateAppointmentStatus(appointmentId, doctorId, updateData) {
    try {
      const appointment = await Consultation.findOne({
        where: { id: appointmentId, doctorId },
      });

      if (!appointment) {
        throw new Error("Appointment not found or unauthorized");
      }

      const allowedFields = ["status", "notes", "diagnosis"];
      const filteredData = Object.keys(updateData)
        .filter(key => allowedFields.includes(key))
        .reduce((obj, key) => {
          obj[key] = updateData[key];
          return obj;
        }, {});

      await appointment.update(filteredData);

      const updatedAppointment = await Consultation.findByPk(appointmentId, {
        include: ["patient"],
      });

      return updatedAppointment;
    } catch (error) {
      throw error;
    }
  }

  // Create prescription
  async createPrescription(doctorId, prescriptionData) {
    try {
      const { patientId, appointmentId, diagnosis, instructions, medicines } = prescriptionData;

      // Generate prescription number
      const prescriptionNumber = `RX${Date.now()}${Math.random().toString(36).substr(2, 5).toUpperCase()}`;

      const prescription = await Prescription.create({
        patientId,
        doctorId,
        appointmentId,
        prescriptionNumber,
        diagnosis,
        instructions,
      });

      // Add medicines to prescription
      if (medicines && medicines.length > 0) {
        await prescription.addMedicines(medicines);
      }

      const createdPrescription = await Prescription.findByPk(prescription.id, {
        include: ["patient", "medicines"],
      });

      return createdPrescription;
    } catch (error) {
      throw error;
    }
  }
}

export const doctorService = new DoctorService();
