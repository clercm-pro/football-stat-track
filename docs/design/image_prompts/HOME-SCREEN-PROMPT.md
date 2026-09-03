# 🎨 Home Screen - Image Generation Prompt

**Fichier**: `HOME-SCREEN-PROMPT.md`  
**Version**: 1.0  
**Date**: 2026-08-27  
**Statut**: Prêt pour génération  

---

## 📋 Informations de Base

| Propriété | Valeur |
|-----------|--------|
| **Nom de l'app** | StatTrack |
| **Écran** | Page d'accueil (Home Screen) |
| **Style** | Minimaliste & Data-Driven |
| **Thème** | Sombre (Dark) |
| **Plateforme** | Cross-platform premium neutre |
| **Résolution** | 1080x2340 (iPhone 15 Pro Max) ou 1024x2048 |
| **Format** | Portrait |

---

## 🎯 Objectif

Générer **une image premium** de la page d'accueil de StatTrack montrant **l'état complet** (4 profils créés) avec un design:
- ✅ **App-native** (ne pas ressembler à un site web)
- ✅ **Premium** (qualité professionnelle)
- ✅ **Minimaliste & Data-Driven** (focus sur les données)
- ✅ **Clean** (pas de désordre visuel)
- ✅ **Lisible** (texte facilement lisible)
- ✅ **Cohérent** (respecte la charte graphique)

---

## 🎨 Spécifications Visuelles

### Palette de Couleurs (OBLIGATOIRE)

| Nom | Code Hex | Usage |
|-----|----------|-------|
| **Surface/Background** | `#362F4F` | Fond principal de l'écran |
| **Primary** | `#5B23FF` | AppBar, FAB, boutons principaux |
| **Secondary** | `#008BFF` | Bordures, accents |
| **Accent** | `#E4FF30` | Compteur, labels, icônes |
| **Error** | `#EA4335` | Messages d'erreur |
| **Text Primary** | `#FFFFFF` | Texte principal |
| **Text Secondary** | `#B0B0B0` | Texte secondaire |
| **Surface Light** | `#4A4458` | Fond des cartes |

> ⚠️ **IMPORTANT**: Utilisez **uniquement** ces couleurs. Aucune autre couleur ne doit apparaître dans l'image.

### Typographie

| Élément | Police | Taille | Style | Couleur |
|---------|--------|--------|-------|---------|
| Titre AppBar | Roboto | 20sp | Bold | `#FFFFFF` |
| Nom du profil | Roboto | 16sp | Bold | `#FFFFFF` |
| Statistiques | Roboto | 14sp | Regular | `#B0B0B0` |
| Labels (⚽, 👟, 🏆) | Roboto | 14sp | Regular | `#E4FF30` |
| Compteur | Roboto | 12sp | Medium | `#E4FF30` |

### Espacement

| Élément | Valeur |
|---------|--------|
| Marge extérieure | 16dp |
| Espacement entre cartes | 12dp (horizontal et vertical) |
| Padding AppBar | 16dp |
| Padding cartes | 16dp (horizontal), 12dp (vertical) |

### Éléments d'Interface

#### 1. AppBar
- **Position**: Haut de l'écran
- **Hauteur**: 56dp
- **Couleur**: `#5B23FF`
- **Contenu**: "STATTRACK" centré, en blanc, Bold 20sp
- **Élevation**: Ombre légère (4dp)

#### 2. Compteur de Profils
- **Position**: Sous l'AppBar, aligné à gauche, 16dp de marge
- **Texte**: "4/4 profils"
- **Style**: Roboto Medium 12sp, couleur `#E4FF30`

#### 3. Grille de Cartes (2x2)
- **Position**: Sous le compteur, 16dp de marge latérale
- **Configuration**: 2 colonnes, 2 lignes
- **Ratio**: Presque carré (0.9)

**Chaque carte contient**:
- **Avatar**: Cercle 40dp, fond coloré pastel (basé sur le nom), icône ⚽ ou initiale
- **Nom**: Leo, Max, Emma, Sophie (Bold 16sp, blanc)
- **Statistiques**:
  - 🏆 X matchs (14sp, gris clair)
  - ⚽ Y buts (14sp, gris clair)
  - 👟 Z Passes D. (14sp, gris clair)
