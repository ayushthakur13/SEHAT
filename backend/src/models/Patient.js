import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const Patient = sequelize.define("Patient", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: true, // Temporarily allow null during migration
    unique: true,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  address: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  city: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  state: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  pincode: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  emergencyContact: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  emergencyPhone: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  bloodGroup: {
    type: DataTypes.ENUM("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"),
    allowNull: true,
  },
  allergies: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  medicalHistory: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  lastSyncAt: {
    type: DataTypes.DATE,
    allowNull: true,
  },
}, {
  tableName: "patients",
  timestamps: true,
  paranoid: true,
});

export default Patient;