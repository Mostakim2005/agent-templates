# Universal Operating Protocol (`AGENTS.md`)
**MANDATORY FOR ALL AI CODING AGENTS**

## 1. User Profile, Agency & Voice-Dictation Decoder
- **High-Level Agency:** Operate with autonomous engineering judgment. Rely on high-level intent, architecture, and desired outcomes rather than waiting for step-by-step CLI micromanagement.
- **South Asian Voice-Dictation Input:** Prompts are voice-typed by a South Asian English speaker. Expect phonetic mishearings, nasalized sound substitutions, repeated words, fillers, and fragmented phrasing. Silently ignore fillers, auto-correct likely mishearings from project context, and tolerate speech-to-text typos on NATO tags and option numbers (e.g., `brabo` -> `Bravo`, `to` / `one` -> `2` / `1`).

## 2. Instruction Triage & Modular Confirmation Gate
Before modifying files, triage the prompt into one of three paths:
- **Path A: Fast Path (Direct Execution):** For small tweaks, clear bug fixes, routine operations, or continuing an approved plan. State a 1-line assumption of intent and execute immediately.
- **Path B: Modular Topic-Based Confirmation Gate (New, Complex, or Ambiguous Tasks):** For new features, multi-step changes, architectural shifts, or ambiguous dictation where a wrong guess wastes work. Do NOT write code yet. Present **one single merged agenda** grouped by **topic** so the user reads and decides once from top to bottom.
  - **Single-Pass Merged Agenda (Never Split Report vs. Questions):** NEVER write a separate summary, audit report, or pre-implementation checklist above a second "Confirmation / Questions" section at the bottom. Put each topic's concise **Findings & Plan** (plain-English intent, findings, and proposed changes) directly inside its own NATO block, immediately followed by that topic's decision prompt. Omit routine file-path/impact clutter unless something could unexpectedly break.
  - **Explicit Question Types:** Label every prompt unambiguously as `[Pick One]` (single choice), `[Multiple]` (multi-select — choose any combination), `[Yes / No]` (do / don't), or `[Confirm]` (reconfirming a straightforward topic with no open choices), with a simple plain-English explanation of each option.
  - **Voice-Safe NATO + Number Tagging:** Label topics using the NATO phonetic alphabet (`ALPHA`, `BRAVO`, `CHARLIE`, `DELTA`, `ECHO`, `FOXTROT` — always `BRAVO`, never `Beta`) and number options continuously inside each topic (`Bravo 1`, `Bravo 2`, `Bravo 3`, `Bravo 4`). Wait for confirmation before executing.
  - **Proactive OSS Reuse & Lateral Feature Check (New Features, Subsystems & Apps):** Before proposing a Path B plan for any new feature, subsystem, or app (skipped on Path A micro-fixes), proactively check: (1) existing open-source or source-available libraries, plugins, or apps we can adopt, fork, bridge, or borrow patterns from (checking license compatibility, maintenance health, `%LOCALAPPDATA%\SharedLibraries`, `ecosystem-registry.json`, and `THIRD_PARTY_NOTICES.md` impact), and (2) comparable apps to surface natural **lateral/companion features** (`AUDITS.md` Modules 13–14). Present Build vs. Reuse/Fork/Bridge as `[Pick One]` and optional companion features as `[Multiple]` inside the relevant NATO block so deferred items can park cleanly in `docs/PRODUCT.md` (`[WISHLIST]`).

  **Required Path B Template (Single Merged Agenda — No Separate Report Above):**
  ```markdown
  **ALPHA — [Short Topic Name]**
  * **Findings & Plan:** [Concise plain-English intent, findings, or proposed changes for this topic.]
  * **`[Yes / No]` — Alpha:** [Clear do/don't question in simple English?]

  **BRAVO — [Short Topic Name]**
  * **Findings & Plan:** [Concise plain-English intent, findings, or proposed changes for this topic.]
  * **`[Pick One]` — [Single-choice question in simple English?]**
    * **Bravo 1 *(recommended)*:** [Option name] — [What this means in practice.]
    * **Bravo 2:** [Option name] — [What this means in practice.]
  * **`[Multiple]` — [Multi-choice optional extras?]**
    * **Bravo 3:** [Option name] — [Simple explanation.]
    * **Bravo 4:** [Option name] — [Simple explanation.]

  **CHARLIE — [Short Topic Name]**
  * **Findings & Plan:** [Concise plain-English summary of a straightforward item with no open choices.]
  * **`[Confirm]` — Charlie:** [Short reconfirmation prompt?]
  ```

- **Path C: On-Demand Visual Preview Path (Strictly on Request):** Only generate visual previews when explicitly asked for a preview or visual example:
  - **UI/UX or Visual Changes:** Self-contained HTML/CSS/JS preview (including Three.js or needed libraries) inside root `preview/` beside `docs/` (never inside `docs/`), using kebab-case names (e.g., `preview/theme-toggle.html`).
  - **Logic/Flow Changes:** Obsidian-compatible Mermaid flowchart following Section 3.
  - **File/System Operations:** Before -> After Action Table (`Target | Action | Outcome`).

## 3. Interconnected Search-First Documentation & Visual Markdown Standard
- **Search-First Dynamic Slicing (Protect Context — Zero Stored Line Numbers):** Never bulk-read `docs/` on startup, never create an `INDEX.md`, and never store line numbers in `docs/`. Every doc item must use `### [TYPE: Descriptive-Slug] | Aliases: synonym 1, synonym 2` (valid `TYPE`: `FEATURE`, `WISHLIST`, `SUBSYSTEM`, `FLOW`, `DECISION`, `TRAP`) followed immediately on the next line by `> **1-Line Summary:**`. Run `grep -n -A 1 "^### \[" docs/` (or `Select-String` on Windows) to find relevant slugs/aliases and compute their **current live start and next-header line bounds on the fly**, then read **only** that matched line slice (`StartLine`–`EndLine`) even after edits shift lines.
- **Unified Symbol Anchors (`::` Everywhere):** Never use line numbers as anchors. Always use `` `path/to/file.ext :: symbolName` `` across docs, audits, and reports (staying backward-tolerant when reading legacy `->` anchors).
- **Connected 3-Doc Graph & Single-Owner Anchors (`docs/` — Strictly Markdown-Native):** Connect related items across docs with `* **Links:** \`[TYPE: Slug]\`` and keep HTML out of `docs/`:
  - `docs/PRODUCT.md` — Owns **what & why** (vision, UX feel, active features, and `[WISHLIST]`). Links each `[FEATURE]` to its `[FLOW]`/`[TRAP]` and a `* **Verified By:**` test anchor (`tests/file.ext :: testName` or CLI smoke command) rather than duplicating implementation code anchors.
  - `docs/ARCHITECTURE.md` — Single living visual map and **canonical owner of implementation `Code Anchors`**: high-level system map, tech stack rationale, in-place color-coded Mermaid flowcharts (`SUBSYSTEM` / `FLOW`), and safe extension recipes. Every Mermaid diagram must render cleanly in **Obsidian** and **GitHub** with `classDef` colors, a **Legend** subgraph, labeled directional arrows (`start -> end`), and a plain-English walkthrough.
  - `docs/DECISIONS_AND_TRAPS.md` — Architectural pivots, intentional audit/UI waivers (`[DECIDED BY: HUMAN]` vs. `[DECIDED BY: AGENT]`), and non-obvious engineering `[TRAP]` landmines with `Protected Code Anchors`. Never log trivial syntax fixes or routine setup steps.
- **Project Root `AGENTS.md` Boundary:** Keep repository-specific facts only (project name, verification mode, commands, runtime/ports, layout, and 1-line `[TRAP: Slug]` pointers). Never duplicate master `AGENTS.md`.
- **Local-First Templates & Audit Guides:** Load copy-ready templates (`templates/PRODUCT.md`, `ARCHITECTURE.md`, `DECISIONS_AND_TRAPS.md`, `PROJECT_AGENTS.md`, `ci.yml`, `local-ci.ps1`) and audit suites (`AUDITS.md`, `UIUX.md`) directly from `%USERPROFILE%\.agent-templates\`, falling back to `https://github.com/Mostakim2005/agent-templates` only if the local folder is absent or during an explicit sync.

## 4. Session Sync, Repo Classification, Shared Ecosystem & Licensing
- **Session-Scoped Latest-State Sync & Non-Interactive Git:** All Git commands must run non-interactively (`GIT_TERMINAL_PROMPT=0`; abort and report auth blocks immediately). Once at session start (and before syncing or pushing—not on every mid-session edit), check `git remote -v`: if `https://github.com/Mostakim2005/<repo>` exists, compare local vs. GitHub, treat whichever has newer commits as active truth, and reconcile without overwriting newer local work.
- **Naming, Source Hygiene & Licensing:** GitHub repos use `kebab-case` (`music-manager`), local folders use `Title Case` with spaces (`Music Manager`), and upstream forks preserve exact upstream casing (`DeepTutor`, `GaussBoard`). Keep source files modular and single-responsibility with strict `.gitignore` rules; treat archive/zip snapshots (`git archive`) as strictly one-time actions. Keep `LICENSE` for **PolyForm Noncommercial 1.0.0** and maintain `THIRD_PARTY_NOTICES.md` split into *"Ships inside the app"* and *"Build / test only — not shipped"* with upstream license links.
- **Repo Classification — GitHub-First (Default) vs. Top-Secret Local-Only:**
  - **GitHub-Backed Repos (Remote Configured — Default):** `.github/workflows/ci.yml` (bootstrapped from `templates/ci.yml`, including built-in UTF-8 no-BOM, doc header, `[TYPE: Slug]` cross-link, and live `path :: symbol` anchor checks) is the authoritative verification runner. **Do NOT download heavy runtimes, bloated toolchains, or temp-heavy build dependencies onto the local PC**—run local checks only when the runtime is tiny/already installed and fast feedback helps. Keep releases strictly tag-triggered (`vX.Y.Z`), attaching portable Windows `.exe` binaries in cloud releases by default.
  - **Top-Secret Local-Only Repos (No Remote Configured):** Confirm with the user if unsure; **NEVER** create a GitHub repo, add a remote, push, or upload files/logs externally. Installing local runtimes and running full verification via `local-ci.ps1` (from `templates/local-ci.ps1`) is explicitly authorized.
- **OS-Default Tools vs. Shared Libraries & Ecosystem Registry:** Keep standard CLI/runtime tools in OS-default discovery paths (`PATH`, `%USERPROFILE%\.local\bin`, `site-packages`, system SDKs). Store non-auto-discoverable offline JS/WASM assets (`katex`, `tesseract`, `mermaid`, `pdfjs`, `3dmol`) once in `%LOCALAPPDATA%\SharedLibraries` (`LOCAL_COMMON_LIBRARIES`) and resolve local apps/ports/toolchains from `%USERPROFILE%\.local\share\ecosystem-registry.json` (`LOCAL_ECOSYSTEM_REGISTRY`), updating `libraries.json` and `ecosystem-registry.json` as **UTF-8 without BOM**.

## 5. UI/UX Craft, Closed-Loop Audits & Disposable `Downloads\` Reports
- **Visual Craft & Theme Contrast:** Maintain clean visual hierarchy, calibrated spacing, and strict **WCAG AA/AAA contrast** across both Light and Dark themes with zero text- or icon-contrast inversions.
- **Companion Skills & On-Demand Audit Frameworks (`%USERPROFILE%\.agent-templates\`):** Skill-enabled harnesses (`Antigravity`, `Claude Code`, `Codex`, `OpenCode`) auto-discover these synced skills; harnesses without skill setups (`DeepSeek`, `CommandCode`, `Freebuff`) MUST read the matching file below on demand (slicing requested modules via `grep -n "^## "` rather than asking the user to attach guides):
  - **`code-audit` (`skills/code-audit/SKILL.md` -> `AUDITS.md`):** 15-module code, security (Cloudflare 6-phase), concurrency, performance, data-integrity, layout/a11y-bug, OSS-reuse, and lateral-ecosystem audit framework.
  - **`uiux-audit` (`skills/uiux-audit/SKILL.md` -> `UIUX.md`):** Platform-agnostic U1–U10 UI/UX surface parity checklist, 5-state verdict taxonomy, and 3-Gate Feasibility Rubric.
  - **`repo-bootstrap` (`skills/repo-bootstrap/SKILL.md`):** Runbook to scaffold or upgrade `GitHub-First` (`ci.yml`) or `Top-Secret Local-Only` (`local-ci.ps1`) repos, `docs/` graphs, `LICENSE`, and `THIRD_PARTY_NOTICES.md`.
  - **`pref-consolidator` (`skills/pref-consolidator/SKILL.md`):** Runbook to extract `SECTION8_REVIEW.md` (`extract-prefs.ps1`), fold Section 8 preferences into Sections 1–7, and sync all harnesses (`sync-all.ps1`).
  - **Pre-Audit Waiver Respect:** Scan `docs/DECISIONS_AND_TRAPS.md` and `docs/PRODUCT.md` first so recorded waivers (`N/A — Cumbersome`, `N/A — Conflicting`, rejected OSS swaps) and `[TRAP]` invariants are respected rather than re-flagged.
  - **Post-Audit Closure Loop:** When audit fixes land, persist non-obvious bug/security root causes as regression tests (`Verified By:`) + `[TRAP]`, waivers/architectural choices as `[DECISION]`, and deferred companion upgrades as `[WISHLIST]`.
- **Single Disposable & Patch-Ready Report Standard (`Downloads\` Only):** Write every one-time/disposable file (CI failure reports, Code/UIUX Audits, ad-hoc bug investigations, one-off fix/migration checklists) directly to **`%USERPROFILE%\Downloads\<Repo Title Case> - <Short Practical Topic>.md`** (preserving upstream fork casing; if a tool only writes in-workspace, move to `Downloads\` and delete the workspace copy immediately—never leave disposable reports in the repo). Every disposable output must be git-patch-ready: (1) Repository, branch, commit SHA, and CI run URL, (2) Coverage or Stage Failure Ledger, (3) exact `path/to/file.ext :: symbolName` anchors, (4) failing command/error logs, root cause, or triggering `git diff` excerpt, and (5) concrete fix sequence or `.patch` specification.

## 6. Mandatory Post-Change Protocol
Before **every** `git commit` (fixes, refactors, features, or architectural changes):
1. **Pre-Commit Doc & Anchor Sync Gate:** Update `docs/PRODUCT.md` (`Links:` + `Verified By:`), `docs/ARCHITECTURE.md` (in-place Mermaid flows + `Code Anchors`), `docs/DECISIONS_AND_TRAPS.md`, and root `AGENTS.md` / `README.md` *before* staging so code, anchors, and docs ship in one commit (built-in Stage 8/9 CI verifies UTF-8 no-BOM, cross-links, and live `path :: symbol` anchors). Skip doc edits only for purely cosmetic zero-impact commits, noting the check ran.
2. **Verify & Deliver (Branch by Repo Classification):**
   - **GitHub-Backed Repos:** Commit clean source + docs and push to `https://github.com/Mostakim2005/<repo>` (never auto-bump versions or create `vX.Y.Z` tags unless asked). Immediately monitor GitHub Actions (`gh run list` / `gh run watch`). If any CI job fails, download `gh run download <run-id> -p "ci-failure-report*" -D "%USERPROFILE%\Downloads"` (flattening any artifact subfolder so `<Repo Title Case> - CI Failure Report*.md` sits directly in `Downloads\`, or generating it from `gh run view <run-id> --log-failed` + `git show` if unconfigured) and report the saved path.
   - **Top-Secret Local-Only Repos:** Run `powershell -NoProfile -ExecutionPolicy Bypass -File .\local-ci.ps1` locally (never push). On failure, halt and fix or report `%USERPROFILE%\Downloads\<Repo Title Case> - Local CI Failure Report.md`.
3. **Executive Report (Plain English + Rationale):** Reply with a 1-line status header and topic-by-topic plain-English summary of **what changed and why** (omit raw file/symbol lists unless asked):

   **Required Post-Change Report Template:**
   ```markdown
   **Done — [Short Task Title]** (`<commit-hash>` pushed to `<branch>` | <checks passed or CI report saved>)
   * **[Topic 1]:** [What changed in plain English.] *Why:* [Brief rationale.]
   * **[Topic 2]:** [What changed in plain English.] *Why:* [Brief rationale.]
   * **Docs updated:** [1-line note on which `docs/` files were updated, or "None (checked — no doc impact)".]
   ```

## 7. Dynamic Preference Routing & Master Sync Protocol
- **On-Demand Symlink-First Sync:** Master templates and companion `skills/*` live at `%USERPROFILE%\.agent-templates\`. Sync all 7 harness `AGENTS.md` links, all cross-harness skill junctions, and GitHub strictly on-demand via `run-sync.bat` / `sync-all.ps1` (never run background watchers, polling daemons, or scheduled tasks):
  `powershell -NoProfile -ExecutionPolicy Bypass -File "%USERPROFILE%\.agent-templates\sync-all.ps1"`
  Run `run-extract.bat` / `extract-prefs.ps1` to generate `SECTION8_REVIEW.md` for frontier-LLM consolidation.
- **Semantic Scope Routing:**
  - **Project-Specific (Local `./AGENTS.md`):** Rules tied to one repo's stack, commands, layout, or domain traps.
  - **Universal (Master `AGENTS.md`):** Cross-project workflow, coding, or tool preferences go into master `AGENTS.md` Section 8 as `- [PREF: Descriptive-Slug | YYYY-MM-DD | Category] Plain-English rule.`, followed by `sync-all.ps1`.
  - **Ambiguous / Borderline:** Record in `./AGENTS.md` first, then ask in 1 line: *"Recorded in project AGENTS.md. Promote to global master AGENTS.md?"*
- **Cross-Project Consolidation:** When instructed, fold Section 8 entries cleanly into Sections 1–7 across local and master repos.

## 8. Live User Preferences (Auto-Captured)
*(All preferences up to 2026-11-26 have been consolidated into Sections 1–7. Append newly discovered preferences below.)*
- [PREF: CI-Artifacts-For-Testing-And-Releases-For-Milestones | 2026-11-26 | Release Workflow] Always use CI APK/build artifacts for intermediate testing and save `vX.Y.Z` releases strictly for stable milestone bundles.
