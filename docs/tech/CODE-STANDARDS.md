# Code Standards - Flutter/Dart

**Version:** 1.0
**Date:** 2026-09-03
**Statut:** Aligné avec le design Scoreboard et les bonnes pratiques Flutter

This document outlines the coding conventions, patterns, and best practices for the StatTrack Flutter application.

---

## 📁 File Organization

### Directory Structure
```
lib/
├── config/               # Application configuration
│   ├── colors.dart       # Color palette and theme
│   ├── spacing.dart      # Spacing constants (recommended)
│   └── typography.dart   # Typography constants (recommended)
│
├── models/               # Data models (Isar)
│   ├── child_profile.dart
│   ├── season.dart
│   └── match.dart
│
├── providers/            # Riverpod providers
│   ├── child_profile_provider.dart
│   ├── season_provider.dart
│   └── match_provider.dart
│
├── screens/              # UI Screens
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   ├── match_screen.dart
│   ├── create_profile_screen.dart
│   └── create_season_screen.dart
│
├── widgets/              # Reusable widgets
│   ├── profile_card.dart
│   ├── stat_card.dart
│   ├── sparkline.dart     # NEW: Sparkline component
│   └── counter_card.dart  # NEW: Counter component
│
└── l10n/                # Localization
    └── app_localizations.dart
```

---

## 🏗️ Architecture Patterns

### State Management - Riverpod

**Rules:**
1. **Use providers for all state** - No local state in widgets (except UI state)
2. **Separation of concerns** - Providers should only manage state, not UI logic
3. **Provider naming** - Use clear, descriptive names

```dart
// ✅ GOOD
final childProfilesProvider = StateNotifierProvider<ChildProfileNotifier, List<ChildProfile>>((ref) {
  return ChildProfileNotifier();
});

// ❌ BAD - Vague name
final profilesProvider = Provider((ref) => []);
```

### Data Layer - Isar

**Rules:**
1. **All models extend IsarObject** with `@Embedded()` or `@Collection()`
2. **Use proper IDs** - UUID for all entities
3. **Timestamps** - All models should have `createdAt` and `updatedAt`

```dart
// ✅ GOOD
@Collection()
class ChildProfile {
  Id id = Isar.autoIncrement; // or UUID
  String nickname;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  
  // Indexes for querying
  @Index()
  String get nicknameLower => nickname.toLowerCase();
}
```

---

## 🎨 UI Development Standards

### Widget Structure

**Rules:**
1. **Stateless widgets by default** - Use Stateful only when needed
2. **Small, focused widgets** - Extract reusable components
3. **Use const constructors** - For immutable widgets
4. **Key usage** - Always provide keys for lists

```dart
// ✅ GOOD - Extracted component
class PlayerStatRow extends StatelessWidget {
  final int goals;
  final int assists;
  
  const PlayerStatRow({super.key, required this.goals, required this.assists});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Stat widgets
      ],
    );
  }
}

// ✅ GOOD - const constructor
const PlayerStatRow({super.key, required this.goals, required this.assists});

// ✅ GOOD - Keys in lists
ListView.builder(
  itemCount: profiles.length,
  itemBuilder: (context, index) => PlayerCard(
    key: ValueKey(profiles[index].id),
    profile: profiles[index],
  ),
)
```

### Theme Usage

**Rules:**
1. **Use AppColors tokens** - Never use hardcoded colors
2. **Respect design system** - Use correct spacing, typography
3. **Tabular figures** - All numeric values should use tabular figures

```dart
// ✅ GOOD - Using design tokens
Text(
  '25',
  style: TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  ),
)

// ❌ BAD - Hardcoded values
Text(
  '25',
  style: TextStyle(fontSize: 44, color: Color(0xFF008A78)),
)
```

### Typography

**Rules:**
1. **Use Archivo font** - Primary font family
2. **Tabular figures** - For all numeric displays
3. **Follow design spec** - Exact sizes, weights, letter-spacing

```dart
// ✅ GOOD - In theme configuration
ThemeData(
  fontFamily: 'Archivo',
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 76,
      fontWeight: FontWeight.w800,
      letterSpacing: -3,
      fontFeatures: [FontFeature.tabularFigures()],
    ),
    // Other text styles
  ),
)
```

---

## 📊 Performance Standards

### Widget Building
1. **Avoid expensive operations in build()** - Move to initState or providers
2. **Use RepaintBoundary** - For complex animations
3. **Minimize rebuilds** - Use const widgets, Provider scoping

```dart
// ✅ GOOD - Expensive operation in initState
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final List<Item> items;
  
  @override
  void initState() {
    super.initState();
    items = _loadItems(); // Expensive operation
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(children: _buildItems()); // Fast
  }
}
```

### Image and Asset Handling
1. **Use proper asset paths**
2. **Cache network images**
3. **Use appropriate sizes**

