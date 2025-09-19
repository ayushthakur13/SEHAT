import { sequelize } from "../config/database.js";
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
// Patient associations
Patient.hasMany(Consultation, { foreignKey: "patientId", as: "consultations" });
Patient.hasMany(Prescription, { foreignKey: "patientId", as: "prescriptions" });
Patient.hasMany(HealthRecord, { foreignKey: "patientId", as: "healthRecords" });

// Doctor associations
Doctor.hasMany(Consultation, { foreignKey: "doctorId", as: "consultations" });
Doctor.hasMany(Prescription, { foreignKey: "doctorId", as: "prescriptions" });
Doctor.hasMany(HealthRecord, { foreignKey: "doctorId", as: "healthRecords" });

// Pharmacy associations
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