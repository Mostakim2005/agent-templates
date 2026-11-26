# Project Operating Instructions (`AGENTS.md`)
> **Notice:** This project inherits user profile, confirmation gates, OS-default vs. Shared Libraries/Ecosystem Registry rules, GitHub-first CI/CD defaults, Top-Secret Local-Only rules, closed-loop `AUDITS.md`/`UIUX.md` and `Downloads\` report routing, pre-commit doc sync, and visual/doc standards from master `AGENTS.md`. Do not duplicate those rules here.

## 1. Repository Classification & Tech Stack
* **Project Name:** [Repo Title Case — or exact upstream casing for forks, e.g., DeepTutor]
* **Verification Mode:** `[GitHub-First (Remote Configured)]` *(or `[Top-Secret Local-Only — NO REMOTE, run local-ci.ps1 only]`)*
* **Runtime / Language:** [e.g., Node.js v20+, TypeScript 5+, Electron 30]
* **Framework / Host:** [e.g., Vue 3 + Tailwind CSS]
* **Target OS / Build Output:** [e.g., Windows x64 portable .exe]
* **Shared Libraries & Local Ports:** [None, or list shared JS/WASM assets from `%LOCALAPPDATA%\SharedLibraries` (`LOCAL_COMMON_LIBRARIES`) and local services/ports in `%USERPROFILE%\.local\share\ecosystem-registry.json` (`LOCAL_ECOSYSTEM_REGISTRY`)]

## 2. Verification & Build Commands (Mirrored in CI)
*(GitHub-backed repos run these in `.github/workflows/ci.yml` on push/PR without installing heavy local toolchains. Top-Secret Local-Only repos wire these into `local-ci.ps1`.)*
* **Format & Lint:** `npm run lint`
* **Static Type Check:** `npm run typecheck`
* **Unit Tests:** `npm run test:unit`
* **Integration Tests:** `npm run test:integration`
* **E2E / UI Tests:** `npm run test:e2e`
* **Security & Secret Scan:** `npm audit --audit-level=high`
* **Build & Smoke Test:** `npm run build`
* **Structure & Doc Parity:** Built-in Stage 8/9 check in `ci.yml` / `local-ci.ps1` (UTF-8 no-BOM, doc headers, `[TYPE: Slug]` cross-links, and live `path :: symbol` anchors)

## 3. Repository Directory Structure & Conventions
* `.github/workflows/` — GitHub Actions CI/CD (`ci.yml` on push/PR with patch-ready failure report artifact; tag-triggered `release.yml` for `vX.Y.Z` builds).
* `local-ci.ps1` — *(Top-Secret Local-Only repos only)* Local Windows verification runner saving patch-ready failure reports to `%USERPROFILE%\Downloads\`.
* `src/` — Modular single-responsibility source files.
* `docs/` — Interconnected Markdown suite (`PRODUCT.md`, `ARCHITECTURE.md`, `DECISIONS_AND_TRAPS.md`). Scan via `grep -A 1 "^### \[" docs/`.
* `preview/` — On-demand HTML/CSS/JS visual previews (e.g., `preview/theme-toggle.html`), created beside `docs/` only when requested.

## 4. Critical Trap Pointers (1-Line Warnings Only)
*(Key directly by `[TRAP: <Slug>]`; put full rationale and `Protected Code Anchors` in `docs/DECISIONS_AND_TRAPS.md`.)*
* **`[TRAP: Descriptive-Trap-Name]`:** [1-line stop sign — see `docs/DECISIONS_AND_TRAPS.md`]