- **Couleur de fond**: `#4A4458`
- **Bordure**: 1dp, `#008BFF` à 20% d'opacité
- **Coins arrondis**: 12dp
- **Élevation**: Ombre 8dp

**Données des profils** (exemple):
| Nom | Matchs | Buts | Passes |
|-----|--------|------|--------|
| Leo | 12 | 24 | 10 |
| Max | 8 | 15 | 5 |
| Emma | 5 | 8 | 3 |
| Sophie | 20 | 30 | 15 |

#### 4. FAB (Floating Action Button)
- **Position**: Coin inférieur droit, 16dp de marge, dans la Safe Area
- **Forme**: Cercle (56dp × 56dp)
- **Couleur**: `#5B23FF`
- **Icône**: "+" (blanc)
- **État**: **Désactivé** (40% d'opacité, **pas d'ombre**)

---

## 📝 Prompts pour Générateurs d'Images

### Prompt Principal (Recommandé pour DALL·E 3 / MidJourney)

```
Premium mobile app home screen for "StatTrack", a football statistics tracking application. 

Layout: Clean phone mockup (iPhone 15 style, black frame, centered on dark background) displaying a single app screen in portrait orientation, high resolution (1080x2340).

AppBar: Dark purple (#5B23FF) with "STATTRACK" title in bold white Roboto font, centered, subtle elevation shadow (4dp).

Content Area (on #362F4F background):
- Small text "4/4 profils" in accent lime yellow (#E4FF30), Roboto Medium 12sp, aligned left, 16dp margin below AppBar
- 2x2 grid of player profile cards with 12dp spacing between them, 16dp outer margins

Each Profile Card:
- Background: Slightly lighter purple (#4A4458)
- Rounded corners: 12dp
- Elevation shadow: 8dp (subtle, black 15% opacity)
- Border: Thin 1dp border with secondary blue (#008BFF) at 20% opacity
- Content:
  - Top-left: Circular avatar (40dp) with geometric pattern or football icon (⚽)
  - Below avatar: Player name (Leo, Max, Emma, Sophie) in bold white 16sp
  - Bottom: Three stats with icons:
    - 🏆 [number] matchs (trophy icon, #E4FF30)
    - ⚽ [number] buts (football icon, #E4FF30)
    - 👟 [number] Passes D. (shoe icon, #E4FF30)
  - Stats text: Light gray (#B0B0B0), 14sp Regular

Data:
- Leo: 🏆12 matchs, ⚽24 buts, 👟10 Passes D.
- Max: 🏆8 matchs, ⚽15 buts, 👟5 Passes D.
- Emma: 🏆5 matchs, ⚽8 buts, 👟3 Passes D.
- Sophie: 🏆20 matchs, ⚽30 buts, 👟15 Passes D.

FAB: Floating action button in bottom-right (16dp margin, safe area), circular (56dp), primary purple (#5B23FF), white "+" icon, DISABLED STATE (40% opacity, NO SHADOW).

Color Palette: ONLY use #362F4F (background), #5B23FF (primary), #008BFF (secondary), #E4FF30 (accent), #FFFFFF (text), #B0B0B0 (secondary text), #4A4458 (cards). No other colors.

Typography: Clean, readable, Roboto-like font family, proper hierarchy, never too small.

Style: Material Design, dark theme, premium feel, subtle noise texture on surfaces, no glassmorphism, no gradients, clean drop shadows, respect safe areas, proper mobile spacing.

Quality: Photorealistic UI, crisp details, perfect alignment, no text cutoff, professional app design.

Avoid: Generic AI mobile tells, purple-blue gradients, glass cards, floating widgets, tiny text, cluttered layout, non-native patterns, bright neon colors, generic placeholder avatars.

The design must feel: App-native, premium, clean, highly intentional, data-focused, sporty but not childish, readable at normal viewing size, consistent.
```

---

### Prompt Alternatif (Plus Court pour MidJourney)

```
/imagine prompt: Premium dark mobile app home screen for "StatTrack" football stats tracker, cross-platform UI, 2x2 grid of player profile cards with names (Leo, Max, Emma, Sophie) and stats (🏆12 ⚽24 👟10 etc.), purple color scheme (#362F4F #5B23FF #008BFF #E4FF30), disabled FAB button, "4/4 profils" counter, iPhone mockup, Material Design, clean minimalist data-driven aesthetic, high resolution, photorealistic UI --ar 9:19.5 --style raw --v 6
```

