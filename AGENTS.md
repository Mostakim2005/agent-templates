# Universal Operating Protocol (`AGENTS.md`)
**MANDATORY FOR ALL AI CODING AGENTS**

## 1. User Profile, Agency & Voice-Dictation Decoder
- **High-Level Agency:** Operate with autonomous engineering judgment. Rely on high-level intent, architecture, and desired outcomes rather than waiting for micromanaged step-by-step CLI instructions.
- **South Asian Voice-Dictation Input:** Prompts are voice-typed by a South Asian English speaker. Expect phonetic mishearings, nasalized sound substitutions, repeated words, fillers, and fragmented phrasing. Silently ignore fillers, auto-correct likely mishearings from project context, and tolerate minor speech-to-text typos on NATO topic tags and option numbers (e.g., `brabo` -> `Bravo`, `to` -> `2`).

## 2. Instruction Triage & Modular Confirmation Gate
Before modifying files, triage the prompt into one of three paths:
- **Path A: Fast Path (Direct Execution):** For small tweaks, clear bug fixes, routine operations, or continuing an approved plan. State a 1-line assumption of intent and execute immediately.
- **Path B: Modular Topic-Based Confirmation Gate (New, Complex, or Ambiguous Tasks):** For new features, multi-step changes, architectural shifts, or ambiguous dictation where a wrong guess wastes work. Do NOT write code yet. Present a single executive agenda grouped by **topic** so everything about one topic stays inside one self-contained block (intent + questions/options together).
  - **Intent First, No Routine Impact Clutter:** Open each topic with `What I understood:` in plain English so the user can immediately verify alignment. Omit routine file-path/impact lists unless something could unexpectedly break.
  - **Explicit Question Types:** Label every prompt unambiguously as `[Pick One]`, `[Pick Any]`, `[Yes / No]`, or `[Confirm]` (when no choice is needed), with a simple plain-English explanation of each option.
  - **Voice-Safe NATO + Number Tagging:** Label topics using the NATO phonetic alphabet (`ALPHA`, `BRAVO`, `CHARLIE`, `DELTA`, `ECHO`, `FOXTROT` — always `BRAVO`, never `Beta`) and number options continuously inside each topic (`Bravo 1`, `Bravo 2`, `Bravo 3`, `Bravo 4`). Wait for confirmation before executing.

  **Required Path B Template:**
  ```markdown
  **ALPHA — [Short Topic Name]**
  * **What I understood:** [1–2 plain-English sentences restating the user's intent.]
  * **`[Yes / No]` — Alpha:** [Clear binary question in simple English?]

  **BRAVO — [Short Topic Name]**
  * **What I understood:** [1–2 plain-English sentences restating the user's intent.]
  * **`[Pick One]` — [Question in simple English?]**
    * **Bravo 1 *(recommended)*:** [Option name] — [Simple explanation of what this means in practice.]
    * **Bravo 2:** [Option name] — [Simple explanation of what this means in practice.]
  * **`[Pick Any]` — [Optional extras?]**
    * **Bravo 3:** [Option name] — [Simple explanation.]
    * **Bravo 4:** [Option name] — [Simple explanation.]

  **CHARLIE — [Short Topic Name]**
  * **What I understood:** [1–2 plain-English sentences restating the user's intent.]
  * **`[Confirm]` — Charlie:** No choices needed — confirm I read your intent right.
  ```

- **Path C: On-Demand Visual Preview Path (Strictly on Request):** Only generate visual previews when the user explicitly asks for a preview or visual example.
  - **UI/UX or Visual Changes:** Build an accurate, self-contained HTML preview using proper CSS and JavaScript (including Three.js or other needed web libraries for visual accuracy) inside a dedicated lowercase `preview/` folder located in the project root right beside `docs/` (never inside `docs/`). Name each file with a clear, short kebab-case reference to the feature (e.g., `preview/theme-toggle.html`, `preview/backup-scheduler.html`).
  - **Logic/Flow Changes:** Render an Obsidian-compatible Mermaid flowchart following the Section 3 visual diagram standard.
  - **File/System Operations:** Present a Before -> After Action Table (`Target | Action | Outcome`).

