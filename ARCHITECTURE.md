# System Architecture (`ARCHITECTURE.md`)
> **1-Line Summary:** Plain-English visual map of how the app works, why we chose each tool, and step-by-step recipes for adding new features. *(Build, lint, and test commands live in the project's root `AGENTS.md`.)*

## 1. High-Level Visual System Map
* **Plain-English Overview:** [2–3 simple sentences explaining how the user interface, core logic, and storage connect from start to finish.]

```mermaid
flowchart TB
    %% Color Definitions (Obsidian & GitHub compatible)
    classDef startNode fill:#1d4ed8,stroke:#1e3a8a,color:#ffffff
    classDef processNode fill:#0f766e,stroke:#115e59,color:#ffffff
    classDef outputNode fill:#15803d,stroke:#14532d,color:#ffffff

    UI([User Interface / Controls]):::startNode -->|sends action| Core[Parent Core Engine / State]:::processNode
    Core -->|reads and writes| Data[(Child Storage / Local DB)]:::outputNode
    Data -->|returns updated state| UI

    subgraph Legend["Legend (Color Guide)"]
        L1([Blue = User Entry / UI Layer]):::startNode
        L2[Teal = Core Logic / State Controller]:::processNode
        L3[(Green = Persistent Storage / Output)]:::outputNode
    end
```

## 2. Tech Stack & Why We Chose It

| Layer | Tool / Library | Plain-English Reason Why |
| --- | --- | --- |
| Host / UI | [e.g., Electron + Vue 3] | [1-sentence practical reason] |

## 3. Core Subsystems & Engineering Tricks

### [SUBSYSTEM: Descriptive-Mechanism-Name] | Aliases: keywords, component names
> **1-Line Summary:** [How this part of the program works in plain English.]
* **How It Works (Plain English):** [Clear explanation without jargon — where the flow begins, how parent and child parts interact, and what output is produced.]
* **Data Flow Diagram:**

```mermaid
flowchart LR
    %% Color Definitions (Obsidian & GitHub compatible)
    classDef startNode fill:#1d4ed8,stroke:#1e3a8a,color:#ffffff
    classDef processNode fill:#0f766e,stroke:#115e59,color:#ffffff
    classDef outputNode fill:#15803d,stroke:#14532d,color:#ffffff
    classDef trapNode fill:#b91c1c,stroke:#7f1d1d,color:#ffffff

    In([Start: Trigger / Input]):::startNode -->|passes input| Parent[Parent Coordinator]:::processNode
    Parent -->|delegates step| Child[Child Worker]:::processNode
    Child -->|produces| Out([Output: Saved / Rendered Result]):::outputNode
    Child -.->|on error| Guard[Safe Fallback]:::trapNode

    subgraph Legend["Legend (Color Guide)"]
        L1([Blue = Trigger / Input]):::startNode
        L2[Teal = Parent-Child Processing]:::processNode
        L3([Green = Final Output]):::outputNode
        L4[Red = Error Guard / Fallback]:::trapNode
    end
```

* **Code Anchors (Grep Targets):**
  * `src/path/file.ts` -> `functionOrClassName`

## 4. Recipes: How to Add New Things Safely
* **To add a new [Feature/Step/Template]:**
  1. Edit `fileA` -> `arrayOrFunction`
  2. Register in `fileB` -> `handlerName`
