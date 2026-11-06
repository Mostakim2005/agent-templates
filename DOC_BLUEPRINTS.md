# Modular Documentation & Visual Guide Blueprints
**Referenced by `AGENTS.md`. Use these exact structures when creating or updating project documentation.**

---

## Core Formatting Rules for All Markdown Docs
1. **Self-Descriptive Headers + Synonym Aliases:**
   Every item in `PRODUCT.md`, `ARCHITECTURE.md`, and `DECISIONS_AND_TRAPS.md` MUST use this exact `###` header pattern so `grep` can match either the title or everyday synonyms:
   `### [TYPE: Descriptive-Name-With-Hyphens] | Aliases: synonym 1, synonym 2, keyword 3`
   *(Valid `TYPE` values: `FEATURE`, `WISHLIST`, `SUBSYSTEM`, `DECISION`, `TRAP`, `VERIFY`)*
2. **Mandatory 1-Line Summary on Line 2:**
   Immediately below every `###` header, place a blockquote summary on a single line:
   `> **1-Line Summary:** Plain-English summary of what this is and why it matters.`
   *(AI agents read this 1-line summary first via `grep -A 1 "^### \[" docs/` before deciding whether to read the rest of the section.)*
3. **Function/Variable Code Anchors Only:**
   Never write line numbers. Write: `` `path/to/file.ext` -> `functionName` / `variableName` ``.
4. **Keep Files Modular:**
   If any single doc file exceeds ~250 lines, split detailed sub-items into `docs/modules/<topic-name>.md` and keep the `### [TYPE: ...]` header + `> **1-Line Summary:**` + link in the main file.

---

## Template 1: `docs/PRODUCT.md` (User Intention & Feature Source of Truth)

```markdown
# Product Intent & Feature Map (`PRODUCT.md`)
> **1-Line Summary:** The permanent source of truth for what the user wants the app to do and feel like, independent of how the code is currently implemented.

## 1. Core Vision & User Experience Intent
* **What This App Does (Plain English):** [1-2 sentences]
* **How It Must Feel to Use:** [Key UX expectations, theme behavior, speed, offline capability]

## 2. Active Features (Do Not Break)

### [FEATURE: Descriptive-Feature-Name] | Aliases: everyday words, UI button name, related concept
> **1-Line Summary:** [What the user sees and does with this feature in one sentence.]
* **User Intention (Non-Negotiable):** [Why the user wanted this and how it must behave.]
* **Visual / UI Behavior:** [Where it lives on screen and how the user interacts with it.]
* **Code Anchors (Grep Targets):**
  * `src/path/file.ts` -> `mainFunctionName`, `stateVariableName`

## 3. Planned Features & App-Merge Wishlist

### [WISHLIST: Descriptive-Planned-Feature] | Aliases: future feature keywords
> **1-Line Summary:** [What we plan to build or merge from another app next.]
* **User Intention:** [Desired outcome]
* **Target Integration Point:** [Which existing subsystem it will connect to]