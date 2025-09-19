import { Sequelize } from 'sequelize';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

let sequelize;

// Common Sequelize options
const commonOptions = {
  define: {
    timestamps: true,
    paranoid: true, // Soft deletes
    underscored: true,
    freezeTableName: true
  },
  logging: process.env.ENABLE_SQL_LOGGING === 'true' ? console.log : false
};

// Use DB_DIALECT from environment variables
const dbDialect = process.env.DB_DIALECT || 'sqlite';

if (dbDialect === 'sqlite') {
  // SQLite configuration (Development/Offline)
  const dbStorage = process.env.DB_STORAGE || path.join(__dirname, '../../database/sehat.sqlite');
  const dbDir = path.dirname(dbStorage);
  
  // Ensure database directory exists
  if (!fs.existsSync(dbDir)) {
    fs.mkdirSync(dbDir, { recursive: true });
    console.log(`📁 Created database directory: ${dbDir}`);
  }
  
  sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: dbStorage,
    ...commonOptions
  });
  
  console.log(`🗄️  Using SQLite database: ${dbStorage}`);
  
} else if (dbDialect === 'postgres') {
  // PostgreSQL configuration (Supabase/Production)
  const databaseUrl = process.env.DATABASE_URL;
  
  if (databaseUrl) {
    // Using DATABASE_URL (recommended for Supabase)
    sequelize = new Sequelize(databaseUrl, {
      dialect: 'postgres',
      protocol: 'postgres',
      pool: {
        max: 10,
        min: 0,
        acquire: 30000,
        idle: 10000,
      },
      dialectOptions: {
        ssl: process.env.NODE_ENV === 'production' ? {
          require: true,
          rejectUnauthorized: false,
        } : false,
      },
      ...commonOptions
    });
    
    console.log(`🐘 Using PostgreSQL with DATABASE_URL`);
    
  } else {
    // Using discrete environment variables
    sequelize = new Sequelize(
      process.env.DB_NAME,
      process.env.DB_USER,
      process.env.DB_PASSWORD,
      {
        host: process.env.DB_HOST,
        port: process.env.DB_PORT || 5432,
        dialect: 'postgres',
        pool: {
          max: 10,
          min: 0,
          acquire: 30000,
          idle: 10000,
        },
        dialectOptions: {
          ssl: process.env.NODE_ENV === 'production' ? {
            require: true,
            rejectUnauthorized: false,
          } : false,
        },
        ...commonOptions
      }
    );
    
    console.log(`🐘 Using PostgreSQL: ${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`);
  }
  
} else {
  throw new Error(`Unsupported database dialect: ${dbDialect}. Only 'sqlite' and 'postgres' are supported.`);
}

export { sequelize };
