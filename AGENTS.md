# Universal Operating Protocol (`AGENTS.md`)
**MANDATORY FOR ALL AI CODING AGENTS**

## 1. User Profile, Agency & Voice-Dictation Decoder
- **High-Level Agency:** Operate with autonomous engineering judgment. Rely on high-level intent, architecture, and desired outcomes rather than waiting for micromanaged step-by-step CLI instructions.
- **South Asian Voice-Dictation Input:** Prompts are voice-typed by a South Asian English speaker. Expect phonetic mishearings, nasalized sound substitutions, repeated words, fillers, and fragmented phrasing. Silently ignore fillers, auto-correct likely mishearings from project context, and tolerate minor speech-to-text typos on NATO topic tags and option numbers (e.g., `brabo` -> `Bravo`, `to` -> `2`).

## 2. Instruction Triage & Modular Confirmation Gate
Before modifying files, triage the prompt into one of three paths:
- **Path A: Fast Path (Direct Execution):** For small tweaks, clear bug fixes, routine operations, or continuing an approved plan. State a 1-line assumption of intent and execute immediately.
- **Path B: Modular Topic-Based Confirmation Gate (New, Complex, or Ambiguous Tasks):** For new features, multi-step changes, architectural shifts, or ambiguous dictation where a wrong guess wastes work. Do NOT write code yet. Present a single executive agenda grouped by **topic** (intent + questions/options together).
  - **Intent First, No Routine Impact Clutter:** Open each topic with `What I understood:` in plain English. Omit routine file-path/impact lists unless something could unexpectedly break.
  - **Explicit Question Types:** Label every prompt unambiguously as `[Pick One]`, `[Pick Any]`, `[Yes / No]`, or `[Confirm]` (when no choice is needed), with a simple plain-English explanation of each option.
  - **Voice-Safe NATO + Number Tagging:** Label topics using the NATO phonetic alphabet (`ALPHA`, `BRAVO`, `CHARLIE`, `DELTA`, `ECHO`, `FOXTROT` — always `BRAVO`, never `Beta`) and number options continuously inside each topic (`Bravo 1`, `Bravo 2`, `Bravo 3`, `Bravo 4`). Wait for confirmation before executing.

  **Required Path B Template:**
  ```markdown
  **ALPHA — [Short Topic Name]**
  * **What I understood:** [1–2 plain-English sentences restating intent.]
  * **`[Yes / No]` — Alpha:** [Clear binary question in simple English?]

  **BRAVO — [Short Topic Name]**
  * **What I understood:** [1–2 plain-English sentences restating intent.]
  * **`[Pick One]` — [Question in simple English?]**
    * **Bravo 1 *(recommended)*:** [Option name] — [What this means in practice.]
    * **Bravo 2:** [Option name] — [What this means in practice.]
  * **`[Pick Any]` — [Optional extras?]**
    * **Bravo 3:** [Option name] — [Simple explanation.]
  *(Use **`[Confirm]` — [Topic]:** when no choices are needed.)*
  ```

- **Path C: On-Demand Visual Preview Path (Strictly on Request):** Only generate visual previews when explicitly asked for a preview or visual example.
  - **UI/UX or Visual Changes:** Build an accurate, self-contained HTML preview using proper CSS and JavaScript (including Three.js or other needed web libraries) inside root `preview/` beside `docs/` (never inside `docs/`), using short kebab-case names (e.g., `preview/theme-toggle.html`).
  - **Logic/Flow Changes:** Render an Obsidian-compatible Mermaid flowchart following Section 3.
  - **File/System Operations:** Present a Before -> After Action Table (`Target | Action | Outcome`).

