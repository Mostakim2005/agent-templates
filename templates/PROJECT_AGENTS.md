# Project Operating Instructions (`AGENTS.md`)
> **Notice:** This project inherits user persona, confirmation gates, GitHub Actions CI/CD defaults, visual standards, and documentation blueprints from the global master `AGENTS.md`. Do not duplicate those rules here.

## 1. Project Tech Stack & Environment
* **Runtime / Language:** [e.g., Node.js v20+, TypeScript 5+, Electron 30]
* **Framework / Host:** [e.g., Vue 3 + Tailwind CSS]
* **Target OS / Build Output:** [e.g., Windows x64 portable .exe]

## 2. Mandatory Verification & Build Commands (Mirrored in GitHub Actions)
*(These commands run automatically in `.github/workflows/ci.yml` on every push and pull request.)*
* **Type Check:** `npm run typecheck`
* **Lint:** `npm run lint`
* **Test Suite:** `npm test`
* **Build / Package:** `npm run build`

## 3. Repository Directory Structure & Conventions
* `.github/workflows/` - Default GitHub Actions CI/CD workflows (`ci.yml` on push/PR for lint, typecheck, tests, and build; tag-triggered `release.yml` for `vX.Y.Z` builds).
* `src/` - Modular source files. Single-responsibility modules only.
* `docs/` - Core Markdown documentation suite (`PRODUCT.md`, `ARCHITECTURE.md`, `DECISIONS_AND_TRAPS.md`). Scan with `grep -A 1 "^### \[" docs/`.
* `preview/` - On-demand interactive HTML/CSS/JS visual previews (e.g., `preview/theme-toggle.html`), kept beside `docs/` and created only when explicitly requested.

## 4. Critical Trap Pointers (1-Line Warnings Only)
*(Keep only quick 1-line stop signs here; write the full explanation and code anchors in `docs/DECISIONS_AND_TRAPS.md`.)*
* **TRAP 1:** [1-line warning — see `docs/DECISIONS_AND_TRAPS.md` -> `[TRAP: Descriptive-Trap-Name]`]
