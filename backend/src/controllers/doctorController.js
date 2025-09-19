import bcrypt from "bcryptjs";
import { Doctor, Consultation } from "../models/index.js";
import { generateToken } from "../middleware/auth.js";
import { doctorService } from "../services/doctorService.js";

// Register a new doctor
export const registerDoctor = async (req, res) => {
  try {
    const { 
      name, 
      email, 
      phone, 
      password, 
      licenseNumber, 
      specialization, 
      experience, 
      consultationFee 
    } = req.body;

    // Check if doctor already exists
    const existingDoctor = await Doctor.findOne({ where: { email } });
    if (existingDoctor) {
      return res.status(400).json({ message: "Doctor already exists with this email" });
    }

    // Check if license number already exists
    const existingLicense = await Doctor.findOne({ where: { licenseNumber } });
    if (existingLicense) {
      return res.status(400).json({ message: "Doctor already exists with this license number" });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);

    // Create doctor
    const doctor = await Doctor.create({
      name,
      email,
      phone,
      password: hashedPassword,
      licenseNumber,
      specialization,
      experience,
      consultationFee,
    });

    // Generate token
    const token = generateToken({
      userId: doctor.id,
      userType: "doctor",
    });

    res.status(201).json({
      message: "Doctor registered successfully",
      token,
      doctor: {
        id: doctor.id,
        name: doctor.name,
        email: doctor.email,
        phone: doctor.phone,
        specialization: doctor.specialization,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Error registering doctor", error: error.message });
  }
};

// Login doctor
export const loginDoctor = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find doctor
    const doctor = await Doctor.findOne({ where: { email } });
    if (!doctor) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Check password
    const isValidPassword = await bcrypt.compare(password, doctor.password);
    if (!isValidPassword) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Generate token
    const token = generateToken({
      userId: doctor.id,
      userType: "doctor",
    });

    res.json({
      message: "Login successful",
      token,
      doctor: {
        id: doctor.id,
        name: doctor.name,
        email: doctor.email,
        phone: doctor.phone,
        specialization: doctor.specialization,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Error logging in", error: error.message });
  }
};

// Get doctor profile
export const getDoctorProfile = async (req, res) => {
  try {
    const doctor = await doctorService.getDoctorProfile(req.user.id);
    res.json({ doctor });
  } catch (error) {
    res.status(500).json({ message: "Error fetching profile", error: error.message });
  }
};

// Update doctor profile
export const updateDoctorProfile = async (req, res) => {
  try {
    const updatedDoctor = await doctorService.updateDoctorProfile(req.user.id, req.body);
    res.json({ message: "Profile updated successfully", doctor: updatedDoctor });
  } catch (error) {
    res.status(500).json({ message: "Error updating profile", error: error.message });
  }
};

// Get doctor appointments
export const getDoctorAppointments = async (req, res) => {
  try {
    const appointments = await doctorService.getDoctorAppointments(req.user.id, req.query);
    res.json({ appointments });
  } catch (error) {
    res.status(500).json({ message: "Error fetching appointments", error: error.message });
  }
};

// Update appointment status
export const updateAppointmentStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, notes, diagnosis } = req.body;
    
    const appointment = await doctorService.updateAppointmentStatus(id, req.user.id, {
      status,
      notes,
      diagnosis,
    });
    
    res.json({ message: "Appointment updated successfully", appointment });
  } catch (error) {
    res.status(500).json({ message: "Error updating appointment", error: error.message });
  }
};
