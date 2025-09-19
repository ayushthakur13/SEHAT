import express from "express";
import { authMiddleware, requireRole } from "../middleware/auth.js";
import {
  registerPharmacy,
  loginPharmacy,
  getPharmacyProfile,
  updatePharmacyProfile,
  getMedicines,
  addMedicine,
  updateMedicine,
  getPrescriptions,
  updatePrescriptionStatus,
} from "../controllers/pharmacyController.js";

const router = express.Router();

// Public routes
router.post("/register", registerPharmacy);
router.post("/login", loginPharmacy);

// Protected routes (Pharmacy only)
router.use(authMiddleware);
router.use(requireRole(["pharmacy"]));

router.get("/profile", getPharmacyProfile);
router.put("/profile", updatePharmacyProfile);
router.get("/medicines", getMedicines);
router.post("/medicines", addMedicine);
router.put("/medicines/:id", updateMedicine);
router.get("/prescriptions", getPrescriptions);
router.put("/prescriptions/:id/status", updatePrescriptionStatus);

export default router;
