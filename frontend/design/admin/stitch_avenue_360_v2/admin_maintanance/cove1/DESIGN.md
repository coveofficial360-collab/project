# Design System Specification: Residential Excellence

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Digital Concierge."** 

Moving beyond the utilitarian "admin dashboard" aesthetic common in property management, this system adopts a high-end editorial approach. It balances the authority of a trusted institution with the warmth of a luxury residence. We break the "Material template" look through **intentional white space, tonal depth, and typographic dominance.** The layout should feel like a premium architectural magazine—breathable, structured, and profoundly calm.

## 2. Colors: Tonal Architecture
We utilize a sophisticated palette where color is used for "mood" and "status" rather than structural containment.

### The "No-Line" Rule
**Prohibit 1px solid borders for sectioning.** Boundaries must be defined solely through background color shifts. To separate a sidebar from a main feed, use `surface-container-low` against a `surface` background. This creates a "soft-edge" UI that feels modern and integrated.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the following tokens to create "nested" depth:
- **Base Layer:** `surface` (#f8f9fa) - The foundation.
- **Sectioning:** `surface-container-low` (#f3f4f5) - Large layout regions.
- **Content Cards:** `surface-container-lowest` (#ffffff) - High-priority interactive elements.
- **Overlays:** `surface-container-high` (#e7e8e9) - Modals and flyouts.

### The Glass & Gradient Rule
To inject "soul" into the professional blue, use **Glassmorphism** for floating navigation or header elements. Apply `surface` at 80% opacity with a `24px backdrop-blur`. 
**Signature Gradients:** For primary CTAs, transition from `primary` (#005bbf) to `primary_container` (#1a73e8) at a 135-degree angle to provide a subtle 3D "sheen."

---

## 3. Typography: Editorial Authority
The type system pairs the geometric precision of **Plus Jakarta Sans** (our high-end interpretation of Google Sans) with the functional clarity of **Inter** (replacing standard Roboto for a more contemporary feel).

*   **Display (Plus Jakarta Sans):** Used for "Big Numbers" (e.g., total society funds). Large, bold, and authoritative.
*   **Headlines (Plus Jakarta Sans):** Medium weight. Use wide letter-spacing (-0.02em) to create a premium feel.
*   **Body (Inter):** Regular weight. Line height is increased to 1.6x to ensure readability for long-form community bylaws or notices.
*   **Labels (Inter):** Uppercase with 0.05em tracking for a "legal" or "official" tone in small metadata.

---

## 4. Elevation & Depth: The Layering Principle
We reject traditional drop shadows in favor of **Tonal Layering.**

*   **Stacking:** Place a `surface-container-lowest` card on a `surface-container-low` section. This creates a natural "lift" through color contrast alone.
*   **Ambient Shadows:** If an element must float (e.g., a FAB or Menu), use a "Soft-Focus" shadow: `box-shadow: 0 12px 32px rgba(25, 28, 29, 0.06);`. The shadow color is a tinted version of `on-surface`, never pure black.
*   **The Ghost Border:** If a boundary is required for accessibility, use `outline-variant` at 15% opacity. It should be felt, not seen.
*   **Glass Depth:** Floating headers should use the Glassmorphism effect to allow content colors to bleed through, making the interface feel like a single cohesive environment.

---

## 5. Components: The Signature Suite

### Buttons
- **Primary:** Full pill-shape (`rounded-xl` / 28dp). Gradient fill from `primary` to `primary_container`. No border.
- **Secondary:** Transparent background with a `Ghost Border`. Use `primary` text.
- **Tertiary:** No background, no border. Use `primary` text with an underline on hover.

### Cards
- **Radius:** Fixed at `16dp` (1rem).
- **Style:** Never use dividers. Separate content using `1.5rem` (md) vertical padding or by nesting a `surface-container-highest` badge within a `surface-container-lowest` card.

### Inputs & Fields
- **Container:** Filled style using `surface-container-high`. 
- **Indicator:** A 2px bottom bar in `primary` that appears only on focus.
- **Roundedness:** `0.5rem` (sm) for the container to contrast with pill-shaped buttons.

### Chips (Action & Status)
- **Status Chips:** For "Paid" or "Pending." Use 10% opacity of the status color (Success/Danger) for the background and 100% opacity for the text. No border.

### Additional Signature Component: "The Amenity Tile"
A specialized card for residential features (Gym, Pool, Hall). Uses an image background with a `surface-dim` (20% opacity) overlay and `headline-sm` text anchored to the bottom-left for a cinematic, high-end feel.

---

## 6. Do’s and Don’ts

### Do:
- **Do** use asymmetrical layouts. Align text to the left but place supporting imagery or data visualizations slightly offset to the right.
- **Do** use Material Symbols Rounded at 200/400 weight for a soft, friendly touch.
- **Do** prioritize "Breathing Room." If you think there is enough margin, double it.

### Don't:
- **Don’t** use 1px solid lines to separate list items. Use a 12px gap instead.
- **Don’t** use pure #000000 for text. Use `on-surface` (#191c1d) to maintain the "ink on paper" softness.
- **Don’t** use high-intensity Amber (#F8AB00) for large surfaces. It is an accent (Secondary); use it for gold-standard features, alerts, or "VIP" statuses only.