import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const Patient = sequelize.define("Patient", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true,
    },
  },
  phone: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  dateOfBirth: {
    type: DataTypes.DATE,
    allowNull: true,
  },
  gender: {
    type: DataTypes.ENUM("male", "female", "other"),
    allowNull: true,
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
  preferredLanguage: {
    type: DataTypes.ENUM("punjabi", "hindi", "english"),
    defaultValue: "english",
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
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
  lastSyncAt: {
    type: DataTypes.DATE,
    allowNull: true,
  },
  deviceId: {
    type: DataTypes.STRING,
    allowNull: true,
  },
}, {
  tableName: "patients",
  timestamps: true,
  paranoid: true,
});

export default Patient;