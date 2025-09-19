import bcrypt from "bcryptjs";
import { User, Patient, Doctor, Pharmacy, sequelize } from "../models/index.js";
import { generateToken } from "../middleware/auth.js";
import { Op } from "sequelize";

class AuthService {
  // Unified registration - creates ONLY User record, role-specific records created on verification
  async registerUser({ name, phone, email, password, gender, dateOfBirth, role, preferredLanguage }) {
    const transaction = await sequelize.transaction();
    
    try {
      // Check if user already exists by phone or email
      const existingUser = await User.findOne({
        where: {
          [Op.or]: [
            { phone },
            ...(email ? [{ email }] : [])
          ]
        }
      });

      if (existingUser) {
        throw new Error('User already exists with this phone number or email');
      }

      // Hash password
      const hashedPassword = await bcrypt.hash(password, 12);

      // Create ONLY User record - no role-specific records yet
      const user = await User.create({
        name,
        phone,
        email,
        password: hashedPassword,
        role,
        preferredLanguage,
        gender,
        dateOfBirth,
        isVerified: role === 'patient' // Only patients are auto-verified
      }, { transaction });

      // For patients, create Patient record immediately since no verification needed
      if (role === 'patient') {
        await Patient.create({
          userId: user.id
        }, { transaction });
      }
      // For doctors and pharmacies, role-specific records will be created during verification

      await transaction.commit();

      // Generate token
      const token = generateToken({
        userId: user.id,
        userType: role,
      });

      return {
        token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          role: user.role,
          preferredLanguage: user.preferredLanguage,
          isVerified: user.isVerified,
          needsVerification: role !== 'patient'
        }
      };
    } catch (error) {
      await transaction.rollback();
      throw error;
    }
  }

  // Unified login - accepts phone/email and password
  async loginUser(identifier, password) {
    // Find user by phone or email
    const user = await User.findOne({
      where: {
        [Op.or]: [
          { phone: identifier },
          { email: identifier }
        ]
      },
      include: [
        { model: Patient, as: 'patient' },
        { model: Doctor, as: 'doctor' },
        { model: Pharmacy, as: 'pharmacy' }
      ]
    });

    if (!user) {
      throw new Error('Invalid credentials');
    }

    // Check password
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      throw new Error('Invalid credentials');
    }

    if (!user.isActive) {
      throw new Error('Account is deactivated. Please contact support.');
    }

    // Update last login
    await user.update({ lastLoginAt: new Date() });

    // Generate token
    const token = generateToken({
      userId: user.id,
      userType: user.role,
    });

    // Get role-specific data
    let roleSpecificData = {};
    switch (user.role) {
      case 'doctor':
        if (user.doctor) {
          roleSpecificData = {
            specialization: user.doctor.specialization,
            isVerified: user.doctor.isVerified
          };
        }
        break;
      case 'pharmacy':
        if (user.pharmacy) {
          roleSpecificData = {
            address: user.pharmacy.address,
            isVerified: user.pharmacy.isVerified
          };
        }
        break;
    }

    return {
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        preferredLanguage: user.preferredLanguage,
        isVerified: user.isVerified,
        ...roleSpecificData
      }
    };
  }

  // Doctor verification - creates Doctor record with verification data
  async verifyDoctor(userId, verificationData) {
    const { hospitalId, specialization, experience, languages, currentHospitalClinic, pincode } = verificationData;
    
    const transaction = await sequelize.transaction();
    
    try {
      // Find user
      const user = await User.findByPk(userId);
      
      if (!user || user.role !== 'doctor') {
        throw new Error('Invalid user or user is not a doctor');
      }
      
      if (user.isVerified) {
        throw new Error('Doctor is already verified');
      }
      
      // Check if Doctor record already exists
      let doctorRecord = await Doctor.findOne({ where: { userId } });
      
      if (doctorRecord) {
        // Update existing doctor record
        await doctorRecord.update({
          hospitalId,
          specialization,
          experience,
          languages: Array.isArray(languages) ? languages : [languages],
          currentHospitalClinic,
          pincode,
          isVerified: true,
          verificationData: {
            verifiedAt: new Date(),
            ...verificationData
          }
        }, { transaction });
      } else {
        // Create new doctor record with verification data
        doctorRecord = await Doctor.create({
          userId,
          hospitalId,
          specialization,
          experience,
          languages: Array.isArray(languages) ? languages : [languages],
          currentHospitalClinic,
          pincode,
          isVerified: true,
          verificationData: {
            verifiedAt: new Date(),
            ...verificationData
          }
        }, { transaction });
      }
      
      // Update user verification status
      await user.update({ isVerified: true }, { transaction });
      
      await transaction.commit();
      
      return {
        message: 'Doctor verification completed successfully',
        isVerified: true
      };
    } catch (error) {
      await transaction.rollback();
      throw error;
    }
  }

  // Pharmacy verification - creates Pharmacy record with verification data
  async verifyPharmacy(userId, verificationData) {
    const { storeName, licenseNumber, gstNumber, address, city, state, pincode, workingHours } = verificationData;
    
    const transaction = await sequelize.transaction();
    
    try {
      // Find user
      const user = await User.findByPk(userId);
      
      if (!user || user.role !== 'pharmacy') {
        throw new Error('Invalid user or user is not a pharmacy owner');
      }
      
      if (user.isVerified) {
        throw new Error('Pharmacy is already verified');
      }
      
      // Check if Pharmacy record already exists
      let pharmacyRecord = await Pharmacy.findOne({ where: { userId } });
      
      if (pharmacyRecord) {
        // Update existing pharmacy record
        await pharmacyRecord.update({
          storeName,
          licenseNumber,
          gstNumber,
          address,
          city,
          state,
          pincode,
          workingHours,
          isVerified: true,
          verificationData: {
            verifiedAt: new Date(),
            ...verificationData
          }
        }, { transaction });
      } else {
        // Create new pharmacy record with verification data
        pharmacyRecord = await Pharmacy.create({
          userId,
          storeName,
          licenseNumber,
          gstNumber,
          address,
          city,
          state,
          pincode,
          workingHours,
          isVerified: true,
          verificationData: {
            verifiedAt: new Date(),
            ...verificationData
          }
        }, { transaction });
      }
      
      // Update user verification status
      await user.update({ isVerified: true }, { transaction });
      
      await transaction.commit();
      
      return {
        message: 'Pharmacy verification completed successfully',
        isVerified: true
      };
    } catch (error) {
      await transaction.rollback();
      throw error;
    }
  }

  async refreshToken(refreshToken) {
    // In a real implementation, you would validate the refresh token
    // For now, we'll just return an error
    throw new Error('Refresh token functionality not implemented yet');
  }
}

export const authService = new AuthService();
