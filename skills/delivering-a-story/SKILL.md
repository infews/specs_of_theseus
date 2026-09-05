---
name: delivering-a-story
description: Use when working the top story off the backlog — analysing which subsystems it touches, writing the manifest delta, breaking it into TDD tasks, and building it. Use when asked to start, work, implement, or finish a story in a codebase that has docs/epics.md and docs/subsystems.md.
---

# Delivering a Story

## Overview

The path from one story to working, annotated code. Every other skill in this method either feeds this one or is called by it.

**REQUIRED BACKGROUND:** Read the [specs-of-theseus](../specs-of-theseus/SKILL.md) skill first. Formats live in [work-format.md](../specs-of-theseus/references/work-format.md).

The rule the whole skill turns on:

> A story does not contain specs. A story contains a list of edits to the manifest, and the tasks that make the code match.

That is the core skill's *never change code first and the manifest after*, one level up. The delta is written and approved before a line of code moves, because the delta is the promise and the code is only its current expression.

## Two levels of gate

They are gating different things, which is why both exist.

**Phase STOPs** — at the boundaries below. These approve **what is promised**: the routing, the manifest delta, the plan, the finished story. Getting one wrong puts a false statement in the durable record.

**Per-step gates** — inside the TDD cycle, at every transition. These approve **how it gets built**. They are cheap to prompt through when the developer wants speed, and the pause is where they get context they would otherwise have to reconstruct from a diff.

### What counts as approval

An affirmative from the developer: "approved", "lgtm", "go", "yes", "ship it". The following are **not**:

- Silence.
- "Looks fine" alongside an unresolved question in the same message.
- An earlier blanket "just do the whole story" — translate it into per-step approvals anyway, and say that you are doing so.
- Your own confidence that they would approve.

Asking costs one message. Acting without approval costs the pairing.

## Checklist

Create a TodoWrite item per phase, for this session. **Task-by-task progress lives in the story file, not in TodoWrite** — a story can span sessions, and the session is not the unit the work is measured in.

### 1. Analyse the inventory

For each behavior the story requires, decide which of three it is:

| Situation | Route |
| --- | --- |
| A managed subsystem needs spec changes | Phase 2, here |
| Existing unmanaged code the story depends on | [adopting-a-subsystem](../adopting-a-subsystem/SKILL.md), then return |
| Behavior with no home yet | [growing-a-subsystem](../growing-a-subsystem/SKILL.md), then return |

When adopting mid-story, **adopt only the boundary the story needs.** Record the rest as identified-but-not-adopted. A story is a bad place to widen coverage: the pressure is to finish, and adoption done under that pressure is how entropy gets enshrined.

**STOP. Present the routing before touching anything.**

### 2. Write the manifest delta

Every entry the story adds, modifies, or retires, with its EARS statement and its ID, into the story's `Manifest delta` table. Then apply it to the subsystem files.

**This is the only place in the story where EARS appears.**

Three things to check before presenting it:

- **A story with no delta is one of two things.** An ordinary change under existing specs — legitimate, say so explicitly and note it in the story — or unpromised behavior, which is a defect.
- **A modified invariant is not a routine edit.** Stop and escalate. Either the epic is wrong or the invariant was; that is the developer's call, not yours.
- **A retirement is visible.** Record what replaced it and why, per [manifest-format.md](../specs-of-theseus/references/manifest-format.md).

**STOP. The delta is the promise. Get approval before any code moves.**

### 3. Extract the work

Turn the delta into an ordered task list in the story file. A task is **one red/green/refactor cycle** and names the entry it serves. Tasks are not written in EARS — see [work-format.md](../specs-of-theseus/references/work-format.md).

Check both directions, now rather than at close:

- An entry in the delta with no tasks will not get built.
- A task with no entry is unpromised behavior.

Order by dependency — foundations before the layers that rest on them.

**If the delta is large enough that patching would distort the subsystem, the first task is a cut.** Hand off to [regrowing-a-subsystem](../regrowing-a-subsystem/SKILL.md) and resume here afterward. This is how regrowth enters ordinary work; it is not a separate entry point.

