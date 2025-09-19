import { DataTypes } from "sequelize";
import { sequelize } from "../config/database.js";

const PrescriptionMedicine = sequelize.define("PrescriptionMedicine", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  prescriptionId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: "prescriptions",
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
  },
  dosage: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  frequency: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  duration: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  instructions: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  isDispensed: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  dispensedAt: {
    type: DataTypes.DATE,
    allowNull: true,
  },
}, {
  tableName: "prescription_medicines",
  timestamps: true,
  paranoid: true,
});

export default PrescriptionMedicine;