---
name: adopting-a-subsystem
description: Use when an existing subsystem is not yet in docs/subsystems.md and needs its intent declared — typically a high-entropy subsystem you intend to delete and regrow. Use when asked to extract invariants from existing code, characterize what a subsystem promises, or bring a subsystem under Specs of Theseus management.
---

# Adopting a Subsystem

## Overview

Bringing existing code under management means recovering intent from an implementation that never declared any. The subsystem cannot be trusted to describe itself: its observable behavior mixes deliberate promises, accidents people now depend on, bugs that became load-bearing, and side effects nobody knows exist.

**The whole difficulty is telling intent from accident.** Capture behavior wholesale and you enshrine the entropy in the one artifact meant to outlive it. Capture only what someone can articulate and you delete things real users depend on.

**REQUIRED BACKGROUND:** Read the [specs-of-theseus](../specs-of-theseus/SKILL.md) skill first for the model and vocabulary.

Adoption does not change behavior. It produces a subsystem file and a set of binding tests that pass against the code as it stands today.

## Where this is reached from

Usually from inside a story, when [delivering-a-story](../delivering-a-story/SKILL.md) finds that the story depends on code nobody has declared intent for. Occasionally on its own, to bring a known high-entropy area under management ahead of the work that will regrow it.

**When adopting mid-story, adopt only the boundary the story needs.** Record the rest as identified but not adopted. A story is a bad place to widen coverage: the pressure is to finish, and adoption done under that pressure is exactly how entropy gets enshrined in the artifact meant to outlive it.

## Checklist

Track the steps however this session allows — TodoWrite if it is available, a written list otherwise. Each ends with a stop.

Adoption changes no behavior, so an interrupted one breaks nothing and session-level tracking is enough. The classification decisions at step 3 are the exception, and they are written into the subsystem file as they are made rather than held in the session.

### 1. Draw the boundary

Name the subsystem. State precisely what is inside and outside, in terms of files, modules, or directories.

The boundary is one you draw, not one you discover. It may follow the existing module structure, but it does not have to — in a high-entropy area that structure is often *the* entropy, and regrowth is free to produce a different internal shape. Draw the boundary around the behavior worth promising, then note which existing code falls inside it.

Then map its edges:

- **Who calls in** — every caller, and what each depends on
- **What it calls out to** — services, databases, queues, filesystems, third parties
- **What crosses the boundary** — function signatures, routes, event and message shapes, schemas, file formats, CLI flags

Nothing else can be decided until the boundary is fixed. If the boundary cannot be drawn cleanly, say so — a subsystem with no discernible edge is not yet adoptable, and the honest move is to propose a smaller one.

**The boundary is fixed for this adoption, not forever.** A later redraw can merge this subsystem, split it, or move its contents, carrying the entries across by ID — see [system.md](../specs-of-theseus/references/system.md). That is a reason to draw the smallest defensible boundary now rather than an ambitious one, and not a reason to agonize: the expensive decisions in adoption are the classifications at step 3, which survive any redraw.

**STOP. Present the boundary and get approval before continuing.**

### 2. Enumerate invariant candidates

Gather candidates from evidence, strongest first. See [invariants.md](../specs-of-theseus/references/invariants.md) for categories and elicitation.

| Evidence | Strength | Notes |
| --- | --- | --- |
| Actual callers and what they rely on | Strongest | Real dependency, not claimed |
| Exterior surface — signatures, routes, schemas, formats, flags | Strong | Observable contract |
| Production behavior — latency, throughput, resource ceilings, batch sizes | Strong | Source of performance invariants |
| Architectural constraints — ordering, idempotency, transactionality, separability | Strong | Easy to violate silently in a rewrite |
| Documentation, comments, tickets | Medium | States past intent, often stale |
| Existing tests | **Weak** | Assert implementation as often as intent |

List candidates without judging them yet. Judging while gathering suppresses inconvenient findings.

### 3. Classify every candidate

This is the human judgment gate and the step that determines whether the manifest inherits the entropy or sheds it. **Do not classify alone.** Walk the list with the user, one at a time:

- **Invariant** — must survive a total rewrite. Gets an `INV` entry and a binding test.
- **Spec** — a behavioral promise, but not one that constrains a rewrite. Gets a `SPEC` entry.
- **Accident** — happens today, not promised. Gets a `NON` entry with the reason.
- **Bug we are fixing now** — the regrowth is expected to behave differently. Record the intended behavior as a spec, and note what the old behavior was.
- **Don't care** — not worth recording.

For anything you cannot classify, default to **accident** and say so out loud. An unrecorded promise is recoverable; a wrongly enshrined one is forever.

**Write each decision down as it is made**, not at the end. These are the expensive part of adoption — they cost the user's attention and cannot be reconstructed from the code, which is the whole reason this step exists. A long list will outlast a session; losing it means asking the same questions twice.

**STOP. Present the classification and get approval before continuing.**

### 4. Write the subsystem file

Create `docs/subsystems/<subsystem>.md` and add a row to the manifest at `docs/subsystems.md` with status `adopted — not yet regrown`. Follow [manifest-format.md](../specs-of-theseus/references/manifest-format.md).

Link both directions: the manifest row links to the subsystem file, and the subsystem file opens with a link back to the manifest.

Record the boundary itself in the subsystem file. The cut later depends on it.

If adoption was scoped down mid-story, record what you deliberately left out in the manifest's **Identified but not adopted** table. An unadopted sibling that nobody wrote down looks identical to one nobody noticed.

**STOP. Present the subsystem file and get approval before continuing.**

### 5. Prove the binding tests against the existing implementation

Write a binding test for every invariant, per [tests.md](../specs-of-theseus/references/tests.md). Run them against the code as it stands.

**Every binding test must pass before anything is deleted.** A binding test that has never been green against the current ship is not a statement about the system — it is a guess, and regrowth will be measured against a guess.

When a binding test fails against current code, that is a finding, not a defect in the test. Either the invariant was stated wrong, or you have discovered a real bug. Take it back to the user and reclassify.

**STOP. Report which tests pass, and any invariants that turned out to be false.**

### 6. Hand off

Adoption is complete. The subsystem's intent is declared and survives deletion.

**It is not yet under management.** Its status is `adopted — not yet regrown`, and it stays there until a regrowth proves the intent is sufficient to rebuild from. Declaring intent well is not the same as demonstrating it is enough.

If this was reached from a story, return to [delivering-a-story](../delivering-a-story/SKILL.md) — there are now entries to write a delta and tasks against. To regrow the subsystem directly, use [regrowing-a-subsystem](../regrowing-a-subsystem/SKILL.md).

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Mining the existing test suite for invariants | Tests assert implementation. Start from callers and the exterior surface. |
| Classifying candidates yourself to save time | The classification gate is the point of the skill. It requires the human. |
| Writing binding tests that reach inside the boundary | Binding tests are black-box. Reaching inside makes them scaffolding wearing a badge. |
| Adopting the whole codebase | Partial coverage is legitimate and expected. |
| Fixing bugs during adoption | Adoption changes no behavior. Record the bug as a spec for the regrowth. |
