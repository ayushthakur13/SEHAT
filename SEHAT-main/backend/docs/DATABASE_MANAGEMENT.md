# 🗄️ SEHAT Database Management Guide

## 🎯 Overview

This guide explains how to manage your SEHAT database during development without losing valuable data.

---

## 📋 Database Scripts Available

### 1. **Normal Server Start** (Preserves Data)
```bash
npm run dev
# or
npm start
```
- ✅ **Preserves all existing data**
- ✅ Creates missing tables only
- ✅ Safe for development and production
- ❌ Won't add new columns to existing tables

### 2. **Database Migration** (Preserves Data + Updates Schema)
```bash
npm run db:migrate
```
- ✅ **Preserves all existing data**
- ✅ Creates missing tables
- ✅ **Adds new columns to existing tables**
- ✅ Safe for development and production
- ✅ **Recommended for schema updates**

### 3. **Database Reset** ⚠️ (Destroys Data)
```bash
npm run db:reset
```
- ❌ **Destroys all existing data**
- ✅ Creates fresh database structure
- ⚠️ **Only use when you want to start fresh**

---

## 🔄 Recommended Development Workflow

### **For Day-to-Day Development:**
```bash
# Just start the server normally
npm run dev
```

### **When You Add New Features (New Columns/Tables):**
```bash
# 1. Stop the server (Ctrl+C)
# 2. Run migration to update schema safely
npm run db:migrate
# 3. Start the server
npm run dev
```

### **When You Want to Start Fresh (Testing/Demo):**
```bash
# Only if you want to lose all data
npm run db:reset
npm run dev
```

---

## 🛠️ What Each Approach Does

### **Normal Server Start (`npm run dev`)**
```javascript
// In server.js
await sequelize.sync({ alter: false });
```
- Creates tables that don't exist
- Preserves existing tables and data
- **Does NOT modify existing table structure**

### **Database Migration (`npm run db:migrate`)**
```javascript
// Smart column addition
if (!tableInfo.newColumn) {
  await queryInterface.addColumn('table', 'newColumn', {
    type: DataTypes.STRING,
    allowNull: true
  });
}
```
- Checks each table for missing columns
- Adds new columns safely
- Preserves all existing data
- Creates new tables if needed

### **Database Reset (`npm run db:reset`)**
```javascript
// In reset script
await sequelize.sync({ force: true });
```
- Drops all tables
- Recreates everything from scratch
- **ALL DATA IS LOST**

---

## 📊 When to Use Each Script

| Scenario | Use This | Why |
|----------|----------|-----|
| Daily development | `npm run dev` | Preserves your test data |
| Added new model fields | `npm run db:migrate` | Adds columns without losing data |
| Major schema changes | `npm run db:migrate` | Smart updates preserve data |
| Testing from scratch | `npm run db:reset` | Fresh start for testing |
| Demo preparation | `npm run db:reset` | Clean slate for demo |
| Production deployment | `npm run db:migrate` | Never lose production data |

---

## 🚨 Important Notes

### **Development Best Practices:**
1. **Always try `npm run db:migrate` first** before resetting
2. **Backup important test data** before major changes
3. **Use reset only when you're sure** you want to lose data
4. **Never use reset in production**

### **Production Deployment:**
1. **Always use migrations** in production
2. **Test migrations on a copy** of production data first
3. **Have database backups** before running migrations
4. **Never use `db:reset` in production**

---

## 📈 Schema Evolution Example

### **Scenario: You added new fields to Doctor model**

**❌ Wrong Way (Loses Data):**
```bash
npm run db:reset  # All doctors and consultations lost!
npm run dev
```

**✅ Right Way (Preserves Data):**
```bash
npm run db:migrate  # Adds new columns, keeps existing doctors
npm run dev
```

### **What Migration Does:**
```sql
-- Migration automatically runs these SQL commands:
ALTER TABLE doctors ADD COLUMN availabilitySchedule JSON;
ALTER TABLE doctors ADD COLUMN currentStatus VARCHAR(255) DEFAULT 'offline';
ALTER TABLE doctors ADD COLUMN lowBandwidthMode BOOLEAN DEFAULT false;
-- etc... all while preserving your existing doctor records
```

---

## 🔧 Troubleshooting

### **Server Won't Start After Model Changes:**
```bash
# Try migration first
npm run db:migrate
npm run dev
```

### **Migration Fails:**
```bash
# Check the error message
# If it's a complex schema change, you might need reset
npm run db:reset  # Only if migration fails and you're okay losing data
npm run dev
```

### **Want to See What's in Database:**
```bash
# Connect to your PostgreSQL database using any SQL client
# Check tables and data before making changes
```

---

## 📝 Summary

**For 99% of development scenarios, use this simple workflow:**

1. **Regular development:** `npm run dev`
2. **Added new features:** `npm run db:migrate` → `npm run dev`
3. **Testing/Demo reset:** `npm run db:reset` → `npm run dev`

**Your existing doctor accounts, consultations, and prescriptions will be preserved with the migration approach! 🩺💾**