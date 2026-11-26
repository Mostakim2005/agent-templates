---
name: uiux-audit
description: >-
  Audits interactive desktop, web, mobile, or extension interfaces against the platform-agnostic
  U1-U10 UI/UX Parity Framework and 3-Gate Feasibility Rubric (UIUX.md), scoring surfaces as
  Present, Partial, Missing (Required), N/A - Conflicting, or N/A - Cumbersome and saving
  git-patch-ready reports to Downloads. Use whenever the user asks for a UI/UX review, design-system
  or theme/contrast parity check, ergonomic/accessibility surface audit, or UIUX.md run.
---

# Platform-Agnostic UI/UX Parity Audit Skill (`uiux-audit`)

Thin progressive-disclosure skill wrapper for `%USERPROFILE%\.agent-templates\UIUX.md` (`~/.agent-templates/UIUX.md`).

## Module Index (Slice Only What You Need)

| Module | Surface / Capability Scope |
| :--- | :--- |
| **Part 1** | Execution Protocol, 5-State Verdict Taxonomy (`Present` / `Partial` / `Missing` / `N/A — Conflicting` / `N/A — Cumbersome`), & 3-Gate Feasibility Rubric |
| **Module U1** | Primary Entry Points & Launch Surfaces (rail/tray/FAB, active sync, command registry, deep-links) |
| **Module U2** | Persistent & Workspace Views (single-instance deduplication, pinning/dirty guards, compact/wide layouts) |
| **Module U3** | Transient & Contextual Surfaces (modals/sheets, context menus + `⋮` overflow, fuzzy quick-picker, tooltips) |
| **Module U4** | Ambient Telemetry & Status Surfaces (glanceable status, click-to-act, shape+icon+color encoding) |
| **Module U5** | Configuration & Discoverability (Settings grouping, plain descriptions, reset/import/export, empty states) |
| **Module U6** | Inline & Embedded Content Surfaces (cards/widgets, floating selection toolbars, quick-look preview) |
| **Module U7** | Visual Design System & Theming (zero raw color leaks, WCAG AA `>= 4.5:1` Light/Dark parity, SVG icons, z-index ladder) |
| **Module U8** | Interactive Polish, Motion & Feedback (`120–220ms` transitions, reduced-motion, undo toasts, skeletons, Show/Hide toggles) |
| **Module U9** | Safety Guardrails, Keyboard & Accessibility (`Tab`/arrow/`Esc` focus rings, native ARIA controls, themed destructive dialogs, `44x44px` touch) |
| **Module U10** | Documentation, Test & Guardrail Parity (`README.md` inventory, `PRODUCT.md` <-> `ARCHITECTURE.md` `Links:`/`Verified By:`, `[TRAP]`/`[DECISION]` waivers) |
| **Part 3** | Lateral & Ideal UI/UX Additions (Unified Action Registry, Empty/Loading/Error Triad, Plan->Preview->Commit, Density Toggle, `?` Cheat-Sheet) |

## Execution Procedure

1. **Load Only Requested Sections (Save Context):**
   - Compute live line offsets dynamically in `%USERPROFILE%\.agent-templates\UIUX.md`:
     `grep -n "^##\|^### Module U" "%USERPROFILE%\.agent-templates\UIUX.md"` (or PowerShell `Select-String -Pattern '^##|^### Module U' "$env:USERPROFILE\.agent-templates\UIUX.md"`).
   - Read `## Part 1` plus **only** the requested `Module U*` / `Part 3` line slices (`StartLine`–`EndLine`), or read the full file when running a complete U1–U10 audit.
2. **Detect Platform & Respect Recorded Waivers:**
   - Identify the repo's native UI host first (desktop/tray, web, mobile, extension) so primitives map idiomatically.
   - Run `grep -n -A 1 "^### \[" docs/` in the target repo and read matching `[DECISION]` and `[TRAP]` slices so previously waived chrome (`N/A — Cumbersome`, `N/A — Conflicting`) is respected rather than re-flagged.
3. **Evaluate Against the 3-Gate Feasibility Rubric:**
   - Score every checked item through the **Frequency Gate**, **Cognitive Load Gate**, and **Viewport & Ergonomics Gate** from live source code/CSS.
4. **Patch-Ready Output (`Downloads\` Only):**
   - Save directly to `%USERPROFILE%\Downloads\<Repo Title Case> - UIUX Audit.md` (or scoped variant; never leave inside the repo).
   - Include: Metadata Header, Coverage Ledger Table with `path/to/file.ext :: symbolName` anchors, Systemic Design Gaps, and the unified `Phase 1–4` Execution Plan (aligned with `code-audit`).
5. **Post-Audit Closure Loop (When Implementing Fixes):**
   - Log accepted `N/A — Conflicting` / `N/A — Cumbersome` waivers as `[DECISION]` in `docs/DECISIONS_AND_TRAPS.md`, subtle CSS/focus traps as `[TRAP]` (+ 1-line pointer in root `AGENTS.md`), UI verification in `docs/PRODUCT.md` (`Verified By:`), and deferred Part 3 ideas as `[WISHLIST]`.
