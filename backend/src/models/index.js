import { sequelize } from "../config/database.js";
import User from "./User.js";
import Patient from "./Patient.js";
import Doctor from "./Doctor.js";
import Pharmacy from "./Pharmacy.js";
import Consultation from "./Consultation.js";
import Medicine from "./Medicine.js";
import Prescription from "./Prescription.js";
import PrescriptionMedicine from "./PrescriptionMedicine.js";
import HealthRecord from "./HealthRecord.js";
import PharmacyStock from "./PharmacyStock.js";

// Define associations
// User associations
User.hasOne(Patient, { foreignKey: "userId", as: "patient" });
User.hasOne(Doctor, { foreignKey: "userId", as: "doctor" });
User.hasOne(Pharmacy, { foreignKey: "userId", as: "pharmacy" });

// Patient associations
Patient.belongsTo(User, { foreignKey: "userId", as: "user" });
Patient.hasMany(Consultation, { foreignKey: "patientId", as: "consultations" });
Patient.hasMany(Prescription, { foreignKey: "patientId", as: "prescriptions" });
Patient.hasMany(HealthRecord, { foreignKey: "patientId", as: "healthRecords" });

// Doctor associations
Doctor.belongsTo(User, { foreignKey: "userId", as: "user" });
Doctor.hasMany(Consultation, { foreignKey: "doctorId", as: "consultations" });
Doctor.hasMany(Prescription, { foreignKey: "doctorId", as: "prescriptions" });
Doctor.hasMany(HealthRecord, { foreignKey: "doctorId", as: "healthRecords" });

// Pharmacy associations
Pharmacy.belongsTo(User, { foreignKey: "userId", as: "user" });
Pharmacy.hasMany(Prescription, { foreignKey: "pharmacyId", as: "prescriptions" });
Pharmacy.hasMany(PharmacyStock, { foreignKey: "pharmacyId", as: "stocks" });

// Consultation associations
Consultation.belongsTo(Patient, { foreignKey: "patientId", as: "patient" });
Consultation.belongsTo(Doctor, { foreignKey: "doctorId", as: "doctor" });
Consultation.belongsTo(Prescription, { foreignKey: "prescriptionId", as: "prescription" });

// Prescription associations
Prescription.belongsTo(Patient, { foreignKey: "patientId", as: "patient" });
Prescription.belongsTo(Doctor, { foreignKey: "doctorId", as: "doctor" });
Prescription.belongsTo(Pharmacy, { foreignKey: "pharmacyId", as: "pharmacy" });
Prescription.belongsTo(Consultation, { foreignKey: "consultationId", as: "consultation" });
Prescription.belongsToMany(Medicine, { 
  through: PrescriptionMedicine, 
  foreignKey: "prescriptionId",
  as: "medicines" 
});

// Medicine associations
Medicine.belongsToMany(Prescription, { 
  through: PrescriptionMedicine, 
  foreignKey: "medicineId",
  as: "prescriptions" 
});
Medicine.hasMany(PharmacyStock, { foreignKey: "medicineId", as: "stocks" });

// PrescriptionMedicine associations
PrescriptionMedicine.belongsTo(Prescription, { foreignKey: "prescriptionId" });
PrescriptionMedicine.belongsTo(Medicine, { foreignKey: "medicineId" });

// HealthRecord associations
HealthRecord.belongsTo(Patient, { foreignKey: "patientId", as: "patient" });
HealthRecord.belongsTo(Doctor, { foreignKey: "doctorId", as: "doctor" });

// PharmacyStock associations
PharmacyStock.belongsTo(Pharmacy, { foreignKey: "pharmacyId", as: "pharmacy" });
PharmacyStock.belongsTo(Medicine, { foreignKey: "medicineId", as: "medicine" });

export {
  sequelize,
  User,
  Patient,
  Doctor,
  Pharmacy,
  Consultation,
  Medicine,
  Prescription,
  PrescriptionMedicine,
  HealthRecord,
  PharmacyStock,
};
