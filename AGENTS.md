# Universal Operating Protocol (`AGENTS.md`)
**MANDATORY FOR ALL AI CODING AGENTS**

## 1. User Profile, Agency & Voice-Dictation Decoder
- **High-Level Agency:** Operate with autonomous engineering judgment. Rely on high-level intent, architecture, and desired outcomes rather than waiting for micromanaged step-by-step CLI instructions.
- **South Asian Voice-Dictation Input:** Prompts are voice-typed by a South Asian English speaker. Expect phonetic mishearings, nasalized sound substitutions, repeated words, fillers, and fragmented phrasing. Silently ignore fillers and auto-correct likely mishearings from project context.

## 2. Instruction Triage & Numbered Confirmation Gate
Before modifying files, triage the prompt into one of three paths:
- **Path A: Fast Path (Direct Execution):** For small tweaks, clear bug fixes, routine operations, or continuing an approved plan. State a 1-line assumption of intent and execute immediately.
- **Path B: Intent Confirmation Gate (New, Complex, or Ambiguous Tasks):** For new features, multi-step changes, architectural shifts, or ambiguous dictation where a wrong guess wastes work. Do NOT write code yet. Output ONLY a structured Intent Rephrase using numbered/lettered tags so the user can reply easily by voice (e.g., *"1 is yes, for 2 pick B"*):
  - **`[1] Core Goal:`** 1–2 sentences on the intended outcome.
  - **`[2] Clarifications / Options (if needed):`** Concrete choices labeled `[2A]`, `[2B]`, `[2C]` with brief plain-English trade-offs.
  - **`[3] Planned Impact:`** Bullet list of user-visible features or files affected.
  - **Wait:** Stop and wait for approval before executing.
- **Path C: Visual Preview Path (On Request):** When the user asks for an example, preview, or how a change will look:
  - **UI/UX Changes:** Generate a self-contained HTML/SVG visual mock or wireframe showing Before vs. After.
  - **Logic/Flow Changes:** Render a Mermaid flowchart of the user or data flow.
  - **File/System Operations:** Present a Before -> After Action Table (Target | Action | Outcome).

## 3. Progressive Search-First Documentation & Markdown Visuals
- **Search-First Discovery (Protect Context):** Never bulk-read the entire documentation folder on startup and never create an `INDEX.md` file. Every documentation section must use a descriptive slug header with natural-language aliases (`### [TYPE: Descriptive-Slug] | Aliases: ...`) followed immediately by a single-line `> **1-Line Summary:**`. Scan headers and 1-line summaries first; read full sections only when relevant to the active task.
- **Function/Symbol Anchors Only:** Never use line numbers as code anchors. Reference file paths paired with exact function, class, or variable names.
- **Template Resolution (GitHub vs. Local Fallback):** Load documentation blueprints from the master `agent-templates` repository on `https://github.com/Mostakim2005` or the local fallback directory `C:\Users\kazir\.agent-templates\`—always checking both and using whichever exists or has the latest modifications.
- **Core Documentation Suite (`docs/`):**
  - `PRODUCT.md` — Permanent source of truth for user intentions, active feature checklist, and merge wishlist.
  - `ARCHITECTURE.md` — Visual Mermaid diagrams (rendered natively in GitHub and Obsidian), tech stack rationale, subsystem mechanics, and extension recipes.
  - `DECISIONS_AND_TRAPS.md` — Architectural pivots (what failed, why we switched, and whether `[DECIDED BY: HUMAN]` or `[DECIDED BY: AGENT]`) plus non-obvious engineering landmines, incorporating inline Mermaid comparisons. Never log trivial syntax/type fixes or routine setup steps.
- **Markdown-Native Visual Docs (No HTML Guides):** Standardize documentation strictly to Markdown (`PRODUCT.md`, `ARCHITECTURE.md`, `DECISIONS_AND_TRAPS.md`) with native inline Mermaid diagrams. Never create or maintain separate `VISUAL_GUIDE.html` files to eliminate redundant HTML maintenance and token consumption.
- **Project-Specific `AGENTS.md` Boundary:** A project-level `AGENTS.md` file (in a project root) must contain repository-specific facts only (build/test commands, runtime versions, repo directory layout, and unique traps). It must NEVER duplicate or restate the master `AGENTS.md` profile, triage gate, documentation format, or master sync protocols.

## 4. Latest-State Sync, GitHub (`Mostakim2005`), Builds & Licensing
- **Latest-State Verification (Local PC vs. GitHub):** The user may make local edits and forget to push, or update GitHub from another session. Before starting work or syncing, always compare the local project workspace (and `C:\Users\kazir\.agent-templates\`) against `https://github.com/Mostakim2005` (one dedicated public repo per project), treat whichever has the newest changes as the active truth, and reconcile them without overwriting newer local work.
- **Non-Interactive Git Execution:** All Git operations must assume non-interactive terminal execution (`GIT_TERMINAL_PROMPT=0`). Never hang waiting for interactive credential prompts or passphrases; if an authentication or permission error occurs, abort and report the block immediately.
- **Repository & Local Workspace Naming Convention:** GitHub repositories must use slugified lowercase (`kebab-case`, e.g., `novel-writing`, `music-manager`, `clipboard-manager`) to comply with standard GitHub URL conventions and prevent cross-platform casing desync. Local working copies in development directories (e.g., `Agentic Harness`) use clean Title Case with spaces (`Title Case`, e.g., `Novel Writing`, `Music Manager`, `Clipboard Manager`). Upstream forks (repositories tracking upstream remotes, e.g., `DeepTutor`, `GaussBoard`) MUST preserve their exact upstream casing and naming so upstream merges and PR syncs remain frictionless.
- **Clean Modular Source Only:** Keep source files modular and single-responsibility. Enforce strict `.gitignore` rules to block dependencies, build outputs, binaries, and secret environment files—never commit heavy binaries or credentials.
- **Tag-Triggered Cloud Builds:** Package Windows desktop apps as **portable `.exe` binaries by default** (unless an installer is explicitly requested). Use GitHub Actions workflows triggered by version tags to compile and attach portable releases in the cloud rather than storing builds locally.
- **Licensing & Third-Party Attribution:** Keep `LICENSE` strictly for **PolyForm Noncommercial 1.0.0**. Maintain all upstream open-source credits (MIT, Apache, etc.) in `THIRD_PARTY_NOTICES.md` formatted as a clean Markdown table split into *"Ships inside the app"* and *"Build / test only — not shipped"* with links to upstream license texts.
- **UI/UX & Accessibility:** Maintain clean visual hierarchy, proportional spacing, calibrated color scales, and strict WCAG AA/AAA contrast across both Light and Dark themes without text-contrast inversions.

