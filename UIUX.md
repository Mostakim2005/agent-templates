# UI/UX

**Platform-Agnostic UI/UX Parity Standard & AI Agent Audit Framework**

> **Purpose:** A reusable, zero-platform-bias UI/UX audit specification designed to sit alongside `AGENTS.md` and `AUDITS.md`. Hand this file to any AI coding agent to audit *any* interactive software repository (desktop, mobile, web, or host-extension), score every UI/UX capability from actual code, and decide whether missing features should be implemented or legitimately waived.

## Part 1: AI Agent Execution Protocol & Feasibility Rubric

When invoked on any repository (e.g., *"Run `UIUX.md` against this repo"* or *"Run Modules U1–U5 from `UIUX.md`"*), the AI coding agent must:

1. **Detect Target Platform First:** Inspect the repository's build config, source files, and UI framework to identify its native platform idioms (e.g., desktop window/tray/panel, mobile screen/FAB/bottom sheet, web app/drawer/dialog, or host-app extension surfaces). Map every agnostic primitive below to the target platform's idiomatic equivalent without importing concepts from unrelated platforms.
2. **Audit Code, Not Just Docs:** Inspect actual source files, layouts, styles, and event handlers—never trust `README.md` or design docs without code verification.
3. **Evaluate Feasibility Before Recommending:** Apply the 3-Gate Feasibility Test so parity upgrades improve usability instead of adding redundant chrome.

### 1.1 Five-State Verdict Taxonomy

Every checklist item must receive exactly one status in the audit report's **Coverage Ledger**:

| Status | Meaning | Required Agent Action |
| :--- | :--- | :--- |
| **`Present`** | Implemented, wired to real state, and meets baseline polish criteria. | Cite exact file path and symbol; note any minor polish tips. |
| **`Partial`** | Surface exists but lacks parity polish (e.g., missing keyboard navigation, hardcoded colors, no empty state, or undocumented). | Cite exact gap, file path, and concrete upgrade step. |
| **`Missing (Required)`** | Absent, and adding it fits the Universal Baseline without harming ergonomics. | Propose exact placement, interaction contract, and implementation target. |
| **`N/A — Conflicting`** | Adding the surface conflicts with the host platform, user workflow, or core architecture (e.g., a permanent footer status bar on a full-screen touch canvas). | State the concrete conflict; propose the lightest equivalent fallback if any. |
| **`N/A — Cumbersome`** | Technically possible, but adds redundant clutter or friction that outweighs user value (e.g., a full persistent sidebar for a single-action formatter). | Justify why a lighter surface (dialog, context menu, or toggle) is superior. |

### 1.2 Universal Baseline vs. Exception Rule

Default posture is **Universal Parity**: every interactive application should expose the full core UI/UX baseline—adapted to its own domain variation—*unless* a surface fails the **3-Gate Feasibility & Ideality Test**:

1. **Frequency Gate:** Will a user trigger or inspect this surface at least once per typical session? *(If no, demote from persistent chrome like a launch rail or status bar to the command launcher or settings.)*
2. **Cognitive Load Gate:** Does adding this surface reduce clicks or friction, or does it duplicate an adjacent control with identical scope? *(Avoid two controls doing the exact same thing on the same screen unless one is global and one is contextual.)*
3. **Viewport & Ergonomics Gate:** Does the surface respect viewport constraints (narrow panes, touch targets >= 44x44 px, screen readers, reduced motion) without crowding primary content?

### 1.3 Standard Agent Output Format (Git-Patch Compatible & Downloads Output)

When completing a `UIUX.md` audit, save the report directly to `%USERPROFILE%\Downloads\<Repo Title Case> - UIUX Audit.md` (or `<Repo Title Case> - UIUX Audit (<Scope>).md` when scoped) with enough concrete detail to generate clean `.patch` files:

