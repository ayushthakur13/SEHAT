import { Sequelize } from 'sequelize';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

let sequelize;

if (process.env.NODE_ENV === 'production' || process.env.NODE_ENV === 'staging') {
  // PostgreSQL/MySQL configuration for production
  sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASSWORD,
    {
      host: process.env.DB_HOST,
      port: process.env.DB_PORT,
      dialect: process.env.DB_DIALECT || 'postgres',
      logging: false,
      pool: {
        max: 10,
        min: 0,
        acquire: 30000,
        idle: 10000
      },
      dialectOptions: {
        ssl: process.env.NODE_ENV === 'production' ? {
          require: true,
          rejectUnauthorized: false
        } : false
      },
      define: {
        timestamps: true,
        paranoid: true, // Soft deletes
        underscored: true,
        freezeTableName: true
      }
    }
  );
} else {
  // SQLite configuration for development
  const dbPath = path.join(__dirname, '../../database/sehat.sqlite');
  sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: dbPath,
    logging: false, // Disable SQL query logging
    define: {
      timestamps: true,
      paranoid: true, // Soft deletes
      underscored: true,
      freezeTableName: true
    }
  });
}

export { sequelize };
