# Modular Codebase Audit Framework (`AUDITS.md`)

A modular, agent-ready instruction set for performing thorough, candid audits of any codebase (apps, plugins, extensions, CLIs, or libraries). Each module can be run **individually**, **in selected combinations** (e.g., *"Audit this repo using `AUDITS.md` Modules 1, 2, and 7"*), or **sequentially phase-by-phase** alongside `UIUX.md` without losing depth.

## How to Invoke This Framework

* **Single-Module Deep Dive:** `"Audit this codebase using Module 2 of AUDITS.md."`
* **Targeted Subset:** `"Audit this codebase using Modules 1, 4, 7, and 14 of AUDITS.md."`
* **Phased Full Audit (Recommended for Large Repos):** `"Run AUDITS.md sequentially in batches: Phase A (Modules 1–5), Phase B (Modules 6–9), Phase C (Modules 10–14), then Module 15 for the handoff plan."`
* **Full Single-Pass Audit (Small Repos Only):** `"Audit this codebase using all modules in AUDITS.md."`

## Quick-Reference Module Index

| Module | Scope | Primary Focus |
| :--- | :--- | :--- |
| **Module 1** | Bugs, Concurrency & State | Logic bugs, edge cases, race conditions, state/logic overlaps |
| **Module 2** | Security, Isolation & Encryption | Attack surfaces, Cloudflare 6-phase verification, crypto, sandboxing, segmentation |
| **Module 3** | Performance & Memory Leaks | Event/listener leaks, render thrash, unbounded caches, I/O bottlenecks |
| **Module 4** | Data Integrity, Migrations & Backups | Atomic writes, schema migrations, round-trip fidelity, crash recovery |
| **Module 5** | Privacy, Offline-First & Network Hygiene | Hidden outbound calls, local-first resilience, log/API data-leak prevention |
| **Module 6** | Parity, Dead Code & Cross-Refs | Doc/anchor/test parity (`Links:` + `Verified By:`), stubs, stale code, ghost settings |
| **Module 7** | UI Layout Bugs & Contrast Defects | Overflow/z-index clipping, non-token color leaks, Light/Dark contrast inversions *(full UI parity -> `UIUX.md`)* |
| **Module 8** | Code-Level Accessibility Defects | Broken keyboard reachability, missing focus traps/rings, non-semantic tags, missing ARIA *(ergonomic parity -> `UIUX.md`)* |
| **Module 9** | Testability, Logging & Diagnostics | Critical-path test coverage, structured logs, debug/diagnostic export modes |
| **Module 10** | Simplification & Pruning | Logic/function/architecture simplification, deduplication, merging, modularization |
| **Module 11** | Architecture & Robustness | Structural decisions, resilience, error boundaries, plugin-to-app readiness |
| **Module 12** | Automation & Agent Readiness | Headless core decoupling, CLI flags, JSON output, URI schemes, local API/MCP hooks |
| **Module 13** | OSS Reuse & External Ecosystem | Libraries to adopt/fork, sibling plugins/apps to harvest, dedicated OSS app alternatives |
| **Module 14** | Lateral Features & Ecosystem | Companion features, QoL upgrades, automatic "Ecosystem Ripple" completion |
| **Module 15** | Agent Handoff & Closure Loop | Unified `Phase 1–4` execution plan, verification checklist, and living-doc/test closure routing |

## Global Operating Rules (Apply to Every Module)

