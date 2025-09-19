import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const Doctor = sequelize.define("Doctor", {
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
  licenseNumber: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  specialization: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  experience: {
    type: DataTypes.INTEGER,
    allowNull: true,
  },
  consultationFee: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true,
  },
  languages: {
    type: DataTypes.JSON,
    allowNull: true,
    defaultValue: ["english"],
  },
  workingHours: {
    type: DataTypes.JSON,
    allowNull: true,
  },
  isAvailable: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
  rating: {
    type: DataTypes.DECIMAL(3, 2),
    defaultValue: 0,
  },
  totalConsultations: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  lastActiveAt: {
    type: DataTypes.DATE,
    allowNull: true,
  },
}, {
  tableName: "doctors",
  timestamps: true,
  paranoid: true,
});

export default Doctor;