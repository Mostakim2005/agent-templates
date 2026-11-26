# Product Intent & Feature Map (`PRODUCT.md`)
> **1-Line Summary:** Permanent source of truth for what the app must do and feel like, linking every active feature to its architecture flow, trap guards, and verification test. *(Implementation code anchors live in `docs/ARCHITECTURE.md`.)*

## 1. Core Vision & User Experience Intent
* **What This App Does (Plain English):** [1–2 sentences]
* **How It Must Feel to Use:** [Key UX expectations, Light/Dark theme parity, speed, offline capability]

## 2. Active Features (Do Not Break)

### [FEATURE: Descriptive-Feature-Name] | Aliases: everyday words, UI button name, related concept
> **1-Line Summary:** [What the user sees and does with this feature in one sentence.]
* **Links:** `[FLOW: Descriptive-Feature-Flow-Name]`, `[TRAP: Descriptive-Trap-Name]`
* **User Intention (Non-Negotiable):** [Why the user wanted this and how it must behave.]
* **Visual / UI Behavior:** [Where it lives on screen and how the user interacts with it.]
* **Verified By:** `tests/feature.test.ts :: testFeatureBehavior` *(or CLI smoke command, e.g., `app-cli status --json`)*

## 3. Planned Features & App-Merge Wishlist

### [WISHLIST: Descriptive-Planned-Feature] | Aliases: future feature keywords, deferred audit item
> **1-Line Summary:** [What we plan to build, merge from another app, or revisit from a Path B / Audit agenda.]
* **Links:** `[SUBSYSTEM: Descriptive-Mechanism-Name]`
* **User Intention:** [Desired outcome and how it connects to existing workflows]
