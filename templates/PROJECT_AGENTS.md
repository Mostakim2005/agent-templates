# Project Operating Instructions (`AGENTS.md`)
> **Notice:** This project inherits user persona, confirmation gates, GitHub-first CI/CD defaults, Top-Secret Local-Only rules, on-demand `AUDITS.md`/`UIUX.md` routing, visual standards, and documentation blueprints from the global master `AGENTS.md`. Do not duplicate those rules here.

## 1. Repository Classification & Tech Stack
* **Verification Mode:** `[GitHub-First (Remote Configured)]` *(or `[Top-Secret Local-Only — NO REMOTE, run local-ci.ps1 only]`)*
* **Runtime / Language:** [e.g., Node.js v20+, TypeScript 5+, Electron 30]
* **Framework / Host:** [e.g., Vue 3 + Tailwind CSS]
* **Target OS / Build Output:** [e.g., Windows x64 portable .exe]

## 2. Verification & Build Commands (Mirrored in CI)
*(For GitHub-backed repos, these run automatically in `.github/workflows/ci.yml` on push/PR; do not install heavy runtimes locally. For Top-Secret Local-Only repos, wire these into `local-ci.ps1`.)*
* **Format & Lint:** `npm run lint`
* **Static Type Check:** `npm run typecheck`
* **Unit Tests:** `npm run test:unit`
* **Integration Tests:** `npm run test:integration`
* **E2E / UI Tests:** `npm run test:e2e`
* **Security & Secret Scan:** `npm audit --audit-level=high`
* **Build & Smoke Test:** `npm run build`
* **Structure & Doc Checks:** `npm run check:docs`

## 3. Repository Directory Structure & Conventions
* `.github/workflows/` - Default GitHub Actions CI/CD workflows (`ci.yml` on push/PR with automatic patch-ready failure report artifact; tag-triggered `release.yml` for `vX.Y.Z` builds).
* `local-ci.ps1` - *(Top-Secret Local-Only repos only)* Local Windows verification runner emitting patch-ready failure reports directly to `%USERPROFILE%\Downloads\`.
* `src/` - Modular source files. Single-responsibility modules only.
* `docs/` - Core Markdown documentation suite (`PRODUCT.md`, `ARCHITECTURE.md`, `DECISIONS_AND_TRAPS.md`). Scan with `grep -A 1 "^### \[" docs/`.
* `preview/` - On-demand interactive HTML/CSS/JS visual previews (e.g., `preview/theme-toggle.html`), kept beside `docs/` and created only when explicitly requested.

## 4. Critical Trap Pointers (1-Line Warnings Only)
*(Keep only quick 1-line stop signs here; write the full explanation and code anchors in `docs/DECISIONS_AND_TRAPS.md`.)*
* **TRAP 1:** [1-line warning — see `docs/DECISIONS_AND_TRAPS.md` -> `[TRAP: Descriptive-Trap-Name]`]
