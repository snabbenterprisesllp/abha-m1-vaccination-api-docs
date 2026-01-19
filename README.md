# Vaccination Locker - ABHA M1 Sandbox Documentation

## 📋 Project Overview

### Problem Statement

India's Universal Immunization Program (UIP) requires parents to maintain physical vaccination cards for their children, leading to:
- **Loss of critical health records** due to misplaced or damaged cards
- **Difficulty in tracking** vaccination schedules across multiple healthcare providers
- **Lack of centralized access** to immunization history for schools, travel, and medical emergencies
- **No integration** with national health infrastructure (ABDM/ABHA)

### Solution

**Vaccination Locker** is a comprehensive digital platform that enables:
- **Digital vaccination record management** for children (0-18 years) and adults
- **Automated vaccination reminders** based on WHO and Indian UIP schedules
- **Multi-stakeholder access** for parents, hospitals, and administrators
- **ABHA (Ayushman Bharat Health Account) integration** for seamless health record portability
- **QR code-based access** for quick retrieval of vaccination records

---

## 🎯 Scope of ABHA M1 Sandbox Integration

This documentation covers the **ABHA M1 Sandbox** integration scope for the Vaccination Locker backend API.

### M1 Sandbox Objectives

1. **ABHA Linking**: Enable parents to link their child's vaccination records to ABHA number
2. **Consent Management**: Implement explicit consent flow for ABHA data sharing
3. **Health Record Structure**: Define vaccination record structure compatible with ABDM standards
4. **API Readiness**: Prepare APIs for future ABDM gateway integration (M2+)

### What is Included (M1 Scope)

✅ **ABHA Number Linking**: API endpoints to link/unlink ABHA numbers to beneficiary profiles  
✅ **Consent Management**: Consent capture and tracking for ABHA data sharing  
✅ **Vaccination Record Structure**: Standardized vaccination data format  
✅ **Profile Management**: Child and adult beneficiary profile APIs  
✅ **Authentication**: Secure API authentication mechanisms  

### What is NOT Included (M1 Scope)

❌ **Direct ABDM API Calls**: No production ABDM gateway integration  
❌ **Health ID Generation**: ABHA numbers must be obtained externally  
❌ **Health Information User (HIU) Integration**: Not in M1 scope  
❌ **Health Information Provider (HIP) Integration**: Not in M1 scope  
❌ **Consent Manager Integration**: Not in M1 scope  

---

## 🏗️ System Architecture

### High-Level Architecture

This diagram shows the three types of users/clients that access the Vaccination Locker platform and how they connect to the backend:

