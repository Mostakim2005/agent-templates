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
- **Template Resolution:** Load copy-ready project templates from `templates/` (`PRODUCT.md`, `ARCHITECTURE.md`, `DECISIONS_AND_TRAPS.md`, `PROJECT_AGENTS.md`, `ci.yml`, `local-ci.ps1`) using whichever is newest between `%USERPROFILE%\.agent-templates\` and `https://github.com/Mostakim2005/agent-templates`.
- **Core Documentation Suite (`docs/` — Strictly Markdown-Native):** Never commit HTML guides into `docs/` (previews belong in root `preview/` per Path C). Maintain three core Markdown docs:
  - `docs/PRODUCT.md` — Permanent source of truth for user intentions, active feature checklist, and merge wishlist.
  - `docs/ARCHITECTURE.md` — Single living visual map: high-level system diagram, tech stack rationale, per-subsystem and per-feature color-coded Mermaid flowcharts (updated in place), and extension recipes.
  - `docs/DECISIONS_AND_TRAPS.md` — Architectural pivots (what failed, why we switched, `[DECIDED BY: HUMAN]` vs. `[DECIDED BY: AGENT]`) plus non-obvious engineering landmines. Never log trivial syntax/type fixes or routine setup steps.
- **Obsidian-Compatible Mermaid Visual Standard:** Every Mermaid diagram in `docs/` must render cleanly in both **Obsidian** and **GitHub** and include: (1) distinct `classDef` color coding + a **Legend / Explanation Box**, (2) clear directional arrows with labels (`start -> end`, input/output, parent -> child), and (3) a short plain-English explanation alongside it.
- **Project-Specific `AGENTS.md` Boundary:** A project root `AGENTS.md` must contain repository-specific facts only (repo classification, build/test commands, runtime versions, directory layout, and 1-line trap pointers). Never duplicate this master `AGENTS.md`.

## 4. Latest-State Sync, Repo Classification, Shared Libraries, GitHub-First CI/CD & Licensing
- **Latest-State Verification (Local PC vs. GitHub):** Before starting work, loading templates, or syncing, check `git remote -v`. If a GitHub remote exists (`https://github.com/Mostakim2005/<repo>`), compare the local workspace against GitHub, treat whichever has the newest changes as active truth, and reconcile without overwriting newer local work.
- **Non-Interactive Git Execution:** All Git operations must assume non-interactive execution (`GIT_TERMINAL_PROMPT=0`). Never hang waiting for credential prompts or passphrases; abort and report any auth/permission block immediately.
- **Repository, Workspace & Report Naming:** GitHub repositories use slugified lowercase (`kebab-case`, e.g., `novel-writing`, `music-manager`). Local working copies use clean `Title Case` with spaces (e.g., `Novel Writing`, `Music Manager`). Upstream forks (e.g., `DeepTutor`, `GaussBoard`) MUST preserve exact upstream casing and naming. All generated disposable or one-time Markdown reports, audits, and instruction sets (CI failures, Code Audits, UI/UX Audits, ad-hoc analyses, one-off fix/migration guides) bridge both conventions by using clean **Title Case**: `<Repo Title Case> - <Short Practical Topic>.md`.
- **Clean Modular Source & One-Time Archives:** Keep source files modular and single-responsibility, with strict `.gitignore` rules blocking dependencies, build outputs, binaries, and secrets. Archive/zip snapshots (e.g., `git archive`) are strictly one-time actions—never auto-refresh them on later commits unless explicitly asked.
- **Repo Classification — GitHub-First (Default) vs. Top-Secret Local-Only:**
  - **GitHub-Backed Repos (Remote Configured — Default):** Treat **GitHub Actions** (`.github/workflows/ci.yml`, bootstrapped from `templates/ci.yml`) as the authoritative runner for all verification layers: formatting/linting, static type checking, unit tests, integration tests, E2E/headless UI tests, security & secret scanning, build & smoke tests, and structure/doc checks. **Do NOT download heavy runtimes, bloated toolchains, or temp-file-heavy build dependencies onto the local PC.** Only run local checks when the required runtime is tiny/already installed and fast manual back-and-forth feedback is needed. Keep CD/release workflows strictly **tag-triggered (`vX.Y.Z`)**—package Windows desktop apps as **portable `.exe` binaries by default** (unless an installer is requested) and attach releases in the cloud rather than storing builds locally.
  - **Top-Secret Local-Only Repos (No Remote Configured):** If `git remote -v` returns no remote (ask the user to confirm if unsure), classify the project as **Top-Secret Local-Only**. **NEVER** create a GitHub repo, add a remote, push, or upload files/logs externally. For these repos, installing runtimes and running full verification locally via `local-ci.ps1` (bootstrapped from `templates/local-ci.ps1`) is explicitly authorized.
- **OS-Default vs. Shared Libraries Rule:** Always keep or install tools and runtimes that have a standard OS/runtime search path (CLI binaries on `PATH` / `%USERPROFILE%\.local\bin`, Python packages in `site-packages`, Java/SDK system defaults) in their default system locations so any app discovers them automatically.
- **Shared JS/WASM & Ecosystem Registry:** Store non-auto-discoverable offline assets (browser JS/WASM bundles like `katex`, `tesseract`, `mermaid`, `pdfjs`, `3dmol`) once in `%LOCALAPPDATA%\SharedLibraries` (`LOCAL_COMMON_LIBRARIES`), and resolve all local apps, ports, and toolchains from `%USERPROFILE%\.local\share\ecosystem-registry.json` (`LOCAL_ECOSYSTEM_REGISTRY`) before bundling duplicates or hardcoding paths. Whenever a new shared library or local service is added, update `libraries.json` and `ecosystem-registry.json` (UTF-8 without BOM).
- **Licensing & Third-Party Attribution:** Keep `LICENSE` strictly for **PolyForm Noncommercial 1.0.0**. Maintain upstream open-source credits in `THIRD_PARTY_NOTICES.md` as a Markdown table split into *"Ships inside the app"* and *"Build / test only — not shipped"* with links to upstream license texts.