## 3. Progressive Search-First Documentation & Visual Markdown Standard
- **Search-First Discovery (Protect Context):** Never bulk-read `docs/` on startup and never create an `INDEX.md`. Every doc item must use `### [TYPE: Descriptive-Slug] | Aliases: synonym 1, synonym 2` (valid `TYPE`: `FEATURE`, `WISHLIST`, `SUBSYSTEM`, `FLOW`, `DECISION`, `TRAP`) followed immediately on the very next line (no blank line) by `> **1-Line Summary:**`. Scan with `grep -A 1 "^### \[" docs/` first; read full sections only when relevant. If any doc exceeds ~250 lines, split details into `docs/modules/<topic-name>.md` and keep the header, 1-line summary, and link in the main file.
- **Function/Symbol Anchors Only:** Never use line numbers as code anchors. Reference file paths paired with exact function, class, or variable names (`` `path/to/file.ext` -> `symbolName` ``).
- **Template Resolution:** Load copy-ready project templates from `templates/` (`PRODUCT.md`, `ARCHITECTURE.md`, `DECISIONS_AND_TRAPS.md`, `PROJECT_AGENTS.md`, `ci.yml`) using whichever is newest between the local master templates repo and `https://github.com/Mostakim2005/agent-templates`.
- **Core Documentation Suite (`docs/` — Strictly Markdown-Native):** Never commit HTML guides into `docs/` (previews belong in root `preview/` per Path C). Maintain three core Markdown docs:
  - `docs/PRODUCT.md` — Permanent source of truth for user intentions, active feature checklist, and merge wishlist.
  - `docs/ARCHITECTURE.md` — Single living visual map: high-level system diagram, tech stack rationale, per-subsystem and per-feature color-coded Mermaid flowcharts (updated in place), and extension recipes.
  - `docs/DECISIONS_AND_TRAPS.md` — Architectural pivots (what failed, why we switched, `[DECIDED BY: HUMAN]` vs. `[DECIDED BY: AGENT]`) plus non-obvious engineering landmines. Never log trivial syntax/type fixes or routine setup steps.
- **Obsidian-Compatible Mermaid Visual Standard:** Every Mermaid diagram in `docs/` must render cleanly in both **Obsidian** and **GitHub** and include: (1) distinct `classDef` color coding + a **Legend / Explanation Box**, (2) clear directional arrows with labels (`start -> end`, input/output, parent -> child), and (3) a short plain-English explanation alongside it.
- **Project-Specific `AGENTS.md` Boundary:** A project root `AGENTS.md` must contain repository-specific facts only (build/test commands, runtime versions, directory layout, and 1-line trap pointers). Never duplicate this master `AGENTS.md`.

## 4. Latest-State Sync, GitHub (`Mostakim2005`), CI/CD, Builds & Licensing
- **Latest-State Verification (Local PC vs. GitHub):** Before starting work, loading templates, or syncing, compare the local workspace against `https://github.com/Mostakim2005` (one dedicated public repo per project), treat whichever has the newest changes as active truth, and reconcile without overwriting newer local work.
- **Non-Interactive Git Execution:** All Git operations must assume non-interactive execution (`GIT_TERMINAL_PROMPT=0`). Never hang waiting for credential prompts or passphrases; abort and report any auth/permission block immediately.
- **Repository & Local Workspace Naming:** GitHub repositories use slugified lowercase (`kebab-case`, e.g., `novel-writing`, `music-manager`). Local working copies use clean `Title Case` with spaces (e.g., `Novel Writing`, `Music Manager`). Upstream forks (e.g., `DeepTutor`, `GaussBoard`) MUST preserve exact upstream casing and naming.
- **Clean Modular Source & One-Time Archives:** Keep source files modular and single-responsibility, with strict `.gitignore` rules blocking dependencies, build outputs, binaries, and secrets. Archive/zip snapshots (e.g., `git archive`) are strictly one-time actions—never auto-refresh them on later commits unless explicitly asked.
- **GitHub Actions as Default CI/CD, Lint & Test Runner:** Run all CI, CD, linting, formatting, type-checking, unit/integration tests, and build verification inside **GitHub Actions** (`.github/workflows/`) by default. Every project repository must include and maintain a default CI workflow (e.g., `.github/workflows/ci.yml`, bootstrapped from `templates/ci.yml`) triggered automatically on pushes and pull requests so GitHub serves as the authoritative verification gate. Keep CD/release workflows strictly **tag-triggered (`vX.Y.Z`)**—package Windows desktop apps as **portable `.exe` binaries by default** (unless an installer is requested) and attach releases in the cloud rather than storing builds locally.
- **Licensing & Third-Party Attribution:** Keep `LICENSE` strictly for **PolyForm Noncommercial 1.0.0**. Maintain upstream open-source credits in `THIRD_PARTY_NOTICES.md` as a Markdown table split into *"Ships inside the app"* and *"Build / test only — not shipped"* with links to upstream license texts.

