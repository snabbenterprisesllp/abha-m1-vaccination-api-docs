# Child Profile Creation Flow

## Overview

This document describes the flow for creating a child profile in the Vaccination Locker system.

## Flow Diagram

```
┌─────────────┐
│   Parent    │
│  Dashboard  │
└──────┬──────┘
       │
       │ Click "Add Child"
       ▼
┌─────────────────┐
│  Add Child Form │
└──────┬──────────┘
       │
       │ Enter Child Details
       ▼
┌─────────────────┐
│  Validate Form  │
└──────┬──────────┘
       │
       │ Create Child Profile
       ▼
┌─────────────────┐
│  POST /api/v1/  │
│  beneficiaries  │
└──────┬──────────┘
       │
       │ Profile Created
       ▼
┌─────────────────┐
│  Generate QR    │
│  Code           │
└──────┬──────────┘
       │
       │ Generate Timeline
       ▼
┌─────────────────┐
│  Calculate Age  │
│  & Schedule     │
└──────┬──────────┘
       │
       │ Profile Ready
       ▼
┌─────────────────┐
│  Child Detail   │
│  Page           │
└─────────────────┘
```

## Step-by-Step Process

### Step 1: Initiate Child Profile Creation

**User Action**: Parent clicks "Add Child" button on dashboard  
**Screen**: Add Child Profile form

### Step 2: Enter Child Information

**Required Fields**:
- First Name
- Last Name
- Date of Birth
- Gender (Male/Female/Other)

**Optional Fields**:
- Middle Name
- Phone Number
- Email Address
- Birth Weight
- Birth Height
- Head Circumference
- Gestational Age Type (Full term/Preterm/Post-term)
- Gestational Age Weeks
- Place of Birth
- Address
- Blood Group
- Allergies
- Medical Conditions

### Step 3: Form Validation

**Client-Side Validation**:
- All required fields must be filled
- Date of birth cannot be in the future
- Date of birth must be reasonable (not more than 18 years ago for child)
- Phone number format validation (if provided)
- Email format validation (if provided)

### Step 4: Create Child Profile

**API Call**: `POST /api/v1/beneficiaries`

**Request**:
```json
{
  "first_name": "Priya",
  "last_name": "Kumar",
  "date_of_birth": "2020-03-20",
  "gender": "female",
  "type": "CHILD",
  "birth_weight": "3.2",
  "birth_height": "50.5",
  "head_circumference": "35.0",
  "gestational_age_type": "full_term",
  "gestational_age_weeks": 38,
  "place_of_birth": "City Hospital",
  "blood_group": "O+"
}
```

**Response**:
```json
{
  "id": 11,
  "first_name": "Priya",
  "last_name": "Kumar",
  "date_of_birth": "2020-03-20",
  "gender": "female",
  "type": "CHILD",
  "abha_number": null,
  "abha_linked": false,
  "qr_code_url": "https://storage.example.com/qr/beneficiary_11_qr.png",
  "qr_code_token": "qr_token_abc123",
  "created_at": "2024-01-15T10:00:00Z"
}
```

**Backend Actions**:
1. Create beneficiary record (type: CHILD)
2. Link to parent user
3. Generate unique QR code
4. Create child profile record (legacy support)
5. Calculate age in weeks
6. Generate initial vaccination timeline

### Step 5: Generate Vaccination Timeline

**Automatic Process**: After profile creation, system automatically:
1. Calculates child's age in weeks
2. Looks up WHO/Indian UIP vaccination schedule
3. Generates timeline with:
   - Completed vaccines (if any birth doses were given)
   - Upcoming vaccines based on age
   - Due dates for each vaccine

**Timeline Generation**:
- Birth dose vaccines (BCG, Hepatitis B, OPV-0) marked as "Due at Birth"
- Age-based vaccines scheduled according to UIP schedule
- Status set to "DUE_NEXT" for future vaccines

### Step 6: Display Child Profile

**Screen**: Child Detail Page showing:
- Profile information
- Vaccination timeline
- Upcoming vaccinations
- Document locker
- QR code for sharing

## Birth Details Section

### Head Circumference
- **Unit**: Centimeters (cm)
- **Optional**: Yes
- **Purpose**: Track growth metrics

### Gestational Age
- **Type**: Full term / Preterm / Post-term
- **Weeks**: Number of weeks (e.g., 38)
- **Optional**: Yes
- **Purpose**: Adjust vaccination schedule if needed

## Validation Rules

### Date of Birth
- Cannot be in the future
- Must be within last 18 years (for CHILD type)
- Format: YYYY-MM-DD

### Name Fields
- First name: Required, 1-50 characters
- Last name: Required, 1-50 characters
- Middle name: Optional, 1-50 characters

### Gender
- Must be one of: "male", "female", "other"

## Error Handling

### Invalid Date of Birth
```json
{
  "detail": "Date of birth cannot be in the future"
}
```

### Missing Required Fields
```json
{
  "detail": [
    {
      "field": "first_name",
      "message": "First name is required"
    }
  ]
}
```

### Duplicate Profile
```json
{
  "detail": "A profile with this information already exists"
}
```

## Post-Creation Actions

After child profile creation, parents can:
1. View vaccination timeline
2. Link ABHA number (optional)
3. Upload birth certificate
5. Record birth dose vaccinations
6. Set up vaccination reminders

## QR Code Generation

**Purpose**: Quick access to child's vaccination records  
**Format**: PNG image  
**Content**: Encoded beneficiary ID token  
**Usage**: Hospitals can scan QR code to access vaccination history (with consent)

**QR Code Data Structure**:
```json
{
  "beneficiary_id": 11,
  "qr_token": "qr_token_abc123",
  "type": "CHILD"
}
```