1. **Metadata Header** (Repository, Branch, Commit SHA, Detected Platform/Framework).
2. **Coverage Ledger Table** (`Module ID`, `Feature`, `Status`, `Feasibility Verdict`, `Exact File & Symbol`, `Actionable Fix / Patch Spec`).
3. **Systemic Design Gaps** (theming/tokens, contrast, motion, keyboard ergonomics, accessibility, documentation drift) with exact `path/to/file.ext :: symbolName` anchors.
4. **Phased Implementation Plan** (P0 Entry-Point Parity -> P1 Visual & Token Hygiene -> P2 Interactive Polish & Guardrails -> P3 Docs & Lateral Upgrades) with concrete patch specifications.

---

## Part 2: Platform-Agnostic UI/UX Parity Checklist (Modules U1–U10)

### Module U1: Primary Entry Points & Launch Surfaces

- [ ] **U1.1 Global Launch Control (Rail / App Bar / FAB / Tray):** Exposes a single, unmistakable primary icon or action button with a concise tooltip/label to open or toggle the app's main interactive surface.
- [ ] **U1.2 Toggle & Active-State Sync:** Activating the primary launch control when the main view is already open either focuses or cleanly toggles it closed, and updates the control's active/pressed visual state.
- [ ] **U1.3 Command Registry Coverage:** Every user-facing action (open main UI, quick-add, toggle view, sync/refresh, focus search, undo) is registered as a searchable command with clear verb-first naming.
- [ ] **U1.4 Optional Chrome Declutter Setting:** Users can hide or toggle persistent launch chrome (rail button, tray icon, or toolbar shortcut) in Settings if they prefer keyboard-only invocation.
- [ ] **U1.5 Deep-Link / Protocol Hook (Lateral):** Supports URI, route, or CLI launch triggers so users and automation harnesses can jump directly to specific views or actions.

### Module U2: Persistent & Workspace Views

- [ ] **U2.1 Dedicated Workspace View:** Complex or multi-step workflows provide a persistent sidebar, drawer, tab, or main workspace view instead of trapping long sessions inside ephemeral dialogs.
- [ ] **U2.2 Single-Instance Deduplication:** Re-opening a persistent view reveals and focuses the existing pane/window/tab instead of spawning duplicate instances.
- [ ] **U2.3 Close-Protection / Pinning (Where Appropriate):** Long-lived dashboards or active workbenches support pinning or close-protection so users do not accidentally dismiss work in progress.
- [ ] **U2.4 View-Mode Flexibility:** Adapts cleanly between narrow/compact layouts (sidebars, split screens, mobile portrait) and wide full-window layouts.

### Module U3: Transient & Contextual Surfaces

- [ ] **U3.1 Purpose-Built Modals / Sheets:** Focused workflows (create/edit item, preview before commit, import/export) use cleanly scoped dialogs or bottom sheets with a clear header, labeled inputs, and separated primary/secondary footer actions.
- [ ] **U3.2 Contextual Menus (Right-Click / Long-Press / Overflow):** When operating on files, text selections, links, or list/canvas items, exposes a grouped, icon-labeled contextual menu only when relevant—paired with a visible overflow trigger (`⋮`) for touch and pointer discoverability.
- [ ] **U3.3 Fuzzy Quick-Picker / Command Launcher:** Any selection list exceeding ~10 items (or global action launcher) provides a keyboard-driven fuzzy search picker rather than forcing raw scrolling.
- [ ] **U3.4 Non-Blocking Tooltips & Popovers:** Icon-only controls always carry accessible labels and hover/focus tooltips showing both action name and keyboard shortcut when bound.

### Module U4: Ambient Telemetry & Status Surfaces

- [ ] **U4.1 Glanceable Status Indicator:** Background services, sync engines, active counters, or mode-switching tools expose a compact, low-noise status indicator (e.g., `● Ready`, `3 Due`, `Synced`).
- [ ] **U4.2 Click-to-Act Status Surface:** Clicking or tapping the status indicator performs a high-value action (opens a quick popover, toggles the primary view, triggers a refresh, or surfaces diagnostics) rather than acting as dead text.
- [ ] **U4.3 Redundant Visual State Encoding:** Status indicators pair color with shape, icon, or text (never color alone) to distinguish Idle, Active/Running, Warning, and Error states.

