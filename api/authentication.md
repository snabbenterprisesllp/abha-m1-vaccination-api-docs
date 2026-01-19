# Authentication APIs

## Overview

The Vaccination Locker API uses JWT (JSON Web Token) based authentication. All API endpoints (except public endpoints) require a valid JWT token in the Authorization header.

## Authentication Methods

### 1. OTP-Based Authentication (Primary)

**Endpoint**: `POST /api/v1/auth/otp/send`  
**Description**: Send OTP to user's mobile number

**Request**:
```json
{
  "mobile_number": "9876543210"
}
```

**Response**:
```json
{
  "message": "OTP sent successfully",
  "otp_expires_in": 300
}
```

**Endpoint**: `POST /api/v1/auth/otp/verify`  
**Description**: Verify OTP and receive JWT token

**Request**:
```json
{
  "mobile_number": "9876543210",
  "otp": "123456"
}
```

**Response**:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600,
  "user": {
    "id": 1,
    "email": "parent@example.com",
    "role": "parent",
    "mobile_number": "9876543210"
  }
}
```

### 2. Token-Based Authentication (TAB) - Hospital Users

**Endpoint**: `POST /api/v1/auth/tab/login`  
**Description**: Hospital staff login using TAB (Token-Based Authentication)

**Request**:
```json
{
  "hospital_id": 123,
  "tab_token": "hospital_tab_token_here",
  "user_identifier": "doctor@hospital.com"
}
```

**Response**:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600,
  "user": {
    "id": 45,
    "email": "doctor@hospital.com",
    "role": "hospital",
    "hospital_id": 123,
    "hospital_role": "doctor"
  }
}
```

## Token Usage

### Authorization Header Format

```
Authorization: Bearer <access_token>
```

### Example Request

```bash
curl -X GET "http://localhost:8000/api/v1/beneficiaries" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

## Token Refresh

**Endpoint**: `POST /api/v1/auth/refresh`  
**Description**: Refresh access token using refresh token

**Request**:
```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response**:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600
}
```

## User Roles

The JWT token contains user role information:

- **parent**: Regular parent user
- **hospital**: Hospital staff user
- **admin**: System administrator

Role-based access control (RBAC) is enforced at the API endpoint level.

## Error Responses

### Invalid Token (401)
```json
{
  "detail": "Could not validate credentials"
}
```

### Expired Token (401)
```json
{
  "detail": "Token has expired"
}
```

### Insufficient Permissions (403)
```json
{
  "detail": "Not enough permissions"
}
```

