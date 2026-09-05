---
name: specs-of-theseus
description: Use when a subsystem has accumulated too much entropy to keep patching, when new requirements arrive for a subsystem already under management, or when working in a codebase that has a docs/subsystems.md manifest. Also use when asked about the spec manifest, invariants, binding tests, regenerating or regrowing a subsystem, or Specs of Theseus.
---

# Specs of Theseus

## Overview

The running system is replaceable material. The declared intent is the durable asset.

Code and most tests are planks. The **spec manifest** and its **binding tests** are what make the system the same ship after every plank has been replaced.

**Change happens by regeneration, not accretion.** When requirements arrive, the move is not "patch this into the existing shape." It is: decide what to delete so the system can be rethought *including* the new requirements, then regrow it against intent that survived the deletion.

Normal development accretes because deletion is frightening — the code is the only place intent is written down, so throwing it away loses knowledge. Once intent lives outside the code, deletion becomes husbandry rather than destruction. Entropy accumulates in implementations, not in intent.

Lineage: Chad Fowler's Regenerative Development / Phoenix Architecture.

## How work flows

Intent enters as an epic and reaches code as a task. Nothing is built that is not promised, and nothing is promised in a place that gets deleted.

Two diagrams, split by zoom. Nodes are activities; **the arrows are the artifacts passed between them.**

### Intent to tasks

```mermaid
---
config:
  layout: dagre
  look: handDrawn
  theme: forest
  fontFamily: '''Open Sans Variable'', sans-serif'
  themeVariables:
    fontFamily: '''Open Sans Variable'', sans-serif'
title: Specs of Theseus — Intent to Tasks
---
flowchart TB
     classDef hidden fill:none,stroke:none,color:transparent
     S1:::hidden
     S2:::hidden
     S3:::hidden


    S1["S1"] -- Business need --> A["Decide Next Intent"]
    S2["S2"] -- Product idea --> A
    S3["S3"] -- Technical spike --> A
    A -- Epic --> B["Slice Vertically"]
    B -- Stories --> C["Prioritize <br> Backlog"]
    K(("Inner loop <br> Diagram <br> fa:fa-diagram-project")) -- Manifest Defect --> H

    C -- Top story --> E["Analyze <br> Inventory"]
    E -- Managed subsystem <br> needs changes --> F["Update Specs"]
    E -- Existing code <br> not yet managed --> G["Adopt: <br> recover <br> invariants"]
    E -- No subsystem yet --> G2["Grow: <br> declare <br> invariants"]
    F --> H["Update <br> Manifest"]
    G --> H
    G2 --> H
    H -- Tasks --> I["Choose task"]
    I -- Task --> J(("Inner loop <br> Diagram <br> fa:fa-diagram-project"))
    J -- Completed Task --> I
    I -. Completed Story .-> D["Deploy"]
    D -- Accepted Work --> C
    D -. Rejected Work .-> C
    C -- Completed Epic --> A
```

**Regrowth has no node of its own.** When a story's manifest delta is large enough that patching would distort the subsystem, the cut becomes the story's first task. Deletion is a way of delivering a story, not a separate kind of work.

### Building one task

```mermaid
---
config:
  layout: dagre
  look: handDrawn
  theme: forest
  themeVariables:
    fontFamily: '''Open Sans Variable'', sans-serif'
title: Specs of Theseus — Inner Loop (One Task)
---
flowchart LR
    classDef hidden fill:none,stroke:none,color:transparent

    AA(("Intent <br>Tasks <br> Diagram <br> fa:fa-diagram-project")) -- Task --> AB["Write Test"]
    AB -- Test --> AC["Run Tests"]
    AC -- Red Test --> AD["Write <br> Implementation"]
    AD -- Implementation --> AC
    AC -- Green Test --> AE["Refactor"]
    AC -. Manifest Defect -.-> AF(("Intent <br>Tasks <br> Diagram <br> fa:fa-diagram-project"))
    AE -- Better Code --> AC
    AC -- Green Tests &amp; <br> Implementation --> AG["Annotate Code <br> with Spec Tags"]
    AG -- Annotated Code --> AH["AH"]:::hidden
    AG -- Completed <br> Task --> AA
```

The dotted `Manifest Defect` arrow is the path that matters most and gets skipped most: discovering mid-cycle that the entry itself is wrong means going back to change it deliberately, never bending the test to fit. Refactoring is genuinely optional — which is why green has two exits — but skipping it silently is not.

## Lifecycle of a subsystem

The nodes are the statuses recorded in `docs/subsystems.md`; the arrows are the things you do.

```mermaid
stateDiagram-v2
    [*] --> Unmanaged
    Unmanaged --> Adopted: adopt — draw the boundary,<br/>classify candidates, write the subsystem file
    Adopted --> Regrowing: cut — delete implementation<br/>and scaffolding tests
    Regrowing --> Managed: regrow — rebuild to green,<br/>verify invariants, reconcile the manifest
    Managed --> Regrowing: cut again — new requirements,<br/>or accumulated entropy
    Managed --> Managed: ordinary change<br/>under existing specs

    Unmanaged: Unmanaged
    Adopted: Adopted — not yet regrown
    Regrowing: Regrowth in progress
    Managed: Under management
```

A subsystem only reaches **Under management** by being regrown. Adoption alone declares intent; it does not prove the intent is sufficient to rebuild from. That proof is the regrowth.

