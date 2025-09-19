import { sequelize } from "../src/models/index.js";
import dotenv from "dotenv";

// Load environment variables
dotenv.config();

async function resetDatabase() {
  try {
    console.log('🔄 Starting database reset...');
    
    // Force sync all models (this will drop and recreate tables)
    await sequelize.sync({ force: true });
    
    console.log('✅ Database reset completed successfully!');
    console.log('📝 All tables have been recreated with the new schema.');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error resetting database:', error);
    process.exit(1);
  }
}

resetDatabase();