1. **Inspect Actual Implementation Only:** Read live source code, build configs, manifests, stylesheets, and tests. Never assume READMEs, comments, or specs are accurate.
2. **Pre-Audit Decision & Waiver Scan (Respect Recorded Choices):** Before hunting for missing features, UI surfaces, or OSS replacements, run `grep -A 1 "^### \[" docs/` and inspect relevant `[DECISION]`, `[TRAP]`, and `[WISHLIST]` items in `docs/DECISIONS_AND_TRAPS.md` and `docs/PRODUCT.md`. Honor `[TRAP]` invariants and previously recorded waivers (`N/A — Cumbersome`, `N/A — Conflicting`, rejected library swaps) instead of re-flagging them unless the live code violates the stated contract.
3. **Mandatory Coverage Ledger:** At the top of every audit report, include a concise **Coverage Ledger** listing: (a) every file/directory inspected, (b) files intentionally skipped (vendor/lockfiles/minified bundles), and (c) any areas that could not be inspected.
4. **Adversarial Verification & Priority-vs-Certainty Separation** (adapted from [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill)):
   * Attempt to **disprove** every candidate finding against the actual code path before reporting it.
   * Label every finding as either `confirmed` (proven by a complete, traceable code path) or `needs_validation` (a specific, source-grounded boundary hypothesis blocked by runtime/environment state).
   * Assign severity (`Critical`, `High`, `Medium`, `Low`, `Informational`) **only** to `confirmed` findings. `needs_validation` items receive no severity and must state the exact runtime condition or header/config to check.
