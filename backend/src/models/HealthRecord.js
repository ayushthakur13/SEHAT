import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const HealthRecord = sequelize.define("HealthRecord", {
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
  recordType: {
    type: DataTypes.ENUM("consultation", "prescription", "lab_report", "vital", "vaccination", "other"),
    allowNull: false,
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  filePath: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  fileType: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  fileSize: {
    type: DataTypes.INTEGER,
    allowNull: true,
  },
  recordDate: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  doctorId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: "doctors",
      key: "id",
    },
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
  tableName: "health_records",
  timestamps: true,
  paranoid: true,
});

export default HealthRecord;
