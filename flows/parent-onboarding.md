# Parent Onboarding Flow

## Overview

This document describes the flow for parent user registration and onboarding in the Vaccination Locker system.

## Flow Diagram

```
┌─────────────┐
│   Parent    │
│  Opens App  │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  Registration   │
│  Screen         │
└──────┬──────────┘
       │
       │ Enter Mobile Number
       ▼
┌─────────────────┐
│  Send OTP API   │
│  POST /auth/otp │
└──────┬──────────┘
       │
       │ OTP Sent
       ▼
┌─────────────────┐
│  Enter OTP      │
└──────┬──────────┘
       │
       │ Verify OTP
       ▼
┌─────────────────┐
│  Verify OTP API │
│  POST /auth/otp │
│  /verify        │
└──────┬──────────┘
       │
       │ JWT Token Received
       ▼
┌─────────────────┐
│  Create Parent  │
│  Profile        │
└──────┬──────────┘
       │
       │ Profile Created
       ▼
┌─────────────────┐
│  Dashboard      │
│  (Home Screen)  │
└─────────────────┘
```

## Step-by-Step Process

### Step 1: Registration Initiation

**User Action**: Parent opens mobile app or web app  
**Screen**: Registration/Login screen

**Fields**:
- Mobile number (10 digits, Indian format)

**Validation**:
- Mobile number format validation
- Check if user already exists

### Step 2: OTP Request

**API Call**: `POST /api/v1/auth/otp/send`

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

**Backend Actions**:
1. Generate 6-digit OTP
2. Store OTP with expiration (5 minutes)
3. Send OTP via SMS (or email if configured)

### Step 3: OTP Verification

**User Action**: Enter OTP received via SMS  
**API Call**: `POST /api/v1/auth/otp/verify`

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
    "mobile_number": "9876543210",
    "role": "parent",
    "email": null
  }
}
```

**Backend Actions**:
1. Validate OTP
2. Check OTP expiration
3. Create user account if new user
4. Generate JWT tokens
5. Create parent beneficiary record (ADULT type)

### Step 4: Profile Completion (Optional)

**User Action**: Complete profile information  
**API Call**: `PUT /api/v1/beneficiaries/{beneficiary_id}`

**Optional Fields**:
- Email address
- Full name
- Date of birth
- Gender

### Step 5: Dashboard Access

**User Action**: Navigate to dashboard  
**Screen**: Home dashboard showing:
- "My Vaccinations" card (parent's own records)
- "My Children" card (child profiles)

## Error Handling

### Invalid Mobile Number
```json
{
  "detail": "Invalid mobile number format"
}
```

### OTP Expired
```json
{
  "detail": "OTP has expired. Please request a new OTP"
}
```

### Invalid OTP
```json
{
  "detail": "Invalid OTP. Please try again"
}
```

### Rate Limiting
```json
{
  "detail": "Too many OTP requests. Please try again after 5 minutes"
}
```

## Security Considerations

1. **OTP Expiration**: OTPs expire after 5 minutes
2. **Rate Limiting**: Maximum 3 OTP requests per mobile number per hour
3. **JWT Expiration**: Access tokens expire after 1 hour
4. **Token Refresh**: Refresh tokens valid for 7 days
5. **Mobile Verification**: Mobile number verified via OTP before account creation

## Post-Onboarding Actions

After successful onboarding, parents can:
1. Add child profiles
2. View vaccination schedules
3. Link ABHA numbers (optional)
4. Receive vaccination reminders
5. Upload vaccination documents

