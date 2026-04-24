---
name: COVE Luminary
colors:
  surface: '#f4faff'
  surface-dim: '#d4dbe0'
  surface-bright: '#f4faff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eef5fa'
  surface-container: '#e8eff4'
  surface-container-high: '#e2e9ee'
  surface-container-highest: '#dce3e8'
  on-surface: '#151d20'
  on-surface-variant: '#414751'
  inverse-surface: '#2a3135'
  inverse-on-surface: '#ebf2f7'
  outline: '#717782'
  outline-variant: '#c1c7d2'
  surface-tint: '#0861a6'
  primary: '#00467c'
  on-primary: '#ffffff'
  primary-container: '#005ea3'
  on-primary-container: '#bad7ff'
  inverse-primary: '#a1c9ff'
  secondary: '#006686'
  on-secondary: '#ffffff'
  secondary-container: '#93dbff'
  on-secondary-container: '#006180'
  tertiary: '#00457f'
  on-tertiary: '#ffffff'
  tertiary-container: '#075da6'
  on-tertiary-container: '#bcd6ff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d2e4ff'
  primary-fixed-dim: '#a1c9ff'
  on-primary-fixed: '#001c37'
  on-primary-fixed-variant: '#004880'
  secondary-fixed: '#c0e8ff'
  secondary-fixed-dim: '#87d0f4'
  on-secondary-fixed: '#001e2b'
  on-secondary-fixed-variant: '#004d66'
  tertiary-fixed: '#d4e3ff'
  tertiary-fixed-dim: '#a4c9ff'
  on-tertiary-fixed: '#001c39'
  on-tertiary-fixed-variant: '#004883'
  background: '#f4faff'
  on-background: '#151d20'
  surface-variant: '#dce3e8'
typography:
  display:
    fontFamily: Inter
    fontSize: 2.75rem
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 1.875rem
    fontWeight: '700'
    lineHeight: 2.25rem
    letterSpacing: -0.025em
  headline-md:
    fontFamily: Inter
    fontSize: 1.375rem
    fontWeight: '700'
    lineHeight: 1.75rem
  body-md:
    fontFamily: Inter
    fontSize: 1rem
    fontWeight: '400'
    lineHeight: 1.5rem
  label-bold:
    fontFamily: Inter
    fontSize: 0.75rem
    fontWeight: '700'
    lineHeight: 1rem
    letterSpacing: 0.05em
  stats-number:
    fontFamily: Inter
    fontSize: 1.875rem
    fontWeight: '700'
    lineHeight: '1'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-padding: 2rem
  section-gap: 2rem
  element-gap: 1rem
  card-padding: 1.5rem
  sidebar-width: 18rem
---

## Brand & Style
The brand personality is professional, sophisticated, and technologically advanced, aimed at high-end residential management. It evokes a sense of "premium security" and "operational clarity."

The design style is **Corporate Modern with Glassmorphism accents**. It balances the reliability of a traditional SaaS dashboard with contemporary visual flourishes like backdrop blurs, subtle gradients, and "bento-box" grid layouts. The interface uses a light, airy palette with deep blue anchors to establish trust, while utilizing translucent "glass" panels for secondary information to maintain a sense of depth and modernity.

## Colors
The palette is dominated by "Oceanic Blues" and "Cool Grays," creating a serene but authoritative environment. 

- **Primary:** A deep, trustworthy blue (#005ea3) used for brand elements, active states, and primary actions.
- **Surface Strategy:** The system uses `surface-container-low` (#e9f5fc) for sidebar backgrounds and `surface-container-lowest` (#ffffff) for primary content cards to create clear architectural hierarchy.
- **Semantic Colors:** Error states use a high-chroma red (#ba1a1a), while positive trends and secondary data points utilize a bright cyan-blue (#5bcdff).
- **Glass Effects:** Interactive panels use a semi-transparent white with a 20px backdrop blur to lift elements off the background without traditional heavy shadows.

## Typography
The system relies exclusively on **Inter**, utilizing its variable weight axis to create a rigorous information hierarchy. 

Key typographic principles:
- **Tracking:** Tightened tracking (-0.02em to -0.05em) is applied to large display text and headlines to create a "compact" and modern editorial feel.
- **Casing:** Label styles and small status indicators use uppercase with wider tracking (0.05em to 0.1em) for better legibility and a premium "tag" appearance.
- **Weight:** Black (900) or Bold (700) weights are used for branding and major greetings, while Medium (500) is preferred for UI controls.

## Layout & Spacing
The system uses a **Fixed-Fluid Hybrid Grid**. 
- **Navigation:** A fixed left sidebar (288px/18rem) persists on desktop, transitioning to a bottom-tab bar on mobile devices.
- **Content:** The main canvas has a maximum width of 1280px (max-w-7xl) and is centered, ensuring readability on ultra-wide monitors.
- **Rhythm:** A 4px/8px base unit is used. Standard page margins are 32px (2rem) on desktop and 16px (1rem) on mobile. 
- **Bento Grid:** Information cards use a flexible grid that shifts from 2 columns (mobile) to 4 columns (desktop) to maintain "glanceability."

## Elevation & Depth
Hierarchy is established through **Tonal Layering** and **Soft Ambient Shadows** rather than high-contrast borders.

1.  **Level 0 (Base):** The `surface` color (#f3faff) acts as the foundation.
2.  **Level 1 (Floating Panels):** Glassmorphic cards use `backdrop-blur-xl` and a 1px `outline-variant` border at 15% opacity. Shadows are extra-diffused: `0px 12px 32px rgba(0, 94, 163, 0.06)`.
3.  **Level 2 (Active States/Modals):** High-impact buttons use a stronger shadow with color tinting: `0px 12px 32px rgba(0, 94, 163, 0.15)`.
4.  **Visual Anchors:** Deep blue gradients (Primary to Primary-Container) are used to pull the eye toward primary conversion points (e.g., "Add Resident").

## Shapes
The shape language is "Friendly Professional." 
- **Cards & Sections:** Use `rounded-xl` (0.75rem) to 1rem for a substantial, containerized feel.
- **Interactive Elements:** Buttons and tags use `rounded-xl` or `rounded-full` (pill-shaped) to distinguish them from structural content.
- **Profiles:** User avatars and status pips are strictly `rounded-full` (circular) to contrast with the angularity of the grid.

## Components
- **Buttons:**
    - *Primary:* Gradient-filled (Blue), white text, bold tracking, `rounded-xl`.
    - *Secondary:* White background, 1px border, primary-colored icons.
- **Cards (Bento Style):** 
    - Glassmorphic finish, fixed height (32rem), internal padding (1.5rem). 
    - Features a "decorative blur" (a large, blurred circle of secondary color in the top-right corner) that expands on hover.
- **Navigation Drawer:** 
    - High-blur (20px) white/slate-900 background. 
    - Active items feature a 4px right-border accent and a subtle background tint.
- **Charts:** 
    - Simplified line charts using curved paths (splines). 
    - Area fill using a vertical gradient from Primary (20% opacity) to Transparent.
- **Status Indicators:** 
    - Pulsing pips for "System Active" states. 
    - Small, uppercase tags with 10% background opacity of their semantic color.