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
