# Vaccination Reminder Flow

## Overview

This document describes the automated vaccination reminder system that notifies parents about upcoming vaccinations based on WHO and Indian UIP schedules.

## Flow Diagram

```
┌─────────────────┐
│  Child Profile  │
│  Created/Updated │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Calculate Age  │
│  & Schedule     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Generate       │
│  Reminders      │
└────────┬────────┘
         │
         │ For each vaccination
         ▼
┌─────────────────┐
│  Schedule       │
│  Reminders:     │
│  -7 days        │
│  -1 day         │
│  Due date       │
│  +7 days (if    │
│   missed)       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Send           │
│  Notification   │
└────────┬────────┘
         │
         │ Vaccination Administered?
         ▼
    ┌────┴────┐
    │   Yes   │  No
    │         │
    ▼         ▼
┌─────────┐ ┌──────────────┐
│ Cancel  │ │ Continue     │
│ Future  │ │ Reminders    │
│ Reminders│ │              │
└─────────┘ └──────────────┘
```

## Reminder Timing

### Standard Reminders

For each vaccination, reminders are scheduled at:

1. **7 Days Before Due Date**
   - Purpose: Early notification for planning
   - Message: "Your child's [Vaccine Name] - Dose [X] is due in 7 days"

2. **1 Day Before Due Date**
   - Purpose: Final reminder
   - Message: "Reminder: [Vaccine Name] - Dose [X] is due tomorrow"

3. **On Due Date**
   - Purpose: Same-day reminder
   - Message: "Today is the due date for [Vaccine Name] - Dose [X]"

4. **7 Days After Due Date** (if missed)
   - Purpose: Follow-up for missed vaccinations
   - Message: "Missed: [Vaccine Name] - Dose [X] was due 7 days ago. Please schedule soon."

### Birth Dose Reminders

For birth dose vaccines (BCG, Hepatitis B, OPV-0):
- Reminders triggered on **date of birth**
- No date range calculation
- Message: "[Vaccine Name] Birth Dose is due at birth or within 24 hours"

## Reminder Generation Process

### Step 1: Profile Creation/Update

**Trigger**: When child profile is created or date of birth is updated

**API Call**: `POST /api/v1/reminders/beneficiaries/{beneficiary_id}/schedule`

**Backend Actions**:
1. Calculate child's current age
2. Look up vaccination schedule from vaccine master data
3. Generate timeline with due dates
4. Schedule reminders for each vaccination

### Step 2: Reminder Scheduling

**For Each Vaccination**:

```json
{
  "beneficiary_id": 11,
  "vaccine_code": "DPT001",
  "vaccine_name": "DPT",
  "dose_number": 1,
  "due_date": "2024-02-15",
  "reminders": [
    {
      "type": "before_due",
      "reminder_date": "2024-02-08",
      "days_before": 7,
      "status": "pending"
    },
    {
      "type": "before_due",
      "reminder_date": "2024-02-14",
      "days_before": 1,
      "status": "pending"
    },
    {
      "type": "on_due",
      "reminder_date": "2024-02-15",
      "days_before": 0,
      "status": "pending"
    },
    {
      "type": "after_missed",
      "reminder_date": "2024-02-22",
      "days_after": 7,
      "status": "pending"
    }
  ]
}
```

### Step 3: Notification Delivery

**Channels**:
- **Push Notification**: Mobile app notification
- **SMS**: Text message to registered mobile number
- **Email**: Email to registered email address (if provided)

**User Preferences**: Parents can configure notification channels per vaccine

### Step 4: Reminder Cancellation

**Trigger**: When vaccination is marked as "completed"

**API Call**: Automatic cancellation when vaccination status changes

**Backend Actions**:
1. Mark all pending reminders for that vaccination as "cancelled"
2. Remove from notification queue
3. Log cancellation reason

## Reminder Status Values

- `pending`: Reminder scheduled but not yet sent
- `sent`: Reminder notification delivered
- `cancelled`: Reminder cancelled (vaccination completed)
- `failed`: Notification delivery failed

## Notification Content

### Standard Reminder Message

```
Subject: Vaccination Reminder - [Child Name]

Dear Parent,

This is a reminder that [Child Name]'s vaccination is due:

Vaccine: [Vaccine Name] - Dose [X]
Due Date: [Date]
Days Remaining: [X] days

Please schedule an appointment with your healthcare provider.

Thank you,
Vaccination Locker Team
```

### Birth Dose Reminder Message

```
Subject: Birth Dose Vaccination Reminder

Dear Parent,

[Child Name]'s birth dose vaccination is due:

Vaccine: [Vaccine Name] (Birth Dose)
Due: At birth or within 24 hours

Please ensure this vaccination is administered at the hospital.

Thank you,
Vaccination Locker Team
```

## User Controls

### Reminder Settings

**Endpoint**: `PUT /api/v1/reminders/preferences/beneficiaries/{beneficiary_id}/vaccines/{vaccine_id}`

**Request**:
```json
{
  "enable_reminders": true,
  "notification_channels": ["push", "sms", "email"],
  "days_before_reminder": [7, 1],
  "enable_missed_reminder": true
}
```

### Disable Reminders

Parents can disable reminders for specific vaccines:
- Useful for vaccines not applicable to their child
- Can be re-enabled at any time

## Catch-Up Schedule Support

If a child misses vaccinations, the system:
1. Identifies missed vaccines
2. Schedules catch-up reminders
3. Adjusts future vaccination dates accordingly
4. Maintains proper spacing between doses

## Error Handling

### Reminder Generation Failed
```json
{
  "detail": "Failed to generate reminders. Please try again."
}
```

### Notification Delivery Failed
- System retries up to 3 times
- Logs failure for manual follow-up
- Continues with other reminders

## Integration Points

### Backend Scheduling
- Uses cron jobs or background workers
- Processes reminders daily at scheduled times
- Handles timezone conversions

### Notification Service
- Integrates with SMS gateway
- Integrates with email service
- Uses push notification service (FCM/APNS)

## Audit Trail

All reminder operations are logged:
- Reminder creation
- Notification sent
- Reminder cancellation
- User preference changes

