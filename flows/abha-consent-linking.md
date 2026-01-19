# ABHA Consent and Linking Flow

## Overview

This document describes the flow for linking a child's vaccination records to an ABHA (Ayushman Bharat Health Account) number with explicit consent management. This is part of the **ABHA M1 Sandbox** scope.

## Important M1 Sandbox Notes

⚠️ **Sandbox Limitations**:
- No direct ABDM API calls
- ABHA number format validation only
- Consent management is internal
- No Consent Manager integration
- No HIU/HIP integration

## Flow Diagram

```
┌─────────────┐
│   Parent    │
│  Child      │
│  Profile    │
└──────┬──────┘
       │
       │ Click "Link ABHA"
       ▼
┌─────────────────┐
│  Enter ABHA     │
│  Number         │
└──────┬──────────┘
       │
       │ Validate Format
       ▼
┌─────────────────┐
│  Format Valid?  │
└──────┬──────────┘
       │
    No │ Yes
       │
       ▼
┌─────────────────┐
│  Display        │
│  Consent Form   │
└──────┬──────────┘
       │
       │ Read & Accept
       ▼
┌─────────────────┐
│  Consent        │
│  Details:       │
│  - Purpose      │
│  - Duration     │
│  - Data Types   │
│  - Right to     │
│    Revoke       │
└──────┬──────────┘
       │
       │ User Accepts
       ▼
┌─────────────────┐
│  Store Consent  │
│  & Link ABHA    │
└──────┬──────────┘
       │
       │ Success
       ▼
┌─────────────────┐
│  Confirmation   │
│  Screen         │
└─────────────────┘
```

## Step-by-Step Process

### Step 1: Initiate ABHA Linking

**User Action**: Parent navigates to child profile and clicks "Link ABHA Number"  
**Screen**: ABHA Linking form

**Prerequisites**:
- Child profile must exist
- Parent must have ABHA number (obtained externally)
- Parent must be authenticated

### Step 2: Enter ABHA Number

**User Action**: Enter 14-digit ABHA number

**Field**:
- ABHA Number: 14-digit numeric string

**Format Validation**:
- Must be exactly 14 digits
- Numeric only
- No spaces or special characters

**API Call**: `POST /api/v1/abha/validate`

**Request**:
```json
{
  "abha_number": "12345678901234"
}
```

**Response**:
```json
{
  "valid": true,
  "format": "14-digit",
  "message": "ABHA number format is valid"
}
```

### Step 3: Display Consent Form

**Screen**: Consent form displaying:

1. **Purpose of Linking**
   - "To enable sharing of vaccination records for health continuity"
   - "To facilitate access to immunization history across healthcare providers"

2. **Data to be Shared**
   - Vaccination records (dates, vaccines, doses)
   - Immunization history
   - Vaccination certificates (if consent provided)

3. **Consent Duration Options**
   - Indefinite (until revoked)
   - 1 year
   - 2 years
   - 5 years

4. **Right to Revoke**
   - "You can revoke this consent at any time"
   - "Revocation will immediately unlink ABHA number"
   - "Your data will no longer be accessible via ABHA"

5. **Explicit Consent Checkbox**
   - "I understand and consent to linking my child's vaccination records to ABHA"
   - Required checkbox

### Step 4: User Accepts Consent

**User Action**: 
- Read consent form
- Select consent duration
- Check explicit consent checkbox
- Click "Link ABHA"

**Validation**:
- Explicit consent checkbox must be checked
- Consent duration must be selected

### Step 5: Store Consent and Link ABHA

**API Call**: `POST /api/v1/beneficiaries/{beneficiary_id}/abha/link`

**Request**:
```json
{
  "abha_number": "12345678901234",
  "consent": {
    "purpose": "Vaccination record sharing for health continuity",
    "duration": "indefinite",
    "data_categories": [
      "vaccination_records",
      "immunization_history"
    ],
    "explicit_consent": true
  }
}
```

**Backend Actions**:
1. Validate ABHA number format
2. Check if ABHA already linked to another beneficiary
3. Encrypt ABHA number (AES-256)
4. Store consent record with:
   - Consent timestamp
   - Purpose
   - Duration
   - Data categories
   - User ID (who gave consent)
