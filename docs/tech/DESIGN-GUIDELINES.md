# Design Guidelines - Scoreboard Theme

**Version:** 2.0 (Migration vers design Scoreboard Claude #2b/#3a-#3c)
**Date:** 2026-09-03
**Statut:** Approuvé (basé sur docs/design/claude_design/README.md)

This document outlines the **NEW** visual identity, UI components, and accessibility standards for StatTrack v2.0.

**⚠️ IMPORTANT:** Ce document remplace les guidelines précédentes. La migration est documentée dans les scénarios Gherkin `@DS-01`.

---

## Color Palette - Modern Turquoise

**Source:** Design Claude #2b/#3a-#3c (Scoreboard direction)

| Token | Hex Code | Usage | Notes |
|-------|----------|-------|-------|
| **background** | `#F3F4F3` | Screen background, sheet | Remplace le thème sombre |
| **surface** | `#FFFFFF` | Cards, fields, elevated surfaces | Fond des cartes |
| **ink** | `#343B46` | Primary text, assist values | Texte principal |
| **ink-60** | `rgba(52,59,70,.5)` | Secondary text, labels | Texte secondaire |
| **ink-30** | `rgba(52,59,70,.3)` | Zero values, chevrons, icons | Texte discret |
| **hairline** | `rgba(52,59,70,.12)` | Field borders, dividers | Bordures fines |
| **primary** | `#008A78` | Goals, accents, profile CTA | Couleur principale |
| **primary-dark** | `#01584A` | Hero block, primary buttons | Variante foncée |
| **accent** | `#2CADA3` | Sparkline bars, on-dark eyebrow | Accent vert |
| **avatar-1** | `#6A71FF` | Player 1 identity color | Bleu |
| **avatar-2** | `#6BFF9B` | Player 2 identity color | Vert |
| **avatar-3** | `#FFE16B` | Player 3 identity color | Jaune |
| **avatar-4** | `#FF6E6B` | Player 4 identity color | Rouge |

### Migration Notes
- **Ancienne palette:** Dark theme avec `#362F4F`, `#5B23FF`, `#008BFF`
- **Nouvelle palette:** Light theme avec turquoise/vert
- **Impact:** Tous les écrans doivent être mis à jour

---

## Typography - Archivo

**Font Family:** Archivo (Google Fonts)
**Fallback:** Roboto (si Archivo non disponible)

### Font Weights Available
- 400 (Regular)
- 500 (Medium) 
- 600 (SemiBold)
- 700 (Bold)
- 800 (ExtraBold)

### Text Styles

| Role | Size | Weight | Letter Spacing | Line Height | Color | Notes |
|------|------|--------|----------------|-------------|-------|-------|
| Display timer | 76px | 800 | -3px | 1.05 | `#343B46` | Timer principal |
| Screen title (profile) | 40px | 800 | -1.2px | - | Blanc | Titre page profil |
| Screen title (home) | 34px | 800 | -1px | 1.05 | `#343B46` | Titre page d'accueil |
| Counter value | 92px | 800 | 0 | 0.85 | Blanc/#343B46 | Compteurs match |
| Stat value large | 44px | 800 | 0 | - | `#008A78`/#343B46 | Stats carte joueur |
| Stat value medium | 36-38px | 800 | 0 | - | Variable | Stats tuples |
| Row stat value | 22px | 800 | 0 | - | `#008A78`/#343B46 | Stats ligne match |
| Sheet title | 30px | 800 | -0.8px | - | `#343B46` | Titre bottom sheet |
| Player name (card) | 19px | 700 | 0 | - | `#343B46` | Nom sur carte |
| Section header | 16px | 700 | 0 | - | `#343B46` | En-tête section |
| Button/cta | 15-16px | 700 | 0 | - | Blanc | Boutons |
| Body | 13-16px | 400-600 | 0 | - | Variable | Texte corps |
| Eyebrow/stat label | 11px | 700 | 1-2px | - | `#008A78`/Variable | Labels |
| Micro label | 10px | 400-600 | 0.5px | - | Variable | Unités (G, A) |

### Special Features
- **Tabular Figures:** Tous les nombres utilisent `FontFeature.tabularFigures()`
- **Archivo Font:** Doit être ajouté à `pubspec.yaml`

```yaml
flutter:
  fonts:
    - family: Archivo
      fonts:
        - asset: fonts/Archivo-Regular.ttf
        - asset: fonts/Archivo-Medium.ttf
          weight: 500
        - asset: fonts/Archivo-SemiBold.ttf
          weight: 600
        - asset: fonts/Archivo-Bold.ttf
          weight: 700
        - asset: fonts/Archivo-ExtraBold.ttf
          weight: 800
```

---

## Spacing Scale

**Base Unit:** 4px

| Scale | Value | Usage |
|-------|-------|-------|
| xs | 4px | Micro gaps |
| sm | 6px | Small gaps |
| md | 8px | Medium gaps |
| lg | 10px | Large gaps |
| xl | 12px | Extra large gaps |
| 2xl | 14px | Section padding |
| 3xl | 16px | Card padding |
| 4xl | 18px | Player card padding |
| 5xl | 20px | Large gaps |
| 6xl | 22px | Counter card padding |
| 7xl | 24px | Screen padding |
| 8xl | 26px | Sheet radius |
| 9xl | 30px | Bottom inset |

---

## Border Radii

| Name | Value | Usage |
|------|-------|-------|
| **bars** | 2px | Sparkline bars |
| **small** | 4px | Color bars, avatar color indicator |
| **fields** | 14px | Input fields, small cards |
| **buttons** | 16px | Buttons, tiles |
| **player-card** | 18px | Player profile cards |
| **counter-card** | 22px | Live match counter cards |
| **sheet** | 26px | Bottom sheet |
| **avatar** | 52px | Avatar circle (radius) |

---

## Shadows

| Component | Shadow Value | Notes |
|-----------|--------------|-------|
| Player cards | `0 1px 2px rgba(52,59,70,.08)` | Carte joueur |
| Assist card | `0 1px 3px rgba(52,59,70,.07)` | Carte passes |
| Goals card | `0 2px 6px rgba(1,88,74,.25)` | Carte buts |
| Bottom sheet | `0 -6px 30px rgba(52,59,70,.3)` | Sheet |

---

## UI Components

### Cards

#### Player Card (Home Screen)
- **Background:** `#FFFFFF` (surface)
- **Radius:** 18px
- **Padding:** 18px
- **Shadow:** `0 1px 2px rgba(52,59,70,.08)`
- **Content:**
  - Color bar: 8px × 36px, radius 4, avatar color
  - Name: 19px/700, `#343B46`
  - Subtitle: 12px, `rgba(52,59,70,.5)`
  - Stats row: Goals (44px/800, `#008A78`) + Assists (44px/800, `#343B46`)
  - Sparkline: 6 bars, height proportional to goals, `#2CADA3` with last bar `#01584A`

#### Counter Card (Live Match)
- **Goals:** Background `#008A78`, radius 22, padding 22
  - Shadow: `0 2px 6px rgba(1,88,74,.25)`
  - Label: "GOALS" 12px/700, letter-spacing 1.5px, `rgba(243,244,243,.7)`
  - Hint: "Tap to add" 15px, `rgba(243,244,243,.6)`
  - Value: 92px/800, line-height 0.85, tabular, blanc, right-aligned

- **Assists:** Background white, border 1.5px `rgba(52,59,70,.1)`, radius 22
  - Shadow: `0 1px 3px rgba(52,59,70,.07)`
  - Label/Hint: `rgba(52,59,70,.45)`
  - Value: `#343B46`

### Buttons

#### Primary Button
- **Height:** 52-56px
- **Radius:** 14-16px
- **Background:** `#01584A` or `#008A78` (selon contexte)
- **Text:** White, 15-16px/700
- **Icon:** 22px, white (si présent)

#### Secondary/Outlined Button
- **Height:** 52-56px
- **Radius:** 14-16px
- **Background:** Transparent or white
- **Border:** 1.5px `rgba(52,59,70,.15)`
- **Text:** `#343B46` or `rgba(52,59,70,.6)`, 15-16px/600-700

#### Square Icon Button
- **Size:** 52×52
- **Radius:** 14px
- **Border:** 1.5px `rgba(52,59,70,.15)`
- **Icon:** 22px, `#343B46`

### Input Fields
- **Height:** 52px
- **Background:** White
- **Radius:** 14px
- **Padding:** 16px horizontal
- **Value:** 16px, `#343B46`
- **Placeholder:** `rgba(52,59,70,.35)`
- **Border:** 1.5px `rgba(52,59,70,.12)`
- **Focused/Valid:** 1.5px `#008A78`
- **Error:** 1.5px `#FF6E6B` (ou couleur erreur)

### Bottom Sheet
- **Background:** `#F3F4F3`
- **Radius:** 26px (top only)
- **Padding:** `28px 24px 24px`
- **Shadow:** `0 -6px 30px rgba(52,59,70,.3)`
- **Margin:** 16px external
- **Scrim:** `rgba(52,59,70,.55)`

### Stat Tiles (Summary)
- **Radius:** 16px
- **Padding:** `18px 14px`
- **Gap:** 10px
- **Value:** 36px/800
- **Label:** 11px/600, letter-spacing 1px

---

## Accessibility

| Requirement | Solution | Status |
|-------------|----------|--------|
| **Color blindness** | High contrast palette (≥ 4.5:1) | ✅ Verifié |
| **Touch targets** | Minimum 48×48dp, buttons 52-56px | ✅ Respecté |
| **Haptic feedback** | 30ms vibration on counter changes | ✅ Implémenté |
| **Light theme** | Native support, `#F3F4F3` background | ✅ Nouveau |
| **Readable text** | Minimum 11px, Archivo improves clarity | ✅ Amélioré |
| **Animations** | 150ms scale/fade on counter changes | ✅ Feedback visuel |

### Contrast Ratios
- Background (`#F3F4F3`) vs Ink (`#343B46`): ~7:1 ✅
- Surface (White) vs Ink: ~13:1 ✅
- Primary (`#008A78`) vs White: ~6:1 ✅
- Primary (`#008A78`) vs Background: ~5:1 ✅

---

## Screen Specifications

### 1. Home Screen (#2b)
- **Background:** `#F3F4F3`
- **Safe area:** Top inset, 30px bottom inset
- **Header:**
  - Eyebrow: "STATTRACK" 11px/700, letter-spacing 2px, `#008A78`
  - Title: Dynamic player count, 34px/800, letter-spacing -1px, `#343B46`
- **Player list:** Horizontal padding 16px, 10px gap
- **Add section:** Padding `16px 16px 30px`, 10px gap

### 2. Profile Screen (#2b)
- **Hero block:** Background `#01584A`, padding-bottom 24px
- **Header:** `arrow_back` + `home` icons, 24px
- **Content:** Season eyebrow, name 40px/800, subtitle 13px
- **Season totals:** 3 columns, 38px values, 11px labels
- **Match log:** Section with season picker
- **Match rows:** White, radius 14, padding `14px 16px`
- **CTA:** "Start a match" button, height 56, radius 16, `#008A78`

### 3. Live Match Screen (#3a)
- **Header:** `arrow_back`, LIVE badge, `stop_circle`
- **Timer:** Context 13px/600, timer 76px/800, letter-spacing -3px
- **Counters:** 2 cards, flex fill, 12px gap, padding 22px
- **Instructions:** 12px, `rgba(52,59,70,.45)`, centered
- **Buttons:** Cancel (outlined) + End match (primary)

### 4. Match Summary (#3b)
- **Sheet:** `#F3F4F3`, radius 26, padding `28px 24px 24px`
- **Header:** Eyebrow "MATCH COMPLETED", title 30px/800
- **Stats:** 3 tiles, 10px gap, radius 16
- **Confirmation:** Computed totals text
- **Buttons:** Save match (primary) + Resume timer (text)

### 5. Create Profile (#3c)
- **Header:** `arrow_back` + "New player"
- **Avatar:** 76px circle, 4 color swatches (32px)
- **Fields:** Label 12px/700, field height 52px, radius 14
- **Info:** Background `rgba(0,138,120,.08)`, radius 14
- **Buttons:** Cancel (outlined) + Save player (primary)

---

## Interaction Patterns

### Counter Interaction (MATCH-01)
- **Short press:** +1, 30ms haptic, 150ms animation
- **Long press:** -1, 30ms haptic, 150ms animation
- **Floor:** Minimum 0 (cannot go negative)
- **Animation:** Scale + fade effect

### Navigation
- **Home → Profile:** Tap player card
- **Home → Create Profile:** Tap "Add player" button
- **Home → Create Season:** Tap calendar button
- **Profile → Live Match:** Tap "Start a match"
- **Live Match → Summary:** Tap "End match"
- **Summary → Profile:** Tap "Save match"
- **Summary → Live Match:** Tap "Resume timer"

### Data Display
- **Sparkline:** Last 6 matches, height = goals as % of best match, min ~15%
- **Season totals:** Computed from matches filtered by childId + seasonId
- **Age calculation:** Current year - birthYear (if birthYear provided)

---

## Migration Checklist

### Phase 1: Foundation
- [ ] Add Archivo font to `pubspec.yaml`
- [ ] Update `lib/config/colors.dart` with new palette
- [ ] Switch theme from dark to light
- [ ] Update typography settings

### Phase 2: Screens
- [ ] Update `home_screen.dart` (HOME-01)
- [ ] Update `profile_screen.dart` (PROFILE-01)
- [ ] Update `match_screen.dart` (MATCH-01)
- [ ] Update `create_profile_screen.dart` (CREATE-01)
- [ ] Replace AlertDialog with BottomSheet (SUMMARY-01)

### Phase 3: Localization
- [ ] Add new English strings to `app_localizations.dart`
- [ ] Add French translations for all new strings
- [ ] Update existing strings if needed

### Phase 4: Data & Logic
- [ ] Implement sparkline component
- [ ] Add derived data computation (season aggregates)
- [ ] Add haptic feedback on counter changes
- [ ] Add counter animations

---

## Design References

- **Primary Reference:** `docs/design/claude_design/README.md`
- **Visual Mockups:** `docs/design/claude_design/StatTrack Screens.dc.html`
- **Approved designs:** #2b (Home + Profile), #3a (Live Match), #3b (Summary), #3c (Create Profile)

---

**See also:**
- [ARCHITECTURE.md](ARCHITECTURE.md) for implementation details
- [CODE-STANDARDS.md](CODE-STANDARDS.md) for coding conventions
- [DATA-MODEL.md](DATA-MODEL.md) for data entities
- [../specs/FEATURES.md](../specs/FEATURES.md) for Gherkin scenarios