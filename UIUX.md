# UI/UX Parity & Ergonomics Audit Framework (`UIUX.md`)

> **Purpose:** A platform-agnostic UI/UX surface, design-system, and ergonomics audit framework designed to pair cleanly with `AGENTS.md` and `AUDITS.md` (which covers backend, security, concurrency, data safety, and code-level bug hunting). Hand this file to any AI coding agent to evaluate interactive software across desktop, mobile, web, or host-extension platforms, score every capability from live code, and distinguish required upgrades from legitimate waivers.

## Part 1: AI Agent Execution Protocol & Feasibility Rubric

When invoked on any repository (e.g., *"Run `UIUX.md` against this repo"* or *"Run Modules U1–U5 from `UIUX.md`"*), the AI coding agent must:

1. **Detect Target Platform First:** Inspect build configs, source files, and UI frameworks to identify native platform idioms (desktop window/tray/panel, mobile screen/FAB/bottom sheet, web app/drawer/dialog, or host-extension surfaces). Map every agnostic primitive below to its idiomatic target equivalent without importing alien patterns.
2. **Pre-Audit Waiver & Decision Scan (Respect Recorded Choices):** Run `grep -A 1 "^### \[" docs/` and inspect `docs/DECISIONS_AND_TRAPS.md` and `docs/PRODUCT.md` first. Honor existing `[TRAP]` UI invariants and previously recorded `[DECISION]` waivers (`N/A — Conflicting`, `N/A — Cumbersome`) so repeat audits never re-propose already-waived chrome unless live code drifted.
3. **Audit Live Code, Not Just Docs:** Inspect actual layouts, stylesheets, tokens, and event handlers—never trust `README.md` or specs without source verification.
4. **Apply the 3-Gate Feasibility Test Before Recommending:** Ensure parity upgrades reduce friction rather than adding redundant chrome.

### 1.1 Five-State Verdict Taxonomy

Every checklist item (`U1.1`–`U10.3`) receives exactly one status in the **Coverage Ledger**:

| Status | Meaning | Required Agent Action |
| :--- | :--- | :--- |
| **`Present`** | Implemented, wired to real state, and meets baseline polish criteria. | Cite `path/to/file.ext :: symbolName`; note minor polish tips only if high-value. |
| **`Partial`** | Surface exists but lacks parity polish (missing keyboard support, hardcoded colors, no empty state, or undocumented). | Cite exact gap, `path/to/file.ext :: symbolName`, and concrete upgrade step. |
| **`Missing (Required)`** | Absent, and adding it passes all 3 Feasibility Gates without harming ergonomics. | Propose exact placement, interaction contract, and implementation target. |
| **`N/A — Conflicting`** | Adding the surface conflicts with the host platform, user workflow, or core architecture (e.g., permanent footer bar on a full-screen canvas). | State the concrete conflict; propose the lightest fallback if needed and log as `[DECISION]` on closure. |
| **`N/A — Cumbersome`** | Technically possible, but adds clutter or friction outweighing user value (e.g., persistent sidebar for a single-action utility). | Justify why a lighter surface (dialog, menu, toggle) wins and log as `[DECISION]` on closure. |

### 1.2 Universal Baseline vs. 3-Gate Feasibility Rubric

Default posture is **Universal Parity** *unless* a surface fails one of the three gates:

1. **Frequency Gate:** Will a user trigger or inspect this surface at least once per typical session? *(If no, demote from persistent chrome to the command launcher or Settings.)*
2. **Cognitive Load Gate:** Does adding this surface reduce clicks/friction, or duplicate an adjacent control with identical scope? *(Avoid duplicate same-scope controls on one screen.)*
3. **Viewport & Ergonomics Gate:** Does the surface respect narrow viewports, touch targets (`>= 44x44 px`), screen readers, and `prefers-reduced-motion` without crowding primary content?

### 1.3 Standard Output Format (`Downloads\` Patch-Ready Report & Closure Loop)

Save the report directly to `%USERPROFILE%\Downloads\<Repo Title Case> - UIUX Audit.md` (or `<Repo Title Case> - UIUX Audit (<Scope>).md`, preserving exact upstream fork casing) with full git-patch readiness:

