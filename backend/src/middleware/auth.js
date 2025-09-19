import jwt from "jsonwebtoken";
import { User, Patient, Doctor, Pharmacy } from "../models/index.js";

const JWT_SECRET = process.env.JWT_SECRET || "sehat_secret_key_2025";

// Generate JWT token
export const generateToken = (payload) => {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: "24h" });
};

// Verify JWT token
export const verifyToken = (token) => {
  return jwt.verify(token, JWT_SECRET);
};

// Authentication middleware
export const authMiddleware = async (req, res, next) => {
  try {
    const token = req.header("Authorization")?.replace("Bearer ", "");
    
    if (!token) {
      return res.status(401).json({
        status: 'error',
        message: 'Access denied. No token provided.'
      });
    }

    const decoded = verifyToken(token);
    const { userId, userType } = decoded;

    // Find user with role-specific data
    const user = await User.findByPk(userId, {
      attributes: { exclude: ['password'] },
      include: [
        { model: Patient, as: 'patient', required: false },
        { model: Doctor, as: 'doctor', required: false },
        { model: Pharmacy, as: 'pharmacy', required: false }
      ]
    });

    if (!user) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid token. User not found.'
      });
    }

    if (!user.isActive) {
      return res.status(401).json({
        status: 'error',
        message: 'Account is deactivated. Please contact support.'
      });
    }

    // Verify userType matches the user's actual role
    if (user.role !== userType) {
      return res.status(401).json({
        status: 'error',
        message: 'Token user type mismatch.'
      });
    }

    req.user = user;
    req.userType = userType;
    next();
  } catch (error) {
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid token.'
      });
    }
    
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        status: 'error',
        message: 'Token expired. Please login again.'
      });
    }

    res.status(500).json({
      status: 'error',
      message: 'Server error during authentication.'
    });
  }
};

// Role-based middleware
export const requireRole = (roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.userType)) {
      return res.status(403).json({
        status: 'error',
        message: 'Access denied. Insufficient permissions.'
      });
    }
    next();
  };
};