import bcrypt from "bcryptjs";
import { Patient } from "../models/index.js";
import { generateToken } from "../middleware/auth.js";
import { patientService } from "../services/patientService.js";

// Register a new patient
export const registerPatient = async (req, res) => {
  try {
    const { name, email, phone, password, dateOfBirth, gender, address } = req.body;

    // Check if patient already exists
    const existingPatient = await Patient.findOne({ where: { email } });
    if (existingPatient) {
      return res.status(400).json({ message: "Patient already exists with this email" });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);

    // Create patient
    const patient = await Patient.create({
      name,
      email,
      phone,
      password: hashedPassword,
      dateOfBirth,
      gender,
      address,
    });

    // Generate token
    const token = generateToken({
      userId: patient.id,
      userType: "patient",
    });

    res.status(201).json({
      message: "Patient registered successfully",
      token,
      patient: {
        id: patient.id,
        name: patient.name,
        email: patient.email,
        phone: patient.phone,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Error registering patient", error: error.message });
  }
};

// Login patient
export const loginPatient = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find patient
    const patient = await Patient.findOne({ where: { email } });
    if (!patient) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Check password
    const isValidPassword = await bcrypt.compare(password, patient.password);
    if (!isValidPassword) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Generate token
    const token = generateToken({
      userId: patient.id,
      userType: "patient",
    });

    res.json({
      message: "Login successful",
      token,
      patient: {
        id: patient.id,
        name: patient.name,
        email: patient.email,
        phone: patient.phone,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Error logging in", error: error.message });
  }
};

// Get patient profile
export const getPatientProfile = async (req, res) => {
  try {
    const patient = await patientService.getPatientProfile(req.user.id);
    res.json({ patient });
  } catch (error) {
    res.status(500).json({ message: "Error fetching profile", error: error.message });
  }
};

// Update patient profile
export const updatePatientProfile = async (req, res) => {
  try {
    const updatedPatient = await patientService.updatePatientProfile(req.user.id, req.body);
    res.json({ message: "Profile updated successfully", patient: updatedPatient });
  } catch (error) {
    res.status(500).json({ message: "Error updating profile", error: error.message });
  }
};