An implausibly long list is information. Thirty tasks usually means the story was sliced too wide, not that the work is hard.

**STOP. Present the plan.**

### 4. TDD each task

**REQUIRED SUB-SKILL:** use a test-driven-development skill, checked in this order — `superpowers-ruby:test-driven-development`, `superpowers:test-driven-development`, `pxp:test-driven-development`.

One task at a time. Never batch. The gates:

1. Write the failing test. **Gate: approval before running it.**
2. Run it. Confirm it fails for the expected reason.
3. Write the minimal implementation. **Gate: approval before running again.**
4. Run it. Confirm green, and run the full suite.
5. Refactor while the context is fresh. **Gate: approval before refactoring.** If nothing needs it, say so out loud rather than skipping silently.

Binding tests go in the binding directory; scaffolding tests anywhere that helps. Write scaffolding freely — it is cheap, it makes progress visible, and it is expected to die at the next regrowth.

**If the entry turns out to be wrong** — incorrect, incomplete, or impossible — stop. Do not quietly reshape it by writing a different test. Return to phase 2, fix the entry in the manifest, re-plan if needed, then resume. An entry silently bent to match the code is the black sail failure in miniature.

**If you cannot test one entry without implementing another,** the entries are wrong, not the plan. Surface it and re-cut them.

### 5. Annotate and check off

Per task, before moving on:

- `@proves {ID}` on the test, `@implements {ID}` on the code. Bare IDs, comma-separated — no paths, no links.
- **Do not restate the entry in a comment.** The statement lives in the subsystem file, and a second copy is a second thing to keep true. Explaining *why this code* satisfies the entry is different, and welcome.
- Check the task off in the story file and commit it with the work it describes. A task list updated in a batch at the end was never a plan.

Then back to phase 4 for the next task.

### 6. Close the story

- Full suite green.
- Every task checked, every delta entry tagged in code and tests.
- Story status set, and checked off in its epic.
- If it was the last story, close the epic in `docs/epics.md`.

**STOP. Report: what was promised, what was built, anything that surprised you, and any entry that changed shape along the way.**

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Writing specs into the story | The story is disposable; the spec would die with it. Specs are manifest entries. |
| Code before the delta is approved | The delta is the promise. Reversing the order is how the record goes wrong. |
| Widening an adoption because the story touched it | Adopt the boundary the story needs. Record the rest. |
| Bending an entry to match the code you wrote | Go back to phase 2 and change it deliberately, or the manifest quietly becomes fiction. |
| Weakening an invariant to make the story land | Invariants are the point. Escalate. |
| Tracking task progress only in TodoWrite | It dies with the session; a half-built story outlives it. |
| Restating the entry in the code comment | Two copies, one maintained. Tag with the ID and stop. |
| Closing the story without closing the epic | An epic reading `in progress` with every story done is the same lie as a stale manifest. |

## Common rationalizations

| Excuse | Reality |
| --- | --- |
| "The dev said do the whole story" | Translate to per-step gates and say you are doing so. |
| "These tests are trivial, I can skip the gate" | The gate is what makes you a pair rather than a contractor. |
| "I'll draft the implementation while the test is in review" | Approval, then action. Drafting ahead anchors you to one solution. |
| "I'll batch the refactors at the end" | Refactor with the context fresh. Batching loses the why. |
| "Refactoring isn't needed here" | Probably true. Say it out loud rather than skipping step 5 silently. |
| "This entry is close enough to what I built" | Close enough is the black sail. Change the entry or change the code. |
| "I'll write the delta once I see how it shakes out" | Then the code wrote the promise, which is the one thing this method exists to prevent. |
| "Two tasks are easier together" | If you cannot test one without the other, the entries are wrong. Re-cut them. |

## Red flags

- You are about to run a test with no approval message.
- You are writing implementation for a task whose test was never approved.
- You are touching code for more than one entry at a time.
- You are editing a manifest entry to match code that already exists.
- The developer has not replied and you are moving anyway.

**All of these mean: stop, say what you were about to do, and wait.**