---

### Prompt pour Stable Diffusion

```
masterpiece, best quality, ultra detailed, photorealistic, 
Premium mobile app UI, StatTrack football statistics tracker home screen, 
dark theme, 2x2 grid layout, profile cards with player names and stats, 
color palette: #362F4F #5B23FF #008BFF #E4FF30 #FFFFFF #B0B0B0 #4A4458, 
Material Design, iPhone mockup, clean background, professional app design, 
8k resolution, sharp details, perfect text rendering
```

**Negative Prompt**:
```
low quality, blurry, text cutoff, generic UI, website layout, gradient background, glassmorphism, neon colors, bright colors, childish design, cartoon, 3D render, watermark, extra elements, too many colors, messy layout
```

---

## 📁 Stockage de l'Image

Une fois générée, l'image doit être enregistrée sous:

```
docs/design/images/HOME-SCREEN-V1.png
```

**Format recommandé**: PNG (qualité maximale, fond transparent optionnel pour le mockup)

---

## ✅ Checklist de Validation de l'Image

Avant d'accepter l'image générée, vérifiez:

- [ ] **Palette de couleurs**: Uniquement les couleurs spécifiées (#362F4F, #5B23FF, etc.)
- [ ] **Typographie**: Texte lisible, bonne hiérarchie (20sp, 16sp, 14sp, 12sp)
- [ ] **AppBar**: "STATTRACK" centré, couleur #5B23FF
- [ ] **Compteur**: "4/4 profils" visible, couleur #E4FF30
- [ ] **4 cartes**: Grille 2x2 avec Leo, Max, Emma, Sophie
- [ ] **Stats**: Affichage correct (🏆X matchs, ⚽Y buts, 👟Z Passes D.)
- [ ] **FAB**: Bouton "+" désactivé (40% opacité), pas d'ombre
- [ ] **Mockup**: Cadre de téléphone propre et centré
- [ ] **Résolution**: Minimum 1024x2048
- [ ] **Qualité**: Net, sans flou, texte lisible
- [ ] **Style**: App-native, premium, pas de design web

---

## 🎨 Exemple de Composition

```
┌─────────────────────────────────────────┐
│  [PHONE MOCKUP FRAME - Black/Transparent] │
│  ┌─────────────────────────────────┐   │
│  │ STATTRACK                      │   │  ← AppBar #5B23FF
│  │                                 │   │
│  │ 4/4 profils                     │   │  ← Compteur #E4FF30
│  │                                 │   │
│  │ ┌─────────┐   ┌─────────┐      │   │
│  │ │ ⚽ Leo   │   │ ⚽ Max   │      │   │
│  │ │         │   │         │      │   │
│  │ │ 🏆12    │   │ 🏆8     │      │   │
│  │ │ ⚽24👟10│   │ ⚽15👟5 │      │   │
│  │ └─────────┘   └─────────┘      │   │
│  │                                 │   │
│  │ ┌─────────┐   ┌─────────┐      │   │
│  │ │ ⚽ Emma  │   │ ⚽ Sophie│      │   │
│  │ │         │   │         │      │   │
│  │ │ 🏆5     │   │ 🏆20    │      │   │
│  │ │ ⚽8👟3  │   │ ⚽30👟15│      │   │
│  │ └─────────┘   └─────────┘      │   │
│  │                                 │   │
│  │                   [+]            │   │  ← FAB désactivé
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

---

## 📌 Notes Supplémentaires

1. **Génération Multiple**: Générez plusieurs variantes et sélectionnez la meilleure
2. **Validation**: Vérifiez que le texte est correctement orthographié ("StatTrack", "profils", etc.)
3. **Consistance**: L'image doit correspondre exactement à la spécification dans [HOME-SCREEN.md](../HOME-SCREEN.md)
4. **Outils Recommandés**:
   - DALL·E 3 (meilleur pour le texte)
   - MidJourney v6
   - Stable Diffusion XL avec LoRA pour UI

---

**Dernière mise à jour**: 2026-08-27  
**Version**: 1.0  
**Prochaine étape**: Générer l'image avec l'un des prompts ci-dessus et l'enregistrer dans `docs/design/images/HOME-SCREEN-V1.png`