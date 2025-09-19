import { Op } from "sequelize";
import { Medicine, PharmacyStock, Pharmacy } from "../models/index.js";

class MedicineService {
  async searchMedicines({ q, category, form }) {
    const whereClause = { isActive: true };
    
    if (q) {
      whereClause[Op.or] = [
        { name: { [Op.iLike]: `%${q}%` } },
        { genericName: { [Op.iLike]: `%${q}%` } }
      ];
    }

    if (category) {
      whereClause.category = category;
    }

    if (form) {
      whereClause.form = form;
    }

    const medicines = await Medicine.findAll({
      where: whereClause,
      order: [['name', 'ASC']],
      limit: 50
    });

    return medicines;
  }

  async getCategories() {
    const categories = await Medicine.findAll({
      attributes: ['category'],
      where: {
        category: { [Op.ne]: null },
        isActive: true
      },
      group: ['category'],
      order: [['category', 'ASC']]
    });

    return categories.map(c => c.category);
  }

  async checkAvailability(medicineId, city, pincode) {
    const whereClause = {
      medicineId,
      isAvailable: true,
      quantity: { [Op.gt]: 0 }
    };

    if (city) {
      whereClause['$pharmacy.city$'] = city;
    }

    if (pincode) {
      whereClause['$pharmacy.pincode$'] = pincode;
    }

    const stocks = await PharmacyStock.findAll({
      where: whereClause,
      include: [
        { 
          model: Pharmacy, 
          as: 'pharmacy', 
          attributes: ['id', 'name', 'address', 'city', 'pincode', 'phone'],
          where: { isActive: true }
        },
        { 
          model: Medicine, 
          as: 'medicine', 
          attributes: ['id', 'name', 'form', 'strength'] 
        }
      ],
      order: [['quantity', 'DESC']]
    });

    return stocks;
  }

  async getMedicines(filters = {}) {
    const whereClause = { isActive: true };
    
    if (filters.search) {
      whereClause[Op.or] = [
        { name: { [Op.iLike]: `%${filters.search}%` } },
        { genericName: { [Op.iLike]: `%${filters.search}%` } }
      ];
    }

    if (filters.category) {
      whereClause.category = filters.category;
    }

    const medicines = await Medicine.findAll({
      where: whereClause,
      order: [['name', 'ASC']],
      limit: filters.limit || 20,
      offset: ((filters.page || 1) - 1) * (filters.limit || 20)
    });

    return medicines;
  }

  async addMedicine(medicineData) {
    const medicine = await Medicine.create(medicineData);
    return medicine;
  }

  async updateMedicine(medicineId, updateData) {
    const medicine = await Medicine.findByPk(medicineId);
    
    if (!medicine) {
      throw new Error('Medicine not found');
    }

    await medicine.update(updateData);
    return medicine;
  }

  async updateStock(pharmacyId, medicineId, stockData) {
    let stock = await PharmacyStock.findOne({
      where: { pharmacyId, medicineId }
    });

    if (stock) {
      await stock.update({
        ...stockData,
        lastUpdated: new Date()
      });
    } else {
      stock = await PharmacyStock.create({
        pharmacyId,
        medicineId,
        ...stockData,
        lastUpdated: new Date()
      });
    }

    return stock;
  }
}

export const medicineService = new MedicineService();
