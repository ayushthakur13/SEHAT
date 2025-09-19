import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const Prescription = sequelize.define("Prescription", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  patientId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: "patients",
      key: "id",
    },
  },
  doctorId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: "doctors",
      key: "id",
    },
  },
  consultationId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: "consultations",
      key: "id",
    },
  },
  prescriptionNumber: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  diagnosis: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  instructions: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  status: {
    type: DataTypes.ENUM("pending", "dispensed", "cancelled"),
    defaultValue: "pending",
  },
  pharmacyId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: "pharmacies",
      key: "id",
    },
  },
  dispensedAt: {
    type: DataTypes.DATE,
    allowNull: true,
  },
  followUpDate: {
    type: DataTypes.DATE,
    allowNull: true,
  },
  isOffline: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  syncStatus: {
    type: DataTypes.ENUM("pending", "synced", "failed"),
    defaultValue: "pending",
  },
}, {
  tableName: "prescriptions",
  timestamps: true,
  paranoid: true,
});

export default Prescription;