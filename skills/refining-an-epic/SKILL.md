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

Track the steps however this session allows — TodoWrite if it is available, a written list otherwise. Refinement writes no code, so an interrupted one breaks nothing.

### 1. Take inventory before asking anything

Read [docs/subsystems.md](../specs-of-theseus/references/manifest-format.md) and work out which subsystems the epic plausibly touches, and which of them are under management.

This comes first because it changes what the epic *is*. An epic landing entirely in managed subsystems is a set of manifest deltas. An epic landing in unmanaged code carries an adoption or a new subsystem inside it, which is a different size of job and needs saying out loud before anyone estimates anything.

A third possibility worth holding open: the epic may want a **decomposition that does not exist yet**. If every story in it would span the same three subsystems, the shape is the problem, and a redraw is a legitimate thing for an epic to carry. Name it as a possibility here — it is decided in a story, not now.

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

**Then walk `docs/system.md`.** Cross-cutting invariants belong to no subsystem, so no subsystem's inventory will surface them — they are invisible to the walk above by construction, and an epic is the last cheap moment to notice one. Data safety, authentication, degradation behavior: the properties most expensive to break are the ones with no owner.

**Ask in both directions.** "Would this epic break an invariant?" assumes the risk lives in the code the epic changes. It does not always — an invariant can govern *the work itself* rather than the product: what the test suite may depend on, what a fixture may contain, whether a binding test may reach a live service, what tooling is allowed in CI. A hardening epic inverts the question entirely, because its output *is* tests, and the tests it adds are what collide. So ask the second question explicitly:

> Does any invariant constrain what this epic is allowed to *write*?

These are the easiest findings to miss and among the cheapest to act on, because the answer changes the plan rather than the product.

Empty is a valid answer. Assuming empty without looking is not — an epic that breaks an invariant must discover that now, when the answer is "then the epic is wrong or the invariant is," and not during implementation, when the pressure is to weaken the invariant.

An epic that breaks an invariant is not blocked. It is a bigger epic than it looked, and it says so on its face.

**A new outcome may need new cross-cutting invariants of its own.** If the epic promises something the whole system must now hold to — "imports are resumable", "nothing is visible until it is committed" — that is a `SYSTEM-INV` candidate, not a subsystem spec. Name it here; it is written when a story delivers it, like any other entry.

### 4. Write the epic

Create `docs/epics/NNNN-name.md` from the template in [work-format.md](../specs-of-theseus/references/work-format.md) and add a row to `docs/epics.md`. Link both directions.

Record the answers, not the questions. An epic full of open questions that were in fact answered in conversation is a lossy transcript.

**When the epic's content *is* manifest entries** — a hardening epic, or one whose whole point is declaring intent — the pull to write the EARS statements right here is strong, because there seems to be nothing else to write. Resist it: write each one as a **plain-language property with its category** (`contract`, `performance`, `architecture`) and leave the EARS statement to the story's delta. The scope table then sizes the epic without promising anything, which is the distinction the epic layer exists to hold.

**STOP. Present the epic and get approval before slicing.**

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Writing stories during refinement | Different skill, different judgement. Slicing needs the epic settled first. |
| Writing EARS specs in the epic | Specs are manifest entries and belong to a story's delta. An epic that contains specs has skipped two steps. |
| Writing EARS in a *hardening* epic, where entries are the whole content | The easiest version of the mistake to commit, because it feels like the only thing to write. Plain-language properties with categories; EARS in the delta. |
| "Invariants at risk: none" after checking only the code the epic changes | Also ask what constrains what the epic may *write*. For a hardening epic that is where every finding is. |
| Skipping the inventory because the answer seems obvious | The unmanaged half is what makes the epic expensive, and it is invisible until you look. |
| "Invariants at risk: none" without opening a subsystem file | The whole point is to be surprised here rather than later. |
| Leaving answered questions in Open Questions | The epic is read later by someone who was not in the room. |
| An epic that is one story | Fine — say so, write the story, skip the epic. Do not pad it. |
