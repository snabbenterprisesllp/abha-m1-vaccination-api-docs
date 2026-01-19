# Vaccination Record APIs

## Overview

Vaccination APIs manage vaccination records, schedules, and history for beneficiaries. Hospital staff can record vaccinations, and parents can view vaccination history.

## Get All Vaccinations

**Endpoint**: `GET /api/v1/vaccinations`  
**Description**: Get vaccination records  
**Query Parameters**:
- `child_id` (optional): Filter by child ID
- `beneficiary_id` (optional): Filter by beneficiary ID
- `status` (optional): Filter by status (`completed`, `scheduled`, `missed`)

**Response**:
```json
[
  {
    "id": 1,
    "beneficiary_id": 11,
    "vaccine_id": 5,
    "vaccine_name": "BCG",
    "dose_number": 1,
    "vaccination_date": "2020-03-20",
    "status": "completed",
    "batch_number": "BCG20200315",
    "manufacturer": "Serum Institute",
    "administered_by": "Dr. Sharma",
    "hospital_id": 10,
    "temperature": "36.5",
    "temperature_unit": "C",
    "weight": "3.2",
    "created_at": "2020-03-20T10:00:00Z"
  }
]
```

## Get Vaccination by ID

**Endpoint**: `GET /api/v1/vaccinations/{vaccination_id}`  
**Description**: Get specific vaccination record details

**Response**:
```json
{
  "id": 1,
  "beneficiary_id": 11,
  "vaccine_id": 5,
  "vaccine_name": "BCG",
  "dose_number": 1,
  "vaccination_date": "2020-03-20",
  "status": "completed",
  "batch_number": "BCG20200315",
  "manufacturer": "Serum Institute",
  "expiry_date": "2025-03-15",
  "site_of_administration": "Left arm",
  "route_of_administration": "Intradermal",
  "administered_by": "Dr. Sharma",
  "hospital_id": 10,
  "adverse_reaction": false,
  "reaction_details": null,
  "notes": "No adverse reactions observed",
  "temperature": "36.5",
  "temperature_unit": "C",
  "weight": "3.2",
  "height_length": "50.5",
  "pulse_rate": 120,
  "oxygen_saturation": "98.5",
  "created_at": "2020-03-20T10:00:00Z",
  "updated_at": "2020-03-20T10:00:00Z"
}
```

## Create Vaccination Record

**Endpoint**: `POST /api/v1/vaccinations`  
**Description**: Create a new vaccination record  
**Role**: Hospital staff

**Request**:
```json
{
  "beneficiary_id": 11,
  "vaccine_id": 5,
  "vaccine_name": "DPT",
  "dose_number": 1,
  "vaccination_date": "2024-02-15",
  "status": "completed",
  "batch_number": "DPT20240210",
  "manufacturer": "Serum Institute",
  "administered_by": "Dr. Sharma",
  "hospital_id": 10,
  "site_of_administration": "Left thigh",
  "route_of_administration": "Intramuscular",
  "temperature": "36.8",
  "temperature_unit": "C",
  "weight": "8.5",
  "height_length": "72.0",
  "pulse_rate": 110,
  "oxygen_saturation": "99.0",
  "adverse_reaction": false,
  "notes": "Vaccination administered successfully"
}
```

**Response**: Created vaccination object

## Update Vaccination Record

**Endpoint**: `PUT /api/v1/vaccinations/{vaccination_id}`  
**Description**: Update vaccination record  
**Role**: Hospital staff (who created it) or Admin

**Request**: Same format as create, with fields to update

**Response**: Updated vaccination object

## Delete Vaccination Record

**Endpoint**: `DELETE /api/v1/vaccinations/{vaccination_id}`  
**Description**: Soft delete vaccination record  
**Role**: Admin only

**Response**:
```json
{
  "message": "Vaccination record deleted successfully"
}
```

## Vaccination Status Values

- `completed`: Vaccination has been administered
- `scheduled`: Vaccination is scheduled for future date
- `missed`: Vaccination was due but not administered
- `cancelled`: Scheduled vaccination was cancelled

## Vitals at Vaccination

All vaccination records include vitals captured at the time of vaccination:

- **Temperature** (mandatory): Body temperature in °C or °F
- **Weight** (mandatory): Weight in kilograms
- **Height/Length** (optional): Height/length in centimeters
- **Pulse Rate** (optional): Heart rate in beats per minute
- **Oxygen Saturation** (optional): SpO₂ percentage

## Error Responses

### Invalid Beneficiary (400)
```json
{
  "detail": "Beneficiary ID is required"
}
```

### Invalid Hospital (400)
```json
{
  "detail": "Invalid hospital ID"
}
```

### Unauthorized (403)
```json
{
  "detail": "Only hospital staff can create vaccination records"
}
```

