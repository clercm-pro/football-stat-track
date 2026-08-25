# 🔍 Analyse Technique - BUG-01

## 📌 Metadata

| Propriété | Valeur |
|-----------|--------|
| **ID** | BUG-01 |
| **Type** | Bug UI/UX |
| **Priorité** | 🔴 Haute |
| **Complexité** | ⭐ (Très faible) |
| **Estimation** | 30 min |
| **Statut** | ⚠️ Corrigé (documentation rétroactive) |

---

## 🎯 Contexte

### Problème identifié
Les cartes des joueurs sur la page d'accueil **n'étaient pas lisibles** car elles utilisaient la même couleur de fond que l'application (`AppColors.surface` = `0xFF1A1A1A`), rendant les cartes **invisibles** sur le fond sombre.

### Impact
- **Accessibilité** : Ratio de contraste = 0:1 (norme WCAG : minimum 3:1)
- **Expérience utilisateur** : Impossibilité de distinguer les cartes
- **Design** : Violation des bonnes pratiques Material Design

---

## 🔍 Diagnostic

### Architecture actuelle
```
Scaffold (background: AppColors.surface = 0xFF1A1A1A)
└── GridView
    └── ProfileCard (color: AppColors.surface = 0xFF1A1A1A) ❌
```

### Causes racines
| Cause | Fichier | Ligne | Impact |
|-------|--------|-------|--------|
| Couleur de carte = fond | `home_screen.dart` | 353 | Cartes invisibles |
| `cardTheme.color` = `surface` | `colors.dart` | 73 | Thème incohérent |
| `elevation` trop faible | `home_screen.dart` | 354 | Peu de profondeur |
| Bordure trop transparente | `home_screen.dart` | 359 | Pas de délimitation |

---

## 🔧 Solution technique

### Modifications apportées

#### 1. `lib/config/colors.dart` (Thème global)
```dart
// AVANT
cardTheme: CardThemeData(
  elevation: 4,
  color: surface,  // ❌ Même couleur que le fond
  shape: RoundedRectangleBorder(...),
)

// APRÈS
cardTheme: CardThemeData(
  elevation: 8,    // Ombre renforcée
  color: surfaceLight,  // 0xFF2A2A2A > 0xFF1A1A1A ✅
  shape: RoundedRectangleBorder(
    side: BorderSide(  // Bordure visible
      color: primary.withValues(alpha: 0.5),
      width: 1.0,
    ),
  ),
)
```

#### 2. `lib/screens/home_screen.dart` (Cartes des joueurs)
```dart
// AVANT
Card(
  color: AppColors.surface,    // ❌ Invisible
  elevation: 4,
  side: BorderSide(alpha: 0.3),
)

// APRÈS
Card(
  color: AppColors.surfaceLight,  // ✅ Visible
  elevation: 8,
  side: BorderSide(alpha: 0.5, width: 1.0),
)
```

---

## 📊 Métriques

| Métrique | Avant | Après | Amélioration |
|----------|-------|-------|--------------|
| Contraste carte/fond | 0:1 | ~10% (0xFF2A2A2A vs 0xFF1A1A1A) | ✅ Lible |
| `elevation` | 4 | 8 | +100% |
| Opacité bordure | 0.3 | 0.5 | +66% |
| Épaisseur bordure | 0 (par défaut) | 1.0 | ✅ Ajoutée |

---

## ⚠️ Risques identifiés

| ID | Description | Probabilité | Impact | Atténuation |
|----|-------------|-------------|--------|-------------|
| RISK-BUG-01-1 | Incohérence avec d'autres cartes de l'app | Moyenne | Faible | Appliquer `cardTheme` globalement |
| RISK-BUG-01-2 | `surfaceLight` trop clair pour le thème | Faible | Faible | Tester visuellement |

---

## 🔗 Dépendances impactées
Aucune dépendance externe modifiée (seulement du code Dart/Flutter natif).

---

## ✅ Validation
- [x] `flutter analyze` → No issues
- [x] Contraste visuel vérifié manuellement
- [ ] Test utilisateur sur différents devices (à faire)
