# Modular Codebase Audit Framework (`audits.md`)

A modular, agent-ready instruction set for performing thorough, candid audits of any codebase (apps, plugins, extensions, CLIs, or libraries). Each module can be run **individually**, **in selected combinations** (e.g., *"Audit this repo using `audits.md` Modules 1, 2, and 7"*), or **sequentially phase-by-phase** so the auditing agent maintains full depth without skipping details.

## How to Invoke This Framework

Use one of the following invocation patterns when handing this file to an AI coding agent:

* **Single-Module Deep Dive:** `"Audit this codebase using Module 2 of audits.md."`
* **Targeted Subset:** `"Audit this codebase using Modules 1, 4, 7, and 14 of audits.md."`
* **Phased Full Audit (Recommended for Large Repos):** `"Run audits.md sequentially in batches: Phase A (Modules 1–5), Phase B (Modules 6–9), Phase C (Modules 10–14), then Module 15 for the handoff plan."`
* **Full Single-Pass Audit (Small Repos Only):** `"Audit this codebase using all modules in audits.md."`

## Quick-Reference Module Index

| Module | Scope | Primary Focus |
| :--- | :--- | :--- |
| **Module 1** | Bugs, Concurrency & State | Logic bugs, edge cases, race conditions, state/logic overlaps |
| **Module 2** | Security, Isolation & Encryption | Attack surfaces, Cloudflare 6-phase verification, crypto, sandboxing, segmentation |
| **Module 3** | Performance & Memory Leaks | Event/listener leaks, render thrash, unbounded caches, I/O bottlenecks |
| **Module 4** | Data Integrity, Migrations & Backups | Atomic writes, schema migrations, round-trip fidelity, crash recovery |
| **Module 5** | Privacy, Offline-First & Network Hygiene | Hidden outbound calls, local-first resilience, log/API data-leak prevention |
| **Module 6** | Parity, Dead Code & Cross-Refs | Doc vs. code parity, stubs, stale functions, broken internal links/settings |
| **Module 7** | UI/UX, Layout & Design Systems | Overflow/z-index, contrast inversion, Minimalist/M3/Glassmorphism, SVG icons, show/hide toggles |
| **Module 8** | Accessibility & Keyboard Ergonomics | Full keyboard operability, focus traps, ARIA roles, reduced motion, OS high-contrast |
| **Module 9** | Testability, Logging & Diagnostics | Critical-path test coverage, structured logs, debug/diagnostic export modes |
| **Module 10** | Simplification & Pruning | Logic/function/architecture simplification, deduplication, merging, modularization |
| **Module 11** | Architecture & Robustness | Structural decisions, resilience, error boundaries, plugin-to-app readiness |
| **Module 12** | Automation & Agent Readiness | Headless core decoupling, CLI flags, JSON output, URI schemes, local API/MCP hooks |
| **Module 13** | OSS Reuse & External Ecosystem | Libraries to adopt/fork, sibling plugins/apps to harvest, dedicated OSS app alternatives |
| **Module 14** | Lateral Features & Ecosystem | Companion features, QoL upgrades, automatic "Ecosystem Ripple" completion |
| **Module 15** | Agent Handoff & Phased Plan | Non-conflicting execution phases, dependency ordering, verification checklist |

## Global Operating Rules (Apply to Every Module)

1. **Inspect Actual Implementation Only:** Read the live source code, build configs, manifests, stylesheets, and tests. Never assume READMEs, comments, or specs are accurate.
2. **Mandatory Coverage Ledger:** At the top of every audit report, include a concise **Coverage Ledger** listing: (a) every file/directory actually inspected, (b) files intentionally skipped (e.g., vendor/lockfiles/minified bundles), and (c) any areas that could not be inspected. Do not skim only entry points when running multiple modules.
3. **Adversarial Verification & Priority-vs-Certainty Separation** (adapted from [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill)):
   * Attempt to **disprove** every candidate finding against the actual code path before reporting it.
   * Label every finding as either `confirmed` (proven by a complete, traceable code path) or `needs_validation` (a specific, source-grounded boundary hypothesis blocked by runtime/environment state).
   * Assign severity (`Critical`, `High`, `Medium`, `Low`, `Informational`) **only** to `confirmed` findings. `needs_validation` items receive no severity and must state the exact runtime condition or header/config to check.
