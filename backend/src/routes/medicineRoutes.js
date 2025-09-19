import express from "express";
import { authMiddleware, requireRole } from "../middleware/auth.js";
import { medicineController } from "../controllers/medicineController.js";

const router = express.Router();

// Public routes (for medicine search)
router.get("/search", medicineController.searchMedicines);
router.get("/categories", medicineController.getCategories);

// All other routes require authentication
router.use(authMiddleware);

// Patient routes
router.get("/availability", requireRole(["patient"]), medicineController.checkAvailability);

// Pharmacy routes
router.get("/", requireRole(["pharmacy"]), medicineController.getMedicines);
router.post("/", requireRole(["pharmacy"]), medicineController.addMedicine);
router.put("/:id", requireRole(["pharmacy"]), medicineController.updateMedicine);
router.post("/stock", requireRole(["pharmacy"]), medicineController.updateStock);

export default router;
