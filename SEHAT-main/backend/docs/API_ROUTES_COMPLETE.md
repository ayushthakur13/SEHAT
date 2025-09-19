# 🩺 SEHAT Doctor Backend - Complete API Documentation

## 🔗 Base URL
```
http://localhost:5000
```

---

## 📋 Table of Contents
1. [Authentication APIs](#1-authentication-apis)
2. [Dashboard & Profile APIs](#2-dashboard--profile-apis)
3. [Availability Management APIs](#3-availability-management-apis)
4. [Appointment Management APIs](#4-appointment-management-apis)
5. [Consultation Management APIs](#5-consultation-management-apis)
6. [Patient Health Records APIs](#6-patient-health-records-apis)
7. [Prescription Management APIs](#7-prescription-management-apis)
8. [Communication & Notifications APIs](#8-communication--notifications-apis)
9. [Analytics & Reports APIs](#9-analytics--reports-apis)
10. [Offline Sync APIs](#10-offline-sync-apis)
11. [Multilingual Support APIs](#11-multilingual-support-apis)

---

## 1. Authentication APIs

### 1.1. Health Check
**Endpoint:** `GET /health`
**Description:** Check if the server is running
**Authentication:** None required

**Headers:**
```
Content-Type: application/json
```

**Response:**
```json
{
  "status": "success",
  "message": "SEHAT Backend is running",
  "timestamp": "2025-01-19T15:04:55.000Z",
  "environment": "development",
  "version": "1.0.0"
}
```

### 1.2. Doctor Registration
**Endpoint:** `POST /api/auth/register`
**Description:** Register a new doctor
**Authentication:** None required

**Headers:**
```
Content-Type: application/json
```

**Raw Data:**
```json
{
  "name": "Dr. John Smith",
  "phone": "+911234567890",
  "email": "john.smith@sehat.com",
  "password": "securePassword123",
  "role": "doctor",
  "preferredLanguage": "english",
  "gender": "male",
  "dateOfBirth": "1985-06-15"
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Doctor registered successfully",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJjOGU2MmY1Mi0yNjIyLTQyN2YtODI5Ni1kNWJmZTEyMDU1MTIiLCJ1c2VyVHlwZSI6ImRvY3RvciIsImlhdCI6MTc1ODI5NDk4NiwiZXhwIjoxNzU4MzgxMzg2fQ.nN-5M63L-NoctygGcdHByhUMX1-94RLi6litdK0HhvY",
    "user": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "Dr. John Smith",
      "email": "john.smith@sehat.com",
      "phone": "+911234567890",
      "role": "doctor",
      "preferredLanguage": "english",
      "isVerified": false,
      "needsVerification": true
    }
  }
}
```

### 1.3. Doctor Login
**Endpoint:** `POST /api/auth/login`
**Description:** Login with existing credentials
**Authentication:** None required

**Headers:**
```
Content-Type: application/json
```

**Raw Data:**
```json
{
  "identifier": "john.smith@sehat.com",
  "password": "securePassword123"
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJjOGU2MmY1Mi0yNjIyLTQyN2YtODI5Ni1kNWJmZTEyMDU1MTIiLCJ1c2VyVHlwZSI6ImRvY3RvciIsImlhdCI6MTc1ODI5NTA2NSwiZXhwIjoxNzU4MzgxNDY1fQ.WD9Yj5XERih1oM7vmcNhRoW0LAmJw1qVrWK-7TgQWZk",
    "user": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "Dr. John Smith",
      "email": "john.smith@sehat.com",
      "phone": "+911234567890",
      "role": "doctor",
      "preferredLanguage": "english",
      "isVerified": true,
      "specialization": "General Medicine",
      "isVerified": true
    }
  }
}
```

### 1.4. Doctor Verification
**Endpoint:** `POST /api/auth/verify/doctor`
**Description:** Complete doctor profile verification
**Authentication:** Required (Doctor role)

**Headers:**
```
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Raw Data:**
```json
{
  "hospitalId": "AIIMS_DEL_001",
  "specialization": "General Medicine",
  "experience": 8,
  "languages": ["english", "hindi", "punjabi"],
  "currentHospitalClinic": "AIIMS New Delhi",
  "pincode": "110029"
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Doctor verification completed successfully",
  "data": {
    "isVerified": true
  }
}
```

### 1.5. Refresh Token
**Endpoint:** `POST /api/auth/refresh`
**Description:** Refresh JWT token
**Authentication:** None required

**Headers:**
```
Content-Type: application/json
```

**Raw Data:**
```json
{
  "refreshToken": "refresh_token_here"
}
```

### 1.6. Logout
**Endpoint:** `POST /api/auth/logout`
**Description:** Logout user
**Authentication:** None required

**Headers:**
```
Content-Type: application/json
```

**Response:**
```json
{
  "status": "success",
  "message": "Logout successful"
}
```

---

## 2. Dashboard & Profile APIs

### 2.1. Get Doctor Dashboard
**Endpoint:** `GET /api/doctors/dashboard`
**Description:** Get complete doctor dashboard with stats and today's appointments
**Authentication:** Required (Doctor role)

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:**
```json
{
  "status": "success",
  "message": "Dashboard data retrieved successfully",
  "data": {
    "doctor": {
      "id": 1,
      "userId": "550e8400-e29b-41d4-a716-446655440000",
      "specialization": "General Medicine",
      "experience": 8,
      "consultationFee": "500.00",
      "languages": ["english", "hindi", "punjabi"],
      "isAvailable": true,
      "currentStatus": "available",
      "totalConsultations": 150,
      "rating": "4.5",
      "user": {
        "name": "Dr. John Smith",
        "phone": "+911234567890",
        "email": "john.smith@sehat.com",
        "preferredLanguage": "english"
      }
    },
    "todayAppointments": [
      {
        "id": 1,
        "appointmentDate": "2025-01-19",
        "startTime": "10:00:00",
        "endTime": "10:30:00",
        "status": "scheduled",
        "consultationType": "video",
        "symptoms": "Fever and headache",
        "patient": {
          "id": 1,
          "user": {
            "name": "John Doe",
            "phone": "+911234567891",
            "preferredLanguage": "hindi"
          }
        }
      }
    ],
    "stats": {
      "totalConsultations": 150,
      "monthlyConsultations": 25,
      "pendingConsultations": 3,
      "completedToday": 2
    },
    "currentStatus": "available",
    "isAvailable": true
  }
}
```

### 2.2. Get Doctor Profile
**Endpoint:** `GET /api/doctors/profile`
**Description:** Get doctor's complete profile information
**Authentication:** Required (Doctor role)

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:**
```json
{
  "status": "success",
  "data": {
    "doctor": {
      "id": 1,
      "userId": "550e8400-e29b-41d4-a716-446655440000",
      "hospitalId": "AIIMS_DEL_001",
      "licenseNumber": "DL_DOC_12345",
      "currentHospitalClinic": "AIIMS New Delhi",
      "pincode": "110029",
      "specialization": "General Medicine",
      "experience": 8,
      "consultationFee": "500.00",
      "languages": ["english", "hindi", "punjabi"],
      "workingHours": {
        "monday": {"start": "09:00", "end": "17:00"},
        "tuesday": {"start": "09:00", "end": "17:00"},
        "wednesday": {"start": "09:00", "end": "17:00"},
        "thursday": {"start": "09:00", "end": "17:00"},
        "friday": {"start": "09:00", "end": "17:00"},
        "saturday": {"start": "09:00", "end": "13:00"}
      },
      "isAvailable": true,
      "currentStatus": "available",
      "preferredConsultationType": "both",
      "lowBandwidthMode": false,
      "offlineCapable": true,
      "user": {
        "name": "Dr. John Smith",
        "phone": "+911234567890",
        "email": "john.smith@sehat.com",
        "preferredLanguage": "english"
      }
    }
  }
}
```

### 2.3. Update Doctor Profile
**Endpoint:** `PUT /api/doctors/profile`
**Description:** Update doctor's profile information
**Authentication:** Required (Doctor role)

**Headers:**
```
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Raw Data:**
```json
{
  "specialization": "Cardiology",
  "experience": 10,
  "consultationFee": "750.00",
  "languages": ["english", "hindi", "punjabi"],
  "workingHours": {
    "monday": {"start": "09:00", "end": "18:00"},
    "tuesday": {"start": "09:00", "end": "18:00"},
    "wednesday": {"start": "09:00", "end": "18:00"},
    "thursday": {"start": "09:00", "end": "18:00"},
    "friday": {"start": "09:00", "end": "18:00"},
    "saturday": {"start": "09:00", "end": "14:00"}
  },
  "isAvailable": true,
  "preferredConsultationType": "video",
  "lowBandwidthMode": false,
  "maxConcurrentConsultations": 2
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Profile updated successfully",
  "data": {
    "doctor": {
      "id": 1,
      "specialization": "Cardiology",
      "experience": 10,
      "consultationFee": "750.00",
      "languages": ["english", "hindi", "punjabi"],
      "isAvailable": true,
      "preferredConsultationType": "video"
    }
  }
}
```

---

## 3. Availability Management APIs

### 3.1. Update Availability
**Endpoint:** `PUT /api/doctors/availability`
**Description:** Update doctor's availability status and schedule
**Authentication:** Required (Doctor role)

**Headers:**
```
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Raw Data:**
```json
{
  "status": "available",
  "schedule": {
    "monday": [
      {"start": "09:00", "end": "12:00"},
      {"start": "14:00", "end": "17:00"}
    ],
    "tuesday": [
      {"start": "09:00", "end": "12:00"},
      {"start": "14:00", "end": "17:00"}
    ],
    "wednesday": [
      {"start": "10:00", "end": "16:00"}
    ],
    "thursday": [
      {"start": "09:00", "end": "12:00"},
      {"start": "14:00", "end": "17:00"}
    ],
    "friday": [
      {"start": "09:00", "end": "12:00"},
      {"start": "14:00", "end": "17:00"}
    ],
    "saturday": [
      {"start": "09:00", "end": "13:00"}
    ]
  },
  "workingHours": {
    "monday": {"start": "09:00", "end": "17:00"},
    "tuesday": {"start": "09:00", "end": "17:00"},
    "wednesday": {"start": "10:00", "end": "16:00"},
    "thursday": {"start": "09:00", "end": "17:00"},
    "friday": {"start": "09:00", "end": "17:00"},
    "saturday": {"start": "09:00", "end": "13:00"}
  }
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Availability updated successfully",
  "data": {
    "message": "Availability updated successfully",
    "doctor": {
      "id": 1,
      "currentStatus": "available",
      "availabilitySchedule": {
        "monday": [
          {"start": "09:00", "end": "12:00"},
          {"start": "14:00", "end": "17:00"}
        ]
      },
      "workingHours": {
        "monday": {"start": "09:00", "end": "17:00"}
      }
    }
  }
}
```

---

## 4. Appointment Management APIs

### 4.1. Get Doctor Appointments
**Endpoint:** `GET /api/doctors/appointments`
**Description:** Get list of doctor's appointments with filtering options
**Authentication:** Required (Doctor role)

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Query Parameters:**
- `status` (optional): Filter by status (`scheduled`, `in_progress`, `completed`, `cancelled`)
- `date` (optional): Filter by date (YYYY-MM-DD)
- `type` (optional): Filter by consultation type (`video`, `audio`, `chat`)
- `limit` (optional): Number of records per page (default: 20)
- `offset` (optional): Number of records to skip (default: 0)

**Example:** `GET /api/doctors/appointments?status=scheduled&limit=10&offset=0`

**Response:**
```json
{
  "status": "success",
  "data": {
    "consultations": [
      {
        "id": 1,
        "patientId": 1,
        "appointmentDate": "2025-01-19T00:00:00.000Z",
        "startTime": "10:00:00",
        "endTime": "10:30:00",
        "status": "scheduled",
        "consultationType": "video",
        "symptoms": "Fever, headache, and body ache",
        "diagnosis": null,
        "notes": null,
        "meetingUrl": null,
        "createdAt": "2025-01-19T08:30:00.000Z",
        "patient": {
          "id": 1,
          "userId": "patient-uuid-here",
          "user": {
            "name": "John Doe",
            "phone": "+911234567891",
            "preferredLanguage": "hindi",
            "gender": "male",
            "dateOfBirth": "1990-05-15T00:00:00.000Z"
          }
        },
        "prescription": null
      }
    ],
    "total": 15,
    "totalPages": 2,
    "currentPage": 1
  }
}
```

### 4.2. Update Appointment Status
**Endpoint:** `PUT /api/doctors/appointments/:id/status`
**Description:** Update status and details of a specific appointment
**Authentication:** Required (Doctor role)

**Headers:**
```
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Raw Data:**
```json
{
  "status": "completed",
  "diagnosis": "Viral fever with mild dehydration",
  "notes": "Patient advised rest and adequate fluid intake. Prescribed paracetamol for fever.",
  "endTime": "10:25:00"
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Appointment updated successfully",
  "data": {
    "appointment": {
      "id": 1,
      "status": "completed",
      "diagnosis": "Viral fever with mild dehydration",
      "notes": "Patient advised rest and adequate fluid intake. Prescribed paracetamol for fever.",
      "endTime": "10:25:00",
      "updatedAt": "2025-01-19T10:25:00.000Z"
    }
  }
}
```

---

## 5. Consultation Management APIs

### 5.1. Create Consultation
**Endpoint:** `POST /api/doctors/consultations`
**Description:** Create a new consultation appointment
**Authentication:** Required (Doctor role)

**Headers:**
```
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Raw Data:**
```json
{
  "patientId": 1,
  "appointmentDate": "2025-01-20",
  "startTime": "14:00:00",
  "endTime": "14:30:00",
  "consultationType": "video",
  "symptoms": "Chest pain and shortness of breath",
  "preferredLanguage": "english"
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Consultation created successfully",
  "data": {
    "consultation": {
      "id": 2,
      "patientId": 1,
      "doctorId": 1,
      "appointmentDate": "2025-01-20T00:00:00.000Z",
      "startTime": "14:00:00",
      "endTime": "14:30:00",
      "consultationType": "video",
      "symptoms": "Chest pain and shortness of breath",
      "status": "scheduled",
      "createdAt": "2025-01-19T15:04:55.000Z"
    }
  }
}
```

### 5.2. Join Consultation
**Endpoint:** `POST /api/doctors/consultations/:consultationId/join`
**Description:** Join a video/audio consultation
**Authentication:** Required (Doctor role)

**Headers:**
```
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:**
```json
{
  "status": "success",
  "message": "Joined consultation successfully",
  "data": {
    "consultation": {
      "id": 1,
      "status": "in_progress",
      "meetingUrl": "https://meet.sehat.com/room/1",
      "patient": {
        "id": 1,
        "user": {
          "name": "John Doe",
          "preferredLanguage": "hindi"
        }
      }
    },
    "meetingUrl": "https://meet.sehat.com/room/1",
    "patientLanguage": "hindi"
  }
}
```

---

## 6. Patient Health Records APIs

### 6.1. Get Patient Health Records
**Endpoint:** `GET /api/doctors/patients/:patientId/health-records`
**Description:** Get complete health records of a specific patient
**Authentication:** Required (Doctor role)

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:**
```json
{
  "status": "success",
  "data": {
    "patient": {
      "id": 1,
      "userId": "patient-uuid-here",
      "user": {
        "name": "John Doe",
        "phone": "+911234567891",
        "preferredLanguage": "hindi",
        "gender": "male",
        "dateOfBirth": "1990-05-15T00:00:00.000Z"
      }
    },
    "healthRecords": [
      {
        "id": 1,
        "recordType": "consultation",
        "title": "General Checkup",
        "description": "Routine health examination",
        "recordDate": "2025-01-15T00:00:00.000Z",
        "data": {
          "vitals": {
            "bloodPressure": "120/80",
            "heartRate": "75",
            "temperature": "98.6°F",
            "weight": "70kg"
          }
        },
        "notes": "Patient is in good health overall",
        "severity": "low",
        "doctor": {
          "id": 1,
          "user": {
            "name": "Dr. John Smith"
          }
        }
      }
    ],
    "pastConsultations": [
      {
        "id": 1,
        "appointmentDate": "2025-01-15T00:00:00.000Z",
        "diagnosis": "General checkup - healthy",
        "notes": "No issues found",
        "status": "completed",
        "doctor": {
          "id": 1,
          "user": {
            "name": "Dr. John Smith"
          }
        },
        "prescription": {
          "id": 1,
          "prescriptionNumber": "RX20250115001",
          "instructions": "Take vitamins daily",
          "medicines": [
            {
              "id": 1,
              "name": "Multivitamin",
              "dosage": "1 tablet",
              "frequency": "Once daily"
            }
          ]
        }
      }
    ],
    "totalConsultations": 5
  }
}
```

### 6.2. Create Health Record
**Endpoint:** `POST /api/doctors/health-records`
**Description:** Create a new health record for a patient
**Authentication:** Required (Doctor role)

**Headers:**
```
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Raw Data:**
```json
{
  "patientId": 1,
  "recordType": "lab_report",
  "title": "Blood Test Results",
  "description": "Complete blood count and lipid profile",
  "data": {
    "cbc": {
      "wbc": "7500",
      "rbc": "4.5",
      "hemoglobin": "14.2",
      "platelet": "250000"
    },
    "lipidProfile": {
      "totalCholesterol": "180",
      "hdl": "45",
      "ldl": "120",
      "triglycerides": "150"
    }
  },
  "notes": "All values within normal range",
  "severity": "low"
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Health record created successfully",
  "data": {
    "healthRecord": {
      "id": 2,
      "patientId": 1,
      "doctorId": 1,
      "recordType": "lab_report",
      "title": "Blood Test Results",
      "description": "Complete blood count and lipid profile",
      "data": {
        "cbc": {
          "wbc": "7500",
          "rbc": "4.5",
          "hemoglobin": "14.2",
          "platelet": "250000"
        }
      },
      "notes": "All values within normal range",
      "severity": "low",
      "createdAt": "2025-01-19T15:04:55.000Z"
    }
  }
}
```

---

## 7. Prescription Management APIs

### 7.1. Create Prescription
**Endpoint:** `POST /api/doctors/prescriptions`
**Description:** Create a new prescription for a patient
**Authentication:** Required (Doctor role)

**Headers:**
```
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Raw Data:**
```json
{
  "patientId": 1,
  "consultationId": 1,
  "diagnosis": "Viral fever with headache",
  "instructions": "Take medicines as prescribed. Rest and drink plenty of fluids.",
  "language": "hindi",
  "validUntil": "2025-02-19",
  "isEmergency": false,
  "medicines": [
    {
      "medicineId": 1,
      "dosage": "500mg",
      "frequency": "Twice daily",
      "duration": "5 days",
      "instructions": "Take after meals"
    },
    {
      "medicineId": 2,
      "dosage": "1 tablet",
      "frequency": "Thrice daily",
      "duration": "3 days",
      "instructions": "Take before meals"
    }
  ]
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Prescription created successfully",
  "data": {
    "prescription": {
      "id": 2,
      "patientId": 1,
      "doctorId": 1,
      "consultationId": 1,
      "prescriptionNumber": "RX17377259751ABCDE",
      "diagnosis": "Viral fever with headache",
      "instructions": "Take medicines as prescribed. Rest and drink plenty of fluids.",
      "language": "hindi",
      "validUntil": "2025-02-19T00:00:00.000Z",
      "isEmergency": false,
      "status": "pending",
      "createdAt": "2025-01-19T15:04:55.000Z"
    }
  }
}
```

---

## 8. Communication & Notifications APIs

### 8.1. Get Doctor Notifications
**Endpoint:** `GET /api/doctors/notifications`
**Description:** Get all notifications for the doctor
**Authentication:** Required (Doctor role)

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Query Parameters:**
- `limit` (optional): Number of notifications per page (default: 20)
- `offset` (optional): Number of notifications to skip (default: 0)
- `unreadOnly` (optional): Show only unread notifications (true/false)
- `type` (optional): Filter by notification type
- `priority` (optional): Filter by priority (low/medium/high/urgent)

**Example:** `GET /api/doctors/notifications?unreadOnly=true&limit=10`

**Response:**
```json
{
  "status": "success",
  "data": {
    "notifications": [
      {
        "id": 1,
        "type": "appointment_request",
        "title": "New Appointment Request",
        "message": "You have a new appointment request from John Doe for tomorrow at 2:00 PM",
        "titleTranslations": {
          "english": "New Appointment Request",
          "hindi": "नई अपॉइंटमेंट का अनुरोध",
          "punjabi": "ਨਵੀਂ ਮੁਲਾਕਾਤ ਦੀ ਬੇਨਤੀ"
        },
        "priority": "medium",
        "language": "english",
        "isRead": false,
        "actionUrl": "/consultations/1",
        "actionData": {
          "consultationId": 1,
          "patientId": 1
        },
        "createdAt": "2025-01-19T14:30:00.000Z",
        "patient": {
          "id": 1,
          "user": {
            "name": "John Doe",
            "phone": "+911234567891"
          }
        }
      }
    ],
    "total": 5,
    "totalPages": 1,
    "currentPage": 1,
    "unreadCount": 3
  }
}
```

### 8.2. Mark Notification as Read
**Endpoint:** `PUT /api/doctors/notifications/:notificationId/read`
**Description:** Mark a specific notification as read
**Authentication:** Required (Doctor role)

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:**
```json
{
  "status": "success",
  "message": "Notification marked as read",
  "data": {
    "notification": {
      "id": 1,
      "isRead": true,
      "readAt": "2025-01-19T15:04:55.000Z"
    }
  }
}
```

### 8.3. Send Patient Message
**Endpoint:** `POST /api/doctors/messages`
**Description:** Send a message to a patient
**Authentication:** Required (Doctor role)

**Headers:**
```
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Raw Data:**
```json
{
  "patientId": 1,
  "message": "Your test results are normal. Please continue the prescribed medication.",
  "language": "english",
  "consultationId": 1
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Message sent successfully",
  "data": {
    "success": true,
    "messageId": 2,
    "sentAt": "2025-01-19T15:04:55.000Z"
  }
}
```

---

## 9. Analytics & Reports APIs

### 9.1. Get Doctor Analytics
**Endpoint:** `GET /api/doctors/analytics`
**Description:** Get comprehensive analytics for the doctor
**Authentication:** Required (Doctor role)

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Query Parameters:**
- `timeRange` (optional): Time range for analytics (7d, 30d, 90d, 1y) - default: 30d

**Example:** `GET /api/doctors/analytics?timeRange=30d`

**Response:**
```json
{
  "status": "success",
  "data": {
    "timeRange": "30d",
    "consultationStats": {
      "byStatus": {
        "scheduled": 5,
        "in_progress": 2,
        "completed": 45,
        "cancelled": 3
      },
      "byType": {
        "video": 30,
        "audio": 15,
        "chat": 10
      },
      "total": 55
    },
    "patientDemographics": {
      "byGender": {
        "male": 25,
        "female": 20,
        "other": 0
      },
      "byLanguage": {
        "english": 20,
        "hindi": 15,
        "punjabi": 10
      },
      "totalUniquePatients": 35
    },
    "revenueStats": {
      "totalRevenue": 27500,
      "totalConsultations": 45,
      "averagePerConsultation": 500
    },
    "consultationTypeBreakdown": [
      {
        "type": "video",
        "count": 30
      },
      {
        "type": "audio",
        "count": 15
      },
      {
        "type": "chat",
        "count": 10
      }
    ],
    "ratingStats": {
      "averageRating": 4.5,
      "totalRatings": 42,
      "ratingBreakdown": {
        "5": 25,
        "4": 12,
        "3": 4,
        "2": 1,
        "1": 0
      }
    }
  }
}
```

---

## 10. Offline Sync APIs

### 10.1. Sync Offline Data
**Endpoint:** `POST /api/doctors/sync`
**Description:** Sync offline consultation, prescription, and health record data
**Authentication:** Required (Doctor role)

**Headers:**
```
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Raw Data:**
```json
{
  "consultations": [
    {
      "patientId": 1,
      "appointmentDate": "2025-01-18",
      "startTime": "15:00:00",
      "endTime": "15:30:00",
      "status": "completed",
      "consultationType": "audio",
      "symptoms": "Cough and cold",
      "diagnosis": "Common cold",
      "notes": "Prescribed rest and fluids",
      "isOffline": true
    }
  ],
  "prescriptions": [
    {
      "patientId": 1,
      "consultationId": 1,
      "diagnosis": "Common cold",
      "instructions": "Rest and take prescribed medicines",
      "language": "english",
      "isOffline": true
    }
  ],
  "healthRecords": [
    {
      "patientId": 1,
      "recordType": "consultation",
      "title": "Follow-up Consultation",
      "description": "Patient feeling better",
      "data": {
        "symptoms": "Mild cough",
        "improvement": "70%"
      },
      "notes": "Patient recovery on track",
      "isOffline": true
    }
  ]
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Data synced successfully",
  "data": {
    "consultations": {
      "success": 1,
      "failed": 0
    },
    "prescriptions": {
      "success": 1,
      "failed": 0
    },
    "healthRecords": {
      "success": 1,
      "failed": 0
    }
  }
}
```

### 10.2. Get Unsynced Data
**Endpoint:** `GET /api/doctors/sync/unsynced`
**Description:** Get all unsynced offline data
**Authentication:** Required (Doctor role)

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:**
```json
{
  "status": "success",
  "data": {
    "consultations": [
      {
        "id": 3,
        "status": "completed",
        "syncStatus": "pending",
        "isOffline": true
      }
    ],
    "prescriptions": [
      {
        "id": 2,
        "prescriptionNumber": "RX20250119002",
        "syncStatus": "pending",
        "isOffline": true
      }
    ],
    "healthRecords": [],
    "totalCount": 2
  }
}
```

---

## 11. Multilingual Support APIs

### 11.1. Get Multilingual Content
**Endpoint:** `GET /api/doctors/content/:contentType/:contentId`
**Description:** Get content in multiple languages
**Authentication:** Required (Doctor role)

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Query Parameters:**
- `language` (optional): Preferred language (english/hindi/punjabi) - default: english

**Example:** `GET /api/doctors/content/prescription/1?language=hindi`

**Response:**
```json
{
  "status": "success",
  "data": {
    "language": "hindi",
    "contentType": "prescription",
    "contentId": "1",
    "translatedContent": null
  }
}
```

---

## 🔧 Error Responses

All APIs follow a consistent error response format:

```json
{
  "status": "error",
  "message": "Error description",
  "error": "Detailed error message (in development mode only)"
}
```

### Common HTTP Status Codes:
- **200**: Success
- **201**: Created successfully
- **400**: Bad request (validation error)
- **401**: Unauthorized (authentication required)
- **403**: Forbidden (insufficient permissions)
- **404**: Not found
- **500**: Internal server error

---

## 🔑 Authentication Flow

1. **Register** → `POST /api/auth/register`
2. **Verify Doctor** → `POST /api/auth/verify/doctor` (with token)
3. **Login** → `POST /api/auth/login`
4. **Use Token** → Add `Authorization: Bearer <token>` header to all protected routes

---

## 🌐 Multilingual Support

The system supports three languages:
- **English** (`english`)
- **Hindi** (`hindi`)
- **Punjabi** (`punjabi`)

Language preferences can be set at:
- User level (during registration)
- Consultation level (per consultation)
- Prescription level (per prescription)
- Notification level (per notification)

---

## 📱 Integration Notes

### For Frontend Integration:
1. Store JWT token securely after login
2. Add Authorization header to all API calls
3. Handle token expiration and refresh
4. Implement offline data queuing for sync APIs

### For Mobile Apps:
1. Use offline sync APIs for rural connectivity
2. Implement local storage for critical data
3. Handle multilingual UI based on user preferences
4. Optimize for low-bandwidth scenarios

---

**🩺 All endpoints are production-ready and fully functional! Start building your doctor interface with these APIs.**