4. **Zero Filler:** Skip praise, generic best-practice lectures, and vague advice. Every item must be specific, code-grounded, and ruthlessly practical.
5. **Mandatory Output Format:**
   * Generate clean, downloadable Markdown report(s) named after the repository: `<repo-name>-audit.md`, or split logically when large (e.g., `<repo-name>-audit-core-security-data.md`, `<repo-name>-audit-ui-a11y-testing.md`, `<repo-name>-audit-architecture-oss-lateral.md`).
   * Use this exact structure for every finding:
     * **ID & Module:** e.g., `[M1-01]`
     * **Status:** `confirmed` | `needs_validation`
     * **Severity / Impact:** `Critical` | `High` | `Medium` | `Low` | `Informational` (or `N/A — needs_validation`)
     * **Exact File Paths & Symbols:** `path/to/file.ext :: ClassName.methodName (L12–L48)`
     * **Root Cause / Rationale:** Concise technical explanation grounded in the actual code.
     * **Concrete Actionable Fix or Spec:** Exact patch specification, refactored contract, or replacement library/architecture.

## Module 1: Bugs, Edge Cases, Concurrency & State Overlaps

Audit the runtime correctness, control flow, and state integrity of the codebase.

* **Logic Bugs & Silent Failures:** Catch swallowed exceptions, inverted conditionals, off-by-one errors, incorrect null/undefined coercion, timezone/locale assumptions, and broken retry/fallback logic.
* **Edge Cases & Boundary Conditions:** Test empty inputs, massive inputs, malformed UTF-8/Unicode, special characters in file paths, offline/disconnected states, cold-start vs. warm-start state, and missing permissions.
* **Concurrency & Race Conditions:**
  * Async out-of-order resolution (stale responses overwriting newer state; missing `AbortController` or request sequence IDs).
  * Concurrent file/DB writes, lock contention, and TOCTOU (time-of-check to time-of-use) races.
  * Re-entrant event handlers, double-submit/double-trigger bugs, and unguarded timers/intervals.
* **State & Logic Overlaps:**
  * Duplicate sources of truth (e.g., UI state, local storage, and backend/file state drifting out of sync).
  * Competing listeners, observers, or CSS/DOM mutators fighting over the same element or state key.
  * Overlapping keyboard shortcuts, command IDs, or event bus namespaces.

## Module 2: Security, Isolation, Encryption & Attack Surfaces

Apply a structured multi-phase security audit modeled on Cloudflare's [security-audit-skill](https://github.com/cloudflare/security-audit-skill) ([SKILL.md](https://github.com/cloudflare/security-audit-skill/blob/main/skills/security-audit/SKILL.md), [ATTACK-CLASSES.md](https://github.com/cloudflare/security-audit-skill/blob/main/skills/security-audit/ATTACK-CLASSES.md), and [CLIENT-SIDE.md](https://github.com/cloudflare/security-audit-skill/blob/main/skills/security-audit/CLIENT-SIDE.md)).

### 2.1 Audit Workflow (Cloudflare 6-Phase Adaptation)

1. **Reconnaissance:** Map architecture, trust boundaries, privilege levels, external input surfaces, and sensitive data stores before hunting.
2. **Coverage-Led Hunting:** Systematically sweep every entry point (IPC, HTTP, CLI args, file parsers, DOM sinks, extension messages, plugin hooks) rather than spot-checking.
3. **Adversarial Validation:** For each candidate vulnerability, prove both the attacker-controlled source and the reachable sink/impact; reject theoretical issues blocked by existing framework escaping, CSP, or OS controls.
4. **Severity Calibration:**
   * `Critical`: Unauthenticated RCE, full data-store compromise, or arbitrary account takeover.
   * `High`: Auth/sandbox bypass, cross-tenant read/write, stored XSS affecting other users, or authenticated RCE.
   * `Medium`: Boundary violation with constrained blast radius or narrow preconditions.
   * `Low`: Non-secret internal disclosure or minimal-gain flaw.
   * `Informational`: Confirmed prerequisite or hardening gap.

### 2.2 Attack Surface Checklist

* **Encryption, Cryptography & Secrets:**
  * Weak or deprecated primitives (MD5, SHA-1, DES, RC4, ECB mode), predictable randomness (`Math.random()` for tokens/IDs), nonce/IV reuse, or hardcoded keys/salts.
  * Improper secret storage (plaintext API keys/tokens in localStorage, unencrypted config files, logs, or committed files missing from `.gitignore`).
  * Missing encryption at rest or in transit (disabled TLS certificate validation, insecure HTTP fallbacks, weak JWT verification such as `alg=none` or algorithm confusion).
