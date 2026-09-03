# 📱 Home Screen Specification - StatTrack

**Version**: 1.0  
**Date**: 2026-08-27  
**Statut**: Approuvé  
**Auteur**: Mistral Vibe (avec contribution utilisateur)  

---

## 🎯 Sommaire

- [Contexte](#-contexte)
- [Exigences Fonctionnelles](#-exigences-fonctionnelles)
- [Spécifications Visuelles](#-spécifications-visuelles)
- [Composants UI](#-composants-ui)
- [État de l'Interface](#-état-de-linterface)
- [Comportement](#-comportement)
- [Accessibilité](#-accessibilité)
- [Références](#-références)

---

## 📌 Contexte

La page d'accueil (**Home Screen**) est l'écran principal de l'application **StatTrack**. Elle permet aux utilisateurs de:
- Visualiser tous leurs profils de joueurs en un coup d'œil
- Accéder rapidement aux statistiques de chaque profil
- Créer de nouveaux profils (jusqu'à la limite de 4)
- Naviguer vers les autres fonctionnalités de l'application

**Public cible**: Parents, athlètes amateurs, entraîneurs

---

## 📋 Exigences Fonctionnelles

| ID | Exigence | Priorité | Statut |
|----|----------|----------|--------|
| REQ-HS-01 | Afficher une grille de 2 colonnes de cartes de profils | ⭐⭐⭐ | ✅ |
| REQ-HS-02 | Limiter l'affichage à **4 profils maximum** par appareil | ⭐⭐⭐ | ✅ |
| REQ-HS-03 | Afficher un indicateur visuel du nombre de profils (X/4) | ⭐⭐⭐ | ✅ |
| REQ-HS-04 | Désactiver le bouton d'ajout quand 4 profils sont atteints | ⭐⭐⭐ | ✅ |
| REQ-HS-05 | Permettre l'accès rapide aux statistiques de chaque profil | ⭐⭐⭐ | ✅ |
| REQ-HS-06 | Respecter la charte graphique StatTrack | ⭐⭐⭐ | ✅ |

---

## 🎨 Spécifications Visuelles

### Palette de Couleurs

| Élément | Couleur | Code Hex | Usage |
|---------|---------|----------|-------|
| Arrière-plan principal | Surface | `#362F4F` | Fond de l'écran |
| AppBar | Primaire | `#5B23FF` | Barre de titre |
| Cartes | Surface Light | `#4A4458` | Fond des cartes de profil |
| Boutons principaux | Primaire | `#5B23FF` | FAB, boutons d'action |
| Secondaire | Secondaire | `#008BFF` | Bordures, accents |
| Accent | Accent | `#E4FF30` | Compteurs, icônes, feedback |
| Texte principal | Blanc | `#FFFFFF` | Titres, noms |
| Texte secondaire | Gris clair | `#B0B0B0` | Stats, labels |

> ⚠️ **Note**: `Surface Light` (#4A4458) est une variante plus claire de `Surface` (#362F4F) pour créer un contraste subtil entre les cartes et l'arrière-plan.

### Typographie

| Élément | Police | Taille | Style | Couleur |
|---------|--------|--------|-------|---------|
| Titre AppBar | Roboto | 20sp | Bold | `#FFFFFF` |
| Nom du profil | Roboto | 16sp | Bold | `#FFFFFF` |
| Statistiques | Roboto | 14sp | Regular | `#B0B0B0` |
| Labels (⚽, 👟, 🏆) | Roboto | 14sp | Regular | `#E4FF30` |
| Compteur (X/4) | Roboto | 12sp | Medium | `#E4FF30` |

### Espacement

| Mesure | Valeur |
|--------|--------|
| Marge extérieure | 16dp |
| Padding des cartes | 16dp (horizontal), 12dp (vertical) |
| Espacement entre cartes | 12dp (horizontal), 12dp (vertical) |
| Espacement entre AppBar et premier élément | 16dp |
| Espacement entre le compteur et la grille | 8dp |

### Ombres (Elevation)

| Élément | Élevation | Couleur de l'ombre |
|---------|-----------|---------------------|
| AppBar | 4dp | Noir 20% opacité |
| Cartes de profil | 8dp | Noir 15% opacité |
| FAB | 6dp (activé) / 0dp (désactivé) | Noir 20% opacité |

### Coins Arrondis

| Élément | Rayon |
|---------|-------|
| Cartes de profil | 12dp |
| FAB | 50% (cercle) |
| Boutons | 8dp |

---

## 🧩 Composants UI

### 1. AppBar

**Type**: `AppBar` Material Design  
**Position**: Haut de l'écran  
**Contenu**:
- **Titre**: "STATTRACK" (centré)
- **Couleur de fond**: `#5B23FF` (Primaire)
- **Élevation**: 4dp
- **Hauteur**: 56dp (standard)

```dart
AppBar(
  title: Text('STATTRACK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  backgroundColor: Color(0xFF5B23FF),
  elevation: 4,
  centerTitle: true,
)
```

### 2. Compteur de Profils

**Type**: `Text` ou `Chip`  
**Position**: Directement sous l'AppBar, aligné à gauche, 16dp de marge  
**Contenu**: "X/4 profils" où X = nombre actuel de profils  
**Style**:
- Police: Roboto Medium 12sp
- Couleur: `#E4FF30` (Accent)
- Opacité: 100%

**Comportement**:
- Mise à jour en temps réel
- Couleur change pour `#EA4335` (Error) quand X > 4 (impossible selon les règles métier)

### 3. Grille de Cartes de Profil

**Type**: `GridView` avec `SliverGridDelegateWithFixedCrossAxisCount`  
**Position**: Sous le compteur, 16dp de marge latérale, 8dp de marge supérieure  
**Configuration**:
- **Nombre de colonnes**: 2
- **Ratio largeur/hauteur**: 0.9 (presque carré)
- **Espacement**: 12dp entre les cartes

#### Structure d'une Carte de Profil

```
┌─────────────────────────┐
│  [Avatar]               │  ← Coin supérieur gauche, 40dp × 40dp
│  ═══════════            │
│  Nom du joueur          │  ← 16sp Bold, blanc
│  ═══════════            │
│  🏆 X matchs            │  ← 14sp Regular, gris clair
│  ⚽ Y buts   👟 Z Passes D.  │  ← 14sp Regular, labels en accent
└─────────────────────────┘
```

**Propriétés de la carte**:
- **Couleur de fond**: `#4A4458` (Surface Light)
- **Bordure**: 1dp, `#008BFF` à 20% d'opacité
- **Coin arrondi**: 12dp
- **Élevation**: 8dp
- **Padding**: 16dp (horizontal), 12dp (vertical)

#### Avatar

- **Forme**: Cercle
- **Taille**: 40dp × 40dp
- **Couleur de fond**: Générée à partir du nom du joueur (couleur pastel)
- **Contenu**:
  - Si image disponible: photo du joueur
  - Sinon: Initial du prénom en blanc sur fond coloré
  - Alternative: Icône football générique (⚽)

#### Statistiques

**Format**:
```
🏆 [nombre] matchs
⚽ [nombre] buts
👟 [nombre] Passes D.
```

**Alignement**: Gauche, sous le nom
**Espacement**: 4dp entre chaque ligne

### 4. Bouton FAB (Floating Action Button)

**Type**: `FloatingActionButton`  
**Position**: Coin inférieur droit, 16dp de marge, dans la Safe Area  
**Forme**: Cercle (50% de coin arrondi)

**Propriétés**:
- **Taille**: 56dp × 56dp
- **Couleur de fond**: `#5B23FF` (Primaire)
- **Icône**: `+` (add)
- **Couleur de l'icône**: `#FFFFFF` (Blanc)
- **Élevation**: 6dp (activé) / 0dp (désactivé)

**Comportement**:
- **Activé** (0-3 profils): Opacité 100%, cliquable, ombre 6dp
- **Désactivé** (4 profils): Opacité 40%, non cliquable, ombre 0dp
- **Tooltip**: "Ajouter un profil" (quand activé) / "Limite atteinte (4/4)" (quand désactivé)

---

## 📊 État de l'Interface

### 1. État Vide (0 profil)

```
┌─────────────────────────┐
│  STATTRACK              │
├─────────────────────────┤
│  0/4 profils             │
│                         │
│  ┌───────────────────┐  │
│  │                   │  │
│  │   [+ Ajouter      │  │
│  │    un profil]     │  │  ← Message d'invitation
│  │                   │  │
│  └───────────────────┘  │
│                         │
│              [+]        │  ← FAB activé
└─────────────────────────┘
```

**Comportement**:
- Afficher un message central: "Aucun profil créé. Appuyez sur + pour commencer."
- FAB activé et visible

### 2. État Partiel (1-3 profils)

```
┌─────────────────────────┐
│  STATTRACK              │
├─────────────────────────┤
│  2/4 profils             │
│                         │
│  ┌─────────┐ ┌─────────┐│
│  │  Leo    │ │  Max    ││
│  │ 🏆12    │ │ 🏆8     ││
│  │ ⚽24👟10│ │ ⚽15👟5 ││
│  └─────────┘ └─────────┘│
│                         │
│              [+]        │  ← FAB activé
└─────────────────────────┘
```

**Comportement**:
- Afficher les profils existants
- Une carte vide avec icône "+" pour ajouter un nouveau profil (optionnel)
- FAB activé

### 3. État Complet (4 profils) ⭐ **État par défaut pour ce design**

```
┌─────────────────────────┐
│  STATTRACK              │
├─────────────────────────┤
│  4/4 profils             │  ← Compteur en accent
│                         │
│  ┌─────────┐ ┌─────────┐│
│  │  Leo    │ │  Max    ││
│  │ 🏆12    │ │ 🏆8     ││
│  │ ⚽24👟10│ │ ⚽15👟5 ││
│  └─────────┘ └─────────┘│
│                         │
│  ┌─────────┐ ┌─────────┐│
│  │  Emma   │ │ Sophie  ││
│  │ 🏆5     │ │ 🏆20    ││
│  │ ⚽8👟3  │ │ ⚽30👟15││
│  └─────────┘ └─────────┘│
│                         │
│              [+]        │  ← FAB DÉSACTIVÉ (40% opacité)
└─────────────────────────┘
```

**Comportement**:
- Toutes les cartes de profil sont remplies
- Compteur "4/4 profils" en couleur accent (#E4FF30)
- FAB désactivé (opacité 40%, pas d'ombre)
- Tooltip au survol: "Limite de profils atteinte (4/4)"

---

## 🔄 Comportement

### Actions Utilisateur

| Action | Comportement |
|--------|--------------|
| **Clic sur une carte de profil** | Navigue vers `ProfileScreen` du profil correspondant |
| **Clic sur FAB (activé)** | Ouvre `CreateProfileScreen` |
| **Clic sur FAB (désactivé)** | Aucun effet (feedback visuel: vibration légère optionnelle) |
| **Appui long sur une carte** | Ouvre menu contextuel (Modifier / Supprimer) |
| **Glissement vers le bas** | Rafraîchir les données (optionnel) |

### Navigation

**Entrée**:
- Écran de démarrage par défaut
- Accessible via le bouton "Accueil" (⌂) depuis d'autres écrans

**Sortie**:
- Vers `ProfileScreen` (clic sur carte)
- Vers `CreateProfileScreen` (clic sur FAB)

---

## ♿ Accessibilité

| Critère | Implémentation |
|---------|----------------|
| **Contraste des couleurs** | Ratio ≥ 4.5:1 (WCAG AA) entre texte et fond |
| **Taille des cibles tactiles** | Cartes: min 120dp × 120dp, FAB: 56dp × 56dp |
| **Feedback tactile** | Vibration légère (30ms) sur clic FAB |
| **Lecture d'écran** | Balises ARIA pour cartes et boutons |
| **Texte alternatif** | Description pour les avatars et icônes |

---

## 📁 Fichiers Associés

- **Prompt de génération d'image**: [./image_prompts/HOME-SCREEN-PROMPT.md](./image_prompts/HOME-SCREEN-PROMPT.md)
- **Design Guidelines général**: [../DESIGN.md](../DESIGN.md)
- **Scénarios Gherkin**: [../specs/FEATURES.md](../specs/FEATURES.md) (tag `@US-01`)

---

## ✅ Checklist de Validation

- [ ] Respect de la palette de couleurs
- [ ] Respect de la typographie
- [ ] Respect des espacements (16dp, 12dp, 8dp)
- [ ] Respect des coins arrondis (12dp pour les cartes)
- [ ] Comportement correct du FAB (activé/désactivé)
- [ ] Affichage correct du compteur (X/4)
- [ ] Grille responsive (2 colonnes)
- [ ] Accessibilité (contraste, taille des cibles)
- [ ] Tests utilisateur sur différents appareils

---

**Dernière mise à jour**: 2026-08-27  
**Version**: 1.0