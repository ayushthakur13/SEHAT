# SEHAT Backend - Unified Telemedicine Platform

A comprehensive backend API for SEHAT telemedicine platform supporting Patients, Doctors, and Pharmacies with offline-first capabilities and multilingual support.

## 🚀 Features

### Core Features
- **Multi-role Authentication**: JWT-based auth for patients, doctors, and pharmacies
- **Offline-first Design**: SQLite for local storage, PostgreSQL/MySQL for production
- **Multilingual Support**: Punjabi, Hindi, and English
- **Real-time Notifications**: WebSocket-ready notification system
- **AI Symptom Checker**: Rule-based health assessment tool
- **Medicine Availability**: Real-time pharmacy stock tracking

### MVP Features
- **Video/Audio Consultations**: Low-bandwidth optimized calls
- **Digital Health Records**: Offline-accessible patient history
- **Prescription Management**: Digital prescriptions with medicine tracking
- **Pharmacy Integration**: Stock management and availability checking
- **Symptom Checker**: AI-powered health triage (offline-capable)

## 🏗️ Architecture

### Tech Stack
- **Runtime**: Node.js with ES6 modules
- **Framework**: Express.js
- **Database**: SQLite (dev) + PostgreSQL/MySQL (prod)
- **ORM**: Sequelize with soft deletes
- **Authentication**: JWT with role-based access
- **Validation**: Joi + Express-validator
- **Rate Limiting**: Express-rate-limit
- **File Upload**: Multer

### Project Structure
```
backend/
├── src/
│   ├── config/
│   │   └── database.js          # Database configuration
│   ├── middleware/
│   │   ├── auth.js             # JWT authentication
│   │   ├── errorHandler.js     # Global error handling
│   │   └── rateLimiter.js      # Rate limiting
│   ├── models/
│   │   ├── Patient.js          # Patient model
│   │   ├── Doctor.js           # Doctor model
│   │   ├── Pharmacy.js         # Pharmacy model
│   │   ├── Consultation.js     # Consultation model
│   │   ├── Prescription.js     # Prescription model
│   │   ├── Medicine.js         # Medicine catalog
│   │   ├── HealthRecord.js     # Health records
│   │   ├── PharmacyStock.js    # Pharmacy inventory
│   │   └── index.js            # Model associations
│   ├── controllers/
│   │   ├── authController.js   # Authentication
│   │   ├── consultationController.js
│   │   ├── prescriptionController.js
│   │   ├── medicineController.js
│   │   ├── healthRecordController.js
│   │   ├── aiController.js     # AI symptom checker
│   │   ├── notificationController.js
│   │   └── syncController.js   # Offline sync
│   ├── services/
│   │   ├── authService.js
│   │   ├── consultationService.js
│   │   ├── prescriptionService.js
│   │   ├── medicineService.js
│   │   ├── healthRecordService.js
│   │   ├── aiService.js
│   │   ├── notificationService.js
│   │   └── syncService.js
│   ├── routes/
│   │   ├── auth.js             # Authentication routes
│   │   ├── consultationRoutes.js
│   │   ├── prescriptionRoutes.js
│   │   ├── medicineRoutes.js
│   │   ├── healthRecordRoutes.js
│   │   ├── aiRoutes.js
│   │   ├── notificationRoutes.js
│   │   └── syncRoutes.js
│   ├── app.js                  # Express app setup
│   └── server.js               # Entry point
├── database/                   # SQLite database files
├── .env                       # Environment configuration
├── package.json
└── README.md
```

## 🚀 Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env with your database settings
```

### 3. Start Development Server
```bash
npm run dev
```

The server will start on `http://localhost:5000`

## 📚 API Endpoints

### Authentication
- `POST /api/auth/register/patient` - Register patient
- `POST /api/auth/register/doctor` - Register doctor
- `POST /api/auth/register/pharmacy` - Register pharmacy
- `POST /api/auth/login/patient` - Patient login
- `POST /api/auth/login/doctor` - Doctor login
- `POST /api/auth/login/pharmacy` - Pharmacy login

### Consultations
- `POST /api/consultations/book` - Book consultation (Patient)
- `GET /api/consultations/my-consultations` - Get my consultations (Patient)
- `GET /api/consultations` - Get doctor consultations (Doctor)
- `PUT /api/consultations/:id/status` - Update consultation status (Doctor)

