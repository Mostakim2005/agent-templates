# System Architecture (`ARCHITECTURE.md`)
> **1-Line Summary:** Plain-English visual map of how the app works, why we chose each tool, and step-by-step recipes for adding new features.

## 1. High-Level Visual System Map
```mermaid
flowchart TB
    %% Draw clear boxes showing how User UI, State, and Core Engines connect

```

## 2. Tech Stack & Why We Chose It

| Layer | Tool / Library | Plain-English Reason Why |
| --- | --- | --- |
| Host / UI | [e.g., Electron + React] | [1-sentence practical reason] |

## 3. Core Subsystems & Engineering Tricks

### [SUBSYSTEM: Descriptive-Mechanism-Name] | Aliases: keywords, component names

> **1-Line Summary:** [How this part of the program works in plain English.]

* **How It Works (Plain English):** [Clear explanation without jargon]
* **Data Flow Diagram:**

```mermaid
sequenceDiagram
    %% Show step-by-step flow

```

* **Code Anchors (Grep Targets):**
* `src/path/file.ts` -> `functionOrClassName`



## 4. Verification & Health Checks

### [VERIFY: Automated-Check-Suite] | Aliases: test commands, build check, audit

> **1-Line Summary:** Commands every AI must run to prove nothing broke before committing.

* **Type & Lint Check:** `[exact command]`
* **Automated UI / Logic Verification:** `[exact command]`
* **Portable `.exe` Packaging Command:** `[exact command]`

## 5. Recipes: How to Add New Things Safely

* **To add a new [Feature/Step/Template]:**
1. Edit `fileA` -> `arrayOrFunction`
2. Register in `fileB` -> `handlerName`


