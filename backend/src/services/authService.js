import bcrypt from "bcryptjs";
import { Patient, Doctor, Pharmacy } from "../models/index.js";
import { generateToken } from "../middleware/auth.js";

class AuthService {
  async registerUser({ userType, userData }) {
    const { email, password } = userData;
    
    // Check if user already exists
    let existingUser;
    switch (userType) {
      case 'patient':
        existingUser = await Patient.findOne({ where: { email } });
        break;
      case 'doctor':
        existingUser = await Doctor.findOne({ where: { email } });
        break;
      case 'pharmacy':
        existingUser = await Pharmacy.findOne({ where: { email } });
        break;
      default:
        throw new Error('Invalid user type');
    }

    if (existingUser) {
      throw new Error(`${userType} already exists with this email`);
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);

    // Create user
    let user;
    switch (userType) {
      case 'patient':
        user = await Patient.create({ ...userData, password: hashedPassword });
        break;
      case 'doctor':
        user = await Doctor.create({ ...userData, password: hashedPassword });
        break;
      case 'pharmacy':
        user = await Pharmacy.create({ ...userData, password: hashedPassword });
        break;
    }

    // Generate token
    const token = generateToken({
      userId: user.id,
      userType: userType,
    });

    return {
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        userType: userType,
        ...(userType === 'doctor' && { specialization: user.specialization }),
        ...(userType === 'pharmacy' && { address: user.address }),
      }
    };
  }

  async loginUser(userType, email, password) {
    // Find user
    let user;
    switch (userType) {
      case 'patient':
        user = await Patient.findOne({ where: { email } });
        break;
      case 'doctor':
        user = await Doctor.findOne({ where: { email } });
        break;
      case 'pharmacy':
        user = await Pharmacy.findOne({ where: { email } });
        break;
      default:
        throw new Error('Invalid user type');
    }

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

    // Generate token
    const token = generateToken({
      userId: user.id,
      userType: userType,
    });

    return {
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        userType: userType,
        ...(userType === 'doctor' && { specialization: user.specialization }),
        ...(userType === 'pharmacy' && { address: user.address }),
      }
    };
  }

  async refreshToken(refreshToken) {
    // In a real implementation, you would validate the refresh token
    // For now, we'll just return an error
    throw new Error('Refresh token functionality not implemented yet');
  }
}

export const authService = new AuthService();
