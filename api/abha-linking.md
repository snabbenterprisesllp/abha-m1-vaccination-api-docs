# ABHA Linking APIs (M1 Sandbox)

## Overview

ABHA linking APIs enable parents to link their child's vaccination records to an ABHA (Ayushman Bharat Health Account) number. These APIs are part of the **M1 Sandbox** scope and do NOT make direct calls to ABDM gateway.

## Important M1 Sandbox Notes

⚠️ **Sandbox Limitations**:
- No direct ABDM API calls
- ABHA number format validation only (14-digit)
- Consent management is internal to the system
- No Health Information User (HIU) or Health Information Provider (HIP) integration
- No Consent Manager integration

## Link ABHA Number

**Endpoint**: `POST /api/v1/beneficiaries/{beneficiary_id}/abha/link`  
**Description**: Link ABHA number to beneficiary profile  
**Role**: Parent (own beneficiaries only)

**Request**:
```json
{
  "abha_number": "12345678901234",
  "consent": {
    "purpose": "Vaccination record sharing for health continuity",
    "duration": "indefinite",
    "data_categories": ["vaccination_records", "immunization_history"],
    "explicit_consent": true
  }
}
```

**Response**:
```json
{
  "success": true,
  "message": "ABHA number linked successfully",
  "beneficiary_id": 11,
  "abha_number": "12345678901234",
  "abha_linked": true,
  "consent": {
    "id": 1,
    "consented": true,
    "consent_date": "2024-01-15T10:30:00Z",
    "purpose": "Vaccination record sharing for health continuity",
    "duration": "indefinite",
    "revoked": false
  }
}
```

## Unlink ABHA Number

**Endpoint**: `POST /api/v1/beneficiaries/{beneficiary_id}/abha/unlink`  
**Description**: Unlink ABHA number from beneficiary profile  
**Role**: Parent (own beneficiaries only)

**Request**:
```json
{
  "revoke_consent": true,
  "revocation_reason": "User requested"
}
```

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

## Get ABHA Link Status

**Endpoint**: `GET /api/v1/beneficiaries/{beneficiary_id}/abha/status`  
**Description**: Get ABHA linking status and consent information

**Response**:
```json
{
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
    "revoked": false,
    "revocation_date": null
  }
}
```

## Validate ABHA Number Format

**Endpoint**: `POST /api/v1/abha/validate`  
**Description**: Validate ABHA number format (14-digit)  
**Note**: This is format validation only, not ABDM gateway validation

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

**Invalid Format Response**:
```json
{
  "valid": false,
  "format": "invalid",
  "message": "ABHA number must be 14 digits"
}
```

## Consent Management

### Consent Structure

```json
{
  "purpose": "Vaccination record sharing for health continuity",
  "duration": "indefinite" | "1_year" | "2_years" | "5_years",
  "data_categories": [
    "vaccination_records",
    "immunization_history",
    "vaccination_documents"
  ],
  "explicit_consent": true
}
```

### Consent Duration Options

- `indefinite`: Consent until explicitly revoked
- `1_year`: Consent valid for 1 year
- `2_years`: Consent valid for 2 years
- `5_years`: Consent valid for 5 years

### Data Categories

- `vaccination_records`: Individual vaccination records
- `immunization_history`: Complete immunization history
- `vaccination_documents`: Vaccination certificates and proofs

## ABHA Number Format

- **Length**: 14 digits
- **Format**: Numeric only
- **Example**: `12345678901234`

## Error Responses

### Invalid ABHA Format (400)
```json
{
  "detail": "ABHA number must be 14 digits"
}
```

### Already Linked (400)
```json
{
  "detail": "ABHA number is already linked to this beneficiary"
}
```

### Consent Required (400)
```json
{
  "detail": "Explicit consent is required to link ABHA number"
}
```

### Unauthorized (403)
```json
{
  "detail": "You do not have permission to link ABHA for this beneficiary"
}
```

## Security Considerations

1. **ABHA Number Encryption**: ABHA numbers are encrypted at rest using AES-256
2. **Consent Audit**: All consent operations are logged for audit purposes
3. **Revocation**: Consent can be revoked at any time, immediately disabling ABHA linking
4. **Access Control**: Only parents can link/unlink ABHA for their own beneficiaries

## Future M2+ Integration

In future phases (M2+), these APIs will integrate with:
- ABDM Consent Manager
- Health Information User (HIU) APIs
- Health Information Provider (HIP) APIs
- ABDM Gateway for real-time ABHA validation

