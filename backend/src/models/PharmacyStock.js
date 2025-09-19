import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const PharmacyStock = sequelize.define("PharmacyStock", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  pharmacyId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: "pharmacies",
      key: "id",
    },
  },
  medicineId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: "medicines",
      key: "id",
    },
  },
  quantity: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0,
  },
  price: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true,
  },
  expiryDate: {
    type: DataTypes.DATE,
    allowNull: true,
  },
  batchNumber: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  isAvailable: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
  lastUpdated: {
    type: DataTypes.DATE,
    allowNull: true,
  },
}, {
  tableName: "pharmacy_stocks",
  timestamps: true,
  paranoid: true,
});

export default PharmacyStock;
