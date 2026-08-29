---
name: adopting-a-region
description: Use when an existing subsystem is not yet in docs/theseus/manifest.md and needs its intent declared — typically a high-entropy region you intend to delete and regrow. Use when asked to extract invariants from existing code, characterize what a subsystem promises, or bring a region under Specs of Theseus management.
---

# Adopting a Region

## Overview

Bringing existing code under management means recovering intent from an implementation that never
declared any. The region cannot be trusted to describe itself: its observable behavior mixes
deliberate promises, accidents people now depend on, bugs that became load-bearing, and side
effects nobody knows exist.

**The whole difficulty is telling intent from accident.** Capture behavior wholesale and you
enshrine the entropy in the one artifact meant to outlive it. Capture only what someone can
articulate and you delete things real users depend on.

**REQUIRED BACKGROUND:** Read the `specs-of-theseus` skill first for the model and vocabulary.

Adoption does not change behavior. It produces a region file and a set of binding tests that pass
against the code as it stands today.

## Checklist

Create a TodoWrite item for each step. Each ends with a stop.

### 1. Draw the boundary

Name the region. State precisely what is inside and outside, in terms of files, modules, or
directories. Then map its edges:

- **Who calls in** — every caller, and what each depends on
- **What it calls out to** — services, databases, queues, filesystems, third parties
- **What crosses the boundary** — function signatures, routes, event and message shapes, schemas,
  file formats, CLI flags

Nothing else can be decided until the boundary is fixed. If the boundary cannot be drawn cleanly,
say so — a region with no discernible edge is not yet adoptable, and the honest move is to propose
a smaller one.

**STOP. Present the boundary and get approval before continuing.**

### 2. Enumerate invariant candidates

Gather candidates from evidence, strongest first. See
[invariants.md](../specs-of-theseus/references/invariants.md) for categories and elicitation.

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

This is the human judgment gate and the step that determines whether the manifest inherits the
entropy or sheds it. **Do not classify alone.** Walk the list with the user, one at a time:

- **Invariant** — must survive a total rewrite. Gets an `INV` entry and a binding test.
- **Spec** — a behavioral promise, but not one that constrains a rewrite. Gets a `SPEC` entry.
- **Accident** — happens today, not promised. Gets a `NON` entry with the reason.
- **Bug we are fixing now** — the regrowth is expected to behave differently. Record the intended
  behavior as a spec, and note what the old behavior was.
- **Don't care** — not worth recording.

For anything you cannot classify, default to **accident** and say so out loud. An unrecorded
promise is recoverable; a wrongly enshrined one is forever.

**STOP. Present the classification and get approval before continuing.**

### 4. Write the region file

Create `docs/theseus/<region>.md` and add the region to `docs/theseus/manifest.md` with status
`adopted — not yet regrown`. Follow
[manifest-format.md](../specs-of-theseus/references/manifest-format.md).

Record the boundary itself in the region file. The cut later depends on it.

**STOP. Present the region file and get approval before continuing.**

### 5. Prove the binding tests against the existing implementation

Write a binding test for every invariant, per
[tests.md](../specs-of-theseus/references/tests.md). Run them against the code as it stands.

**Every binding test must pass before anything is deleted.** A binding test that has never been
green against the current ship is not a statement about the system — it is a guess, and regrowth
will be measured against a guess.

When a binding test fails against current code, that is a finding, not a defect in the test. Either
the invariant was stated wrong, or you have discovered a real bug. Take it back to the user and
reclassify.

**STOP. Report which tests pass, and any invariants that turned out to be false.**

### 6. Hand off

Adoption is complete. The region is now under management and its intent survives deletion.

To regrow it, use the `regrowing-a-region` skill.

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Mining the existing test suite for invariants | Tests assert implementation. Start from callers and the exterior surface. |
| Classifying candidates yourself to save time | The classification gate is the point of the skill. It requires the human. |
| Writing binding tests that reach inside the boundary | Binding tests are black-box. Reaching inside makes them scaffolding wearing a badge. |
| Adopting the whole codebase | Partial coverage is legitimate and expected. |
| Fixing bugs during adoption | Adoption changes no behavior. Record the bug as a spec for the regrowth. |
