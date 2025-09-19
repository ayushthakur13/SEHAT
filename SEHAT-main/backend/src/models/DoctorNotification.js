import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const DoctorNotification = sequelize.define("DoctorNotification", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  doctorId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: "doctors",
      key: "id",
    },
  },
  patientId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: "patients",
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
  type: {
    type: DataTypes.ENUM(
      'appointment_request', 'appointment_reminder', 'consultation_ready',
      'prescription_ready', 'patient_message', 'emergency_consultation',
      'follow_up_reminder', 'health_record_updated', 'medicine_stock_alert'
    ),
    allowNull: false,
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  message: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  titleTranslations: {
    type: DataTypes.JSON,
    allowNull: true
  },
  messageTranslations: {
    type: DataTypes.JSON,
    allowNull: true
  },
  priority: {
    type: DataTypes.ENUM('low', 'medium', 'high', 'urgent'),
    defaultValue: 'medium',
  },
  language: {
    type: DataTypes.ENUM('english', 'hindi', 'punjabi'),
    defaultValue: 'english'
  },
  isRead: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  isOffline: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  readAt: {
    type: DataTypes.DATE,
    allowNull: true,
  },
  actionUrl: {
    type: DataTypes.STRING,
    allowNull: true
  },
  actionData: {
    type: DataTypes.JSON,
    allowNull: true
  },
  expiresAt: {
    type: DataTypes.DATE,
    allowNull: true
  },
  syncStatus: {
    type: DataTypes.ENUM("pending", "synced", "failed"),
    defaultValue: "pending",
  },
}, {
  tableName: "doctor_notifications",
  timestamps: true,
  paranoid: true
});

export default DoctorNotification;