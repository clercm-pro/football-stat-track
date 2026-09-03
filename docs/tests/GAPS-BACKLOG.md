# 📊 GAPs Identifiés - Tests Manquants

## 📌 Metadata
- **Dernière mise à jour:** 2026-09-03
- **Méthodologie:** Audit des scénarios Gherkin vs tests automatisés existants
- **Outils:** flutter_test, mockito

---

## 🏷️ Catégories de GAPs

### 🐛 GAPs de Bug Fix (Priorité: 🔴 Haute)

| ID | Bug ID | Titre | Scénario Gherkin | Type | Fichier Manquant | Statut |
|----|--------|-------|------------------|------|------------------|--------|
| GAP-01 | BUG-AND-01 | Crash Android SafeArea | @BUG-AND-01-1, @BUG-AND-01-2 | Widget Test | `test/widgets/match_screen_test.dart` | ⏳ |
| GAP-02 | BUG-COM-01 | Compilation DiagnosticPropertiesBuilder | @BUG-COM-01-1 | Compilation Test | `test/unit/profile_screen_test.dart` | ⏳ |
| GAP-03 | BUG-COM-02 | Offset non-constant | @BUG-COM-02-1 | Compilation Test | `test/unit/match_screen_test.dart` | ⏳ |
| GAP-04 | BUG-BY-01 | FormatException birthYear | @BUG-BY-01-1, @BUG-BY-01-2 | Widget Test | `test/widgets/create_profile_screen_test.dart` | ⏳ |

### ✨ GAPs de Features (Priorité: 🟡 Moyenne)

| ID | Feature ID | Titre | Scénario Gherkin | Type | Fichier Manquant | Statut |
|----|------------|-------|------------------|------|------------------|--------|
| GAP-05 | PROFILE-01 | Page de Profil - Design Scoreboard | @PROFILE-01-1 à @PROFILE-01-6 | Widget Test | `test/widgets/profile_screen_test.dart` | ⏳ |
| GAP-06 | MATCH-01 | Match en Direct | @MATCH-01-1 à @MATCH-01-7 | Widget Test | `test/widgets/match_screen_test.dart` | ⏳ |
| GAP-07 | CREATE-01 | Création de Profil | @CREATE-01-1 à @CREATE-01-7 | Widget Test | `test/widgets/create_profile_screen_test.dart` | ⏳ |
| GAP-08 | SUMMARY-01 | Résumé de Match | @SUMMARY-01-1 à @SUMMARY-01-7 | Widget Test | `test/widgets/match_summary_test.dart` | ⏳ |

### 🌐 GAPs de Localisation (Priorité: 🟢 Faible)

| ID | Feature ID | Titre | Scénario Gherkin | Type | Fichier Manquant | Statut |
|----|------------|-------|------------------|------|------------------|--------|
| GAP-09 | LOC-02 | Nouvelles chaînes de caractères | @LOC-02-1, @LOC-02-2 | Widget Test | `test/l10n/app_localizations_test.dart` | ⏳ |

### 🎨 GAPs de Design System (Priorité: 🟡 Moyenne)

| ID | Feature ID | Titre | Scénario Gherkin | Type | Fichier Manquant | Statut |
|----|------------|-------|------------------|------|------------------|--------|
| GAP-10 | DS-01 | Thème Clair + Palette | @DS-01-1 à @DS-01-4 | Unit Test | `test/unit/theme_test.dart` | ⏳ |
| GAP-11 | DS-01 | Typographie Archivo | @DS-01-5 | Widget Test | `test/widgets/typography_test.dart` | ⏳ |

### 🏠 GAPs de Page d'Accueil (Priorité: 🟡 Moyenne)

| ID | Feature ID | Titre | Scénario Gherkin | Type | Fichier Manquant | Statut |
|----|------------|-------|------------------|------|------------------|--------|
| GAP-12 | HOME-01 | En-tête dynamique | @HOME-01-1 | Widget Test | `test/widgets/home_screen_test.dart` (étendre) | ⏳ |
| GAP-13 | HOME-01 | Carte de joueur | @HOME-01-2, @HOME-01-3 | Widget Test | `test/widgets/home_screen_test.dart` (étendre) | ⏳ |
| GAP-14 | HOME-01 | État vide | @HOME-01-5 | Widget Test | `test/widgets/home_screen_test.dart` (étendre) | ⏳ |
| GAP-15 | HOME-01 | Limite de profils | @HOME-01-6 | Widget Test | `test/widgets/home_screen_test.dart` (étendre) | ⏳ |

---

## 📈 Statistiques

| Catégorie | Total Gherkin | Avec Tests | GAPs | Couverture |
|-----------|---------------|------------|------|------------|
| Bug Fix | 8 | 0 | 4 | 0% |
| Features | 28 | 0 | 4 | 0% |
| Localisation | 2 | 0 | 1 | 0% |
| Design System | 4 | 0 | 2 | 0% |
| Home | 6 | 2 | 4 | 33% |
| **Total** | **48** | **2** | **15** | **4%** |

---

## 🎯 Recommandations

### Priorité Immédiate (🔴)
1. **GAP-01** - Tester le fix SafeArea sur Android (BUG-AND-01)
2. **GAP-04** - Tester la validation birthYear (BUG-BY-01)

### Priorité Moyenne (🟡)
3. **GAP-05 à GAP-08** - Créer les tests widgets pour les pages principales
4. **GAP-10, GAP-11** - Tests du design system

### Priorité Faible (🟢)
5. **GAP-09** - Tests de localisation
6. **GAP-12 à GAP-15** - Étendre les tests HomeScreen

---

## 📝 Template pour Nouveaux Tests

### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('@ID-XX - Description du test', (final tester) async {
    // Setup
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: ScreenToTest()),
      ),
    );
    
    // Action
    await tester.tap(find.byType(Button));
    await tester.pump();
    
    // Assert
    expect(find.text('Expected'), findsOneWidget);
  });
}
```

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('@ID-XX - Description du test', () {
    // Setup
    final result = functionToTest(param);
    
    // Assert
    expect(result, expectedValue);
  });
}
```

---

## 🔗 Références
- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Gherkin to Dart Test Mapping Guide](https://pub.dev/packages/cucumber)
- [Riverpod Testing Guide](https://riverpod.dev/docs/testing)
