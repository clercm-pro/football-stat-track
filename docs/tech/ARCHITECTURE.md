# Technical Architecture

This document describes the technical architecture, technology stack, and project structure for StatTrack.

---

## Architecture Overview

```mermaid
flowchart TD
    A[Frontend: Flutter] --> B[State Management: Riverpod]
    A --> C[Database: Hive]
    C --> D[(Local Storage)]
    A --> E[Sync Service: WebRTC/Bluetooth]
    E --> F[Pair-to-Pair Sync]
    F --> G[Encryption: AES-256]
```

## Technology Stack

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| **Frontend** | Flutter (Dart) | SDK >= 3.0.0 | Cross-platform UI |
| **State Management** | Riverpod | ^2.4.9 | Reactive state management |
| **Database** | Hive | ^2.2.3 | Local NoSQL storage |
| **Sync** | WebRTC | ^0.9.38 | Peer-to-peer synchronization |
| **QR Code** | qr_flutter | ^4.1.0 | QR code generation/reading |
| **Encryption** | cryptography | ^2.5.0 | Data security |
| **Vibration** | vibration | ^3.0.0 | Haptic feedback |
| **UUID** | uuid | ^3.0.7 | ID generation |

## Project Structure

```
football-stat-track/
├── lib/
│   ├── main.dart                 # Entry point
│   ├── app.dart                  # Theme configuration
│   ├── config/
│   │   └── colors.dart           # Color palette
│   ├── models/
│   │   ├── child_profile.dart    # Profile model
│   │   ├── season.dart           # Season model
│   │   └── match.dart            # Match + Stats model
│   ├── providers/
│   │   ├── child_profile_provider.dart
│   │   ├── season_provider.dart
│   │   └── match_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── match_screen.dart
│   │   ├── create_profile_screen.dart
│   │   └── create_season_screen.dart
│   └── widgets/
│       ├── profile_card.dart
│       └── stat_card.dart
├── pubspec.yaml              # Dependencies
├── build.yaml                # Hive configuration
├── android/
│   └── app/src/main/AndroidManifest.xml
├── ios/
│   └── Runner/Info.plist
└── README.md
```

## Key Technical Decisions

### Local-First Approach

All data is stored locally using Hive, a lightweight NoSQL database for Flutter. This ensures:
- Offline functionality
- Fast access to data
- No dependency on external servers
- Full user control over their data

### Peer-to-Peer Synchronization

Data synchronization happens directly between devices using WebRTC and Bluetooth, without a central server. This provides:
- True privacy - no third-party access to data
- Offline sync capability
- Lower infrastructure costs
- Faster synchronization for nearby devices

### End-to-End Encryption

All data is encrypted using AES-256 before transmission. Keys are exchanged via QR codes or WebRTC connection, ensuring:
- Confidentiality of user data
- Protection against interception
- Secure data at rest and in transit

### Design System - Scoreboard Theme (v2.0)

**Migration Date:** 2026-09-03
**Reference:** docs/design/claude_design/README.md
**Gherkin Scenarios:** @DS-01, @HOME-01, @PROFILE-01, @MATCH-01, @SUMMARY-01, @CREATE-01, @LOC-02

The application migrated from a **dark theme** with purple/blue palette to a **light theme** with modern turquoise palette.

#### Theme Architecture
- **Theme Type:** Light theme (replacing dark theme)
- **Background:** `#F3F4F3` (light gray)
- **Primary Colors:** `#008A78` (turquoise), `#01584A` (dark turquoise)
- **Typography:** Archivo font family (replacing Roboto)
- **Accessibility:** All contrast ratios ≥ 4.5:1

#### Theme Implementation
```dart
// Theme configuration in lib/app.dart or lib/config/theme.dart
ThemeData get lightTheme => ThemeData(
  colorScheme: ColorScheme.light(
    background: AppColors.background, // #F3F4F3
    surface: AppColors.surface,     // #FFFFFF
    primary: AppColors.primary,     // #008A78
    onPrimary: Colors.white,
    onSurface: AppColors.ink,       // #343B46
  ),
  fontFamily: 'Archivo',
  // Other theme properties
);
```

#### Design Tokens System
The application uses a token-based design system for consistency:
- **Colors:** Defined in `lib/config/colors.dart`
- **Spacing:** Recommended to define in `lib/config/spacing.dart`
- **Typography:** Recommended to define in `lib/config/typography.dart`

#### Migration Impact
- All screens required UI updates to match new design
- No changes to state management or data layer
- Backward compatibility maintained through theme switching

---

**See also:**
- [DESIGN-GUIDELINES.md](DESIGN-GUIDELINES.md) for visual specifications
- [CODE-STANDARDS.md](CODE-STANDARDS.md) for coding conventions
- [DATA-MODEL.md](DATA-MODEL.md) for entity definitions
- [../SYNC-PROTOCOL.md](../SYNC-PROTOCOL.md) for synchronization details
- [../SETUP.md](../SETUP.md) for development environment configuration
