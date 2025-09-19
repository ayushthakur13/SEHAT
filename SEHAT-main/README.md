# SEHAT — Smart E-Health Access for Telemedicine

> Offline-first, multilingual telemedicine platform connecting patients, doctors, and pharmacies in Nabha, Punjab.

## Problem Statement
SIH 2025, ID 25018 — Telemedicine Access for Rural Healthcare in Nabha. Many rural communities have limited access to doctors, unstable connectivity, and fragmented medicine supply. SEHAT aims to bridge this gap with an offline-first, low-bandwidth experience.

## Solution Summary
- **Patients**: Book/enter queue for consults, video/audio calls on low bandwidth, access health records offline, AI-assisted symptom checker, and see medicine availability.
- **Doctors**: Manage patient queue, conduct consults, generate e-prescriptions, and schedule follow-ups.
- **Pharmacies**: Maintain stock, receive prescriptions, and mark dispensation to keep records in sync.
- **Offline-first**: Each app instance stores data in local PouchDB and syncs when connectivity is available with CouchDB. Backend exposes Node.js/Express APIs; optional Socket.IO for near real-time updates when online.

## Tech Stack
- **Frontend**: Flutter (three role-specific apps sharing common modules)
- **Backend**: Node.js + Express
- **Databases**: CouchDB (server), PouchDB (client for offline-first sync)
- **Auth**: JWT
- **Realtime (optional)**: Socket.IO

## Repository Structure
```
SEHAT/
├── mobile/
│   ├── patient/      
│   ├── doctor/       
│   ├── pharmacy/     
│   └── common/       
├── backend/
│   ├── src/
│   │   ├── routes/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── services/
│   │   └── utils/
│   └── tests/
├── database/         
├── .gitignore
└──README.md

```

---
SEHAT — Bridging care gaps for rural Punjab with reliable, offline-first access.

