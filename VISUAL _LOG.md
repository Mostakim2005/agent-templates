# Visual Feature & Change Log (`VISUAL_LOG.md`)
> **1-Line Summary:** Plain-English, color-coded Obsidian-compatible Mermaid flowcharts explaining how each new feature or significant change works end to end.

## Feature & Change Flowcharts

### [VISUAL: Descriptive-Feature-Or-Change-Name] | Aliases: feature name, commit topic, keywords
> **1-Line Summary:** [What this feature/change does from start to finish in one simple sentence.]

* **Plain-English Walkthrough:** [Explain in 2–3 simple, jargon-free sentences where the flow begins, how parent and child steps interact, and what output the user sees.]

```mermaid
flowchart TD
    %% Color Definitions (Obsidian & GitHub compatible)
    classDef startNode fill:#1d4ed8,stroke:#1e3a8a,color:#ffffff
    classDef processNode fill:#0f766e,stroke:#115e59,color:#ffffff
    classDef outputNode fill:#15803d,stroke:#14532d,color:#ffffff
    classDef trapNode fill:#b91c1c,stroke:#7f1d1d,color:#ffffff

    Start([Start: User Action / Input]):::startNode -->|triggers| Parent[Parent Module / Controller]:::processNode
    Parent -->|passes data to child| Child[Child Handler / Storage]:::processNode
    Child -->|returns result| Done([Output: Saved / Shown to User]):::outputNode
    Child -.->|if error occurs| Fallback[Error Guard / Safe Fallback]:::trapNode

    subgraph Legend["Legend (Color Guide)"]
        L1([Blue = Starting Point / User Trigger]):::startNode
        L2[Teal = Processing / Parent-Child Step]:::processNode
        L3([Green = Final Output / Result]):::outputNode
        L4[Red = Error Guard / Fallback Path]:::trapNode
    end
```

* **Code Anchors (Grep Targets):**
  * `src/path/file.ts` -> `entryFunctionName`, `childHandlerName`
