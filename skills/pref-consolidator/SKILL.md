---
name: pref-consolidator
description: >-
  Extracts, deduplicates, and consolidates Section 8 live user preferences (- [PREF: ...]) across
  master AGENTS.md and all 7 agent harnesses using extract-prefs.ps1, folds universal rules cleanly
  into Sections 1-7 without duplicating clauses, and syncs all harnesses, skills, and GitHub via
  sync-all.ps1. Use when the user asks to extract preferences, review or consolidate Section 8,
  promote rules to global AGENTS.md, or sync agent harnesses.
---

# Section 8 Preference Extraction & Consolidation Skill (`pref-consolidator`)

Manages cross-harness preference rescue, deduplication, consolidation into master `%USERPROFILE%\.agent-templates\AGENTS.md`, and symlink synchronization.

## Step-by-Step Procedure

1. **Extract & Inspect Current Harness State:**
   - Run the non-interactive extractor:
     `powershell -NoProfile -ExecutionPolicy Bypass -File "%USERPROFILE%\.agent-templates\extract-prefs.ps1"`
   - Read `%USERPROFILE%\.agent-templates\SECTION8_REVIEW.md` (gitignored) to inspect link health across all 7 harnesses (`Antigravity`, `DeepSeekHarness`, `OpenCode`, `CommandCode`, `ClaudeCode`, `Codex`, `Freebuff`) and review every unique `- [PREF: Slug | YYYY-MM-DD | Category]` entry.

2. **Route by Semantic Scope:**
   - **Project-Specific Rules** (coupled to one repo's stack, ports, layout, or domain traps) -> belong in that repo's root `./AGENTS.md` or `docs/DECISIONS_AND_TRAPS.md`, never in master `AGENTS.md`.
   - **Universal Cross-Project Preferences** -> fold concisely into the matching section (`Sections 1–7`) of `%USERPROFILE%\.agent-templates\AGENTS.md`:
     - Merge into existing bullets instead of appending duplicate prose so per-turn token weight stays lean.
     - Preserve all existing non-conflicting rules verbatim in meaning.

3. **Clean Section 8 & Update Consolidation Date:**
   - Remove the folded `- [PREF: ...]` bullets from Section 8 of `%USERPROFILE%\.agent-templates\AGENTS.md` and update the `*(All preferences up to YYYY-MM-DD have been consolidated...)*` marker (UTF-8 without BOM).

4. **Sync All Harnesses, Skills & GitHub + Verify CI:**
   - Run the master sync script (keeping `.ps1` edits 7-bit ASCII if modified):
     `powershell -NoProfile -ExecutionPolicy Bypass -File "%USERPROFILE%\.agent-templates\sync-all.ps1" -CommitMessage "docs(agents): consolidate Section 8 preferences into master AGENTS.md"`
   - Watch the triggered `Mostakim2005/agent-templates` GitHub Actions run (`gh run list` / `gh run watch`) to confirm structure, UTF-8 no-BOM, skill frontmatter, and `PSScriptAnalyzer` checks pass.
