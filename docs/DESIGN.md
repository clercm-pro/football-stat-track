# Design Guidelines

This document outlines the visual identity, UI components, and accessibility standards for StatTrack.

---

## Color Palette

**Source**: [colorhunt.co/palette/362f4f5b23ff008bffe4ff30](https://colorhunt.co/palette/362f4f5b23ff008bffe4ff30)

| Color | Hex Code | Usage |
|-------|----------|-------|
| **Surface/Background** | `#362F4F` | Primary background, cards |
| **Primary** | `#5B23FF` | Primary buttons, AppBar, accents |
| **Secondary** | `#008BFF` | Borders, links, secondary elements |
| **Accent** | `#E4FF30` | Icons, labels, feedback |
| **Error** | `#EA4335` | Error messages |
| **Text Primary** | `#FFFFFF` | Text on dark backgrounds |
| **Text Secondary** | `#B0B0B0` | Less important text |

---

## Typography

| Element | Font | Size | Style |
|---------|------|------|-------|
| Headings | Roboto | 24sp | Bold |
| Body text | Roboto | 16sp | Regular |
| Buttons | Roboto | 16sp | Medium |
| Labels | Roboto | 14sp | Regular |

---

## UI Components

### Cards
- **Elevation**: 4
- **Border Radius**: 12
- **Color**: `#362F4F`

### Buttons
- **Height**: 48dp
- **Border Radius**: 8
- **Primary buttons**: Use `#5B23FF` background
- **Secondary buttons**: Use `#008BFF` border

### Input Fields
- **Border color**: `#008BFF`
- **Background**: `#362F4F` at 80% opacity
- **Border Radius**: 12

### Icons
- **Color**: `#E4FF30`
- **Style**: Material Icons

---

## Accessibility

| Requirement | Solution |
|-------------|----------|
| **Color blindness** | Contrasted colors (WCAG 4.5:1 ratio) |
| **Touch targets** | Buttons >= 48x48dp |
| **Haptic feedback** | Light vibration (30ms) |
| **Dark mode** | Native support (dark theme by default) |
| **Readable text** | Minimum size: 16sp |

---

## UX Best Practices

### Minimalism
- One primary action per screen
- Avoid clutter and unnecessary elements

### Immediate Feedback
- Visual animation for +1/-1 counters
- Optional sound effects
- Haptic feedback on button presses

### Error Prevention
- Confirmation before deletion or cancellation
- Alerts for potentially destructive actions
- Clear error messages

### Consistency
- Buttons always in the same location
- Consistent spacing and padding
- Uniform styling across all screens

---

## Screen Specifications

### Home Screen
- Displays profile cards in a 2-column grid
- **AppBar** with title and **+** button (color `#5B23FF`)
- Each **profile card** shows: avatar, nickname, matches played, goals, assists
- **+ Add** card for creating new profiles

### Profile Screen
- **AppBar** with back button, profile name, and **Home** button
- **Header** with avatar, nickname, and age (if birth year provided)
- **Season selector** dropdown
- **Stats display**: matches, goals, assists for selected season
- **Primary action button**: **Start a Match**

### Match Screen
- **AppBar** with back button, title, and **Stop** button
- **Timer** display (color `#E4FF30`)
- Two large action buttons: **Goal** and **Assist**
  - Goal button: border color `#E4FF30`
  - Assist button: border color `#008BFF`
- Counters for goals and assists
- **End** and **Cancel** buttons
- Instructions: "Short press = +1 • Long press = -1"

---

**See also:**
- [Functional Specifications](FUNCTIONAL-SPECS.md) for user stories and flows
- [Technical Architecture](ARCHITECTURE.md) for implementation details
