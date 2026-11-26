---
name: code-audit
description: >-
  Performs modular or full-repo code, security (Cloudflare 6-phase), concurrency, performance,
  data-integrity, accessibility-bug, OSS-reuse, and lateral-ecosystem audits using the 15-module
  AUDITS.md framework, emitting git-patch-ready reports to Downloads and routing durable findings
  into living docs and tests. Use whenever the user asks to audit a codebase, run security/bug/perf
  checks, evaluate OSS reuse or lateral features, or run specific modules of AUDITS.md.
---

# Modular Codebase Audit Skill (`code-audit`)

Thin progressive-disclosure skill wrapper for `%USERPROFILE%\.agent-templates\AUDITS.md` (`~/.agent-templates/AUDITS.md`).

## Module Index (Slice Only What You Need)

| Module | Scope | Primary Focus |
| :--- | :--- | :--- |
| **Module 1** | Bugs, Concurrency & State | Logic bugs, edge cases, race conditions, state overlaps |
| **Module 2** | Security, Isolation & Encryption | Cloudflare 6-phase workflow, crypto/secrets, sandboxing, XSS/SSRF/RCE |
| **Module 3** | Performance & Memory Leaks | Listener/timer leaks, render thrash, unbounded caches, blocking I/O |
| **Module 4** | Data Integrity, Migrations & Backups | UTF-8 no-BOM atomic writes, schema migrations, round-trip fidelity |
| **Module 5** | Privacy, Offline-First & Network Hygiene | Hidden outbound calls, offline resilience, `127.0.0.1` loopback hygiene |
| **Module 6** | Doc/Test Parity, Dead Code & Cross-Refs | `Links:` + `Verified By:` + `::` anchor parity, dead code, ghost settings |
| **Module 7** | UI Layout Bugs & Contrast Defects | Overflow/z-index clipping, non-token colors, contrast inversions *(full UI parity -> `uiux-audit`)* |
| **Module 8** | Code-Level Accessibility Defects | Broken focus traps/rings, non-semantic tags, missing ARIA *(ergonomic parity -> `uiux-audit`)* |
| **Module 9** | Testability, Logging & Diagnostics | Critical-path test gaps, structured logs, `--json` health/diagnostics |
| **Module 10** | Simplification & Pruning | Flattening god functions, deduplication, single-responsibility splits |
| **Module 11** | Architecture & Robustness | Structural bottlenecks, fault isolation, standalone/shared extraction |
| **Module 12** | Automation & Agent Readiness | Headless core decoupling, `--json` CLI, URI/API/MCP entrypoints |
| **Module 13** | OSS Reuse & External Ecosystem | Library adoption, `SharedLibraries`, Build vs. Adopt vs. Bridge |
| **Module 14** | Lateral Features & Ecosystem | Companion features, QoL upgrades, full Ecosystem Ripple checks |
| **Module 15** | Agent Handoff & Closure Loop | Deduplication, unified `Phase 1–4` execution plan, verification & doc closure |

## Execution Procedure

1. **Load Only Requested Modules (Save Context):**
   - Locate live line offsets dynamically in `%USERPROFILE%\.agent-templates\AUDITS.md`:
     `grep -n "^## " "%USERPROFILE%\.agent-templates\AUDITS.md"` (or PowerShell `Select-String -Pattern '^## ' "$env:USERPROFILE\.agent-templates\AUDITS.md"`).
   - Always read `## Global Operating Rules` plus **only** the target `## Module N` line slices (`StartLine`–`EndLine`) requested by the user (or batch Phases A `1–5`, B `6–9`, C `10–14`, `15` for full large-repo audits).
2. **Pre-Audit Waiver & Trap Scan:**
   - Run `grep -n -A 1 "^### \[" docs/` in the target repo first and read matching `[DECISION]`, `[TRAP]`, and `[WISHLIST]` slices so intentional waivers (`N/A — Cumbersome`, `N/A — Conflicting`, rejected OSS swaps) are respected rather than re-flagged.
3. **Adversarial Verification:**
   - Inspect live implementation code only (never trust READMEs/comments). Attempt to disprove every candidate finding; label `confirmed` (with severity `Critical`..`Informational`) vs. `needs_validation` (no severity; state exact runtime check).
4. **Patch-Ready Output (`Downloads\` Only):**
   - Write report directly to `%USERPROFILE%\Downloads\<Repo Title Case> - <Short Audit Topic>.md` (preserving exact upstream fork casing; never leave disposable reports in the workspace).
   - Include: Metadata Header (Repo, Branch, Commit SHA), Coverage Ledger (inspected/skipped/uninspectable), findings using exact `path/to/file.ext :: symbolName` anchors, and the unified `Phase 1–4` Execution Plan.
5. **Post-Audit Closure Loop (When Implementing Fixes):**
   - Route non-obvious bug/security root causes -> regression test (`Verified By:` in `docs/PRODUCT.md`) + `[TRAP]` in `docs/DECISIONS_AND_TRAPS.md` (+ 1-line pointer in root `AGENTS.md`); waivers/trade-offs -> `[DECISION]`; deferred companion features -> `[WISHLIST]`.