**Never change code first and the manifest after.** The manifest is the statement of intent; code is its current expression. Reversing the order is how the record goes wrong — so a change that touches an invariant updates the manifest before a line of code moves.

## Vocabulary

| Term | Meaning |
| --- | --- |
| **Spec manifest** | `docs/subsystems.md` — the coverage index, with one file per subsystem in `docs/subsystems/`. The authoritative record of what the system promises. |
| **Subsystem** | A named area of the system with a boundary *you draw*; the unit that gets cut and regrown. It need not match an existing module. |
| **Invariant** | A property that must survive a total rewrite: exterior contract, performance characteristic, or high-level architecture |
| **Spec** | A behavioral promise, written in EARS |
| **Non-promise** | Behavior that exists today and is explicitly not promised |
| **Binding test** | Full-system, outcome-level test proving an invariant. Survives deletion. |
| **Scaffolding test** | Unit test on an implementation detail. Deleted with the code it describes. |
| **The cut** | The decision about what to delete before regrowing |
| **Epic** | A body of work larger than one story. Disposable — it records why a set of manifest changes happened. |
| **Story** | A vertical slice of an epic, independently deliverable. Disposable. Holds a manifest delta and its tasks. |
| **Manifest delta** | The entries a story adds, modifies, or retires. The story's promise, written and approved before any code moves. |
| **Task** | One red/green/refactor cycle, naming the entry it serves. Not written in EARS. |

## Durable vs disposable

| Durable — survives the cut | Disposable — deleted without ceremony |
| --- | --- |
| Manifest entries | Implementation code |
| Binding tests | Scaffolding tests |
| Exterior contracts, performance characteristics, architecture | Internal patterns, class decomposition, file layout, line count |
| — | Epics, stories, and their task lists |

Implementation shape matters less — but not zero. It is free to change so long as invariants hold.

## Coverage is partial by design

`docs/subsystems.md` records which subsystems are under management. Code outside a covered subsystem is **not a violation** — it is simply not yet adopted. Never report unadopted code as drift, and never mass-adopt a codebase to make the manifest look complete.

## Reference

- Manifest structure, entry templates, ID scheme: [manifest-format.md](references/manifest-format.md)
- Invariant categories, elicitation, classification gate: [invariants.md](references/invariants.md)
- EARS syntax for specs: [ears.md](references/ears.md)
- Binding vs scaffolding tests, tagging: [tests.md](references/tests.md)
- Epic, story, and task formats: [work-format.md](references/work-format.md)

## Routing

| Where you are | Skill |
| --- | --- |
| A need larger than one story, with no epic behind it | [refining-an-epic](../refining-an-epic/SKILL.md) |
| A refined epic that needs stories | [slicing-an-epic](../slicing-an-epic/SKILL.md) |
| The top story off the backlog | [delivering-a-story](../delivering-a-story/SKILL.md) |
| Existing code the story depends on, not in `docs/subsystems.md` | [adopting-a-subsystem](../adopting-a-subsystem/SKILL.md) |
| Behavior with no subsystem yet — greenfield | [growing-a-subsystem](../growing-a-subsystem/SKILL.md) |
| A managed subsystem where patching would distort the shape, or entropy already has | [regrowing-a-subsystem](../regrowing-a-subsystem/SKILL.md) |

**Work normally enters at an epic**, and the subsystem-level skills are reached *through* a story. The exception is a regrowth driven by entropy alone with no product change behind it, which may be entered directly.

Anything smaller than all of this is an ordinary change under the existing specs — and saying so explicitly is a legitimate outcome, not a failure to find a process.

Read the satellite when you reach it. Do not reconstruct its process from this file.

## Common mistakes

| Mistake | Why it is wrong |
| --- | --- |
| **Procrustean spec** — spec legislates implementation detail | Cuts the code to fit the bed. Regeneration loses its freedom, and the spec breaks on every refactor. A spec constraining internal shape is a manifest defect. |
| **Black sail** — code changed, manifest not | The system works; the record lies; someone acts on the record. This is the failure mode the whole process exists to prevent. |
| **Enshrined entropy** — current behavior captured wholesale as binding tests | Makes the mess permanent in the artifact that is supposed to outlive it. Every candidate invariant gets classified before it becomes binding. |
| **Silent retirement** — deleting a spec that no longer applies | Retirement is visible. Record what was retired, what replaced it, and why. |
| **Adopting everything** | Partial coverage is legitimate. A thousand inferred specs written before you know what a good one looks like is worse than none. |
| **Specs written into a story** | The story is disposable; the spec dies with it. Specs are manifest entries — the story references them. |
| **A story with no manifest delta** | Either an ordinary change under existing specs, which should be said out loud, or unpromised behavior, which is a defect. |

## Red flags

- "I'll update the manifest after the code works"
- "This behavior is obviously intended, no need to classify it"
- "The existing tests tell us what the invariants are" — they assert implementation as often as intent
- "Let me just patch this in" for a change that clearly strains the subsystem's shape
- "Deleting the tests loses coverage" — scaffolding tests are supposed to die with their code
- "I'll write the epic up once we know what we built" — then the code wrote the intent
- "I'll adjust the spec to match what I implemented"


**All of these mean: stop and re-read this skill.**
