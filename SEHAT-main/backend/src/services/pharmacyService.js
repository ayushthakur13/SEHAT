import { Op } from "sequelize";
import { Pharmacy, Medicine, Prescription, Patient, Doctor } from "../models/index.js";

class PharmacyService {
  // Get pharmacy profile
  async getPharmacyProfile(pharmacyId) {
    try {
      const pharmacy = await Pharmacy.findByPk(pharmacyId, {
        attributes: { exclude: ["password"] },
      });

      if (!pharmacy) {
        throw new Error("Pharmacy not found");
      }

      return pharmacy;
    } catch (error) {
      throw error;
    }
  }

  // Update pharmacy profile
  async updatePharmacyProfile(pharmacyId, updateData) {
    try {
      const allowedFields = [
        "name",
        "phone",
        "address",
        "city",
        "state",
        "pincode",
      ];

      const filteredData = Object.keys(updateData)
        .filter(key => allowedFields.includes(key))
        .reduce((obj, key) => {
          obj[key] = updateData[key];
          return obj;
        }, {});

      const [updatedRowsCount] = await Pharmacy.update(filteredData, {
        where: { id: pharmacyId },
      });

      if (updatedRowsCount === 0) {
        throw new Error("Pharmacy not found or no changes made");
      }

      const updatedPharmacy = await Pharmacy.findByPk(pharmacyId, {
        attributes: { exclude: ["password"] },
      });

      return updatedPharmacy;
    } catch (error) {
      throw error;
    }
  }

  // Get medicines
  async getMedicines(filters = {}) {
    try {
      const whereClause = { isActive: true };
      
      if (filters.search) {
        whereClause[Op.or] = [
          { name: { [Op.iLike]: `%${filters.search}%` } },
          { genericName: { [Op.iLike]: `%${filters.search}%` } },
        ];
      }

      if (filters.form) {
        whereClause.form = filters.form;
      }

      const medicines = await Medicine.findAll({
        where: whereClause,
        order: [["name", "ASC"]],
        limit: filters.limit || 100,
      });

      return medicines;
    } catch (error) {
      throw error;
    }
  }

  // Add medicine
  async addMedicine(medicineData) {
    try {
      const medicine = await Medicine.create(medicineData);
      return medicine;
    } catch (error) {
      throw error;
    }
  }

  // Update medicine
  async updateMedicine(medicineId, updateData) {
    try {
      const medicine = await Medicine.findByPk(medicineId);
      
      if (!medicine) {
        throw new Error("Medicine not found");
      }

      await medicine.update(updateData);
      return medicine;
    } catch (error) {
      throw error;
    }
  }

  // Get prescriptions for pharmacy
  async getPrescriptions(pharmacyId, filters = {}) {
    try {
      const whereClause = { pharmacyId };
      
      if (filters.status) {
        whereClause.status = filters.status;
      }

      const prescriptions = await Prescription.findAll({
        where: whereClause,
        include: [
          "patient",
          "doctor",
          "medicines",
        ],
        order: [["createdAt", "DESC"]],
        limit: filters.limit || 50,
      });

      return prescriptions;
    } catch (error) {
      throw error;
    }
  }

  // Update prescription status
  async updatePrescriptionStatus(prescriptionId, pharmacyId, status) {
    try {
      const prescription = await Prescription.findOne({
        where: { id: prescriptionId, pharmacyId },
      });

      if (!prescription) {
        throw new Error("Prescription not found or unauthorized");
      }

      await prescription.update({
        status,
        dispensedAt: status === "dispensed" ? new Date() : null,
      });

      const updatedPrescription = await Prescription.findByPk(prescriptionId, {
        include: ["patient", "doctor", "medicines"],
      });

      return updatedPrescription;
    } catch (error) {
      throw error;
    }
  }

  // Search medicines by name or generic name
  async searchMedicines(searchTerm) {
    try {
      const medicines = await Medicine.findAll({
        where: {
          isActive: true,
          [Op.or]: [
            { name: { [Op.iLike]: `%${searchTerm}%` } },
            { genericName: { [Op.iLike]: `%${searchTerm}%` } },
          ],
        },
        order: [["name", "ASC"]],
        limit: 20,
      });

      return medicines;
    } catch (error) {
      throw error;
    }
  }
}

export const pharmacyService = new PharmacyService();
