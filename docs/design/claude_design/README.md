# Handoff: StatTrack — Scoreboard direction (2b) for Home, Player profile, Live match, Match summary, Create profile

## Overview
StatTrack is a Flutter app (repo `clercm-pro/football-stat-track`, branch `main`) for a parent on the sideline tracking a non-professional player's games, goals and assists per season. This handoff covers a visual redesign of the existing five screens in a light "Scoreboard" direction: numbers-first typography, one card per player, and a new turquoise palette replacing the current green theme in `lib/config/colors.dart`.

Scope is unchanged from the current product: profiles (max 4 per device), seasons (`YYYY/YYYY+1`), and matches with a timer, goals and assists. No new data fields.

## About the Design Files
The file in this bundle (`StatTrack Screens.dc.html`) is a **design reference created in HTML** — a prototype showing intended look and layout, not production code to copy. The task is to **recreate these designs in the existing Flutter codebase**, using its established patterns: `Scaffold`/`AppBar`, Riverpod providers (`child_profile_provider.dart`, `season_provider.dart`, `match_provider.dart`), Isar models, and a revised `AppColors` in `lib/config/colors.dart`. Do not introduce a web view or new styling framework.

The HTML file contains three turns of exploration. **Only turn 3 (`#3a`, `#3b`, `#3c`) and option `#2b` in turn 2 are the approved design.** Turn 1 (`#1a`, `#1b`) is a recreation of the app as it exists today, kept for comparison; options `#2a` and `#2c` were rejected.

Approved screens:
- `#2b` — Home (player list) and Player profile
- `#3a` — Live match
- `#3b` — Match summary sheet
- `#3c` — Create profile

## Fidelity
**High-fidelity.** Colors, type sizes, weights, spacing, and radii are final and listed below. Recreate pixel-perfectly with Flutter widgets. Copy is final and in English (the app currently defaults to the `fr` locale — French strings for the new/changed copy still need writing in `lib/l10n/app_localizations.dart`).

## Screens / Views

Design canvas is 390 × 844 logical px (iPhone-class); layouts are flexible and must work on Android too. All screens: background `#F3F4F3`, safe-area top inset, 30px bottom inset for the home indicator.

### 1. Home — player list (`#2b`, left)
**Purpose:** pick a player, or add a player/season.

Layout, top to bottom:
- Header, padding `8px 24px 20px`: eyebrow "STATTRACK" — 11px / weight 700 / letter-spacing 2px / `#008A78`; title "Three players this season" (two lines) — 34px / 800 / letter-spacing −1px / line-height 1.05 / `#343B46`, `margin-top: 6px`. Title copy is dynamic: player count.
- Player list: horizontal padding 16px, 10px gap between cards.
- Add-player row at the bottom: padding `16px 16px 30px`, 10px gap. Primary "Add player" button — flex, height 52, radius 14, `#01584A`, text 15px/700 `#F3F4F3`, leading `person_add` icon 20px. Secondary square 52×52, radius 14, 1.5px border `rgba(52,59,70,.15)`, `calendar_today` icon 22px `#343B46` → create season.

**Player card:** white, radius 18, padding 18, shadow `0 1px 2px rgba(52,59,70,.08)`.
- Top row: 8px × 36px rounded (radius 4) colour bar in the player's avatar colour; 12px gap; name 19px/700 `#343B46`; sub-line "12 matches · 2026/2027" 12px `rgba(52,59,70,.5)`; trailing `chevron_right` 20px `rgba(52,59,70,.3)`.
- Stat row, `margin-top: 16px`, 20px gap, aligned to baseline/bottom:
  - Goals: value 44px/800 `#008A78`, line-height .9, tabular figures; label "GOALS" 11px/600 letter-spacing 1px `rgba(52,59,70,.5)`, `margin-top: 6px`.
  - Assists: same, value colour `#343B46`.
  - Form sparkline: fills remaining width, height 44, six bars, 3px gap, radius 2, `#2CADA3`; the most recent (last) bar `#01584A`. Bar height = goals in that match as a share of the player's best match, minimum ~15%.

Long press on a card opens the delete confirmation (existing behaviour, `home_screen.dart`).

### 2. Player profile (`#2b`, right)
**Purpose:** season stats for one player, match log, start a match.

