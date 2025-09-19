import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const Pharmacy = sequelize.define("Pharmacy", {
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
  // Pharmacy Store Details (filled during verification)
  storeName: {
    type: DataTypes.STRING,
    allowNull: true, // Will be filled during verification
  },
  licenseNumber: {
    type: DataTypes.STRING,
    allowNull: true,
    unique: true,
  },
  gstNumber: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  address: {
    type: DataTypes.TEXT,
    allowNull: true, // Will be filled during verification
  },
  city: {
    type: DataTypes.STRING,
    allowNull: true, // Will be filled during verification
  },
  state: {
    type: DataTypes.STRING,
    allowNull: true, // Will be filled during verification
  },
  pincode: {
    type: DataTypes.STRING,
    allowNull: true, // Will be filled during verification
  },
  latitude: {
    type: DataTypes.DECIMAL(10, 8),
    allowNull: true,
  },
  longitude: {
    type: DataTypes.DECIMAL(11, 8),
    allowNull: true,
  },
  workingHours: {
    type: DataTypes.JSON,
    allowNull: true,
  },
  isVerified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  verificationData: {
    type: DataTypes.JSON,
    allowNull: true,
  },
  lastSyncAt: {
    type: DataTypes.DATE,
    allowNull: true,
  },
}, {
  tableName: "pharmacies",
  timestamps: true,
  paranoid: true,
});

export default Pharmacy;