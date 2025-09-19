import bcrypt from "bcryptjs";
import { Pharmacy, Medicine, Prescription } from "../models/index.js";
import { generateToken } from "../middleware/auth.js";
import { pharmacyService } from "../services/pharmacyService.js";

// Register a new pharmacy
export const registerPharmacy = async (req, res) => {
  try {
    const { 
      name, 
      email, 
      phone, 
      password, 
      licenseNumber, 
      address, 
      city, 
      state, 
      pincode 
    } = req.body;

    // Check if pharmacy already exists
    const existingPharmacy = await Pharmacy.findOne({ where: { email } });
    if (existingPharmacy) {
      return res.status(400).json({ message: "Pharmacy already exists with this email" });
    }

    // Check if license number already exists
    const existingLicense = await Pharmacy.findOne({ where: { licenseNumber } });
    if (existingLicense) {
      return res.status(400).json({ message: "Pharmacy already exists with this license number" });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);

    // Create pharmacy
    const pharmacy = await Pharmacy.create({
      name,
      email,
      phone,
      password: hashedPassword,
      licenseNumber,
      address,
      city,
      state,
      pincode,
    });

    // Generate token
    const token = generateToken({
      userId: pharmacy.id,
      userType: "pharmacy",
    });

    res.status(201).json({
      message: "Pharmacy registered successfully",
      token,
      pharmacy: {
        id: pharmacy.id,
        name: pharmacy.name,
        email: pharmacy.email,
        phone: pharmacy.phone,
        address: pharmacy.address,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Error registering pharmacy", error: error.message });
  }
};

// Login pharmacy
export const loginPharmacy = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find pharmacy
    const pharmacy = await Pharmacy.findOne({ where: { email } });
    if (!pharmacy) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Check password
    const isValidPassword = await bcrypt.compare(password, pharmacy.password);
    if (!isValidPassword) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Generate token
    const token = generateToken({
      userId: pharmacy.id,
      userType: "pharmacy",
    });

    res.json({
      message: "Login successful",
      token,
      pharmacy: {
        id: pharmacy.id,
        name: pharmacy.name,
        email: pharmacy.email,
        phone: pharmacy.phone,
        address: pharmacy.address,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Error logging in", error: error.message });
  }
};

// Get pharmacy profile
export const getPharmacyProfile = async (req, res) => {
  try {
    const pharmacy = await pharmacyService.getPharmacyProfile(req.user.id);
    res.json({ pharmacy });
  } catch (error) {
    res.status(500).json({ message: "Error fetching profile", error: error.message });
  }
};

// Update pharmacy profile
export const updatePharmacyProfile = async (req, res) => {
  try {
    const updatedPharmacy = await pharmacyService.updatePharmacyProfile(req.user.id, req.body);
    res.json({ message: "Profile updated successfully", pharmacy: updatedPharmacy });
  } catch (error) {
    res.status(500).json({ message: "Error updating profile", error: error.message });
  }
};

// Get medicines
export const getMedicines = async (req, res) => {
  try {
    const medicines = await pharmacyService.getMedicines(req.query);
    res.json({ medicines });
  } catch (error) {
    res.status(500).json({ message: "Error fetching medicines", error: error.message });
  }
};

// Add medicine
export const addMedicine = async (req, res) => {
  try {
    const medicine = await pharmacyService.addMedicine(req.body);
    res.status(201).json({ message: "Medicine added successfully", medicine });
  } catch (error) {
    res.status(500).json({ message: "Error adding medicine", error: error.message });
  }
};

// Update medicine
export const updateMedicine = async (req, res) => {
  try {
    const { id } = req.params;
    const medicine = await pharmacyService.updateMedicine(id, req.body);
    res.json({ message: "Medicine updated successfully", medicine });
  } catch (error) {
    res.status(500).json({ message: "Error updating medicine", error: error.message });
  }
};

// Get prescriptions
export const getPrescriptions = async (req, res) => {
  try {
    const prescriptions = await pharmacyService.getPrescriptions(req.user.id, req.query);
    res.json({ prescriptions });
  } catch (error) {
    res.status(500).json({ message: "Error fetching prescriptions", error: error.message });
  }
};

// Update prescription status
export const updatePrescriptionStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    
    const prescription = await pharmacyService.updatePrescriptionStatus(id, req.user.id, status);
    res.json({ message: "Prescription status updated successfully", prescription });
  } catch (error) {
    res.status(500).json({ message: "Error updating prescription status", error: error.message });
  }
};
