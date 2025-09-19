import express from 'express';
import { authLimiter, generalLimiter } from '../middleware/rateLimiter.js';

const router = express.Router();

// Development-only route to reset rate limits
router.post('/reset-rate-limits', (req, res) => {
  if (process.env.NODE_ENV !== 'development') {
    return res.status(403).json({
      status: 'error',
      message: 'This endpoint is only available in development mode'
    });
  }

  try {
    // Reset rate limit stores
    authLimiter.resetKey(req.ip || req.connection.remoteAddress);
    generalLimiter.resetKey(req.ip || req.connection.remoteAddress);

    res.json({
      status: 'success',
      message: 'Rate limits reset successfully',
      ip: req.ip || req.connection.remoteAddress,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to reset rate limits',
      error: error.message
    });
  }
});

// Get current rate limit status
router.get('/rate-limit-status', (req, res) => {
  if (process.env.NODE_ENV !== 'development') {
    return res.status(403).json({
      status: 'error',
      message: 'This endpoint is only available in development mode'
    });
  }

  res.json({
    status: 'success',
    message: 'Rate limit status',
    ip: req.ip || req.connection.remoteAddress,
    environment: process.env.NODE_ENV,
    timestamp: new Date().toISOString(),
    note: 'Rate limiting is now environment-aware. Check console logs for detailed information.'
  });
});

export default router;