1. **Metadata Header:** Repository, Branch, Commit SHA, and Detected Platform/Framework.
2. **Coverage Ledger Table:** `Module ID` | `Feature` | `Status` | `Feasibility Verdict` | `Exact File & Symbol (path/to/file.ext :: symbolName)` | `Actionable Fix / Patch Spec` (plus files inspected/skipped).
3. **Systemic Design Gaps:** Consolidated token, contrast, overflow/z-index, motion, keyboard, and a11y gaps with exact `path/to/file.ext :: symbolName` anchors.
4. **Unified `Phase 1–4` Execution Plan** (aligned identically with `AUDITS.md` Module 15 for seamless combined runs):
   * **Phase 1 — Stability, Entry-Point & Safety Guardrails:** Primary launch parity (`U1`), close-protection (`U2.3`), and destructive-action confirmation/undo guardrails (`U9.4`).
   * **Phase 2 — Token Hygiene, Cleanup & Core Parity:** Semantic design tokens (`U7.1`), settings/reset portability (`U5`), and command/action deduplication.
   * **Phase 3 — Visual Systems, Surfaces, Motion & Accessibility:** Light/Dark contrast (`U7.2`), elevation/overflow discipline (`U7.5`), contextual/loading/empty states (`U3`, `U8`), reduced-motion, and keyboard/ARIA (`U9`).
   * **Phase 4 — Automation Hooks, Living Docs & Lateral Upgrades:** Deep-link/CLI triggers (`U1.5`), `README.md` + `docs/` sync (`U10`), and cherry-picked Part 3 lateral upgrades.
5. **Post-Audit Closure Loop:** When implementing audit fixes, record accepted `N/A — Conflicting` / `N/A — Cumbersome` waivers as `[DECISION]` entries in `docs/DECISIONS_AND_TRAPS.md`, subtle CSS/focus/theme landmines as `[TRAP]` (plus 1-line pointer in root `AGENTS.md`), UI tests in `docs/PRODUCT.md` (`Verified By:`), and deferred enhancements as `[WISHLIST]`.

---

## Part 2: Platform-Agnostic UI/UX Parity Checklist (Modules U1–U10)

### Module U1: Primary Entry Points & Launch Surfaces

- [ ] **U1.1 Global Launch Control (Rail / App Bar / FAB / Tray):** Exposes one unmistakable primary icon/button with a concise tooltip/label to open or toggle the main surface.
- [ ] **U1.2 Toggle & Active-State Sync:** Re-activating the launch control when open either focuses or cleanly toggles it closed, updating its active/pressed state.
- [ ] **U1.3 Command Registry Coverage:** Every user-facing action (open UI, quick-add, toggle view, sync/refresh, focus search, undo) is registered as a searchable verb-first command.
- [ ] **U1.4 Optional Chrome Declutter Setting:** Users can hide persistent launch chrome (rail icon, tray, toolbar button) in Settings when preferring keyboard-only invocation.
- [ ] **U1.5 Deep-Link / Protocol Hook:** Supports URI, route, or CLI launch triggers so users and automation scripts can jump straight to views or actions.

### Module U2: Persistent & Workspace Views

- [ ] **U2.1 Dedicated Workspace View:** Complex or multi-step workflows use a persistent sidebar, drawer, tab, or main workspace instead of trapping sessions in ephemeral modals.
- [ ] **U2.2 Single-Instance Deduplication:** Re-opening a persistent view focuses the existing pane/window/tab rather than spawning duplicates.
- [ ] **U2.3 Close-Protection / Pinning:** Long-lived dashboards or dirty editors support pinning or unsaved-work guards against accidental dismissal.
- [ ] **U2.4 View-Mode Flexibility:** Adapts cleanly across narrow/compact panes (sidebars, split views, portrait) and wide desktop layouts.

### Module U3: Transient & Contextual Surfaces