- Hero block: background `#01584A`, `padding-bottom: 24px`, content `#F3F4F3`. Row with `arrow_back` 24px and `home` 24px, padding `4px 16px 0`. Then padding `14px 24px 0`: season eyebrow "2026/2027" 11px/700 letter-spacing 2px `#2CADA3`; name "Leo" 40px/800 letter-spacing −1.2px; sub-line "Leonardo Clerc · 10 years old" 13px `rgba(243,244,243,.6)` (omit each part when the field is null — `firstName`/`lastName`/`birthYear` are optional).
- Season totals inside the hero, `padding: 22px 24px 0`, 28px gap: three columns GOALS / ASSISTS / MATCHES, values 38px/800 line-height .9 tabular, labels 11px/600 letter-spacing 1px `rgba(243,244,243,.55)`.
- Section header, padding `18px 24px 10px`: "Match log" 16px/700 `#343B46`; right side season picker "2026/2027" + `expand_more` 18px, 12px/600 `#008A78` — opens the season dropdown (`selectedSeasonProvider`).
- Match log rows: horizontal padding 16, 8px gap. White, radius 14, padding `14px 16px`, shadow `0 1px 2px rgba(52,59,70,.06)`. Left: match label 15px/700 `#343B46`, meta "23 Aug · 90 min" 12px `rgba(52,59,70,.5)`. Right: goals then assists — value 22px/800 tabular (`#008A78` for goals, `#343B46` for assists, both `rgba(52,59,70,.3)` when 0), unit "G"/"A" 10px letter-spacing .5px `rgba(52,59,70,.45)`.
- Footer CTA, padding `14px 16px 30px`: height 56, radius 16, `#008A78`, "Start a match" 16px/700 `#F3F4F3` with `play_arrow` 22px. Keeps the existing guard: if a match is already in progress for this profile, show the error snackbar instead of navigating (`matchInProgressError`).

### 3. Live match (`#3a`)
**Purpose:** count goals and assists while the game runs.

- Top row, padding `4px 18px 0`: `arrow_back` 24px `#343B46`; centre live badge — 8px dot `#008A78` + "LIVE" 11px/700 letter-spacing 1.5px `#008A78`; trailing `stop_circle` 22px `rgba(52,59,70,.35)`.
- Timer block, `padding: 22px 24px 0`, centred: context line "Leo · 2026/2027" 13px/600 `rgba(52,59,70,.5)`; timer "12:34" 76px/800 letter-spacing −3px tabular `#343B46`. Format `MM:SS`, ticking every second (existing `_formatTime`).
- Two counter cards fill the remaining height, `padding: 22px 16px 0`, 12px gap, equal flex:
  - Goals: `#008A78`, radius 22, padding 22, shadow `0 2px 6px rgba(1,88,74,.25)`. Label "GOALS" 12px/700 letter-spacing 1.5px `rgba(243,244,243,.7)`; hint "Tap to add" 15px `rgba(243,244,243,.6)`; value 92px/800 line-height .85 tabular `#F3F4F3`, right-aligned.
  - Assists: white, 1.5px border `rgba(52,59,70,.1)`, radius 22, shadow `0 1px 3px rgba(52,59,70,.07)`; label/hint `rgba(52,59,70,.45)`; value `#343B46`.
- Instruction line, padding `16px 24px 6px`, centred: "Short press = +1 • Long press = −1" 12px `rgba(52,59,70,.45)`.
- Bottom row, padding `6px 16px 30px`, 10px gap: "Cancel" 110×56, radius 16, 1.5px border `rgba(52,59,70,.15)`, 15px/600 `rgba(52,59,70,.6)`; "End match" flex, height 56, radius 16, `#01584A`, 16px/700 `#F3F4F3` with `check` 22px.

### 4. Match summary (`#3b`)
**Purpose:** confirm and save, or go back to the running match. Replaces the current `AlertDialog` with a bottom sheet over the dimmed, blurred match screen (`rgba(52,59,70,.55)` scrim).

