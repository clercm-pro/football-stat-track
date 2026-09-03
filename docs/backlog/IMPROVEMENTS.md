# 💡 Améliorations Techniques et Fonctionnelles

## 📌 Metadata
- **Dernière mise à jour:** 2026-09-03
- **Source:** Revue de code et analyse pendant la correction des bugs
- **Priorisation:** MoSCoW

---

## 🏗️ Améliorations Techniques

### Priorité 🔴 Haute

| ID | Titre | Description | Fichier | Impact | Statut |
|----|-------|-------------|--------|--------|--------|
| IMP-01 | Supprimer tous les `debugFillProperties` | Méthodes inutiles dans les ConsumerWidgets qui causent des erreurs de compilation | `lib/screens/*.dart` | Bloquant | ✅ **DONE** |
| IMP-02 | Corriger les imports inutilisés | `flutter/foundation.dart` importé sans être utilisé dans plusieurs fichiers | `lib/screens/*.dart` | Performance | ✅ **DONE** |
| IMP-03 | Extraire les valeurs non-constantes | Éviter les expressions ternaires dans les constructors | `lib/screens/match_screen.dart` | Compilation | ✅ **DONE** |

### Priorité 🟡 Moyenne

| ID | Titre | Description | Fichier | Impact | Statut |
|----|-------|-------------|--------|--------|--------|
| IMP-04 | Appliquer SafeArea(bottom: true) partout | Éviter les crashes Android avec IME | `lib/screens/*.dart` | Android | ⏳ |
| IMP-05 | Ajouter validation en temps réel | Feedback visuel immédiat pour les champs de formulaire | `lib/screens/create_profile_screen.dart` | UX | ⏳ |
| IMP-06 | Standardiser les messages d'erreur | Utiliser des constantes pour les messages de validation | `lib/screens/create_profile_screen.dart` | Maintenabilité | ⏳ |
| IMP-07 | Corriger les paramètres nommés | Respecter l'ordre required > optional | `lib/screens/match_screen.dart:825` | Style | ⏳ |
| IMP-08 | Utiliser const partout | Optimisation des performances | `lib/screens/*.dart` | Performance | ⏳ |
| IMP-09 | Corriger les lignes > 80 chars | Respect des CODE-STANDARDS | `lib/screens/*.dart` | Lisibilité | ⏳ |

### Priorité 🟢 Faible

| ID | Titre | Description | Fichier | Impact | Statut |
|----|-------|-------------|--------|--------|--------|
| IMP-10 | Ajouter Tooltip sur les champs | Accessibilité améliorée | `lib/screens/*.dart` | Accessibilité | ⏳ |
| IMP-11 | Animation de feedback | Ajouter des animations pour les interactions | `lib/screens/match_screen.dart` | UX | ⏳ |
| IMP-12 | Refactor des fonctions utilitaires | Extraire la logique commune | `lib/screens/create_profile_screen.dart` | DRY | ⏳ |

---

## ✨ Améliorations Fonctionnelles

### Priorité 🟡 Moyenne

| ID | Titre | Description | Fichier | Impact | Statut |
|----|-------|-------------|--------|--------|--------|
| IMP-20 | Limite de profils visuelle | Afficher un indicateur "X/4 profils" | `lib/screens/home_screen.dart` | UX | ⏳ |
| IMP-21 | Confirmation avant suppression | Dialogue de confirmation pour supprimer un profil | `lib/screens/profile_screen.dart` | UX | ⏳ |
| IMP-22 | Export des données | Permettre l'export des stats en JSON/CSV | `lib/screens/profile_screen.dart` | Feature | ⏳ |

### Priorité 🟢 Faible

| ID | Titre | Description | Fichier | Impact | Statut |
|----|-------|-------------|--------|--------|--------|
| IMP-30 | Historique des saisons | Afficher les stats par saison passée | `lib/screens/profile_screen.dart` | Feature | ⏳ |
| IMP-31 | Comparaison entre joueurs | Comparer les stats de plusieurs profils | Nouveau écran | Feature | ⏳ |
| IMP-32 | Statistiques avancées | Moyennes, meilleurs scores, etc. | `lib/screens/profile_screen.dart` | Feature | ⏳ |

---

## 📊 Statistiques

| Type | Total | Priorité 🔴 | Priorité 🟡 | Priorité 🟢 |
|------|-------|-------------|-------------|-------------|
| Techniques | 12 | 3 | 7 | 2 |
| Fonctionnelles | 5 | 0 | 2 | 3 |
| **Total** | **17** | **3** | **9** | **5** |

---

## 🎯 Roadmap

### Sprint 1 (Priorité 🔴)
- [x] IMP-01: Supprimer debugFillProperties
- [x] IMP-02: Nettoyer les imports
- [x] IMP-03: Extraire valeurs non-constantes

### Sprint 2 (Priorité 🟡)
- [ ] IMP-04: SafeArea(bottom: true) partout
- [ ] IMP-05: Validation en temps réel
- [ ] IMP-20: Indicateur limite de profils

### Sprint 3 (Priorité 🟢)
- [ ] IMP-07 à IMP-12: Nettoyage code
- [ ] IMP-21, IMP-22: Améliorations UX
- [ ] IMP-30 à IMP-32: Nouvelles fonctionnalités
