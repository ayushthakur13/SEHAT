import dotenv from 'dotenv';
import app from './app.js';
import { sequelize } from './config/database.js';
import { notificationService } from './services/notificationService.js';

// Load environment variables
dotenv.config();

const PORT = process.env.PORT || 5000;

// Database connection and server start
const startServer = async () => {
  try {
    // Test database connection
    await sequelize.authenticate();
    console.log('✅ Database connection established successfully.');
    
    // Sync database models (alter existing tables to match new schema)
    await sequelize.sync({ alter: true });
    console.log('✅ Database models synchronized.');
    
    // Start server
    app.listen(PORT, () => {
      console.log(`🚀 SEHAT Backend running on port ${PORT}`);
      console.log(`📱 Environment: ${process.env.NODE_ENV}`);
      console.log(`🔗 Health check: http://localhost:${PORT}/health`);
      console.log(`📱 Patient API: http://localhost:${PORT}/api/patients`);
      console.log(`👨‍⚕️ Doctor API: http://localhost:${PORT}/api/doctors`);
      console.log(`💊 Pharmacy API: http://localhost:${PORT}/api/pharmacies`);
      
      // Start notification service
      notificationService.startNotificationService();
      console.log(`🔔 Notification service started`);
    });
  } catch (error) {
    console.error('❌ Unable to start server:', error);
    process.exit(1);
  }
};

startServer();

export default app;