- [ ] **U3.1 Purpose-Built Modals / Sheets:** Focused tasks (create/edit, preview before commit, import/export) use scoped dialogs/sheets with clear headers, labeled inputs, and separated primary/secondary footer actions.
- [ ] **U3.2 Contextual Menus (Right-Click / Long-Press / Overflow):** Exposes grouped, icon-labeled context menus on items/selections paired with a visible overflow trigger (`⋮`) for touch and pointer discoverability.
- [ ] **U3.3 Fuzzy Quick-Picker / Command Launcher:** Selection lists exceeding ~10 items (or global action launchers) provide keyboard-driven fuzzy filtering rather than raw scrolling.
- [ ] **U3.4 Non-Blocking Tooltips & Popovers:** Icon-only controls carry accessible labels and hover/focus tooltips showing action name plus shortcut when bound.

### Module U4: Ambient Telemetry & Status Surfaces

- [ ] **U4.1 Glanceable Status Indicator:** Background services, sync engines, counters, or mode tools expose a compact low-noise status pill (e.g., `● Ready`, `3 Active`, `Synced`).
- [ ] **U4.2 Click-to-Act Status Surface:** Activating the status indicator performs a useful action (opens quick popover, toggles view, refreshes, or shows diagnostics) instead of acting as dead text.
- [ ] **U4.3 Redundant Visual State Encoding:** Pairs color with shape, icon, or text (never color alone) across Idle, Running, Warning, and Error states.

### Module U5: Configuration & Discoverability

- [ ] **U5.1 Dedicated Settings Surface:** Centralizes toggles, defaults, appearance options, and diagnostics in a dedicated Settings screen or tab.
- [ ] **U5.2 Grouped Sections & Plain-Language Descriptions:** Groups settings logically (General, Appearance, Behavior, Advanced/Danger Zone) with 1-sentence user-facing descriptions.
- [ ] **U5.3 Reset-to-Defaults & Config Portability:** Includes a guarded "Reset to defaults" action and portable JSON export/import for non-trivial configs.
- [ ] **U5.4 First-Run Onboarding & Empty States:** Zero-data views show a calm, actionable empty state (icon + 1-line explanation + primary CTA) instead of a blank screen.

### Module U6: Inline & Embedded Content Surfaces

- [ ] **U6.1 Embedded Interactive Cards / Widgets:** Content-enriching surfaces render clean inline previews/cards with hover/focus affordances and graceful offline/missing-data fallbacks.
- [ ] **U6.2 Contextual Floating Toolbars:** Selection- or canvas-based editors position compact floating bars near selections without obscuring primary work.
- [ ] **U6.3 Quick-Look / Lightbox Preview:** Media or file browsers support instant preview (`Space` or click) with `Esc` dismissal preserving scroll position.

### Module U7: Visual Design System & Theming

- [ ] **U7.1 Semantic Design Tokens (Zero Hardcoded Color Leaks):** Derives all colors from semantic surface, text, border, and accent tokens (reusing shared M3/base tokens from `%LOCALAPPDATA%\SharedLibraries` where applicable).
- [ ] **U7.2 Light & Dark Theme Parity (WCAG AA >= 4.5:1):** Maintains `>= 4.5:1` text contrast and `>= 3:1` control/icon contrast across badges, pills, disabled states, and translucent surfaces in both Light and Dark themes.
- [ ] **U7.3 Spacing & Typographic Hierarchy:** Follows a consistent spacing scale (`4/8/12/16/24 px`) and clear typographic hierarchy (title, section label, body, muted caption).
- [ ] **U7.4 Consistent Minimalist Vector Iconography:** Uses one coherent stroke-weight SVG icon family (`currentColor` inheritance) rather than mixing raw emojis, ASCII, and bitmaps.
- [ ] **U7.5 Z-Index & Overflow Discipline:** Enforces a strict elevation ladder (`base 0 -> sticky 10 -> floating 20 -> popover/menu 40 -> dialog 50 -> toast 60`) with zero clipped popovers or horizontal overflow.

### Module U8: Interactive Polish, Motion & Feedback