### Module U5: Configuration & Discoverability

- [ ] **U5.1 Dedicated Settings / Preferences Surface:** Every configurable application centralizes toggles, defaults, appearance options, and diagnostics in a dedicated Settings screen or tab.
- [ ] **U5.2 Grouped Sections & Plain-Language Descriptions:** Settings are grouped under logical headings (General, Appearance, Behavior, Advanced/Danger Zone) with 1-sentence descriptions explaining user-visible effect rather than internal variable names.
- [ ] **U5.3 Reset-to-Defaults & Config Portability:** Includes a guarded "Reset to defaults" action (behind a confirmation dialog) and portable export/import (e.g., JSON) for non-trivial configurations.
- [ ] **U5.4 First-Run Onboarding & Empty States:** First launch or zero-data views display a calm, actionable empty state (icon + 1-line explanation + primary CTA button) rather than a blank canvas.

### Module U6: Inline & Embedded Content Surfaces

- [ ] **U6.1 Embedded Interactive Cards / Widgets:** Content-enriching tools render clean inline previews or interactive blocks with hover/focus affordances and a clean fallback if data is unavailable.
- [ ] **U6.2 Contextual Floating Toolbars:** Selection-based or canvas-based editors surface compact floating action bars near the active selection without obstructing primary content.
- [ ] **U6.3 Quick-Look / Lightbox Preview:** Media-heavy or file-browsing interfaces support instant full-size preview (`Space` or click) with `Esc` or swipe-down dismissal that preserves scroll position.

### Module U7: Visual Design System & Theming

- [ ] **U7.1 Semantic Design Tokens (Zero Hardcoded Color Leaks):** All colors derive from semantic surface, text, border, and accent variables rather than raw hex literals that break across themes.
- [ ] **U7.2 Light & Dark Theme Parity (WCAG AA >= 4.5:1):** Verified in both Light and Dark themes; badges, pills, disabled controls, and translucent surfaces maintain >= 4.5:1 text contrast.
- [ ] **U7.3 Spacing & Typographic Hierarchy:** Uses a consistent spacing scale (4/8/12/16/24 px) and clear size/weight hierarchy (title, section label, body, muted caption) with generous breathing room.
- [ ] **U7.4 Consistent Minimalist Vector Iconography:** Uses a single consistent stroke-weight vector icon family rather than mixing emoji, raw ASCII, and mismatched bitmaps.
- [ ] **U7.5 Z-Index & Overflow Discipline:** Layered surfaces follow a strict elevation ladder (base `0` -> sticky headers `10` -> floating toolbars `20` -> menus/popovers `40` -> dialogs `50` -> toasts `60`) with zero clipped menus or accidental horizontal overflow.

### Module U8: Interactive Polish, Motion & Feedback

- [ ] **U8.1 Purposeful Micro-Animations:** State transitions (hover, press, tab switch, drawer slide, modal entrance, toast reveal) use crisp, fast easing (`120ms–220ms`, `cubic-bezier(0.2, 0.8, 0.2, 1)`)—never sluggish or distracting.
- [ ] **U8.2 Reduced-Motion Compliance:** Respects OS/user reduced-motion preferences (`prefers-reduced-motion: reduce` or native platform equivalent) so motion-sensitive users get instant, clean state changes.
- [ ] **U8.3 Actionable Feedback (Toasts / Snackbars):** Every user-triggered mutation confirms success or explains failure in plain language; deletions or batch mutations include an **Undo** action or preview step.
- [ ] **U8.4 Loading & Async States:** Any operation exceeding ~200 ms displays a skeleton loader, inline spinner, or disabled-with-progress button state—never a frozen UI.
- [ ] **U8.5 Progressive Disclosure (Show/Hide Toggles):** Advanced filters, secondary metadata, and power-user controls collapse cleanly behind labeled Show/Hide chevrons or accordions so default screens remain calm.
- [ ] **U8.6 Search, Filter & Sort Consistency:** Any list or grid exceeding ~8 items offers instant search, filter chips with active count + one-click "Reset filters", and clear sort indicators.