---

## 🔧 Code Quality

### Formatting
1. **Line length** - Maximum 80 characters
2. **Consistent indentation** - 2 spaces
3. **Method organization** - Group related methods
4. **Alphabetical imports** - Within groups

```dart
// ✅ GOOD - Proper formatting
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ❌ BAD - Too long, no grouping
import 'package:flutter/material.dart'; import 'package:flutter_riverpod/flutter_riverpod.dart'; import 'package:intl/intl.dart';
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Classes | PascalCase | `PlayerCard` |
| Variables | camelCase | `playerName` |
| Constants | UPPER_CASE | `MAX_PROFILES` |
| Methods | camelCase | `calculateStats()` |
| Parameters | camelCase | `playerId` |
| Files | snake_case | `player_card.dart` |

### Comments
1. **Document why, not what** - Code should be self-documenting
2. **Use /// for documentation** - For public APIs
3. **Avoid obvious comments** - Don't state the obvious

```dart
// ✅ GOOD - Explains why
/// Returns the player's age based on birth year.
/// Returns null if birth year is not provided.
int? getAge() {
  if (birthYear == null) return null;
  return DateTime.now().year - birthYear!;
}

// ❌ BAD - Obvious comment
// This method returns the age
int getAge() { ... }
```

---

## ⚡ Interaction Standards

### Touch Feedback
1. **Haptic feedback** - 30ms vibration for important actions
2. **Visual feedback** - Animations, color changes
3. **Minimum touch targets** - 48×48dp

```dart
// ✅ GOOD - Haptic feedback on counter change
void _incrementCounter() {
  HapticFeedback.lightImpact();
  setState(() => count++);
}
```

### Navigation
1. **Use Navigator 2.0** - For complex navigation (if needed)
2. **Pass required data** - Don't rely on global state
3. **Handle back navigation** - Consider willPopScope

```dart
// ✅ GOOD - Passing data
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProfileScreen(profileId: profile.id),
  ),
);
```

---

## 🧪 Testing Standards

### Widget Tests
1. **Test all scenarios** - From Gherkin features
2. **Use proper setup** - pumpWidget, tester
3. **Verify behavior** - Not just rendering

```dart
// ✅ GOOD - Widget test
void main() {
  testWidgets('PlayerCard displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlayerCard(profile: testProfile),
      ),
    );
    
    expect(find.text('Leo'), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
  });
}
```

### Provider Tests
1. **Test state changes**
2. **Mock dependencies**
3. **Verify business logic**

---

## 🚫 Anti-Patterns

### ❌ What NOT to do

```dart
// ❌ BAD - Storing BuildContext
class MyWidget extends StatelessWidget {
  BuildContext? _context; // NEVER DO THIS
  
  @override
  Widget build(BuildContext context) {
    _context = context; // This will cause issues
    return Container();
  }
}

// ❌ BAD - Async without mounted check
void _loadData() async {
  var data = await fetchData();
  setState(() => _data = data); // Might setState on disposed widget
}

// ✅ GOOD - With mounted check
void _loadData() async {
  var data = await fetchData();
  if (mounted) {
    setState(() => _data = data);
  }
}

// ❌ BAD - Large widgets, no extraction
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 500 lines of widget code
        ],
      ),
    );
  }
}

// ✅ GOOD - Extracted components
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(),
          PlayerList(),
          AddButton(),
        ],
      ),
    );
  }
}

// ❌ BAD - Hardcoded strings
Text('Add Player')

// ✅ GOOD - Localized strings
Text(AppLocalizations.of(context)!.addPlayer)
```

---

## 📝 Commit Standards

### Commit Messages
1. **Use conventional commits** - feat, fix, docs, refactor, etc.
2. **Be descriptive** - Explain what and why
3. **Reference issues** - If applicable

```bash
# ✅ GOOD
feat: implement sparkline component for home screen

# ✅ GOOD  
fix: correct contrast issue on player cards (BUG-01)

# ❌ BAD
fixed stuff
```

### Pull Requests
1. **Small, focused changes** - One feature/bug per PR
2. **Good description** - Explain changes and impact
3. **Reference design** - Link to relevant design docs
4. **Include screenshots** - For UI changes

---

## 🔗 Tools & Commands

### Analysis & Formatting
```bash
flutter analyze
flutter format .
dart format .
```

### Testing
```bash
flutter test
flutter test --tags @HOME-01
```

### Build
```bash
flutter pub get
flutter pub run build_runner build
```

---

**See also:**
- [ARCHITECTURE.md](ARCHITECTURE.md) for system architecture
- [DESIGN-GUIDELINES.md](DESIGN-GUIDELINES.md) for design specifications
- [DATA-MODEL.md](DATA-MODEL.md) for data entities
- [../specs/FEATURES.md](../specs/FEATURES.md) for Gherkin scenarios