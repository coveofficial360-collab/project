# Cove Glass Design System

### 1. Overview & Creative North Star
**Creative North Star: The Urban Sanctuary**
Cove Glass is a design system that balances the technical demands of property management with the editorial grace of a high-end lifestyle publication. It moves away from the "utility-first" aesthetic of typical apps, instead embracing a "Glass & Light" philosophy. By utilizing intentional asymmetry, deep translucency (Glassmorphism), and a sophisticated hierarchy of elevation, the system creates an environment that feels breathable, premium, and calm.

### 2. Colors
The palette is rooted in a crisp, architectural Blue (#005BBF) but expands into a warm, sunset-inspired secondary and tertiary range to denote different utility categories (e.g., Electricity, Payments).

- **The "No-Line" Rule:** Visual boundaries are created via background shifts. Avoid 1px borders for major sectioning. Use `surface-container-low` against `surface` to define regions.
- **Surface Hierarchy & Nesting:** Primary content lives on `surface-container-lowest` (pure white). Secondary cards or "pressed" states utilize the higher container tiers to simulate a physical stacking effect.
- **The "Glass & Gradient" Rule:** Use `backdrop-blur-xl` and `bg-white/90` for navigation bars and floating headers. Hero cards should feature subtle radial gradients and "floating" blurred background elements to create 3D depth.

### 3. Typography
The system uses a pairing of **Plus Jakarta Sans** for headlines to convey a modern, slightly geometric personality, and **Inter** for body text to ensure maximum readability in dense information environments.

**Typography Scale (Ground Truth):**
- **Display/Hero:** 2.25rem (36px) — Used for large monetary values or primary status numbers.
- **Headline:** 1.5rem to 1.875rem (24px - 30px) — Used for section titles.
- **Sub-headline:** 1.125rem (18px) — For important labels.
- **Body:** 0.875rem (14px) — The workhorse for descriptions and notifications.
- **Labels:** 0.75rem (12px) and a specialized 10px micro-label for timestamps.

The scale uses tight letter-spacing (-0.025em) on headlines to maintain a compact, editorial look, while labels use "tracking-widest" (0.1em) for clarity and style.

### 4. Elevation & Depth
Cove Glass rejects the "card-on-gray" flat look in favor of tonal layering and atmospheric lighting.

- **The Layering Principle:** 
    - Base: `surface` (#F8F9FA).
    - Elevated content: `surface-container-lowest` (#FFFFFF) with a `shadow-sm`.
- **Ambient Shadows:** The system uses extra-diffused shadows. The primary shadow profile is `0 12px 32px rgba(25, 28, 29, 0.06)`, providing a soft lift that suggests the UI is floating on a cushion of air.
- **Glassmorphism:** Navigation and headers must use a high-blur backdrop (`blur-xl` or `blur-2xl`) with a semi-transparent fill (`bg-slate-100/50`).

### 5. Components
- **Buttons:** Large, pill-shaped (rounded-full). Primary buttons use a solid brand color; secondary actions are expressed via scale-down interactions on cards rather than traditional buttons.
- **Action Orbs (Chips):** Circular icon containers (56px x 56px) for high-frequency tasks. They use a subtle `border-outline-variant/15` and a soft background tint.
- **Dynamic Cards:** Cards are not just containers; they are interactive surfaces. On hover, cards should translate vertically (-4px) and gain a more pronounced shadow.
- **Bottom Navigation:** Uses a 24px backdrop blur and a "pill" active state to highlight the current section.

### 6. Do's and Don'ts
**Do:**
- Use uppercase and wide letter spacing for small metadata labels.
- Mix font weights (700 for headlines, 400/500 for body) to create a clear reading path.
- Leverage iconography with the 'FILL' 1 variation for active states to add visual weight.

**Don't:**
- Use harsh black for text; stick to `on-surface` (#191C1D) for a more natural, ink-like feel.
- Overuse borders; if a border is necessary, keep the opacity low (15-30%) and the color tied to the `outline-variant`.
- Crowd the screen; Cove Glass requires generous padding (1.5rem standard) to feel premium.