## 5. UI/UX & Accessibility Standards
- **Visual Craft & Theme Contrast:** Maintain clean visual hierarchy, proportional spacing, calibrated color scales, and strict **WCAG AA/AAA contrast** across both Light and Dark themes without text- or icon-contrast inversions.

## 6. Mandatory Post-Change Protocol
After completing any feature, architectural change, or significant fix:
1. **Verify (Local + GitHub CI):** Run the project's local build, type, lint, and test checks when available, and ensure `.github/workflows/` runs the full lint/typecheck/test/build suite in GitHub Actions by default. **Verification Gate:** If any check fails, do NOT commit or push. Halt, fix or revert, and re-verify first.
2. **Sync Docs:** Update `docs/PRODUCT.md`, `docs/ARCHITECTURE.md` (including visual Mermaid flows in place), and `docs/DECISIONS_AND_TRAPS.md` whenever intent, architecture, visual flows, or traps change.
3. **Commit & Push (No Auto-Releases):** Commit clean source and documentation changes and push to the project's default `https://github.com/Mostakim2005` repository. **Do NOT** bump version numbers, create git version tags (`vX.Y.Z`), or trigger release workflows automatically—only tag and release when explicitly instructed.
4. **Executive Report (Plain English + Rationale):** Reply with a 1-line status header followed by a concise topic-by-topic plain-English summary covering **what changed and why**. Omit raw file/function anchor lists in chat unless asked.

   **Required Post-Change Report Template:**
   ```markdown
   **Done — [Short Task Title]** (`<commit-hash>` pushed to `<branch>` | <checks passed>)
   * **[Topic 1]:** [What changed in plain English.] *Why:* [Brief rationale.]
   * **[Topic 2]:** [What changed in plain English.] *Why:* [Brief rationale.]
   * **Docs updated:** [1-line note on which `docs/` files were updated.]
   ```

## 7. Dynamic Preference Routing & Master Sync Protocol
- **On-Demand Symlink-First Sync Architecture:** The master templates repo lives at `%USERPROFILE%\.agent-templates\` (`C:\Users\kazir\.agent-templates\`). All harness links and GitHub syncs run strictly on-demand via `run-sync.bat` / `sync-all.ps1` (never run persistent background watchers, polling daemons, or scheduled tasks):
  `powershell -NoProfile -ExecutionPolicy Bypass -File "%USERPROFILE%\.agent-templates\sync-all.ps1"`
  To extract and deduplicate Section 8 preferences across Master and all harnesses into a review file (`SECTION8_REVIEW.md`) for frontier-model consolidation, run `run-extract.bat` / `extract-prefs.ps1`.
- **Semantic Scope Analysis (No Hardcoded Triggers):** Route new rules or preferences by semantic scope:
  - **Project-Specific (Local `./AGENTS.md`):** Rules coupled to one project's tech stack, build scripts, directory layout, or domain logic.
  - **Universal / Cross-Project (Master `AGENTS.md`):** General coding standards, workflow discipline, tool behavior, or universal preferences go into master `AGENTS.md` Section 8 as `- [PREF: Descriptive-Slug | YYYY-MM-DD | Category] Plain-English rule.`, followed by running `sync-all.ps1`.
  - **Ambiguous / Borderline:** Record into the project's `./AGENTS.md` first, then ask in 1 line: *"Recorded in project AGENTS.md. Promote to global master AGENTS.md?"*
- **Cross-Project Consolidation:** When instructed, consolidate accumulated Section 8 entries into Sections 1–7 across local and master repositories.

## 8. Live User Preferences (Auto-Captured)
*(All preferences up to 2026-11-21 have been consolidated into Sections 1–7. Append newly discovered preferences below.)*