Sheet: `#F3F4F3`, radius 26, padding `28px 24px 24px`, shadow `0 -6px 30px rgba(52,59,70,.3)`, 16px outer margin.
- Eyebrow "MATCH COMPLETED" 11px/700 letter-spacing 2px `#008A78`; title "Leo · 23 Aug" 30px/800 letter-spacing −.8px `#343B46`.
- Three stat tiles, `margin-top: 20px`, 10px gap, radius 16, padding `18px 14px`: DURATION (white, value 36px/800 `#343B46`), GOALS (`#008A78`, value `#F3F4F3`, label `rgba(243,244,243,.7)`), ASSISTS (white). Labels 11px/600 letter-spacing 1px, `margin-top: 8px`.
- Confirmation line, `margin-top: 18px`: "Saved to season 2026/2027. Leo will be at 25 goals in 13 matches." 13px `rgba(52,59,70,.5)` — computed from the season totals plus this match.
- "Save match" — height 56, radius 16, `#01584A`, 16px/700 `#F3F4F3`, `margin-top: 20px`. Then "Resume timer" — text button, height 52, 15px/600 `#008A78`.

### 5. Create profile (`#3c`)
**Purpose:** add a player. Only nickname is required.

- Header row, padding `4px 18px 0`: `arrow_back` 24px + "New player" 16px/700 `#343B46`.
- Avatar block, `padding: 20px 24px 0`, 18px gap: 76px circle in the selected avatar colour with the nickname's first letter (fallback "?") 32px/800 `#343B46`; beside it label "AVATAR COLOUR" 11px/700 letter-spacing 1.5px `rgba(52,59,70,.45)` and **four** 32px swatches, 8px gap — one per allowed player slot: `#6A71FF`, `#6BFF9B`, `#FFE16B`, `#FF6E6B`. Selected swatch gets a 2.5px `#343B46` border (inset). No other colours are offered; the app is capped at 4 profiles.
- Fields, `padding: 26px 24px 0`, 18px gap. Each: label 12px/700 `#343B46` (required marker `*` in `#008A78`), then a 52px field, white, radius 14, padding `0 16px`, value 16px `#343B46`, placeholder `rgba(52,59,70,.35)`. Border `1.5px rgba(52,59,70,.12)`, and `1.5px #008A78` when focused or filled-and-required.
  - "Nickname *" — required, max 20 chars.
  - "First name" / "Last name" side by side, 12px gap, both optional ("Optional" placeholder).
  - "Birth year" — numeric, 4 digits, range 1900…current year; right-aligned derived age "10 years old" 13px/600 `#008A78`.
- Info note: background `rgba(0,138,120,.08)`, radius 14, padding `14px 16px`, `info` icon 20px `#008A78`, text "You can create up to 4 players on this device. 3 used." 13px `#01584A`.
- Bottom row, padding `16px 16px 30px`, 10px gap: "Cancel" 110×56 outlined; "Save player" flex, height 56, radius 16, `#01584A`, 16px/700.

## Interactions & Behavior
Behaviour is unchanged from the current implementation unless noted.

- **Home → profile**: tap a player card. Long press → delete confirmation dialog; the last remaining profile cannot be deleted.
- **Add player** → create profile screen; disabled with "Maximum profiles reached (4/4)" at 4 profiles. **Calendar button** → create season screen.
- **Profile → live match**: "Start a match" creates a `Match` for the selected season and starts the timer. Blocked with a snackbar if a match is already in progress for that profile. Confirm first if the selected season is not the current one (rule R-10).
- **Live match counters**: short press = +1, long press = −1, floor 0 (R-06). 30ms haptic on every change; the value animates (150ms scale/fade) so the change is visible without looking closely.
- **End match / stop** pauses the timer and opens the summary sheet (`#3b`). "Save match" writes duration, goals and assists and pops back to the profile; "Resume timer" restarts the ticking. **Cancel** on the live screen deletes the in-progress match after a confirmation.
- **Season picker** on the profile filters the totals and the match log; the most recent season is selected by default (R-09).
- **Create profile validation**: nickname required and ≤ 20 chars; birth year must parse and fall in 1900…current year. Errors render below the field, 12px, in the error colour. Save is only enabled when the form is valid.
- **Empty state** (no profiles yet): keep the existing copy "No profiles yet" / "Tap + to add your first player", restyled to this palette — 20px/700 `#343B46` and 14px `rgba(52,59,70,.5)`, centred.