```
┌─────────────────────────────────────────────────────────────┐
│                    Vaccination Locker Platform              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Parents    │  │   Hospitals  │  │   Admins     │     │
│  │   (Mobile)   │  │   (Web/API)  │  │   (Web)      │     │
│  │              │  │              │  │              │     │
│  │ Flutter App  │  │ Web Portal  │  │ Admin Panel  │     │
│  │              │  │ + API Calls │  │              │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                  │                  │              │
│         │  Mobile App      │  Web Browser    │  Web Browser│
│         │  (iOS/Android)   │  (React/Next.js)│  (React)    │
│         │                  │                  │              │
│         └──────────────────┼──────────────────┘             │
│                            │                                │
│                   ┌────────▼────────┐                       │
│                   │  Backend API    │                       │
│                   │  (FastAPI)      │                       │
│                   │  REST Endpoints │                       │
│                   └────────┬────────┘                       │
│                            │                                │
│         ┌──────────────────┼──────────────────┐          │
│         │                  │                    │          │
│  ┌──────▼──────┐  ┌───────▼──────┐  ┌─────────▼──────┐  │
│  │ PostgreSQL  │  │     Redis     │  │  Google Cloud   │  │
│  │  Database   │  │    Cache      │  │    Storage      │  │
│  │             │  │               │  │  (Documents)   │  │
│  └─────────────┘  └───────────────┘  └─────────────────┘  │
│                                                              │
│                            │                                │
│                   ┌────────▼────────┐                       │
│                   │  ABHA Linking   │                       │
│                   │  (M1 Sandbox)   │                       │
│                   │  Consent Mgmt   │                       │
│                   └─────────────────┘                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Explanation of User Types:**

1. **Parents (Mobile)**: 
   - Access the platform via **Flutter mobile app** (iOS/Android)
   - Primary use: Manage their children's vaccination records, view timelines, receive reminders
   - Features: Child profiles, vaccination tracking, ABHA linking, document upload

2. **Hospitals (Web/API)**:
   - Access via **Web portal** (React/Next.js) for staff interface
   - Also use **REST API** directly for integration with hospital systems
   - Primary use: Record vaccinations, scan QR codes, view beneficiary records
   - Features: Vaccination recording, QR scanning, patient lookup

3. **Admins (Web)**:
   - Access via **Web admin panel** (React/Next.js)
   - Primary use: System administration, hospital management, user management
   - Features: Hospital registration, user management, system configuration, audit logs

### Component Description

1. **Backend API (FastAPI)**
   - RESTful API endpoints for all operations
   - JWT-based authentication
   - Role-based access control (Parent, Hospital, Admin)

2. **PostgreSQL Database**
   - Beneficiary profiles (children and adults)
   - Vaccination records
   - ABHA linking metadata
   - Consent records

3. **Redis Cache**
   - Session management
   - API rate limiting
   - Temporary data storage

4. **Google Cloud Storage**
   - Document storage (vaccination cards, certificates)
   - Secure file access

5. **ABHA Integration Layer (M1)**
   - ABHA number validation (format only)
   - Consent management
   - Link/unlink operations
   - **Note**: No direct ABDM API calls in M1

---

## 👥 User Roles

### 1. Parent
- **Responsibilities**:
  - Create and manage child profiles
  - View vaccination timelines
  - Link ABHA numbers to profiles
  - Grant/revoke consent for ABHA data sharing
  - Upload vaccination documents
  - Receive vaccination reminders

- **Access Level**: Own children's records only

### 2. Hospital Staff
- **Responsibilities**:
  - Record vaccinations for beneficiaries
  - Scan QR codes to access beneficiary profiles
  - View vaccination history (with consent)
  - Upload vaccination proofs

- **Access Level**: Read/write access to vaccination records (with beneficiary consent)

### 3. Administrator
- **Responsibilities**:
  - Manage hospital registrations
  - Manage user accounts
  - System configuration
  - Audit log access

- **Access Level**: Full system access

---

## 🔄 Vaccination Lifecycle

### 1. Child Profile Creation
```
Parent Registration → Child Profile Creation → Birth Details Entry
```

### 2. Vaccination Schedule Generation
```
Age Calculation → WHO/UIP Schedule Lookup → Timeline Generation
```

### 3. Vaccination Administration
```
Hospital Records Vaccination → Vitals Capture → Document Upload → Status Update
```

### 4. Reminder System
```
Schedule Calculation → Reminder Generation → Notification Delivery
```

### 5. ABHA Integration
```
ABHA Number Entry → Consent Capture → Linking → Health Record Sync (Future)
```

---

## 🔐 ABHA Linking Flow with Explicit Consent

### Step 1: ABHA Number Entry
- Parent enters ABHA number in child profile
- System validates ABHA number format (14-digit)
- No ABDM API call in M1 (format validation only)

### Step 2: Consent Capture
- System presents consent form with:
  - Purpose of linking
  - Data to be shared
  - Duration of consent
  - Right to revoke
- Parent provides explicit consent (checkbox + signature)

### Step 3: Linking Confirmation
- System stores ABHA number and consent record
- Confirmation message displayed to parent
- Consent timestamp recorded

### Step 4: Consent Management
- Parent can view consent status
- Parent can revoke consent at any time
- Revocation immediately disables ABHA linking

### Consent Data Stored
- ABHA number (encrypted)
- Consent timestamp
- Consent purpose
- Consent duration
- Revocation status
- Revocation timestamp (if applicable)

---

## 🔒 Data Privacy and Security Principles

### Privacy Principles

1. **Explicit Consent**: No ABHA linking without explicit user consent
2. **Data Minimization**: Only necessary vaccination data linked to ABHA
3. **Purpose Limitation**: ABHA data used only for stated purposes
4. **Right to Revoke**: Users can revoke consent at any time
5. **Data Encryption**: ABHA numbers encrypted at rest
6. **Access Control**: Role-based access to ABHA-linked data

### Security Measures

1. **Authentication**: JWT-based secure authentication
2. **Authorization**: Role-based access control (RBAC)
3. **Encryption**: 
   - TLS/HTTPS for data in transit
   - AES-256 encryption for sensitive data at rest
4. **Audit Logging**: All ABHA operations logged
5. **Rate Limiting**: API rate limiting to prevent abuse
6. **Input Validation**: Strict validation of all inputs

### Data Retention

- **Vaccination Records**: Retained indefinitely (medical records)
- **ABHA Linking Data**: Retained until consent revocation
- **Consent Records**: Retained for audit purposes (7 years)

---

## ⚠️ Sandbox-Only Disclaimer

**IMPORTANT**: This repository contains documentation for **ABHA M1 Sandbox** integration only.

- **No Production Code**: This repository does NOT contain production backend code
- **No Secrets**: No credentials, API keys, or sensitive data included
- **Sandbox Testing**: All ABHA integration is for sandbox testing purposes only
- **No Real Data**: Sample data uses dummy values only
- **Local Access**: APIs are accessible only via localhost Swagger during M1 review

**The actual backend codebase remains private and is NOT exposed in this repository.**

---

## 📚 API Documentation Access

### During M1 Sandbox Review

1. **Local Swagger UI**: APIs are available via Swagger UI at `http://localhost:8000/api/v1/docs`
2. **API Endpoints**: See `api/` folder for detailed API documentation
3. **Sample Requests**: See `samples/` folder for example API requests/responses
4. **Flow Diagrams**: See `flows/` folder for user flow documentation