### Prescriptions
- `GET /api/prescriptions/my-prescriptions` - Get my prescriptions (Patient)
- `POST /api/prescriptions/create` - Create prescription (Doctor)
- `GET /api/prescriptions` - Get pharmacy prescriptions (Pharmacy)
- `PUT /api/prescriptions/:id/dispense` - Dispense prescription (Pharmacy)

### Medicines
- `GET /api/medicines/search` - Search medicines (Public)
- `GET /api/medicines/availability` - Check availability (Patient)
- `POST /api/medicines` - Add medicine (Pharmacy)
- `POST /api/medicines/stock` - Update stock (Pharmacy)

### Health Records
- `GET /api/health-records/my-records` - Get my records (Patient)
- `POST /api/health-records/upload` - Upload record (Patient)
- `GET /api/health-records/patient/:patientId` - Get patient records (Doctor)

### AI Services
- `POST /api/ai/symptom-checker` - AI symptom checker (Patient)
- `POST /api/ai/health-tips` - Get health tips (Patient)
- `GET /api/ai/common-illnesses` - Get common illnesses (Public)

### Sync (Offline Support)
- `POST /api/sync/upload` - Upload offline data
- `POST /api/sync/download` - Download latest data
- `GET /api/sync/status` - Get sync status

## 🔧 Configuration

### Database Configuration
The backend supports both SQLite (development) and PostgreSQL/MySQL (production):

**Development (SQLite)**:
```env
DB_DIALECT=sqlite
DB_STORAGE=./database/sehat.sqlite
```

**Production (PostgreSQL)**:
```env
DB_DIALECT=postgres
DB_HOST=localhost
DB_PORT=5432
DB_NAME=sehat_prod
DB_USER=postgres
DB_PASSWORD=your_password
```

### Environment Variables
```env
PORT=5000
NODE_ENV=development
JWT_SECRET=your_secret_key
DB_DIALECT=sqlite
DB_STORAGE=./database/sehat.sqlite
MAX_FILE_SIZE=50mb
UPLOAD_PATH=./uploads
ENABLE_NOTIFICATIONS=true
AI_SERVICE_ENABLED=true
```

## 🏥 User Flows

### Patient Flow
1. **Register/Login** → Select language (Punjabi/Hindi/English)
2. **Book Consultation** → Choose doctor → Video/audio call
3. **Receive Prescription** → Save to health records (offline)
4. **Check Medicine Availability** → Find nearby pharmacies
5. **Use Symptom Checker** → Get health advice (offline)

### Doctor Flow
1. **Login** → View appointment queue
2. **Start Consultation** → Access patient records
3. **Create Prescription** → Save consultation notes
4. **End Consultation** → Next appointment

### Pharmacy Flow
1. **Login** → Update medicine inventory
2. **Receive Prescriptions** → Check stock availability
3. **Dispense Medicines** → Update stock levels
4. **Sync with System** → Real-time availability

## 🔒 Security Features

- **JWT Authentication** with role-based access control
- **Rate Limiting** to prevent abuse
- **Input Validation** using Joi and Express-validator
- **SQL Injection Protection** via Sequelize ORM
- **CORS Configuration** for cross-origin requests
- **Soft Deletes** for data retention

## 📱 Offline-First Design

- **Local SQLite Database** for offline storage
- **Sync Service** for data synchronization
- **Conflict Resolution** for data consistency
- **Offline AI Symptom Checker** with preloaded data
- **Health Records** accessible without internet

## 🌐 Multilingual Support

- **Language Selection** on registration
- **AI Responses** in Punjabi, Hindi, English
- **Health Tips** localized by language
- **Common Illnesses** with local terminology

## 🚀 Deployment

### Development
```bash
npm run dev
```

### Production
```bash
npm start
```

### Docker (Optional)
```bash
docker build -t sehat-backend .
docker run -p 5000:5000 sehat-backend
```

## 📊 Monitoring

- **Health Check**: `GET /health`
- **Database Status**: Automatic connection monitoring
- **Error Logging**: Comprehensive error tracking
- **Performance Metrics**: Request timing and response codes

## 🔮 Future Enhancements

- **WebSocket Integration** for real-time features
- **Push Notifications** for mobile apps
- **Advanced AI Models** for better symptom checking
- **Video Call Integration** with WebRTC
- **Payment Gateway** integration
- **Analytics Dashboard** for healthcare insights

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the ISC License.

---

**SEHAT** - Bridging healthcare gaps for rural Punjab with reliable, offline-first access.