* **Isolation, Sandboxing & Segmentation:**
  * Insufficient privilege separation (e.g., Electron `nodeIntegration: true` / `contextIsolation: false`, overly broad browser extension host permissions, unscoped `iframe` embeds lacking `sandbox` attributes).
  * Missing tenant, profile, workspace, or plugin segmentation (shared caches, global mutable state, or cross-context storage leakage).
  * Subprocess and shell execution risks (command injection via unescaped arguments, `shell: true`, or unsafe `eval`/`Function` execution).
* **File System, Network & Deserialization ([ATTACK-CLASSES.md](https://github.com/cloudflare/security-audit-skill/blob/main/skills/security-audit/ATTACK-CLASSES.md)):**
  * Path traversal (symlinks, encoded sequences, null bytes), zip slip on archive extraction, insecure temp file creation, and TOCTOU file races.
  * SSRF (redirects, DNS rebinding, URL parser differentials) and unsafe deserialization (`pickle`, `yaml.load`, arbitrary JSON revivers).
* **Client-Side, DOM & Messaging ([CLIENT-SIDE.md](https://github.com/cloudflare/security-audit-skill/blob/main/skills/security-audit/CLIENT-SIDE.md)):**
  * DOM-based XSS (`innerHTML`, `outerHTML`, `document.write`, unsafe framework escape hatches), DOM clobbering, and prototype pollution paired with a reachable gadget.
  * `postMessage` handlers missing exact origin allowlists and `event.source` checks, or sending sensitive payloads to `*`.
  * Cross-site WebSocket hijacking (missing `Origin` check or channel token), credentialed CORS reflection, and missing/permissive CSP, `SameSite`, or COOP/CORP headers.
* **Supply Chain & Dependencies:** Outdated dependencies with known CVEs, unpinned remote scripts/CDNs, and excessive third-party permissions.

## Module 3: Performance, Memory Leaks & Resource Lifecycle

Identify runtime bottlenecks, memory growth, and improper cleanup across long-running sessions.

* **Memory Leaks & Lifecycle Cleanup:**
  * Unremoved event listeners (`addEventListener`, IPC listeners, WebSocket/EventSource hooks, plugin register callbacks), dangling `setInterval`/`setTimeout`, or undisposed `MutationObserver`/`ResizeObserver`/`IntersectionObserver`.
  * Unbounded in-memory caches, Maps/Sets holding detached DOM nodes or large buffers, and missing `WeakMap`/`WeakRef` or LRU eviction.
  * Unclosed file handles, database cursors, streams, Web Workers, GPU/WebGL/Canvas contexts, or child processes on unload/reload.
* **Rendering & UI Responsiveness:**
  * Layout thrashing (interleaved DOM reads/writes), excessive re-renders, unvirtualized long lists/tables, unthrottled scroll/resize/input handlers, and main-thread blocking JSON/Markdown/regex work.
* **I/O, Storage & Startup Cost:**
  * Redundant disk reads/writes, synchronous blocking I/O on the UI thread, N+1 queries, unbatched state writes, and heavy eager imports that should be lazy-loaded.

## Module 4: Data Integrity, Migrations & Backup Safety

Ensure user data, settings, and databases survive crashes, upgrades, and format transitions without silent corruption or loss.

* **Atomic Writes & Crash Safety:** Flag direct in-place overwrites of JSON, YAML, Markdown, or config files without write-to-temp-then-rename semantics, file locking, or SQLite WAL/transaction boundaries.
* **Schema Versioning & Migrations:** Check whether stored data/configs carry an explicit schema version, handle missing/renamed/deprecated fields gracefully, and run idempotent forward migrations (with safe fallback on downgrade or malformed files).
* **Backup, Rollback & Recovery:** Verify whether destructive operations or upgrades create rolling backups, detect corrupted/truncated files cleanly, and offer a clear recovery path instead of silently resetting user data to defaults.
* **Import/Export Round-Trip Fidelity:** Audit whether exporting and re-importing data preserves all metadata, IDs, relationships, timestamps, and Unicode/escaping without truncation or drift.

## Module 5: Privacy, Offline-First & Network Hygiene

Verify that the app respects user privacy, avoids hidden external calls, and remains usable without an active internet connection.

* **Hidden Outbound Requests & Telemetry:** Inventory every network call (`fetch`, `XMLHttpRequest`, WebSocket, update checks, analytics, third-party fonts/CDNs/icons). Flag any undisclosed, unconsented, or unnecessary external request.
* **Sensitive Data Leakage:** Check that local file paths, vault/document contents, clipboard history, API keys, and personal identifiers are never leaked into crash logs, debug dumps, browser referrers, URL query params, or unredacted LLM/API prompts.
* **Offline-First Resilience:** Identify hard runtime dependencies on remote CDNs, online fonts, or remote APIs that break core functionality offline. Verify local caching, clean offline detection, request queuing/retry with backoff, and non-blocking degradation.
* **Network Hygiene:** Check for missing request timeouts, unbounded retries, missing rate-limit handling, and improper proxy/local-loopback (`127.0.0.1` vs `0.0.0.0`) binding that accidentally exposes local services on the LAN.

## Module 6: Feature & Documentation Parity, Dead Code & Cross-References

Verify that what is promised, configured, and wired actually works end-to-end.

* **Doc-to-Code Parity:** Audit every feature, CLI flag, keyboard shortcut, setting, and API mentioned in READMEs, changelogs, help modals, and tooltips against the implementation. Flag broken flows, missing handlers, or undocumented behavior.
* **Stale Code, Dead Functions & Feature Husks:**
  * Unused exports, unreachable branches, orphaned CSS rules, abandoned migrations, leftover debug code, and half-built stubs or TODO husks that either need completion or outright deletion.
* **Cross-Reference & Internal Linking Integrity:**
  * Verify every setting, toggle, command, menu item, and hotkey is properly wired to its consuming function (no "ghost settings" that save to config but are never read).
  * Check bidirectional cross-references: deep links between settings, documentation/help tooltips, related views, and companion commands resolve cleanly with zero broken IDs or dead routes.

## Module 7: UI/UX, Overflow/Z-Index, Theme Parity & Design Systems

Audit visual polish, layout resilience, and modern interface consistency.

* **Overflow, Clipping & Z-Index Stacking:**
  * Text/content overflowing containers, clipped modals/dropdowns/tooltips inside `overflow: hidden` ancestors, horizontal scrollbars on narrow viewports, and competing `z-index` stacking contexts (popovers buried under sticky headers, sidebars, or portals).
* **Theme Parity & Contrast Inversion:**
  * Light/dark mode mismatches, hardcoded hex/RGB colors ignoring CSS variables, unreadable text/icon contrast (below WCAG AA 4.5:1 for body text / 3:1 for UI components), broken selection/focus highlights, and inverted images/SVGs/charts that become invisible on dark or light surfaces.
* **Design System Consistency (Minimalist / Material 3 / Glassmorphism):**
  * Check whether all panels, modals, settings rows, buttons, badges, and inputs adhere to a unified design system (e.g., clean Minimalist, Material 3 elevation/tonal surfaces/shape tokens, or restrained Glassmorphism with legible backdrop blur and borders) instead of mixing ad-hoc styles.
  * Flag inconsistent spacing scales, border radii, typography hierarchy, and button affordances.
* **Progressive Disclosure & Show/Hide Toggles:**
  * Identify dense toolbars, cluttered settings pages, or secondary controls that need clean **Show/Hide (collapse/expand)** toggle buttons, collapsible sections, or "Advanced Options" drawers—with persisted toggle state where helpful.
* **Minimalist SVG Iconography:**
  * Flag raw emojis, inconsistent icon packs, blurry raster icons, or missing icons in buttons/menus/tabs.
  * Recommend crisp, unified minimalist SVG icons (consistent stroke width, `viewBox`, `currentColor` inheritance for automatic theme adaptation, and `aria-label` / tooltips).
* **Rough UX States & Responsiveness:**
  * Missing loading/skeleton states, unhelpful raw error dumps, blank empty states, destructive actions without confirmation/undo, and cramped mobile/narrow-pane layouts.

## Module 8: Accessibility (a11y) & Keyboard-First Ergonomics

Ensure every workflow is fast, predictable, and operable without a mouse or visual guesswork.

* **Full Keyboard Operability:** Verify every interactive control (buttons, tabs, dropdowns, custom toggles, list rows, modals) is reachable via `Tab`/arrow keys, uses visible `:focus-visible` rings, supports `Enter`/`Space` activation and `Escape` dismissal, and traps focus properly inside open dialogs (restoring focus to the trigger on close).
* **Semantic Markup & ARIA:** Flag clickable `<div>`/`<span>` elements that should be native `<button>`/`<a>` tags, icon-only buttons missing `aria-label`, form inputs lacking associated `<label>` elements, and dynamic status updates/toasts missing `aria-live` regions.
* **Motion, Contrast & OS Preferences:** Check compliance with `prefers-reduced-motion` (disabling heavy transitions/animations), OS high-contrast / forced-colors modes, scalable font sizes (`rem`/`em` instead of locked tiny `px`), and never relying on color alone to convey status or errors.

## Module 9: Testability, Logging & Diagnostics

Assess how easily bugs can be caught before release and diagnosed when they happen in the wild.

* **Critical-Path Test Coverage:** Identify high-risk business logic, parsers, state transitions, migrations, and security boundaries that lack automated unit or integration tests. Flag brittle tests tied to implementation details or over-mocked paths that pass while real behavior is broken.
* **Structured Logging & Error Context:** Audit error handling for silent catches, generic `"Something went wrong"` messages, or noisy `console.log` spam. Recommend structured, leveled logging (debug/info/warn/error) with actionable context (operation name, relevant IDs, sanitized inputs).
* **Diagnostics & Reproducibility:** Check whether the app provides a clean debug toggle, health/status check, or "Copy Diagnostic Info" action (app version, OS/host version, redacted config, recent error log) so issues can be reproduced quickly.

## Module 10: Simplification, Deduplication, Modularization & Pruning

Aggressively reduce complexity without losing real capability.

* **Logic & Function Simplification:** Flag deeply nested conditionals, god functions, convoluted state machines, and repetitive boilerplate that can be flattened with guard clauses, lookup tables, or pure helper functions.
* **Deduplication & Merging:** Identify copy-pasted utilities, duplicate API/storage wrappers, overlapping UI components, and redundant config schemas that should be merged into a single canonical implementation.
* **Modularization & Separation of Concerns:** Split monolithic files that mix UI rendering, business logic, persistence, and transport into clean, testable modules with explicit interfaces.
* **Architectural Simplification & Pruning:** Flag over-engineered abstractions (unnecessary indirection, premature factories/event buses) and low-impact feature creep or bloat that adds maintenance burden and should be removed outright.

## Module 11: Architectural Decisions & Structural Robustness

Evaluate macro-level design choices that limit reliability, extensibility, or maintainability.

* **Key Architectural Decisions:** Identify foundational bottlenecks (e.g., storage format limits, coupling to host-app internals, synchronous vs. event-driven pipelines, local-first vs. client-server boundaries) and propose concrete architectural upgrades with trade-offs.
* **Structural Robustness & Resilience:**
  * Fault isolation (error boundaries, graceful degradation when optional services/plugins are absent).
  * Clear dependency boundaries so failures in one feature module cannot crash the entire app or host environment.
* **Standalone / Dedicated App Readiness:** When auditing a plugin, script, or extension that has outgrown its host environment, evaluate what decoupling is required (core logic extraction, IPC/CLI/API bridge, standalone UI shell) to promote it into a robust dedicated app or shared library.

## Module 12: Automation & Agent Readiness (CLI, API, URI & MCP)

Evaluate whether the app's core capabilities can be driven reliably by scripts, external workflows, and AI coding agents rather than being trapped behind GUI clicks.

* **Headless Core Decoupling:** Identify core business logic tightly coupled to DOM events, modals, or UI state that should be extracted into pure, UI-agnostic service/command functions.
* **Scriptable Entry Points:** Audit or spec clean automation surfaces—CLI flags with deterministic exit codes, machine-readable `--json` output, custom URI schemes (e.g., `app://action?param=...`), local HTTP/IPC endpoints, or an MCP (Model Context Protocol) tool interface.
* **Idempotency & Safety Guardrails:** Check that automated/agent-callable operations support `--dry-run` or preview modes, clear input validation schemas, idempotent re-execution, and explicit confirmation boundaries for destructive actions.

## Module 13: External Leverage, OSS Reuse & Dedicated App / Plugin Ecosystem

Prevent reinventing the wheel by systematically evaluating external open-source leverage.

* **Battle-Tested Libraries to Integrate:** Recommend mature, actively maintained open-source or source-available libraries (checking license compatibility, bundle size, and maintenance health) that can replace fragile hand-rolled code (e.g., parsing, state, virtual lists, rich editors, crypto, diffing, schema validation, icon sets).
* **Feature Harvesting from Existing Plugins & Apps:** Identify comparable open-source plugins, extensions, or apps in the same domain whose proven patterns, algorithms, UI workflows, or modules can be borrowed, adapted, or forked to strengthen this codebase.
* **Dedicated Open-Source App Alternatives (Build vs. Adopt vs. Bridge):**
  * Candidly flag cases where a dedicated open-source app already solves the problem far more robustly than a custom plugin or wrapper.
  * Recommend whether to: (a) **Replace** a weak custom module with the dedicated app, (b) **Link/Bridge** with the external app via CLI, URI scheme, local API/MCP, or shared file format, or (c) **Merge** overlapping custom tools into one cohesive app.

## Module 14: Lateral Features, QoL Upgrades & Full Feature Ecosystem

Go beyond fixing bugs to make every existing feature feel complete, cohesive, and effortless to use.

* **High-Impact QoL Upgrades:** Suggest friction-reducing improvements inspired by best-in-class comparable apps (command palette/quick-switcher, undo/redo history, drag-and-drop, keyboard-first navigation, instant search/filter, import/export, preset profiles, sensible defaults).
* **Lateral ("Companion") Features:** For every core feature in the codebase, identify the missing natural counterpart that users expect right next to it (e.g., export without import, create without duplicate/template, filter without saved presets, bulk select without bulk actions).
* **Full Ecosystem Ripple Analysis (Automatic Completeness Check):** Whenever a domain feature exists—or is proposed—audit and spec its **entire supporting ecosystem** rather than treating it in isolation. Use these patterns as a baseline:

| Core Feature Present | Required Ecosystem Ripple Checks |
| :--- | :--- |
| **Theming / Styling** | Light/Dark/System auto-switching; contrast inversion fixes (text, borders, SVGs, charts); coherent design presets (Minimalist, Material 3, Glassmorphism); strict CSS scoping so themes never leak, overlap, or overflow containers. |
| **Settings / Options** | Live preview or instant apply; reset-to-defaults; search/filter settings; Show/Hide toggle for advanced options; import/export config; cross-links to affected views/commands. |
| **Data Views / Lists** | Sort, filter, search, empty/loading states, virtualization for large sets, keyboard navigation, copy/export actions, and responsive overflow handling. |
| **Editor / Content Creation** | Undo/redo, autosave + dirty-state warning, keyboard shortcuts, format/preview toggle, and safe recovery on crash. |
| **External Integrations / Sync** | Connection health status, offline queue/retry with backoff, rate-limit handling, clear error surfacing, and manual force-sync trigger. |

## Module 15: Agent Handoff Packaging & Phased Execution Plan

*(Optional closing module—run after completing the selected audit modules to produce an execution-ready roadmap.)*

* **Deduplicate & Cross-Link Findings:** Merge overlapping issues discovered across modules (e.g., a race condition in Module 1 that also causes data corruption in Module 4) into a single canonical fix item.
* **Dependency-Ordered Execution Phases:** Group all fixes and upgrades into small, non-conflicting implementation phases suitable for an AI coding agent:
  * **Phase 1 — Stability, Security & Data Safety:** Critical/High bugs, concurrency races, security/isolation flaws, memory leaks, atomic writes, and privacy/network leaks.
  * **Phase 2 — Parity, Testing, Cleanup & Architecture:** Dead code pruning, deduplication, broken cross-references, core regression tests/diagnostics, and structural refactors (done *before* UI/feature work to avoid churn).
  * **Phase 3 — UI/UX, Design Systems & Accessibility:** Overflow/z-index fixes, theme/contrast parity, Material 3/Glassmorphism/Minimalist alignment, SVG icons, Show/Hide toggles, and keyboard/ARIA fixes.
  * **Phase 4 — Automation, OSS Leverage & Lateral Ecosystem:** CLI/API/MCP automation hooks, library swaps, external app bridges, QoL upgrades, and lateral companion features.
* **Verification Checklist:** Provide concrete commands, manual test scenarios, offline/theme/keyboard checks, and regression tests the coding agent must pass after each phase.
