# Data Model

This document describes the data entities, their properties, and relationships for StatTrack.

---

## Entity Relationship Diagram

```
ChildProfile (1) ---- (∞) Match
    |
    +---- (∞) Season
```

- A **ChildProfile** can have many **Match** records
- A **Match** belongs to one **ChildProfile** and one **Season**
- A **Season** can contain matches for multiple profiles

---

## Entities

### ChildProfile

Represents a player (child or adult) being tracked.

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| `id` | String (UUID) | Unique identifier | Yes |
| `nickname` | String | Display name for the profile | Yes |
| `firstName` | String? | Optional first name | No |
| `lastName` | String? | Optional last name | No |
| `birthYear` | int? | Year of birth for age calculation | No |
| `createdAt` | DateTime | Creation timestamp | Yes (auto) |
| `updatedAt` | DateTime | Last update timestamp | Yes (auto) |

**Constraints:**
- Maximum 4 profiles per device (R-01)
- `nickname` is mandatory (R-04)
- Cannot delete the last profile (R-08)

---

### Season

Represents a sports season for organizing match data.

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| `id` | String (UUID) | Unique identifier | Yes |
| `name` | String | Display name (e.g., "2026/2027") | Yes |
| `startYear` | int | Starting year of the season | Yes |
| `endYear` | int | Ending year of the season | Yes |
| `createdAt` | DateTime | Creation timestamp | Yes (auto) |

**Constraints:**
- Format: `YYYY/YYYY+1` (e.g., 2026/2027) (R-02)
- Runs from September to June (R-03)
- Most recent season selected by default (R-09)

---

### Match

Represents a game session with recorded statistics.

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| `id` | String (UUID) | Unique identifier | Yes |
| `childId` | String | Reference to ChildProfile | Yes |
| `seasonId` | String | Reference to Season | Yes |
| `startTime` | DateTime | Match start timestamp | Yes |
| `endTime` | DateTime? | Match end timestamp | No |
| `goals` | int | Number of goals scored | Yes (default: 0) |
| `assists` | int | Number of assists | Yes (default: 0) |
| `duration` | Duration? | Calculated match duration | No |
| `createdAt` | DateTime | Creation timestamp | Yes (auto) |
| `updatedAt` | DateTime | Last update timestamp | Yes (auto) |

**Constraints:**
- Minimum counter value is 0 (R-06)
- Only one match can be in progress per profile (R-07)
- Alert if starting match on non-current season (R-10)

---

### Stats (Computed)

Aggregated statistics calculated from Match records.

| Field | Type | Description |
|-------|------|-------------|
| `totalMatches` | int | Total number of matches played |
| `totalGoals` | int | Total number of goals scored |
| `totalAssists` | int | Total number of assists |

---

## Data Flow

```
User Action → UI → Riverpod Provider → Hive Database
                                  ↓
                           Sync Service (WebRTC/Bluetooth)
                                  ↓
                           Encryption (AES-256)
                                  ↓
                           Other Device
```

---

## Hive Configuration

The application uses Hive for local storage with the following boxes:

- `child_profiles`: Stores ChildProfile objects
- `seasons`: Stores Season objects
- `matches`: Stores Match objects

**build.yaml** configuration required for Hive model generation:

```yaml
# This file is used by build_runner to generate Hive adapters
# Run: flutter packages pub run build_runner build
```

---

## Example Data

### Sample ChildProfile

```dart
ChildProfile(
  id: '550e8400-e29b-41d4-a716-446655440000',
  nickname: 'Leo',
  firstName: 'Leonardo',
  lastName: 'Messi',
  birthYear: 2016,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
)
```

### Sample Season

```dart
Season(
  id: '550e8400-e29b-41d4-a716-446655440001',
  name: '2026/2027',
  startYear: 2026,
  endYear: 2027,
  createdAt: DateTime.now(),
)
```

### Sample Match

```dart
Match(
  id: '550e8400-e29b-41d4-a716-446655440002',
  childId: '550e8400-e29b-41d4-a716-446655440000',
  seasonId: '550e8400-e29b-41d4-a716-446655440001',
  startTime: DateTime.now(),
  endTime: null,
  goals: 3,
  assists: 1,
  duration: null,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
)
```

---

**See also:**
- [Technical Architecture](ARCHITECTURE.md) for implementation details
- [Sync Protocol](SYNC-PROTOCOL.md) for data synchronization format
- [Functional Specifications](FUNCTIONAL-SPECS.md) for business rules
