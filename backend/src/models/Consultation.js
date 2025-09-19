import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const Consultation = sequelize.define("Consultation", {
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
  appointmentDate: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  startTime: {
    type: DataTypes.TIME,
    allowNull: false,
  },
  endTime: {
    type: DataTypes.TIME,
    allowNull: true,
  },
  status: {
    type: DataTypes.ENUM("scheduled", "in_progress", "completed", "cancelled", "no_show"),
    defaultValue: "scheduled",
  },
  consultationType: {
    type: DataTypes.ENUM("video", "audio", "chat"),
    allowNull: false,
  },
  symptoms: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  diagnosis: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  notes: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  prescriptionId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: "prescriptions",
      key: "id",
    },
  },
  meetingId: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  meetingUrl: {
    type: DataTypes.TEXT,
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
  tableName: "consultations",
  timestamps: true,
  paranoid: true,
});

export default Consultation;
