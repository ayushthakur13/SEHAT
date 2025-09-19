// Global error handling middleware
export const errorHandler = (err, req, res, next) => {
  console.error("Error:", err);

  // Sequelize validation errors
  if (err.name === "SequelizeValidationError") {
    const errors = err.errors.map(e => ({
      field: e.path,
      message: e.message
    }));
    return res.status(400).json({
      status: 'error',
      message: 'Validation error',
      errors
    });
  }

  // Sequelize unique constraint errors
  if (err.name === "SequelizeUniqueConstraintError") {
    return res.status(400).json({
      status: 'error',
      message: 'Duplicate entry',
      field: err.errors[0].path
    });
  }

  // Sequelize foreign key constraint errors
  if (err.name === "SequelizeForeignKeyConstraintError") {
    return res.status(400).json({
      status: 'error',
      message: 'Invalid reference to related record'
    });
  }

  // JWT errors
  if (err.name === "JsonWebTokenError") {
    return res.status(401).json({
      status: 'error',
      message: 'Invalid token'
    });
  }

  if (err.name === "TokenExpiredError") {
    return res.status(401).json({
      status: 'error',
      message: 'Token expired'
    });
  }

  // Validation errors (Joi)
  if (err.isJoi) {
    return res.status(400).json({
      status: 'error',
      message: 'Validation error',
      details: err.details
    });
  }

  // Default error
  const status = err.status || 500;
  const message = err.message || 'Internal server error';

  res.status(status).json({
    status: 'error',
    message,
    ...(process.env.NODE_ENV === "development" && { stack: err.stack })
  });
};