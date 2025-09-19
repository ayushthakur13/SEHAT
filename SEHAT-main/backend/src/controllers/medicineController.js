import { medicineService } from "../services/medicineService.js";

class MedicineController {
  // Search medicines (Public)
  async searchMedicines(req, res) {
    try {
      const { q, category, form } = req.query;
      const medicines = await medicineService.searchMedicines({ q, category, form });

      res.json({
        status: 'success',
        data: medicines
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get categories (Public)
  async getCategories(req, res) {
    try {
      const categories = await medicineService.getCategories();

      res.json({
        status: 'success',
        data: categories
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Check medicine availability (Patient)
  async checkAvailability(req, res) {
    try {
      const { medicineId, city, pincode } = req.query;
      const availability = await medicineService.checkAvailability(medicineId, city, pincode);

      res.json({
        status: 'success',
        data: availability
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Get medicines (Pharmacy)
  async getMedicines(req, res) {
    try {
      const { search, category, page = 1, limit = 20 } = req.query;
      const medicines = await medicineService.getMedicines({
        search,
        category,
        page: parseInt(page),
        limit: parseInt(limit)
      });

      res.json({
        status: 'success',
        data: medicines
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Add medicine (Pharmacy)
  async addMedicine(req, res) {
    try {
      const medicineData = req.body;
      const medicine = await medicineService.addMedicine(medicineData);

      res.status(201).json({
        status: 'success',
        message: 'Medicine added successfully',
        data: medicine
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Update medicine (Pharmacy)
  async updateMedicine(req, res) {
    try {
      const { id } = req.params;
      const updateData = req.body;
      const medicine = await medicineService.updateMedicine(id, updateData);

      res.json({
        status: 'success',
        message: 'Medicine updated successfully',
        data: medicine
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Update stock (Pharmacy)
  async updateStock(req, res) {
    try {
      const { medicineId, quantity, price, expiryDate, batchNumber } = req.body;
      const pharmacyId = req.user.id;

      const stock = await medicineService.updateStock(pharmacyId, medicineId, {
        quantity,
        price,
        expiryDate,
        batchNumber
      });

      res.json({
        status: 'success',
        message: 'Stock updated successfully',
        data: stock
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }
}

export const medicineController = new MedicineController();
