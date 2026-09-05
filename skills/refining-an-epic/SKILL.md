---
name: refining-an-epic
description: Use when a business need, product idea, or technical spike is larger than a single story and needs to become a written epic. Use when asked to refine, scope, or write up an epic, or when work arrives with no epic behind it in a codebase that has docs/epics.md.
---

# Refining an Epic

## Overview

An epic is the record of *why* a set of manifest changes happened. It is disposable — nothing regrows from it — but it is the only place the reasoning behind a body of work survives, and reasoning is expensive to reconstruct.

**REQUIRED BACKGROUND:** Read the [specs-of-theseus](../specs-of-theseus/SKILL.md) skill first for the model and vocabulary. Formats live in [work-format.md](../specs-of-theseus/references/work-format.md).

Refinement produces one epic file and one row in `docs/epics.md`. It produces no stories and no manifest entries. Slicing is the next skill; specs come later still, inside a story.

## Checklist

Create a TodoWrite item for each step. Refinement writes no code, so an interrupted one breaks nothing.

### 1. Take inventory before asking anything

Read [docs/subsystems.md](../specs-of-theseus/references/manifest-format.md) and work out which subsystems the epic plausibly touches, and which of them are under management.

This comes first because it changes what the epic *is*. An epic landing entirely in managed subsystems is a set of manifest deltas. An epic landing in unmanaged code carries an adoption or a new subsystem inside it, which is a different size of job and needs saying out loud before anyone estimates anything.

Do not adopt anything here. Name what is unmanaged and move on.

### 2. Ask questions, in batches

Group by theme, three to five at a time. Twenty at once gets three answered.

- **Scope boundaries** — what is explicitly *out*? This is the highest-value question and the one most often skipped.
- **User intent** — who is the user, and what problem are they solving? Not what feature they asked for.
- **Edge cases** — what happens when it goes wrong? What are the boundary conditions?
- **Acceptance** — how will we know this is done, from the user's side?
- **Dependencies** — does this need something that does not exist yet?

### 3. Name the invariants at risk

Walk the invariants of every subsystem in the inventory and ask: would this epic break it?

Empty is a valid answer. Assuming empty without looking is not — an epic that breaks an invariant must discover that now, when the answer is "then the epic is wrong or the invariant is," and not during implementation, when the pressure is to weaken the invariant.

An epic that breaks an invariant is not blocked. It is a bigger epic than it looked, and it says so on its face.

### 4. Write the epic

Create `docs/epics/NNNN-name.md` from the template in [work-format.md](../specs-of-theseus/references/work-format.md) and add a row to `docs/epics.md`. Link both directions.

Record the answers, not the questions. An epic full of open questions that were in fact answered in conversation is a lossy transcript.

**STOP. Present the epic and get approval before slicing.**

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Writing stories during refinement | Different skill, different judgement. Slicing needs the epic settled first. |
| Writing EARS specs in the epic | Specs are manifest entries and belong to a story's delta. An epic that contains specs has skipped two steps. |
| Skipping the inventory because the answer seems obvious | The unmanaged half is what makes the epic expensive, and it is invisible until you look. |
| "Invariants at risk: none" without opening a subsystem file | The whole point is to be surprised here rather than later. |
| Leaving answered questions in Open Questions | The epic is read later by someone who was not in the room. |
| An epic that is one story | Fine — say so, write the story, skip the epic. Do not pad it. |