- [ ] **U8.1 Purposeful Micro-Animations:** Keeps transitions crisp and fast (`120ms–220ms`, `cubic-bezier(0.2, 0.8, 0.2, 1)`).
- [ ] **U8.2 Reduced-Motion Compliance:** Honors `prefers-reduced-motion: reduce` (or OS equivalent) with instant state transitions.
- [ ] **U8.3 Actionable Feedback (Toasts / Snackbars):** Confirms mutations or explains errors in plain language, pairing deletions/batch edits with **Undo** or preview.
- [ ] **U8.4 Loading & Async States:** Operations exceeding `~200 ms` render skeleton loaders, inline spinners, or busy-disabled buttons—never a frozen UI.
- [ ] **U8.5 Progressive Disclosure (Show/Hide Toggles):** Folds advanced filters, secondary metadata, and power-user options behind labeled Show/Hide toggles (persisting state where helpful).
- [ ] **U8.6 Search, Filter & Sort Consistency:** Lists/grids exceeding ~8 items offer instant search, filter chips with active count + one-click reset, and clear sort indicators.

### Module U9: Safety Guardrails, Keyboard & Accessibility (a11y)

- [ ] **U9.1 Keyboard-First Ergonomics:** Supports `Tab`/`Shift+Tab`, `Arrow` navigation in lists/menus, `Enter`/`Space` activation, `Esc` overlay dismissal (with focus restoration), and `/` or `Ctrl+F` search focus.
- [ ] **U9.2 Visible Keyboard Focus Rings:** Shows high-contrast `:focus-visible` rings on all interactive elements without noisy pointer-click rings.
- [ ] **U9.3 Semantic Controls & Assistive Labels:** Uses native interactive tags (`<button>`, `<input>`, `<select>`), associated `<label>`/`aria-label` attributes, `aria-expanded`/`aria-selected` states, and `aria-live` regions.
- [ ] **U9.4 Destructive-Action Guardrails:** Guards delete, reset, unlink, or overwrite actions with a themed Confirmation Dialog (naming exact target and impact) or reversible Preview + Undo—never raw blocking `alert()`/`confirm()`.
- [ ] **U9.5 Responsive & Touch Adaptation:** Maintains `>= 44x44 px` touch targets and avoids hover-only critical actions.

### Module U10: Documentation, Test & Agent Guardrail Parity

- [ ] **U10.1 `README.md` UI Surface Inventory:** Documents shipped launch controls, views, dialogs, commands, status indicators, context menus, and settings accurately.
- [ ] **U10.2 Interconnected Living Docs (`PRODUCT.md` <-> `ARCHITECTURE.md`):** Keeps `[FEATURE]` items (`Links:` + `Verified By:` UI/E2E or smoke tests) synchronized with `[FLOW]` Mermaid diagrams and `Code Anchors` (`path/to/file.ext :: symbolName`).
- [ ] **U10.3 Agent Guardrails (`AGENTS.md` & `DECISIONS_AND_TRAPS.md`):** Captures UI invariants (`[TRAP]`) and intentional surface waivers (`[DECISION]`) so future sessions never regress parity.

---

## Part 3: Lateral & Ideal UI/UX Additions

Seven high-leverage cross-platform patterns to consider during Path B planning or Phase 4 upgrades:

1. **Unified Action Registry:** Define each action once (ID, verb-first label, icon, shortcut, visibility predicate, handler) and bind launch chrome, command palette, toolbars, and context menus from one source of truth.
2. **Empty / Loading / Error State Triad:** Implement all three non-happy states on every dynamic view with direct recovery (`Create first item`, `Skeleton`, `Retry + Copy error details`).
3. **Plan -> Preview -> Commit Safety Flow:** Show a concise diff/preview dialog before bulk edits, migrations, or layout mutations, paired with Undo.
4. **Density Mode Toggle (Comfortable vs. Compact):** Offer a single density switch tightening row/card padding by ~25% for power users and narrow panes.
5. **In-View Keyboard Cheat-Sheet (`?` Overlay):** Open a minimal shortcut legend on `?` so keyboard ergonomics are self-discoverable.
6. **Shared Baseline Token & Accessibility Layer:** Reuse a compact base stylesheet enforcing reduced-motion rules, `:focus-visible` rings, and semantic surface/text/border tokens across projects.
7. **Feasibility-Gated Parity (Anti-Bloat Guard):** Explicitly record `N/A — Conflicting` and `N/A — Cumbersome` waivers in `docs/DECISIONS_AND_TRAPS.md` so parity never bloats a focused tool.