5. Link ABHA to beneficiary
6. Log consent operation in audit log

**Response**:
```json
{
  "success": true,
  "message": "ABHA number linked successfully",
  "beneficiary_id": 11,
  "abha_number": "12345678901234",
  "abha_linked": true,
  "linked_date": "2024-01-15T10:30:00Z",
  "consent": {
    "id": 1,
    "consented": true,
    "consent_date": "2024-01-15T10:30:00Z",
    "purpose": "Vaccination record sharing for health continuity",
    "duration": "indefinite",
    "data_categories": ["vaccination_records", "immunization_history"],
    "revoked": false
  }
}
```

### Step 6: Confirmation

**Screen**: Success confirmation showing:
- ABHA number linked successfully
- Consent details
- Link to view/manage consent

## Consent Management

### View Consent Status

**API Call**: `GET /api/v1/beneficiaries/{beneficiary_id}/abha/status`

**Response**: See API documentation for details

### Revoke Consent

**User Action**: Navigate to consent management and click "Revoke Consent"

**API Call**: `POST /api/v1/beneficiaries/{beneficiary_id}/abha/unlink`

**Request**:
```json
{
  "revoke_consent": true,
  "revocation_reason": "User requested"
}
```

**Backend Actions**:
1. Mark consent as revoked
2. Record revocation timestamp
3. Store revocation reason
4. Unlink ABHA number
5. Log revocation in audit log

**Response**:
```json
{
  "success": true,
  "message": "ABHA number unlinked successfully",
  "beneficiary_id": 11,
  "abha_linked": false,
  "consent": {
    "id": 1,
    "consented": false,
    "consent_date": "2024-01-15T10:30:00Z",
    "revoked": true,
    "revocation_date": "2024-01-20T14:00:00Z",
    "revocation_reason": "User requested"
  }
}
```

## Consent Data Structure

```json
{
  "id": 1,
  "beneficiary_id": 11,
  "user_id": 1,
  "consented": true,
  "consent_date": "2024-01-15T10:30:00Z",
  "purpose": "Vaccination record sharing for health continuity",
  "duration": "indefinite",
  "data_categories": [
    "vaccination_records",
    "immunization_history"
  ],
  "explicit_consent": true,
  "revoked": false,
  "revocation_date": null,
  "revocation_reason": null,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z"
}
```

## Consent Duration Handling

### Indefinite Consent
- Valid until explicitly revoked
- No expiration date

### Time-Limited Consent
- Expires after selected duration
- System checks expiration daily
- Automatic unlinking on expiration
- Notification sent before expiration

## Security and Privacy

### ABHA Number Encryption
- Encrypted at rest using AES-256
- Decrypted only when needed for display (with user authentication)
- Never logged in plain text

### Consent Audit Trail
- All consent operations logged
- Includes:
  - User ID
  - Timestamp
  - Action (link/unlink)
  - IP address
  - User agent

### Access Control
- Only parent can link/unlink ABHA for their children
- Hospital staff cannot link ABHA
- Admins can view consent records but cannot modify

## Error Handling

### Invalid ABHA Format
```json
{
  "detail": "ABHA number must be 14 digits"
}
```

### Already Linked
```json
{
  "detail": "ABHA number is already linked to this beneficiary"
}
```

### Consent Not Provided
```json
{
  "detail": "Explicit consent is required to link ABHA number"
}
```

### Unauthorized Access
```json
{
  "detail": "You do not have permission to link ABHA for this beneficiary"
}
```

## Future M2+ Integration

In future phases, this flow will integrate with:
- **ABDM Consent Manager**: For centralized consent management
- **HIU APIs**: For health information user access
- **HIP APIs**: For health information provider integration
- **ABDM Gateway**: For real-time ABHA validation and linking

## Compliance Notes

### ABDM M1 Requirements Met

✅ Explicit consent capture  
✅ Consent purpose documentation  
✅ Consent duration options  
✅ Right to revoke clearly stated  
✅ Consent audit trail  
✅ Data encryption  
✅ Access control  

### Not in M1 Scope

❌ Direct ABDM Consent Manager integration  
❌ Real-time ABHA validation via ABDM gateway  
❌ HIU/HIP integration  
❌ Health record sharing via ABDM  

