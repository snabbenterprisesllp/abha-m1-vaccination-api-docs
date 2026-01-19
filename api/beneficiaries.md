# Beneficiary Management APIs

## Overview

Beneficiary APIs manage both **ADULT** (parents) and **CHILD** beneficiaries in a unified system. All endpoints require authentication.

## Get Parent Profile

**Endpoint**: `GET /api/v1/beneficiaries/parent/profile`  
**Description**: Get current user's parent profile with vaccination records  
**Role**: Parent

**Response**:
```json
{
  "beneficiary": {
    "id": 10,
    "first_name": "Rajesh",
    "last_name": "Kumar",
    "date_of_birth": "1985-05-15",
    "gender": "male",
    "type": "ADULT",
    "abha_number": null,
    "abha_linked": false
  },
  "vaccinations": [
    {
      "id": 1,
      "vaccine_name": "COVID-19",
      "dose_number": 1,
      "vaccination_date": "2021-06-15",
      "status": "completed"
    }
  ]
}
```

## Get All Beneficiaries

**Endpoint**: `GET /api/v1/beneficiaries`  
**Description**: Get all beneficiaries for current user  
**Query Parameters**:
- `type` (optional): Filter by type (`ADULT` or `CHILD`)

**Response**:
```json
[
  {
    "id": 10,
    "first_name": "Rajesh",
    "last_name": "Kumar",
    "date_of_birth": "1985-05-15",
    "gender": "male",
    "type": "ADULT",
    "abha_number": null,
    "abha_linked": false
  },
  {
    "id": 11,
    "first_name": "Priya",
    "last_name": "Kumar",
    "date_of_birth": "2020-03-20",
    "gender": "female",
    "type": "CHILD",
    "abha_number": "12345678901234",
    "abha_linked": true
  }
]
```

## Get Children Only

**Endpoint**: `GET /api/v1/beneficiaries/children`  
**Description**: Get all child beneficiaries for current user  
**Role**: Parent

**Response**: Same format as above, filtered to CHILD type only

## Get Beneficiary by ID

**Endpoint**: `GET /api/v1/beneficiaries/{beneficiary_id}`  
**Description**: Get specific beneficiary details

**Response**:
```json
{
  "id": 11,
  "first_name": "Priya",
  "last_name": "Kumar",
  "date_of_birth": "2020-03-20",
  "gender": "female",
  "type": "CHILD",
  "phone_number": "9876543210",
  "email": null,
  "abha_number": "12345678901234",
  "abha_linked": true,
  "abha_consent": {
    "consented": true,
    "consent_date": "2024-01-15T10:30:00Z",
    "purpose": "Vaccination record sharing",
    "revoked": false
  },
  "legacy_child_profile_id": 5
}
```

## Create Beneficiary

**Endpoint**: `POST /api/v1/beneficiaries`  
**Description**: Create a new beneficiary (typically a child)  
**Role**: Parent

**Request**:
```json
{
  "first_name": "Arjun",
  "last_name": "Kumar",
  "date_of_birth": "2023-06-15",
  "gender": "male",
  "type": "CHILD",
  "phone_number": "9876543210"
}
```

**Response**:
```json
{
  "id": 12,
  "first_name": "Arjun",
  "last_name": "Kumar",
  "date_of_birth": "2023-06-15",
  "gender": "male",
  "type": "CHILD",
  "abha_number": null,
  "abha_linked": false,
  "created_at": "2024-01-20T10:00:00Z"
}
```

## Update Beneficiary

**Endpoint**: `PUT /api/v1/beneficiaries/{beneficiary_id}`  
**Description**: Update beneficiary information  
**Role**: Parent (own beneficiaries only)

**Request**:
```json
{
  "first_name": "Arjun",
  "last_name": "Kumar",
  "phone_number": "9876543211"
}
```

**Response**: Updated beneficiary object

## Get Vaccination Timeline

**Endpoint**: `GET /api/v1/beneficiaries/{beneficiary_id}/vaccination-timeline`  
**Description**: Get age-based vaccination timeline for beneficiary

**Response**:
```json
{
  "child": {
    "id": 11,
    "name": "Priya Kumar",
    "dob": "2020-03-20",
    "age_weeks": 208
  },
  "timeline": [
    {
      "vaccine_name": "BCG",
      "vaccine_code": "BCG001",
      "dose": "Birth Dose",
      "dose_number": 1,
      "status": "COMPLETED",
      "vaccinated_on": "2020-03-20",
      "due_date": null,
      "is_birth_dose": true,
      "vaccination_id": 5
    },
    {
      "vaccine_name": "DPT",
      "vaccine_code": "DPT001",
      "dose": "Dose 1",
      "dose_number": 1,
      "status": "UPCOMING",
      "vaccinated_on": null,
      "due_date": "2024-02-15",
      "is_birth_dose": false,
      "vaccination_id": null
    }
  ],
  "reminders": [
    {
      "vaccine_name": "DPT",
      "dose": "Dose 1",
      "due_date": "2024-02-15",
      "days_remaining": 7
    }
  ]
}
```

## Error Responses

### Beneficiary Not Found (404)
```json
{
  "detail": "Beneficiary not found"
}
```

### Unauthorized Access (403)
```json
{
  "detail": "You do not have permission to access this beneficiary"
}
```

