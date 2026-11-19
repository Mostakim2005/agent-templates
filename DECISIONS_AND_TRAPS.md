# Architectural Decisions, Pivots & Landmines (`DECISIONS_AND_TRAPS.md`)
> **1-Line Summary:** Records why we chose specific approaches, what failed when we tried other ways, who made the decision, and full explanations of critical code traps never to touch. *(Keep only 1-line warning pointers in the project's root `AGENTS.md`; put full details and code anchors here.)*

## 1. Architectural Decisions & Pivot History

### [DECISION: Descriptive-Choice-Name] | Aliases: feature name, alternative rejected, keywords
> **1-Line Summary:** [What we decided to do and what failed approach it replaced.]
* **Decision Maker:** `[DECIDED BY: HUMAN]` (or `[DECIDED BY: AGENT - Approved by Human]`)
* **Original User Intention:** [What the user wanted to achieve]
* **Options Considered:**
  * **Option A (Rejected):** [What it was and why it failed or was rejected]
  * **Option B (Chosen):** [What we implemented and why it works]
* **Plain-English Summary of Pivot:** [1–2 simple sentences explaining why the old path broke and how the new path avoids it.]
* **Visual Pivot Map (What Failed vs. What Works):**

```mermaid
flowchart LR
    %% Color Definitions (Obsidian & GitHub compatible)
    classDef failedNode fill:#b91c1c,stroke:#7f1d1d,color:#ffffff
    classDef activeNode fill:#15803d,stroke:#14532d,color:#ffffff

    subgraph Failed["Old Approach (Rejected)"]
        A1[Start: Attempted X]:::failedNode -->|caused issue| A2[Broke because of Y]:::failedNode
    end

    subgraph Active["Current Approach (Active)"]
        B1[Start: Implemented Z]:::activeNode -->|clean flow| B2[Achieves User Intent Safely]:::activeNode
    end

    subgraph Legend["Legend (Color Guide)"]
        L1[Red = Rejected / Failed Path]:::failedNode
        L2[Green = Active / Working Path]:::activeNode
    end
```

* **Code Anchors (Grep Targets):**
  * `src/path/file.ts` -> `implementedFunctionName`

---

## 2. Do-Not-Touch Engineering Landmines (Traps)

### [TRAP: Descriptive-Trap-Name] | Aliases: bug symptom, broken behavior, file name
> **1-Line Summary:** [Strict rule on what NOT to change, and what breaks if you do.]
* **Strict Rule:** **NEVER** [state exact action to avoid, e.g., move script X into `index.html`].
* **Why This Trap Exists (Plain English):** [Explain the hidden interaction, e.g., Electron resets plugin arrays during async startup, or Windows OS dark mode inverts SVG CSS `light-dark()` colors.]
* **Protected Code Anchors (Grep Targets):**
  * `src/path/file.ts` -> `protectedFunctionOrGuardName`