## 3. Progressive Search-First Documentation & Visual Markdown Standard
- **Search-First Discovery (Protect Context):** Never bulk-read the entire documentation folder on startup and never create an `INDEX.md` file. Every documentation section must use a descriptive slug header with natural-language aliases (`### [TYPE: Descriptive-Slug] | Aliases: ...`) followed immediately by a single-line `> **1-Line Summary:**`. Scan headers and 1-line summaries first; read full sections only when relevant to the active task.
- **Function/Symbol Anchors Only:** Never use line numbers as code anchors. Reference file paths paired with exact function, class, or variable names.
- **Template Resolution:** Load documentation blueprints using the newest version resolved via Section 4 (Latest-State Sync) between `C:\Users\kazir\.agent-templates\` and `https://github.com/Mostakim2005/agent-templates`.
- **Core Documentation Suite (`docs/` — Strictly Markdown-Native):** Never commit HTML guides into `docs/` (interactive visual previews belong strictly in root `preview/` per Path C). Maintain four core Markdown docs:
  - `docs/PRODUCT.md` — Permanent source of truth for user intentions, active feature checklist, and merge wishlist.
  - `docs/ARCHITECTURE.md` — High-level system map, tech stack rationale, subsystem mechanics, and extension recipes.
  - `docs/DECISIONS_AND_TRAPS.md` — Architectural pivots (what failed, why we switched, and `[DECIDED BY: HUMAN]` vs. `[DECIDED BY: AGENT]`) plus non-obvious engineering landmines. Never log trivial syntax/type fixes or routine setup steps.
  - `docs/VISUAL_LOG.md` — Per-feature and per-commit visual Mermaid flowcharts with plain-English explanations so changes can be understood visually at a glance.
- **Obsidian-Compatible Mermaid Visual Standard:** Every Mermaid diagram in `docs/` must render cleanly in both **Obsidian** and **GitHub**, and must include:
  1. **Color Coding + Legend Box:** Distinct `classDef` colors paired with a Legend / Explanation Box explaining what each color represents.
  2. **Clear Arrow Directionality & Labels:** Explicit arrows showing start -> end, input/output flow, and parent -> child relationships.
  3. **Plain-English Explanation:** A short, jargon-free explanation alongside the diagram describing what is happening in simple terms.
- **Project-Specific `AGENTS.md` Boundary:** A project-level `AGENTS.md` file (in a project root) must contain repository-specific facts only (build/test commands, runtime versions, repo directory layout, and unique traps). It must NEVER duplicate or restate this master `AGENTS.md`.

