import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const Doctor = sequelize.define("Doctor", {
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
  // Verification Fields (collected during verification step)
  hospitalId: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  licenseNumber: {
    type: DataTypes.STRING,
    allowNull: true,
    unique: true,
  },
  currentHospitalClinic: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  pincode: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  specialization: {
    type: DataTypes.STRING,
    allowNull: true, // Will be filled during verification
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
  isVerified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  verificationData: {
    type: DataTypes.JSON,
    allowNull: true,
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