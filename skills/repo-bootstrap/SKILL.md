---
name: repo-bootstrap
description: >-
  Scaffolds a new project or upgrades an existing repository to the standard .agent-templates
  architecture: classifies GitHub-First vs. Top-Secret Local-Only, initializes interconnected
  docs/ (PRODUCT.md, ARCHITECTURE.md, DECISIONS_AND_TRAPS.md), root AGENTS.md, CI or local-ci.ps1,
  PolyForm Noncommercial LICENSE, THIRD_PARTY_NOTICES.md, and .gitignore. Use when creating a new
  repo, standardizing an existing project's docs/CI, or setting up project templates.
---

# Repository Bootstrap & Template Upgrade Skill (`repo-bootstrap`)

Scaffolds or upgrades any repository using the canonical templates in `%USERPROFILE%\.agent-templates\templates\`.

## Step-by-Step Procedure

1. **Classify Repository Mode (Never Guess on No-Remote Repos):**
   - Run `GIT_TERMINAL_PROMPT=0 git remote -v`.
   - **GitHub-Backed (`https://github.com/Mostakim2005/<repo>` present):** Use `.github/workflows/ci.yml` from `%USERPROFILE%\.agent-templates\templates\ci.yml`. Naming: `kebab-case` on GitHub, `Title Case` with spaces locally, or exact upstream casing for forks (`DeepTutor`, `GaussBoard`).
   - **Top-Secret Local-Only (No Remote):** Confirm with the user if unsure; **NEVER** create a GitHub repo, add a remote, or push externally. Copy `%USERPROFILE%\.agent-templates\templates\local-ci.ps1` to repo root instead of `.github/workflows/`.

2. **Scaffold Interconnected `docs/` & Root `AGENTS.md` (Skip Existing Files Unless Upgrading):**
   - Copy starter templates from `%USERPROFILE%\.agent-templates\templates\`:
     - `PRODUCT.md` -> `docs/PRODUCT.md` (`[FEATURE]` with `Links:` + `Verified By:`, `[WISHLIST]`)
     - `ARCHITECTURE.md` -> `docs/ARCHITECTURE.md` (`[SUBSYSTEM]` & `[FLOW]` with Obsidian/GitHub Mermaid diagrams + canonical `Code Anchors` using `path/to/file.ext :: symbolName`)
     - `DECISIONS_AND_TRAPS.md` -> `docs/DECISIONS_AND_TRAPS.md` (`[DECISION]` pivots/waivers & `[TRAP]` `Protected Code Anchors`)
     - `PROJECT_AGENTS.md` -> `./AGENTS.md` (repo-specific stack, exact `Project Name`, commands, layout, and 1-line `[TRAP: <Slug>]` pointers; never duplicate master `AGENTS.md`)

3. **Licensing, Third-Party Attribution & `.gitignore` Hygiene:**
   - Copy `%USERPROFILE%\.agent-templates\LICENSE` (**PolyForm Noncommercial 1.0.0**) for original projects (preserve upstream license on forks).
   - Create/update `THIRD_PARTY_NOTICES.md` with two Markdown tables (*"Ships inside the app"* and *"Build / test only — not shipped"*) linking to upstream licenses, plus check `%LOCALAPPDATA%\SharedLibraries` (`libraries.json`) and `%USERPROFILE%\.local\share\ecosystem-registry.json` before bundling shared JS/WASM assets or choosing ports.
   - Ensure `.gitignore` excludes dependencies, build artifacts, `.exe` binaries, secrets/env files, `.ci-logs/`, and `.ci-report/`. All JSON/MD/YAML/PS1 files must be written as **UTF-8 without BOM**.

4. **Wire Verification Stages & Validate Doc/Anchor Parity:**
   - Populate stack commands in root `AGENTS.md` Section 2 and wire them into `.github/workflows/ci.yml` Stages 1–8 (or `local-ci.ps1` Stages 01–07).
   - Leave Stage 8/9 (`Structure, UTF-8 & Doc/Anchor Parity Checks`) enabled so UTF-8 no-BOM, `### [TYPE: Slug] | Aliases:` + `> **1-Line Summary:**`, cross-links, and live `path :: symbol` anchors are verified automatically.
