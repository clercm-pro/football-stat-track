# Setup & Deployment

This guide covers development environment setup, building, and deploying StatTrack.

---

## Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version >= 3.0.0)
- Android Studio or Xcode (for Android/iOS development respectively)
- Git
- Android device (API 24+) or iOS device (iOS 13+) for testing

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/clercm-pro/football-stat-track.git
cd football-stat-track
```

### 2. Install Dependencies

```bash
flutter pub get
```

This installs all dependencies listed in `pubspec.yaml`:
- `flutter_riverpod: ^2.4.9` - State management
- `hive: ^2.2.3` - Local database
- `flutter_webrtc: ^0.9.38` - Peer-to-peer sync
- `cryptography: ^2.5.0` - Encryption
- `qr_flutter: ^4.1.0` - QR code support
- And more...

### 3. Generate Hive Adapters

**Important**: This step is required before running the app.

```bash
flutter packages pub run build_runner build
```

This generates the necessary type adapters for Hive to store custom objects (ChildProfile, Season, Match).

If you modify any model classes, re-run this command.

### 4. Run the Application

```bash
flutter run
```

This will:
- Start the app on a connected device or emulator
- Hot reload on code changes
- Show debug output in the console

---

## Development Commands

### Run on Specific Device

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>
```

### Run with Hot Reload

```bash
flutter run --hot-reload
```

Or use the `r` key in the console while the app is running.

### Run with Hot Restart

```bash
flutter run --hot-restart
```

Or use the `R` key in the console while the app is running.

---

## Building for Release

### Android

#### APK Build

```bash
flutter build apk --release
```

The APK will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

#### App Bundle Build

```bash
flutter build appbundle --release
```

The app bundle will be generated at:
`build/app/outputs/bundle/release/app-release.aab`

#### Install Release APK

```bash
flutter install --release
```

### iOS

#### IPA Build

```bash
flutter build ipa --release
```

The IPA will be generated at:
`build/ios/ipa/StatTrack.ipa`

#### Run on iOS Simulator

```bash
flutter emulators --launch <simulator_name>
flutter run
```

---

## Emulator Management

### List Available Emulators

```bash
flutter emulators --list
```

### Launch Emulator

```bash
flutter emulators --launch <emulator_name>
```

### Create New Emulator

Use Android Studio's AVD Manager or:

```bash
# Android
android create avd -n <name> -t <target> --abi <abi>

# iOS (via Xcode)
xcrun simctl create <name> <device_type> <runtime>
```

---

## Cleaning

### Clean Build Cache

```bash
flutter clean
```

This removes:
- The `build/` directory
- The `.dart_tool/` directory
- Pub cache (use `flutter pub cache repair` if needed)

### Rebuild After Clean

```bash
flutter pub get
flutter packages pub run build_runner build
flutter run
```

---

## Platform-Specific Setup

### Android

Ensure the following permissions are in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.VIBRATE" />
```

### iOS

Ensure the following permissions are in `ios/Runner/Info.plist`:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>StatTrack needs Bluetooth to synchronize data.</string>
<key>NSCameraUsageDescription</key>
<string>StatTrack needs the camera to scan QR codes.</string>
<key>NSLocalNetworkUsageDescription</key>
<string>StatTrack needs local network for synchronizing data.</string>
```

---

## Deploying to GitHub

### Initialize Repository

```bash
# If starting fresh
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: StatTrack with complete specifications"

# Add remote (replace with your URL)
git remote add origin https://github.com/your-username/football-stat-track.git

# Push to main branch
git branch -M main
git push -u origin main
```

### Update Existing Repository

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "Add peer-to-peer sync implementation"

# Push to remote
git push
```

---

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **Hive adapter not found** | Run `flutter packages pub run build_runner build` |
| **Device not detected** | Run `flutter devices` to check connection |
| **Dependencies not resolved** | Run `flutter pub get` |
| **Build failed** | Run `flutter clean` then rebuild |
| **Permission denied** | Ensure proper permissions in manifest/plist |

### Debug Mode

For detailed logging during development:

```bash
flutter run -v
```

For even more verbose output:

```bash
flutter run -vv
```

---

**See also:**
- [Technical Architecture](ARCHITECTURE.md) for project structure
- [Functional Specifications](FUNCTIONAL-SPECS.md) for feature details
- [Roadmap](ROADMAP.md) for project timeline