## 5. Mandatory Post-Change Protocol
After completing any feature, architectural change, or significant fix:
1. **Verify:** Run the project's automated build, type, lint, and verification checks. **Verification Gate:** If any check fails, do NOT commit or push. Halt, fix or revert the issue, and re-verify before proceeding.
2. **Sync Docs:** Update `PRODUCT.md`, `ARCHITECTURE.md`, and `DECISIONS_AND_TRAPS.md` whenever intent, architecture, or traps change (maintaining inline Mermaid diagrams for native visual rendering in Obsidian and GitHub).
3. **Commit & Push:** Commit clean source and documentation changes and push to the project's `https://github.com/Mostakim2005` repository.
4. **Report:** Summarize the commit hash/status, plain-English rationale, modified file/function anchors, and verification results.

## 6. Dynamic Preference Routing & Master Sync Protocol
- **On-Demand Sync Architecture:** All synchronization workflows (master `AGENTS.md` multi-harness replication and repository mirrors) operate strictly on-demand via direct script execution or agent invocation (`powershell -ExecutionPolicy Bypass -File C:\Users\kazir\.agent-templates\sync-all.ps1`). Never run persistent background watchers, polling daemons, or scheduled tasks to avoid console pop-ups, CPU spikes, or phantom process alerts.
- **Semantic Scope Analysis (No Hardcoded Triggers):** When instructed to update `AGENTS.md` or when a new preference or way of doing things is stated, dynamically analyze the semantic scope rather than relying on keywords or rigid persona rules:
  - **Project-Specific (Local `./AGENTS.md`):** If the rule is coupled to this project's specific tech stack, local libraries, build scripts, directory layout, or domain business logic, record it into the project root `./AGENTS.md`.
  - **Universal / Cross-Project (Master `AGENTS.md`):** If the rule represents a general coding standard, workflow discipline, tool behavior, or universal preference applying across multiple codebases, record it into master `C:\Users\kazir\.agent-templates\AGENTS.md` Section 7 as `- [PREF: Descriptive-Slug | YYYY-MM-DD | Category] Plain-English rule.`, then trigger on-demand sync via `powershell -ExecutionPolicy Bypass -File C:\Users\kazir\.agent-templates\sync-all.ps1` to replicate across harnesses and push to GitHub.
  - **Ambiguous / Borderline:** Record into the project's `./AGENTS.md` first, then offer a quick 1-line confirmation: *"Recorded in project AGENTS.md. Promote to global master AGENTS.md?"*
- **Cross-Project Consolidation:** When instructed, consolidate accumulated Section 7 entries into Sections 1–5 across local and master repositories.

## 7. Live User Preferences (Auto-Captured)
*(All preferences up to 2026-11-07 have been consolidated into Sections 1–6. Append newly discovered preferences below.)*
- [PREF: Bump-Version-And-Git-Tag | 2026-11-13 | Release-Workflow] Before committing or packaging builds after feature changes or fixes, bump the project version (e.g., `package.json`, app metadata, and artifact version strings) and create an annotated git version tag (`vX.Y.Z`, pushing tags when a remote exists) so each build and code change is clearly distinguishable.
