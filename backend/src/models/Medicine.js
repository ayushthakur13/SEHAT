import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const Medicine = sequelize.define("Medicine", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  genericName: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  manufacturer: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  dosage: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  form: {
    type: DataTypes.ENUM("tablet", "capsule", "syrup", "injection", "cream", "drops", "other"),
    allowNull: true,
  },
  strength: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  isPrescriptionRequired: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
  category: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  sideEffects: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  contraindications: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
}, {
  tableName: "medicines",
  timestamps: true,
  paranoid: true,
});

export default Medicine;