### Module U9: Safety Guardrails, Keyboard & Accessibility (a11y)

- [ ] **U9.1 Keyboard-First Ergonomics:** Full support for `Tab` / `Shift+Tab`, `Arrow` keys in lists and menus, `Enter` to activate, `Esc` to dismiss overlays, and `/` or `Ctrl+F` to focus in-view search.
- [ ] **U9.2 Visible Keyboard Focus Rings:** Every interactive control shows a crisp, high-contrast keyboard focus indicator (`:focus-visible` or native platform equivalent) without distracting mouse-click rings.
- [ ] **U9.3 Semantic Controls & Assistive Labels:** Uses native interactive primitives (buttons, inputs, switches, selects) with accessible labels, expanded/selected states, and polite live-region announcements for dynamic updates.
- [ ] **U9.4 Destructive-Action Guardrails:** Delete, reset, unlink, or bulk-overwrite operations always require either a dedicated themed Confirmation Dialog (naming the exact target and impact) or a reversible Preview + Undo workflow. Never rely on unstyled native blocking alert/confirm popups.
- [ ] **U9.5 Responsive & Touch Adaptation:** Adapts cleanly across narrow viewports and touch devices (minimum 44x44 px touch targets, zero hover-only critical actions).

### Module U10: Documentation & Visual Parity

- [ ] **U10.1 `README.md` UI Surface Inventory:** Accurately documents every user-facing entry point (launch controls, views, dialogs, commands, status indicators, context menus, settings) matching shipped code.
- [ ] **U10.2 Product & Visual Flow Documentation:** Feature maps (`PRODUCT.md`) and architecture/visual flow maps (`ARCHITECTURE.md`) stay synchronized with actual UI flows.
- [ ] **U10.3 Agent Guardrails (`AGENTS.md`):** Records core UI/UX invariants (design tokens, style prefixes, keyboard traps, close-protection rules) so future sessions never regress parity.

---

## Part 3: Lateral & Ideal UI/UX Additions

Seven high-leverage cross-platform patterns that elevate an application from functional to cohesive:

1. **Unified Action Registry:** Define each user action *once* (ID, verb-first label, icon, shortcut, visibility predicate, handler) and bind it to launch chrome, command palette, toolbars, and context menus from a single source of truth—eliminating label drift.
2. **The Empty / Loading / Error State Triad:** Require every dynamic view or list to implement all three non-happy states with a direct recovery control (`Create first item`, `Skeleton loader`, `Retry + Copy error details`).
3. **Plan -> Preview -> Commit Safety Flow:** For bulk edits, migrations, or layout mutations, show a concise diff/preview dialog before committing changes, paired with a reversible Undo path.
4. **Density Mode Toggle (Comfortable vs. Compact):** Expose a single layout-density switch that tightens card and row padding by ~25% for power users working with dense datasets or narrow panes.
5. **In-View Keyboard Cheat-Sheet (`?` Overlay):** Pressing `?` inside any workspace view opens a minimal shortcut legend—making keyboard-first ergonomics self-discoverable.
6. **Shared Baseline Token & Accessibility Contract:** Maintain a small reusable base stylesheet/theme layer enforcing reduced-motion rules, visible focus rings, and semantic surface/text/border tokens across every project.
7. **Feasibility-Gated Parity (Anti-Bloat Guard):** Explicitly distinguish `Missing (Required)` from `N/A — Conflicting` and `N/A — Cumbersome` so striving for parity never bloats a focused micro-utility.