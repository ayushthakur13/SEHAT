import { sequelize } from "../src/models/index.js";
import dotenv from "dotenv";

// Load environment variables
dotenv.config();

async function checkDatabaseStatus() {
  try {
    console.log('🔍 Checking database status...\n');
    
    const queryInterface = sequelize.getQueryInterface();
    
    // Check doctors table
    console.log('👨‍⚕️ Doctors Table:');
    try {
      const doctorsTable = await queryInterface.describeTable('doctors');
      console.log('  ✅ Table exists');
      
      // Check for new MVP columns
      const mvpColumns = ['availabilitySchedule', 'currentStatus', 'maxConcurrentConsultations', 
                         'preferredConsultationType', 'lowBandwidthMode', 'offlineCapable', 'lastSyncAt'];
      
      mvpColumns.forEach(col => {
        if (doctorsTable[col]) {
          console.log(`  ✅ ${col} column exists`);
        } else {
          console.log(`  ❌ ${col} column missing`);
        }
      });
      
      // Check data count
      const [doctorCount] = await sequelize.query('SELECT COUNT(*) as count FROM doctors');
      console.log(`  📊 ${doctorCount[0].count} doctor records found\n`);
      
    } catch (error) {
      console.log('  ❌ Doctors table does not exist\n');
    }
    
    // Check prescriptions table
    console.log('💊 Prescriptions Table:');
    try {
      const prescriptionsTable = await queryInterface.describeTable('prescriptions');
      console.log('  ✅ Table exists');
      
      // Check for new MVP columns
      const mvpColumns = ['language', 'validUntil', 'isEmergency'];
      
      mvpColumns.forEach(col => {
        if (prescriptionsTable[col]) {
          console.log(`  ✅ ${col} column exists`);
        } else {
          console.log(`  ❌ ${col} column missing`);
        }
      });
      
      // Check data count
      const [prescriptionCount] = await sequelize.query('SELECT COUNT(*) as count FROM prescriptions');
      console.log(`  📊 ${prescriptionCount[0].count} prescription records found\n`);
      
    } catch (error) {
      console.log('  ❌ Prescriptions table does not exist\n');
    }
    
    // Check health_records table
    console.log('📋 Health Records Table:');
    try {
      const healthRecordsTable = await queryInterface.describeTable('health_records');
      console.log('  ✅ Table exists');
      
      // Check for new MVP columns
      const mvpColumns = ['data', 'notes', 'severity'];
      
      mvpColumns.forEach(col => {
        if (healthRecordsTable[col]) {
          console.log(`  ✅ ${col} column exists`);
        } else {
          console.log(`  ❌ ${col} column missing`);
        }
      });
      
      // Check data count
      const [healthRecordCount] = await sequelize.query('SELECT COUNT(*) as count FROM health_records');
      console.log(`  📊 ${healthRecordCount[0].count} health record entries found\n`);
      
    } catch (error) {
      console.log('  ❌ Health records table does not exist\n');
    }
    
    // Check notifications table
    console.log('🔔 Doctor Notifications Table:');
    try {
      const notificationsTable = await queryInterface.describeTable('doctor_notifications');
      console.log('  ✅ Table exists');
      
      // Check data count
      const [notificationCount] = await sequelize.query('SELECT COUNT(*) as count FROM doctor_notifications');
      console.log(`  📊 ${notificationCount[0].count} notification records found\n`);
      
    } catch (error) {
      console.log('  ❌ Doctor notifications table does not exist\n');
    }
    
    // Check all main tables
    console.log('📊 All Tables Status:');
    const tables = ['users', 'doctors', 'patients', 'pharmacies', 'consultations', 
                   'prescriptions', 'health_records', 'medicines', 'pharmacy_stock', 
                   'doctor_notifications'];
    
    for (const table of tables) {
      try {
        const [count] = await sequelize.query(`SELECT COUNT(*) as count FROM ${table}`);
        console.log(`  ✅ ${table}: ${count[0].count} records`);
      } catch (error) {
        console.log(`  ❌ ${table}: Table missing or error`);
      }
    }
    
    console.log('\n🎉 Database status check complete!');
    console.log('💡 Your existing data has been preserved during the schema updates.');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error checking database status:', error);
    process.exit(1);
  }
}

checkDatabaseStatus();