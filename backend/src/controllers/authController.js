import bcrypt from "bcryptjs";
import { User, Patient, Doctor, Pharmacy } from "../models/index.js";
import { generateToken } from "../middleware/auth.js";
import { authService } from "../services/authService.js";

class AuthController {
  // Unified Registration
  async register(req, res) {
    try {
      const { name, phone, email, password, gender, dateOfBirth, role, preferredLanguage } = req.body;

      // Validation
      if (!name || !phone || !password || !role) {
        return res.status(400).json({
          status: 'error',
          message: 'Name, phone, password, and role are required'
        });
      }

      if (!['patient', 'doctor', 'pharmacy'].includes(role)) {
        return res.status(400).json({
          status: 'error',
          message: 'Invalid role. Must be patient, doctor, or pharmacy'
        });
      }

      const result = await authService.registerUser({
        name, 
        phone, 
        email, 
        password, 
        gender, 
        dateOfBirth, 
        role, 
        preferredLanguage
      });

      res.status(201).json({
        status: 'success',
        message: `${role.charAt(0).toUpperCase() + role.slice(1)} registered successfully`,
        data: result
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Unified Login
  async login(req, res) {
    try {
      const { identifier, password } = req.body; // identifier can be phone or email

      if (!identifier || !password) {
        return res.status(400).json({
          status: 'error',
          message: 'Phone/email and password are required'
        });
      }

      const result = await authService.loginUser(identifier, password);
      
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

  // Doctor Verification
  async verifyDoctor(req, res) {
    try {
      const userId = req.user.id;
      const { hospitalId, specialization, experience, languages, currentHospitalClinic, pincode } = req.body;

      if (!hospitalId || !specialization || !pincode) {
        return res.status(400).json({
          status: 'error',
          message: 'Hospital ID, specialization, and pincode are required'
        });
      }

      const result = await authService.verifyDoctor(userId, {
        hospitalId,
        specialization,
        experience,
        languages,
        currentHospitalClinic,
        pincode
      });

      res.json({
        status: 'success',
        message: result.message,
        data: { isVerified: result.isVerified }
      });
    } catch (error) {
      res.status(400).json({
        status: 'error',
        message: error.message
      });
    }
  }

  // Pharmacy Verification
  async verifyPharmacy(req, res) {
    try {
      const userId = req.user.id;
      const { storeName, licenseNumber, gstNumber, address, city, state, pincode, workingHours } = req.body;

      if (!storeName || (!licenseNumber && !gstNumber) || !address || !pincode) {
        return res.status(400).json({
          status: 'error',
          message: 'Store name, license number or GST number, address, and pincode are required'
        });
      }

      const result = await authService.verifyPharmacy(userId, {
        storeName,
        licenseNumber,
        gstNumber,
        address,
        city,
        state,
        pincode,
        workingHours
      });

      res.json({
        status: 'success',
        message: result.message,
        data: { isVerified: result.isVerified }
      });
    } catch (error) {
      res.status(400).json({
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
