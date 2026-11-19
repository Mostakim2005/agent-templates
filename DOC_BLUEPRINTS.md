# Modular Documentation & Visual Guide Blueprints
**Referenced by `AGENTS.md`. Use these shared formatting rules and standalone templates when creating or updating project documentation.**

---

## 1. Core Formatting Rules for All Markdown Docs
1. **Self-Descriptive Headers + Synonym Aliases:**
   Every item in `PRODUCT.md`, `ARCHITECTURE.md`, `DECISIONS_AND_TRAPS.md`, and `VISUAL_LOG.md` MUST use this exact `###` header pattern so `grep` can match either the title or everyday synonyms:
   `### [TYPE: Descriptive-Name-With-Hyphens] | Aliases: synonym 1, synonym 2, keyword 3`
   *(Valid `TYPE` values: `FEATURE`, `WISHLIST`, `SUBSYSTEM`, `DECISION`, `TRAP`, `VISUAL`)*
2. **Mandatory 1-Line Summary on Line 2 (No Blank Line):**
   Place the blockquote summary immediately on the very next line below every `###` header—never insert a blank line between them:
   `> **1-Line Summary:** Plain-English summary of what this is and why it matters.`
   *(AI agents read this first via `grep -A 1 "^### \[" docs/` before deciding whether to read the rest of the section.)*
3. **Obsidian-Compatible Color-Coded Mermaid Standard:**
   Every Mermaid diagram must render cleanly in Obsidian and GitHub and include:
   - Explicit `classDef` color coding + a **Legend / Explanation Box** defining what each color represents.
   - Directional arrows with labels showing start -> end, inputs/outputs, and parent -> child relationships.
   - A simple, plain-English explanation right beside the diagram.
4. **Function/Variable Code Anchors Only:**
   Never write line numbers. Write: `` `path/to/file.ext` -> `functionName` / `variableName` ``.
5. **Keep Files Modular:**
   If any single doc file exceeds ~250 lines, split detailed sub-items into `docs/modules/<topic-name>.md` and keep the `### [TYPE: ...]` header + `> **1-Line Summary:**` + link in the main file.

---

## 2. Standalone Documentation Templates (Single Source of Truth)
Load each blueprint directly from its standalone file in `agent-templates` rather than duplicating template bodies here:
* **`PRODUCT.md`** -> `docs/PRODUCT.md` (User intention, active feature map, and merge wishlist)
* **`ARCHITECTURE.md`** -> `docs/ARCHITECTURE.md` (High-level system map, tech stack rationale, core subsystems, and extension recipes)
* **`DECISIONS_AND_TRAPS.md`** -> `docs/DECISIONS_AND_TRAPS.md` (Architectural pivots and full do-not-touch engineering landmine explanations)
* **`VISUAL_LOG.md`** -> `docs/VISUAL_LOG.md` (Per-feature and per-commit color-coded Mermaid flowcharts with plain-English walkthroughs)

---

## 3. Project-Specific `AGENTS.md` Template (Repository Facts Only)
> **1-Line Summary:** Local repository instructions defining build commands, local architecture, and 1-line trap pointers without duplicating the master protocol.

```markdown
# Project Operating Instructions (`AGENTS.md`)
> **Notice:** This project inherits user persona, confirmation gates, visual standards, and documentation blueprints from the global master `AGENTS.md`. Do not duplicate those rules here.

## 1. Project Tech Stack & Environment
* **Runtime / Language:** [e.g., Node.js v20+, TypeScript 5+, Electron 30]
* **Framework / Host:** [e.g., Vue 3 + Tailwind CSS]
* **Target OS / Build Output:** [e.g., Windows x64 portable .exe]

## 2. Mandatory Verification & Build Commands
* **Type Check:** `npm run typecheck`
* **Lint:** `npm run lint`
* **Test Suite:** `npm test`
* **Build / Package:** `npm run build`

## 3. Repository Directory Structure & Conventions
* `src/` - Modular source files. Single-responsibility modules only.
* `docs/` - Core Markdown documentation suite (`PRODUCT.md`, `ARCHITECTURE.md`, `DECISIONS_AND_TRAPS.md`, `VISUAL_LOG.md`).
* `preview/` - On-demand interactive HTML/CSS/JS visual previews (e.g., `preview/theme-toggle.html`), kept beside `docs/` and created only when explicitly requested.

## 4. Critical Trap Pointers (1-Line Warnings Only)
*(Keep only quick 1-line stop signs here; write the full explanation and code anchors in `docs/DECISIONS_AND_TRAPS.md`.)*
* **TRAP 1:** [1-line warning — see `docs/DECISIONS_AND_TRAPS.md` -> `[TRAP: Descriptive-Trap-Name]`]
```