5. **Zero Filler:** Skip praise, generic best-practice lectures, and vague advice. Every item must be specific, code-grounded, and practical.
6. **Mandatory Output Format (Git-Patch Compatible & `Downloads\` Output):**
   * Save clean, git-patch-compatible Markdown report(s) directly to `%USERPROFILE%\Downloads\` using practical **Title Case** (preserving exact upstream casing for forks like `DeepTutor`): `<Repo Title Case> - <Short Audit Identifier>.md` (e.g., `Music Manager - Code Audit.md`, `Music Manager - Security Audit.md`).
   * Include a **Metadata Header** (Repository, Branch, Commit SHA), **Coverage Ledger**, and **Unified `Phase 1–4` Execution Plan** (matching `UIUX.md` so combined runs merge cleanly).
   * Use this exact structure for every finding:
     * **ID & Module:** e.g., `[M1-01]`
     * **Status:** `confirmed` | `needs_validation`
     * **Severity / Impact:** `Critical` | `High` | `Medium` | `Low` | `Informational` (or `N/A — needs_validation`)
     * **Exact File Paths & Symbols:** `path/to/file.ext :: symbolName` (symbol anchors only; never use line numbers)
     * **Root Cause / Rationale:** Concise technical explanation grounded in the actual code.
     * **Concrete Actionable Fix or Patch Spec:** Exact patch specification, refactored contract, or replacement library/architecture.
7. **Post-Audit Closure Loop (Feed Outcomes Into Living Docs & Tests):** Whenever fixes from an audit report are implemented, persist durable outcomes before deleting the `Downloads\` report:
   * Non-obvious bug, concurrency, or security root causes -> add an automated regression test (`Verified By:` in `docs/PRODUCT.md`) + record a `[TRAP: ...]` in `docs/DECISIONS_AND_TRAPS.md` (with a 1-line pointer in root `AGENTS.md`).
   * Architectural trade-offs, rejected OSS swaps, or intentional waivers -> record a concise `[DECISION: ...]` in `docs/DECISIONS_AND_TRAPS.md` so future audits never re-propose them.
   * Deferred companion/lateral features -> park as `[WISHLIST: ...]` in `docs/PRODUCT.md`.

## Module 1: Bugs, Edge Cases, Concurrency & State Overlaps

Audit runtime correctness, control flow, and state integrity.

* **Logic Bugs & Silent Failures:** Catch swallowed exceptions, inverted conditionals, off-by-one errors, null/undefined coercion bugs, timezone/locale assumptions, and broken retry/fallback logic.
* **Edge Cases & Boundary Conditions:** Test empty inputs, massive inputs, malformed UTF-8/Unicode, special characters in file paths, offline/disconnected states, cold-start vs. warm-start state, and missing permissions.
* **Concurrency & Race Conditions:**
  * Async out-of-order resolution (stale responses overwriting newer state; missing `AbortController` or request sequence IDs).
  * Concurrent file/DB writes, lock contention, and TOCTOU (time-of-check to time-of-use) races.
  * Re-entrant event handlers, double-submit/double-trigger bugs, and unguarded timers/intervals.
* **State & Logic Overlaps:**
  * Duplicate sources of truth (UI state, local storage, and backend/file state drifting out of sync).
  * Competing listeners, observers, or CSS/DOM mutators fighting over the same element or state key.
  * Overlapping keyboard shortcuts, command IDs, or event bus namespaces.

## Module 2: Security, Isolation, Encryption & Attack Surfaces

Apply a structured multi-phase security audit modeled on Cloudflare's [security-audit-skill](https://github.com/cloudflare/security-audit-skill) ([SKILL.md](https://github.com/cloudflare/security-audit-skill/blob/main/skills/security-audit/SKILL.md), [ATTACK-CLASSES.md](https://github.com/cloudflare/security-audit-skill/blob/main/skills/security-audit/ATTACK-CLASSES.md), and [CLIENT-SIDE.md](https://github.com/cloudflare/security-audit-skill/blob/main/skills/security-audit/CLIENT-SIDE.md)).

### 2.1 Audit Workflow (Cloudflare 6-Phase Adaptation)

1. **Reconnaissance:** Map architecture, trust boundaries, privilege levels, external input surfaces, and sensitive data stores before hunting.
2. **Coverage-Led Hunting:** Systematically sweep every entry point (IPC, HTTP, CLI args, file parsers, DOM sinks, extension messages, plugin hooks) rather than spot-checking.
3. **Adversarial Validation:** Prove both the attacker-controlled source and reachable sink/impact; reject theoretical issues blocked by framework escaping, CSP, or OS controls.
4. **Severity Calibration:**
   * `Critical`: Unauthenticated RCE, full data-store compromise, or arbitrary account takeover.
   * `High`: Auth/sandbox bypass, cross-tenant read/write, stored XSS affecting other users, or authenticated RCE.
   * `Medium`: Boundary violation with constrained blast radius or narrow preconditions.
   * `Low`: Non-secret internal disclosure or minimal-gain flaw.
   * `Informational`: Confirmed prerequisite or hardening gap.

### 2.2 Attack Surface Checklist

* **Encryption, Cryptography & Secrets:**
  * Weak or deprecated primitives (MD5, SHA-1, DES, RC4, ECB mode), predictable randomness (`Math.random()` for tokens/IDs), nonce/IV reuse, or hardcoded keys/salts.
  * Improper secret storage (plaintext API keys/tokens in localStorage, unencrypted configs, logs, or files missing from `.gitignore`).
  * Missing encryption at rest or in transit (disabled TLS validation, insecure HTTP fallbacks, weak JWT checks such as `alg=none`).
* **Isolation, Sandboxing & Segmentation:**
  * Insufficient privilege separation (Electron `nodeIntegration: true` / `contextIsolation: false`, overly broad host permissions, unscoped `iframe` embeds lacking `sandbox`).
  * Missing tenant, profile, workspace, or plugin segmentation (shared caches, global mutable state, cross-context storage leakage).
  * Subprocess and shell execution risks (command injection via unescaped arguments, `shell: true`, unsafe `eval`/`Function`).
* **File System, Network & Deserialization ([ATTACK-CLASSES.md](https://github.com/cloudflare/security-audit-skill/blob/main/skills/security-audit/ATTACK-CLASSES.md)):**
  * Path traversal (symlinks, encoded sequences, null bytes), zip slip on archive extraction, insecure temp files, and TOCTOU file races.
  * SSRF (redirects, DNS rebinding, URL parser differentials) and unsafe deserialization (`pickle`, `yaml.load`, arbitrary JSON revivers).
* **Client-Side, DOM & Messaging ([CLIENT-SIDE.md](https://github.com/cloudflare/security-audit-skill/blob/main/skills/security-audit/CLIENT-SIDE.md)):**
  * DOM-based XSS (`innerHTML`, `outerHTML`, `document.write`, unsafe framework escape hatches), DOM clobbering, and prototype pollution paired with a reachable gadget.
  * `postMessage` handlers missing exact origin allowlists and `event.source` checks, or sending sensitive payloads to `*`.
  * Cross-site WebSocket hijacking (missing `Origin` check or channel token), credentialed CORS reflection, and missing/permissive CSP, `SameSite`, or COOP/CORP headers.
* **Supply Chain & Dependencies:** Outdated dependencies with known CVEs, unpinned remote scripts/CDNs, and excessive third-party permissions.

## Module 3: Performance, Memory Leaks & Resource Lifecycle

Identify runtime bottlenecks, memory growth, and improper cleanup across long-running sessions.

* **Memory Leaks & Lifecycle Cleanup:**
  * Unremoved event listeners (`addEventListener`, IPC listeners, WebSocket/EventSource hooks, plugin callbacks), dangling `setInterval`/`setTimeout`, or undisposed `MutationObserver`/`ResizeObserver`/`IntersectionObserver`.
  * Unbounded in-memory caches, Maps/Sets holding detached DOM nodes or large buffers, and missing `WeakMap`/`WeakRef` or LRU eviction.
  * Unclosed file handles, database cursors, streams, Web Workers, GPU/WebGL/Canvas contexts, or child processes on unload/reload.
* **Rendering & UI Responsiveness:** Layout thrashing (interleaved DOM reads/writes), excessive re-renders, unvirtualized long lists/tables, unthrottled scroll/resize/input handlers, and main-thread blocking JSON/Markdown/regex work.
* **I/O, Storage & Startup Cost:** Redundant disk reads/writes, synchronous blocking I/O on the UI thread, N+1 queries, unbatched state writes, and heavy eager imports that should be lazy-loaded.

## Module 4: Data Integrity, Migrations & Backup Safety

Ensure user data, settings, and databases survive crashes, upgrades, and format transitions without silent corruption or loss.

* **Atomic Writes & Crash Safety:** Flag direct in-place overwrites of JSON, YAML, Markdown, or config files without write-to-temp-then-rename semantics (UTF-8 without BOM), file locking, or SQLite WAL/transaction boundaries.
* **Schema Versioning & Migrations:** Check whether stored data/configs carry an explicit schema version, handle missing/renamed/deprecated fields gracefully, and run idempotent forward migrations (with safe fallback on downgrade or malformed files).
* **Backup, Rollback & Recovery:** Verify whether destructive operations or upgrades create rolling backups, detect corrupted/truncated files cleanly, and offer recovery instead of silently resetting user data to defaults.
* **Import/Export Round-Trip Fidelity:** Audit whether exporting and re-importing data preserves all metadata, IDs, relationships, timestamps, and Unicode/escaping without drift.

## Module 5: Privacy, Offline-First & Network Hygiene

Verify that the app respects user privacy, avoids hidden external calls, and remains usable offline.

* **Hidden Outbound Requests & Telemetry:** Inventory every network call (`fetch`, `XMLHttpRequest`, WebSocket, update checks, analytics, third-party fonts/CDNs/icons). Flag any undisclosed or unnecessary external request.
* **Sensitive Data Leakage:** Check that local file paths, vault/document contents, clipboard history, API keys, and personal identifiers never leak into crash logs, debug dumps, browser referrers, URL query params, or unredacted LLM/API prompts.
* **Offline-First Resilience:** Identify hard runtime dependencies on remote CDNs, online fonts, or remote APIs that break core workflows offline; prefer `%LOCALAPPDATA%\SharedLibraries` or embedded offline assets.
* **Network Hygiene:** Check for missing request timeouts, unbounded retries, missing rate-limit handling, and improper `0.0.0.0` vs. `127.0.0.1` loopback binding exposing local services on the LAN.

## Module 6: Doc/Test Parity, Dead Code & Cross-References

Verify that what is documented, configured, and wired works end-to-end. *(For full UI surface inventory parity in `README.md`, pair with `UIUX.md` Module U10.)*

* **Living Doc & Anchor Parity:** Verify `docs/PRODUCT.md`, `docs/ARCHITECTURE.md`, `docs/DECISIONS_AND_TRAPS.md`, and root `AGENTS.md` against actual code—checking `[TYPE: Slug]` `Links:`, live `path/to/file.ext :: symbolName` anchors, and `Verified By:` test pointers.
* **Stale Code, Dead Functions & Feature Husks:** Flag unused exports, unreachable branches, orphaned CSS rules, abandoned migrations, leftover debug code, and half-built TODO husks that need completion or deletion.
* **Wiring & Ghost Settings:** Verify every setting, toggle, CLI flag, menu item, and hotkey is consumed by live logic (no "ghost settings" saved to config but never read) with zero broken route/command IDs.

## Module 7: UI Layout Bugs, Overflow/Z-Index & Contrast Defects

Audit **code-level visual and layout defects**. *(For full UI surface parity, progressive disclosure, iconography, motion, and 3-Gate Feasibility scoring across U1–U10, run `UIUX.md` instead of duplicating surface checklists here.)*

* **Overflow, Clipping & Z-Index Bugs:** Text/content overflowing containers, clipped modals/dropdowns/tooltips inside `overflow: hidden` ancestors, accidental horizontal scrollbars on narrow panes, and competing `z-index` contexts burying popovers or dialogs.
* **Hardcoded Color Leaks & Contrast Inversions:** Raw hex/RGB literals bypassing CSS theme tokens, Light/Dark contrast drops below WCAG AA (`4.5:1` text / `3:1` controls), broken selection/focus highlights, and SVGs/icons/charts turning invisible on dark or light surfaces.
* **Broken Non-Happy UI States:** Unhandled async rejections leaving frozen spinners, blank crash screens, or unguarded destructive actions firing without confirmation/undo.

## Module 8: Code-Level Accessibility (a11y) & Focus Defects

Audit **broken keyboard and assistive mechanics** in code. *(For full keyboard-first ergonomics, shortcut discoverability, and touch-target parity, pair with `UIUX.md` Module U9.)*

* **Keyboard Traps & Focus Regressions:** Interactive controls unreachable via `Tab`/arrow keys, missing `:focus-visible` indicators, dialogs failing to trap focus or `Escape`-dismiss cleanly, or failing to restore focus on close.
* **Non-Semantic Markup & Missing ARIA:** Clickable `<div>`/`<span>` tags instead of native `<button>`/`<a>`, icon-only controls missing `aria-label`, unassociated form `<label>` elements, and dynamic status/error updates missing `aria-live` announcements.
* **OS Motion & High-Contrast Violations:** Animations ignoring `prefers-reduced-motion: reduce`, locked tiny `px` text breaking zoom, or status indicators relying on color alone.

## Module 9: Testability, Logging & Diagnostics

Assess how reliably bugs are caught in CI and diagnosed in the wild.

* **Critical-Path Test Coverage:** Identify high-risk business logic, parsers, state transitions, migrations, and security boundaries lacking unit/integration/E2E tests (or missing `Verified By:` links in `docs/PRODUCT.md`). Flag brittle or over-mocked tests that pass while real behavior is broken.
* **Structured Logging & Error Context:** Flag silent catches, vague `"Something went wrong"` errors, or noisy `console.log` spam. Recommend leveled logging with operation context and sanitized inputs.
* **Diagnostics & Reproducibility:** Check for health/status CLI checks (`--json`) or a "Copy Diagnostic Info" action (version, OS, redacted config, recent error tail).

## Module 10: Simplification, Deduplication, Modularization & Pruning

Aggressively reduce complexity without losing real capability.

* **Logic & Function Simplification:** Flatten deeply nested conditionals, god functions, convoluted state machines, and boilerplate with guard clauses, lookup tables, or pure helpers.
* **Deduplication & Merging:** Merge copy-pasted utilities, duplicate storage/API wrappers, overlapping UI components, and redundant config schemas into one canonical module.
* **Modularization & Pruning:** Split monolithic files mixing UI, business logic, and I/O into single-responsibility modules; prune over-engineered indirection and low-value feature bloat.

## Module 11: Architectural Decisions & Structural Robustness

Evaluate macro-level design choices limiting reliability, extensibility, or maintainability.

* **Key Architectural Bottlenecks:** Flag storage format limits, tight host coupling, blocking pipelines, or fragile client-server boundaries, proposing concrete upgrades with trade-offs.
* **Fault Isolation & Resilience:** Verify error boundaries and graceful degradation when optional services (e.g., local proxies, plugins, network) are offline.
* **Standalone / Shared Readiness:** When auditing a plugin or script outgrowing its host, specify the core decoupling and CLI/API/shared-library extraction path.

## Module 12: Automation & Agent Readiness (CLI, API, URI & MCP)

Ensure core capabilities can be driven by scripts and AI agents without GUI clicks.

* **Headless Core Decoupling:** Extract core logic trapped inside DOM events or modals into pure, UI-agnostic service functions.
* **Scriptable Entry Points:** Audit or spec CLI flags with deterministic exit codes, `--json` output, URI schemes, loopback HTTP/IPC endpoints, or MCP tools (syncing ports/CLIs in `ecosystem-registry.json`).
* **Idempotency & Guardrails:** Support `--dry-run`/preview modes, strict input validation, idempotent re-runs, and confirmation flags for destructive actions.

## Module 13: External Leverage, OSS Reuse & Dedicated App Ecosystem

Prevent reinventing the wheel by checking external open-source and local shared assets first.

* **Battle-Tested Libraries & Shared Assets:** Recommend maintained, license-compatible OSS libraries (and check `%LOCALAPPDATA%\SharedLibraries` / `THIRD_PARTY_NOTICES.md` impact) to replace fragile hand-rolled parsers, editors, virtual lists, or crypto.
* **Feature Harvesting:** Identify comparable OSS plugins/apps whose proven patterns, algorithms, or workflows can be adapted or forked.
* **Build vs. Adopt vs. Bridge:** Candidly recommend whether to **Replace** a weak custom module with a dedicated OSS app, **Bridge** to it via CLI/URI/API/MCP, or **Merge** overlapping local tools.

## Module 14: Lateral Features, QoL Upgrades & Ecosystem Ripple

Make existing features feel complete and cohesive. *(For cross-platform UI patterns like Unified Action Registry and Density Toggle, see `UIUX.md` Part 3.)*

* **Companion Features & QoL:** Identify missing natural counterparts (export without import, create without duplicate/template, filter without reset/presets, bulk select without bulk actions).
* **Ecosystem Ripple Check:** Audit the full supporting lifecycle of every present domain capability:
  * **Settings / Config:** Instant apply/preview, guarded reset-to-defaults, portable import/export, and Show/Hide toggles for advanced options.
  * **Data Views / Editors:** Search/sort/filter, empty/loading/error triad, virtualization for large sets, undo/redo, dirty-state protection, and crash recovery.
  * **External Sync / Integrations:** Connection health indicator, offline queue/retry with backoff, rate-limit handling, and manual refresh trigger.

## Module 15: Agent Handoff Packaging, Unified Phases & Closure Loop

*(Closing module—run after selected modules or combined `AUDITS.md` + `UIUX.md` audits to produce one execution-ready roadmap.)*

* **Deduplicate & Cross-Link Findings:** Merge overlapping findings across `AUDITS.md` (`[M*-*]`) and `UIUX.md` (`[U*.*]`) into single canonical fix items.
* **Unified `Phase 1–4` Execution Plan** (shared identically with `UIUX.md`):
  * **Phase 1 — Stability, Security, Data Safety & Entry-Point Guardrails:** Critical/High bugs, races, security/isolation flaws, atomic writes, memory leaks, primary launch parity, and destructive-action guardrails.
  * **Phase 2 — Parity, Token Hygiene, Cleanup & Core Architecture:** Dead code pruning, deduplication, semantic design tokens (zero raw color leaks), broken cross-references, core regression tests, and structural refactors.
  * **Phase 3 — UI/UX Polish, Surfaces, Motion & Accessibility:** Overflow/z-index discipline, Light/Dark contrast parity, workspace/contextual surfaces, Show/Hide progressive disclosure, reduced-motion, and full keyboard/ARIA operability.
  * **Phase 4 — Automation, OSS Leverage, Living Docs & Lateral Ecosystem:** CLI/API/MCP hooks, library swaps, `docs/` + `Verified By:` sync, `[TRAP]`/`[DECISION]`/`[WISHLIST]` closure routing, and cherry-picked companion features.
* **Verification Checklist:** Concrete CI/CLI commands, theme/keyboard/offline checks, and regression tests required to close each phase.