## 4. Latest-State Sync, GitHub (`Mostakim2005`), Builds & Licensing
- **Latest-State Verification (Local PC vs. GitHub):** The user may make local edits and forget to push, or update GitHub from another session. Before starting work, loading templates, or syncing, always compare the local workspace (including `C:\Users\kazir\.agent-templates\`) against `https://github.com/Mostakim2005` (one dedicated public repo per project), treat whichever has the newest changes as active truth, and reconcile without overwriting newer local work.
- **Non-Interactive Git Execution:** All Git operations must assume non-interactive terminal execution (`GIT_TERMINAL_PROMPT=0`). Never hang waiting for interactive credential prompts or passphrases; if an authentication or permission error occurs, abort and report the block immediately.
- **Repository & Local Workspace Naming Convention:** GitHub repositories must use slugified lowercase (`kebab-case`, e.g., `novel-writing`, `music-manager`, `clipboard-manager`). Local working copies in development directories use clean `Title Case` with spaces (e.g., `Novel Writing`, `Music Manager`). Upstream forks (tracking upstream remotes, e.g., `DeepTutor`, `GaussBoard`) MUST preserve exact upstream casing and naming.
- **Clean Modular Source Only:** Keep source files modular and single-responsibility. Enforce strict `.gitignore` rules to block dependencies, build outputs, binaries, and secret environment files—never commit heavy binaries or credentials.
- **Tag-Triggered Cloud Builds:** Package Windows desktop apps as **portable `.exe` binaries by default** (unless an installer is explicitly requested). Use GitHub Actions workflows triggered by version tags to compile and attach portable releases in the cloud rather than storing builds locally.
- **Licensing & Third-Party Attribution:** Keep `LICENSE` strictly for **PolyForm Noncommercial 1.0.0**. Maintain all upstream open-source credits (MIT, Apache, etc.) in `THIRD_PARTY_NOTICES.md` formatted as a clean Markdown table split into *"Ships inside the app"* and *"Build / test only — not shipped"* with links to upstream license texts.

## 5. UI/UX & Accessibility Standards
- **Visual Craft & Theme Contrast:** Maintain clean visual hierarchy, proportional spacing, calibrated color scales, and strict **WCAG AA/AAA contrast** across both Light and Dark themes without text- or icon-contrast inversions.

## 6. Mandatory Post-Change Protocol
After completing any feature, architectural change, or significant fix:
1. **Verify:** Run the project's automated build, type, lint, and verification checks. **Verification Gate:** If any check fails, do NOT commit or push. Halt, fix or revert the issue, and re-verify before proceeding.
2. **Sync Docs:** Update `docs/PRODUCT.md`, `docs/ARCHITECTURE.md`, `docs/DECISIONS_AND_TRAPS.md`, and `docs/VISUAL_LOG.md` whenever intent, architecture, traps, or visual feature flows change (following the Section 3 Obsidian-compatible color-coded Mermaid standard).
3. **Commit & Push (No Auto-Releases):** Commit clean source and documentation changes and push to the project's default `https://github.com/Mostakim2005` repository. **Do NOT** bump version numbers, create git version tags (`vX.Y.Z`), or trigger release workflows automatically—only tag and release when the user explicitly instructs.
4. **Executive Report (Plain English + Rationale):** Reply with a 1-line status header (commit hash, branch, and checks passed) followed by a concise topic-by-topic plain-English summary covering **what changed and why (rationale)**. Omit raw file/function anchor lists in chat unless explicitly asked.

   **Required Post-Change Report Template:**
   ```markdown
   **Done — [Short Task Title]** (`<commit-hash>` pushed to `<branch>` | <checks passed>)
   * **[Topic 1]:** [What changed in plain English.] *Why:* [Brief rationale for the fix or approach.]
   * **[Topic 2]:** [What changed in plain English.] *Why:* [Brief rationale.]
   * **Docs updated:** [1-line note on which `docs/` files were updated.]
   ```

## 7. Dynamic Preference Routing & Master Sync Protocol
- **On-Demand Sync Architecture:** All synchronization workflows (master `AGENTS.md` multi-harness replication and repository mirrors) operate strictly on-demand via:
  `powershell -ExecutionPolicy Bypass -File C:\Users\kazir\.agent-templates\sync-all.ps1`
  Never run persistent background watchers, polling daemons, or scheduled tasks to avoid console pop-ups, CPU spikes, or phantom process alerts.
- **Semantic Scope Analysis (No Hardcoded Triggers):** When instructed to update `AGENTS.md` or when a new preference is stated, route it by semantic scope:
  - **Project-Specific (Local `./AGENTS.md`):** Rules coupled to a single project's tech stack, libraries, build scripts, directory layout, or domain logic go into that project's root `./AGENTS.md`.
  - **Universal / Cross-Project (Master `AGENTS.md`):** General coding standards, workflow discipline, tool behavior, or universal preferences go into master `C:\Users\kazir\.agent-templates\AGENTS.md` Section 8 as `- [PREF: Descriptive-Slug | YYYY-MM-DD | Category] Plain-English rule.`, followed by running the on-demand `sync-all.ps1` command above.
  - **Ambiguous / Borderline:** Record into the project's `./AGENTS.md` first, then ask in 1 line: *"Recorded in project AGENTS.md. Promote to global master AGENTS.md?"*
- **Cross-Project Consolidation:** When instructed, consolidate accumulated Section 8 entries into Sections 1–7 across local and master repositories.

## 8. Live User Preferences (Auto-Captured)
*(All preferences up to 2026-11-19 have been consolidated into Sections 1–7. Append newly discovered preferences below.)*
- [PREF: One-Time-Git-Archive-Snapshots | 2026-11-20 | Git & Workflow] Archive requests (e.g., git archive / zip creation) are strictly one-time actions. Never automatically re-create, update, or refresh archive files on subsequent commits or tasks unless explicitly instructed by the user.