## State Management
No new state. Existing Riverpod providers cover it:
- `childProfilesProvider` — profile list, add, delete, 4-profile cap.
- `seasonsProvider` / `selectedSeasonProvider` / `currentSeasonProvider` — season list and selection.
- `matchesProvider` — create match, `updateGoals`/`updateAssists`, `endMatchWithStats`, `deleteMatch`, `hasMatchInProgress`.
- Live match screen local state: `_goals`, `_assists`, `_totalSeconds`, `_isRunning`, `_matchId`.

Two derived values the screens need that are not stored today: per-season aggregates (matches, goals, assists) for a profile, and the last six matches' goals for the home sparkline. Compute from `matches` filtered by `childId` + `seasonId`. Note that the current home screen hardcodes `0` for all three card stats — that must be replaced with real aggregates.

## Design Tokens

Palette ("modern turquoise"), replacing the green/red set in `lib/config/colors.dart`:

| Token | Hex | Use |
|---|---|---|
| background | `#F3F4F3` | screen background, sheet |
| surface | `#FFFFFF` | cards, fields |
| ink | `#343B46` | primary text, assist values |
| ink-60 | `rgba(52,59,70,.5)` | secondary text, labels |
| ink-30 | `rgba(52,59,70,.3)` | zero values, chevrons |
| hairline | `rgba(52,59,70,.12)` | field borders |
| primary | `#008A78` | goals, accents, profile CTA |
| primary-dark | `#01584A` | hero block, primary buttons |
| accent | `#2CADA3` | sparkline bars, on-dark eyebrow |
| avatar 1–4 | `#6A71FF`, `#6BFF9B`, `#FFE16B`, `#FF6E6B` | player identity colour |

Spacing scale: 4 / 6 / 8 / 10 / 12 / 14 / 16 / 18 / 20 / 22 / 24 / 26 / 30.
Radii: 2 (bars), 4, 14 (fields, small cards), 16 (buttons, tiles), 18 (player card), 22 (counter card), 26 (sheet), 52 (avatar circle / 38 radius).
Shadows: `0 1px 2px rgba(52,59,70,.08)` cards · `0 1px 3px rgba(52,59,70,.07)` assist card · `0 2px 6px rgba(1,88,74,.25)` goals card · `0 -6px 30px rgba(52,59,70,.3)` sheet.

Typography — **Archivo** (Google Fonts, weights 400/500/600/700/800) replaces Roboto. All numeric values use tabular figures (`fontFeatures: [FontFeature.tabularFigures()]`).

| Role | Size / weight | Tracking |
|---|---|---|
| Display timer | 76 / 800 | −3 |
| Screen title | 40 / 800 (profile), 34 / 800 (home) | −1.2 / −1 |
| Counter value | 92 / 800 | 0 |
| Stat value large | 44 / 800 | 0 |
| Stat value medium | 36–38 / 800 | 0 |
| Row stat value | 22 / 800 | 0 |
| Sheet title | 30 / 800 | −.8 |
| Player name (card) | 19 / 700 | 0 |
| Section header / button | 15–16 / 700 | 0 |
| Body | 13–16 / 400–600 | 0 |
| Eyebrow / stat label | 11 / 700 | 1–2 |
| Micro label | 10 / 400–600 | .5 |

Minimum touch target 48×48; primary buttons are 52–56 tall.

## Assets
No image assets. Icons are Material Symbols (already available via Flutter's `Icons`): `person_add`, `calendar_today`, `chevron_right`, `arrow_back`, `home`, `expand_more`, `play_arrow`, `check`, `stop_circle`, `info`. The HTML prototype loads the Material Symbols web font purely for preview.

The "Deerflow" footer and `bolt` icon from the current home screen are not part of this direction — confirm with the product owner before removing.

## Files
- `StatTrack Screens.dc.html` — the design reference. Approved screens: `#2b` (home + profile), `#3a` (live match), `#3b` (match summary), `#3c` (create profile). `#1a`/`#1b` recreate today's UI; `#2a`/`#2c` were rejected.
- Source files to change: `lib/config/colors.dart`, `lib/screens/home_screen.dart`, `lib/screens/profile_screen.dart`, `lib/screens/match_screen.dart`, `lib/screens/create_profile_screen.dart`, `lib/l10n/app_localizations.dart`, `pubspec.yaml` (Archivo font).
