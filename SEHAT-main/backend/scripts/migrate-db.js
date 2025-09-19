import { sequelize } from "../src/models/index.js";
import dotenv from "dotenv";

// Load environment variables
dotenv.config();

async function migrateDatabase() {
  try {
    console.log('🔄 Starting database migration...');
    
    const queryInterface = sequelize.getQueryInterface();
    
    // Check if we need to add new columns to existing tables
    console.log('📋 Checking for required schema updates...');
    
    // Check and add new columns to doctors table
    try {
      const doctorsTableInfo = await queryInterface.describeTable('doctors');
      
      if (!doctorsTableInfo.availabilitySchedule) {
        console.log('➕ Adding availabilitySchedule column to doctors table...');
        await queryInterface.addColumn('doctors', 'availabilitySchedule', {
          type: sequelize.Sequelize.JSON,
          allowNull: true
        });
      }
      
      if (!doctorsTableInfo.currentStatus) {
        console.log('➕ Adding currentStatus column to doctors table...');
        await queryInterface.addColumn('doctors', 'currentStatus', {
          type: sequelize.Sequelize.ENUM('available', 'busy', 'offline', 'in_consultation'),
          defaultValue: 'offline',
          allowNull: true
        });
      }
      
      if (!doctorsTableInfo.maxConcurrentConsultations) {
        console.log('➕ Adding maxConcurrentConsultations column to doctors table...');
        await queryInterface.addColumn('doctors', 'maxConcurrentConsultations', {
          type: sequelize.Sequelize.INTEGER,
          defaultValue: 1,
          allowNull: true
        });
      }
      
      if (!doctorsTableInfo.preferredConsultationType) {
        console.log('➕ Adding preferredConsultationType column to doctors table...');
        await queryInterface.addColumn('doctors', 'preferredConsultationType', {
          type: sequelize.Sequelize.ENUM('video', 'audio', 'both'),
          defaultValue: 'both',
          allowNull: true
        });
      }
      
      if (!doctorsTableInfo.lowBandwidthMode) {
        console.log('➕ Adding lowBandwidthMode column to doctors table...');
        await queryInterface.addColumn('doctors', 'lowBandwidthMode', {
          type: sequelize.Sequelize.BOOLEAN,
          defaultValue: false,
          allowNull: true
        });
      }
      
      if (!doctorsTableInfo.offlineCapable) {
        console.log('➕ Adding offlineCapable column to doctors table...');
        await queryInterface.addColumn('doctors', 'offlineCapable', {
          type: sequelize.Sequelize.BOOLEAN,
          defaultValue: true,
          allowNull: true
        });
      }
      
      if (!doctorsTableInfo.lastSyncAt) {
        console.log('➕ Adding lastSyncAt column to doctors table...');
        await queryInterface.addColumn('doctors', 'lastSyncAt', {
          type: sequelize.Sequelize.DATE,
          allowNull: true
        });
      }
    } catch (error) {
      console.log('⚠️  Doctors table might not exist yet, will be created automatically');
    }
    
    // Check and add new columns to prescriptions table
    try {
      const prescriptionsTableInfo = await queryInterface.describeTable('prescriptions');
      
      if (!prescriptionsTableInfo.language) {
        console.log('➕ Adding language column to prescriptions table...');
        await queryInterface.addColumn('prescriptions', 'language', {
          type: sequelize.Sequelize.ENUM('english', 'hindi', 'punjabi'),
          defaultValue: 'english',
          allowNull: true
        });
      }
      
      if (!prescriptionsTableInfo.validUntil) {
        console.log('➕ Adding validUntil column to prescriptions table...');
        await queryInterface.addColumn('prescriptions', 'validUntil', {
          type: sequelize.Sequelize.DATE,
          allowNull: true
        });
      }
      
      if (!prescriptionsTableInfo.isEmergency) {
        console.log('➕ Adding isEmergency column to prescriptions table...');
        await queryInterface.addColumn('prescriptions', 'isEmergency', {
          type: sequelize.Sequelize.BOOLEAN,
          defaultValue: false,
          allowNull: true
        });
      }
    } catch (error) {
      console.log('⚠️  Prescriptions table might not exist yet, will be created automatically');
    }
    
    // Check and add new columns to health_records table
    try {
      const healthRecordsTableInfo = await queryInterface.describeTable('health_records');
      
      if (!healthRecordsTableInfo.data) {
        console.log('➕ Adding data column to health_records table...');
        await queryInterface.addColumn('health_records', 'data', {
          type: sequelize.Sequelize.JSON,
          allowNull: true
        });
      }
      
      if (!healthRecordsTableInfo.notes) {
        console.log('➕ Adding notes column to health_records table...');
        await queryInterface.addColumn('health_records', 'notes', {
          type: sequelize.Sequelize.TEXT,
          allowNull: true
        });
      }
      
      if (!healthRecordsTableInfo.severity) {
        console.log('➕ Adding severity column to health_records table...');
        await queryInterface.addColumn('health_records', 'severity', {
          type: sequelize.Sequelize.ENUM('low', 'medium', 'high', 'critical'),
          allowNull: true
        });
      }
    } catch (error) {
      console.log('⚠️  Health_records table might not exist yet, will be created automatically');
    }
    
    // Create any missing tables (but don't alter existing ones)
    console.log('🔄 Creating any missing tables...');
    await sequelize.sync({ alter: false, force: false });
    
    console.log('✅ Database migration completed successfully!');
    console.log('📊 Your existing data has been preserved.');
    console.log('🆕 New columns and tables have been added as needed.');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error during database migration:', error);
    console.log('💡 If you encounter issues, you can still use the reset script: npm run db:reset');
    process.exit(1);
  }
}

migrateDatabase();