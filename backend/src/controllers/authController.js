import bcrypt from "bcryptjs";
import { Patient, Doctor, Pharmacy } from "../models/index.js";
import { generateToken } from "../middleware/auth.js";
import { authService } from "../services/authService.js";

class AuthController {
  // Register Patient
  async registerPatient(req, res) {
    try {
      const { name, email, phone, password, dateOfBirth, gender, address, preferredLanguage } = req.body;

      const result = await authService.registerUser({
        userType: 'patient',
        userData: { name, email, phone, password, dateOfBirth, gender, address, preferredLanguage }
      });

      res.status(201).json({
        status: 'success',
        message: 'Patient registered successfully',
        data: result
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Register Doctor
  async registerDoctor(req, res) {
    try {
      const { name, email, phone, password, licenseNumber, specialization, experience, consultationFee, languages } = req.body;

      const result = await authService.registerUser({
        userType: 'doctor',
        userData: { name, email, phone, password, licenseNumber, specialization, experience, consultationFee, languages }
      });

      res.status(201).json({
        status: 'success',
        message: 'Doctor registered successfully',
        data: result
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Register Pharmacy
  async registerPharmacy(req, res) {
    try {
      const { name, email, phone, password, licenseNumber, address, city, state, pincode, workingHours } = req.body;

      const result = await authService.registerUser({
        userType: 'pharmacy',
        userData: { name, email, phone, password, licenseNumber, address, city, state, pincode, workingHours }
      });

      res.status(201).json({
        status: 'success',
        message: 'Pharmacy registered successfully',
        data: result
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Login Patient
  async loginPatient(req, res) {
    try {
      const { email, password } = req.body;
      const result = await authService.loginUser('patient', email, password);
      
      res.json({
        status: 'success',
        message: 'Login successful',
        data: result
      });
    } catch (error) {
      res.status(401).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Login Doctor
  async loginDoctor(req, res) {
    try {
      const { email, password } = req.body;
      const result = await authService.loginUser('doctor', email, password);
      
      res.json({
        status: 'success',
        message: 'Login successful',
        data: result
      });
    } catch (error) {
      res.status(401).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Login Pharmacy
  async loginPharmacy(req, res) {
    try {
      const { email, password } = req.body;
      const result = await authService.loginUser('pharmacy', email, password);
      
      res.json({
        status: 'success',
        message: 'Login successful',
        data: result
      });
    } catch (error) {
      res.status(401).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Refresh Token
  async refreshToken(req, res) {
    try {
      const { refreshToken } = req.body;
      const result = await authService.refreshToken(refreshToken);
      
      res.json({
        status: 'success',
        message: 'Token refreshed successfully',
        data: result
      });
    } catch (error) {
      res.status(401).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Logout
  async logout(req, res) {
    try {
      // In a real implementation, you might want to blacklist the token
      res.json({
        status: 'success',
        message: 'Logout successful'
      });
    } catch (error) {
      res.status(500).json({
        status: 'error',
        message: 'Error during logout'
      });
    }
  }
}

export const authController = new AuthController();