## 5. UI/UX Standards, On-Demand Audits & Disposable Patch-Ready Report Routing
- **Visual Craft & Theme Contrast:** Maintain clean visual hierarchy, proportional spacing, calibrated color scales, and strict **WCAG AA/AAA contrast** across both Light and Dark themes without text- or icon-contrast inversions.
- **On-Demand Audit & UI/UX Instruction Routing (Keep Context Lean):** Never expect the user to attach audit guides manually. Retrieve the full instruction set on demand from `%USERPROFILE%\.agent-templates\` (or fall back to `https://github.com/Mostakim2005/agent-templates` if newer/absent locally):
  - **Code / Security / Performance / Architecture Audits:** Load `AUDITS.md` (`%USERPROFILE%\.agent-templates\AUDITS.md`) and follow its 15-module framework and Coverage Ledger rules.
  - **UI/UX & Parity Audits:** Load `UIUX.md` (`%USERPROFILE%\.agent-templates\UIUX.md`) and follow its platform-agnostic U1–U10 checklist and 3-Gate Feasibility Rubric.
- **Unified Disposable & Patch-Ready Markdown Report Standard (Mandatory for All One-Time Reports, Audits & Instruction Sets):**
  - **Destination, Naming & Repo Hygiene:** Whenever creating any one-time or disposable file meant to be used and deleted after an issue is fixed (CI failures, Code Audits, UI/UX Audits, ad-hoc bug/investigation reports, or one-off instruction sets/checklists), write it directly into **`%USERPROFILE%\Downloads\`** using clear, practical Title Case: `<Repo Title Case> - <Short Practical Topic>.md` (e.g., `Music Manager - CI Failure Report.md`, `GaussBoard - Code Audit.md`, `Note Toolbox - Export Fix Steps.md`). If a tool can only write inside the workspace, immediately move the file to `%USERPROFILE%\Downloads\` and delete the workspace copy—never leave or commit disposable reports or one-time instruction files inside the repository or `docs/`.
  - **Git-Patch Compatibility (All Disposable Outputs):** Every disposable report, audit, or instruction set MUST follow a structured git-patch-ready format so a frontier model can generate clean `.patch` files without guesswork: (1) Repository, branch, commit SHA, and workflow run URL (when from CI), (2) Coverage or Failure Ledger (when auditing or diagnosing CI failures), (3) exact `path/to/file.ext :: symbolName` anchors, (4) exact failing command/error logs, root cause, or triggering commit `git diff` excerpt (when applicable), and (5) concrete actionable fix, step sequence, or patch specification.

## 6. Mandatory Post-Change Protocol
Before **every** `git commit` (small fixes, refactors, features, or architectural changes):
1. **Pre-Commit Doc Sync Gate (Always Update Docs First):** Before staging or committing any change—regardless of size or Path A/B—check and update the relevant living documentation first (`docs/PRODUCT.md`, `docs/ARCHITECTURE.md` including visual Mermaid flows in place, `docs/DECISIONS_AND_TRAPS.md`, and root `AGENTS.md` / `README.md` if commands, layout, or traps changed), and include the doc updates in the same commit so code and docs never drift. Only skip doc edits if a commit is purely cosmetic with zero behavioral or structural impact, and still confirm the check ran in the Post-Change Report.
2. **Verify & Deliver (Branch by Repo Classification):**
   - **GitHub-Backed Repos (GitHub-First Gate):** Run lightweight local checks only if the runtime is already installed/tiny and rapid feedback is needed—otherwise skip local installs/builds. Commit clean source + doc changes and push to `https://github.com/Mostakim2005/<repo>` (never auto-bump versions or create `vX.Y.Z` tags unless explicitly instructed). Immediately monitor the triggered GitHub Actions run via GitHub CLI (`gh run list` / `gh run watch`).
     - **If any CI job fails:** Automatically download the CI failure report artifact (`gh run download <run-id> -n ci-failure-report -D "%USERPROFILE%\Downloads"`) so `<Repo Title Case> - CI Failure Report.md` lands directly in `%USERPROFILE%\Downloads\` (if the repo does not yet upload an artifact, generate the same Title Case patch-ready `.md` report into `%USERPROFILE%\Downloads\` from `gh run view <run-id> --log-failed` + `git show`). Report the failure and saved file path clearly.
   - **Top-Secret Local-Only Repos (No Remote):** Run `powershell -NoProfile -ExecutionPolicy Bypass -File .\local-ci.ps1` locally (never push). If any check fails, ensure the patch-ready failure report is saved to `%USERPROFILE%\Downloads\<Repo Title Case> - Local CI Failure Report.md`, then halt and fix or report before finalizing.
3. **Executive Report (Plain English + Rationale):** Reply with a 1-line status header followed by a concise topic-by-topic plain-English summary covering **what changed and why**. Omit raw file/function anchor lists in chat unless asked.

   **Required Post-Change Report Template:**
   ```markdown
   **Done — [Short Task Title]** (`<commit-hash>` pushed to `<branch>` | <checks passed or CI report saved>)
   * **[Topic 1]:** [What changed in plain English.] *Why:* [Brief rationale.]
   * **[Topic 2]:** [What changed in plain English.] *Why:* [Brief rationale.]
   * **Docs updated:** [1-line note on which `docs/` files were updated, or "None (checked — no doc impact)".]
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
*(All preferences up to 2026-11-22 have been consolidated into Sections 1–7. Append newly discovered preferences below.)*