### API Base URL
```
http://localhost:8000/api/v1
```

### Authentication
All APIs require JWT authentication token in the Authorization header:
```
Authorization: Bearer <jwt_token>
```

---

## 📁 Repository Structure

```
abha-m1-vaccination-api-docs/
├── README.md                 # This file
├── api/                      # API documentation
│   ├── authentication.md
│   ├── beneficiaries.md
│   ├── vaccinations.md
│   └── abha-linking.md
├── flows/                    # User flow documentation
│   ├── parent-onboarding.md
│   ├── child-profile-creation.md
│   ├── vaccination-reminder.md
│   └── abha-consent-linking.md
├── samples/                  # Sample API requests/responses
│   ├── abha-link-request.json
│   ├── vaccination-record.json
│   └── api-responses.json
└── screenshots/              # UI screenshots (if available)
    └── README.md
```

---

## 🚫 What is NOT Included

This repository does NOT include:

- ❌ Backend source code (Python/FastAPI)
- ❌ Database schemas or migration scripts
- ❌ Frontend code (React/Flutter)
- ❌ Deployment configurations
- ❌ Environment variables or secrets
- ❌ Test data with real personal information
- ❌ Production ABDM gateway integration code
- ❌ CI/CD pipelines or build scripts

---

## 📞 Contact Information

For ABDM M1 Sandbox review inquiries, please contact:

- **Project**: Vaccination Locker
- **Repository**: Documentation-only (M1 Sandbox Review)
- **Status**: M1 Sandbox Phase

---

## 📄 License

This documentation repository is for ABDM M1 Sandbox review purposes only.

---

**Last Updated**: January 2025  
**Version**: M1 Sandbox Documentation v1.0

