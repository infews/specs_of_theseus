---
name: regrowing-a-subsystem
description: Use when deleting and rebuilding a subsystem that is already in docs/subsystems.md — because entropy has made it unmaintainable, or because new requirements are large enough that patching would distort it. Also use when the decomposition itself is wrong and subsystems need merging, splitting, or their boundaries redrawn. Use when asked to regrow, regenerate, or rewrite a subsystem from its specs.
---

# Regrowing a Subsystem

## Overview

Delete the implementation inside a boundary and rebuild it from declared intent. The binding tests are the referee; the manifest is the brief. Everything else inside the boundary is free.

**REQUIRED BACKGROUND:** Read the [specs-of-theseus](../specs-of-theseus/SKILL.md) skill first for the model and vocabulary.

This is deliberate, reversible, and ordinary. Git holds the old implementation if the regrowth fails. What must not be lost is intent, and intent lives in the manifest.

## Where this is reached from

Usually from inside a story, when [delivering-a-story](../delivering-a-story/SKILL.md) finds the manifest delta large enough that patching would distort the subsystem. The cut becomes the story's first task, and the story resumes afterward.

Occasionally directly, when entropy alone is the driver and there is no product change behind it. Even then, **write the story first.** A regrowth with no story is a body of work with no record of why it happened and nowhere to track how far it got.

## Two modes

**Ordinary regrowth** rebuilds the inside of one boundary. The boundary is fixed; everything within it is free.

**Redraw** changes the decomposition itself — merging subsystems, splitting one, or moving behavior between them. Reach for it when the work keeps fighting the shape: a story that spans three subsystems every time, a boundary that no longer matches how the behavior actually clusters, two subsystems that only ever change together.

The decomposition is disposable. Boundaries get drawn early, under maximum ignorance, and a boundary nobody revisits becomes load-bearing by accident. Redraw is how that entropy gets shed — see [system.md](../specs-of-theseus/references/system.md).

The checklist below runs the same either way, with the additions marked **(redraw)**.

## Preconditions

Verify all of these before deleting anything. If any is unmet, stop and fix it first.

- [ ] The subsystem is in `docs/subsystems.md` with a drawn boundary
- [ ] Every invariant has at least one binding test
- [ ] All binding tests are **green against the current implementation** (run them; do not assume)
- [ ] The working tree is clean and committed, on a branch
- [ ] If new requirements are driving this, they are already in the manifest as specs — the regrowth is built from the manifest, so intent that is not in the manifest will not exist
- [ ] **(redraw)** *Every* subsystem the redraw touches is adopted, with its binding tests green. The gate is the affected set, not the whole manifest — untouched subsystems need not be adopted.
- [ ] **(redraw)** The cross-cutting invariants in `docs/system.md` are identified and their binding tests are green. They belong to no subsystem, so no subsystem's regrowth will notice when one breaks.

## Tracking the work

Two levels, because they have different lifetimes.

**The six steps below** — tracked however this session allows, TodoWrite or a written list.

**The entries being rebuilt** — the task list in the story file. Committed, because a regrowth can span sessions and an interrupted one leaves a deleted implementation behind. `regrowth in progress` in the manifest says a subsystem is mid-flight; the story's tasks say how far.

Never track entry-by-entry progress in the session alone. It does not survive, and the session is not the unit a regrowth is measured in.

**Never track it in the subsystem file either.** That file describes intent, and intent has no progress. Putting work state there fills the history of the one document you want to read as a record of what the system promises with rows about what was green on Tuesday.

## Checklist

### 1. Choose the cut

State exactly what will be deleted: implementation files, scaffolding tests, dead configuration. State what is kept: binding tests, the manifest, anything outside the boundary.

The cut should be as large as the boundary allows. A timid cut preserves the shape you are trying to escape — the parts you flinch from deleting are usually the parts carrying the entropy.

Flag anything inside the boundary you are unsure about rather than quietly keeping it.

**(redraw) Present the new decomposition and the rehoming plan in the same breath as the cut.**

- **The shape.** What subsystems exist on the other side, what each is for, and where each boundary now falls. Say what the current decomposition costs, concretely — the stories that kept spanning it, the changes that always touched both.
- **The rehoming table.** Every active entry in the affected set, and its destination. This is a transcription from the manifest, not a judgement: read the entries out and give each one a home.

| Entry | From | To | Note |
| --- | --- | --- | --- |
| `BILLING-SPEC-011` | Billing | Ledger | unchanged |
| `BILLING-INV-003` | Billing | Ledger | unchanged |
| `CHECKOUT-SPEC-002` | Checkout | Ledger | boundary moved; statement unchanged |
| `CHECKOUT-SPEC-009` | Checkout | — | **retire** — superseded by `BILLING-SPEC-011` |

**No entry may be orphaned.** Every active entry lands somewhere, or is retired visibly with what replaced it and why. This is the one failure a redraw can produce that nothing downstream will catch: a lost promise breaks no test, because the test went with it. An entry with no obvious home is a decision to bring to the user, never a row to leave blank.

**IDs do not change.** `BILLING-SPEC-011` stays `BILLING-SPEC-011` inside Ledger. The prefix records where an entry was issued, not where it lives — renumbering would make every tag in git history a lie. See [manifest-format.md](../specs-of-theseus/references/manifest-format.md).

**STOP. Present the cut — and, for a redraw, the shape and the rehoming table — and get approval before deleting.**

### 2. Cut

Delete it. Do not read the old implementation for guidance afterward, and do not keep a copy in the tree "for reference" — it is in git.

Copying the old structure defeats the purpose. If the old implementation held knowledge that is not in the manifest, that is a manifest defect: go back, add the spec, then continue.

### 3. Design the regrowth and plan the work

Design from the manifest, not from memory of what was there. Cover: the internal decomposition, how each invariant will be satisfied, and how the specs map onto the new shape.

Invariants constrain the design. Nothing else does — internal patterns, decomposition, and file layout are yours to choose.

Then write the plan into the story's task list — every active invariant and spec inside the boundary, broken into red/green/refactor steps, each naming the entry it serves. The entry list comes from the manifest, so that part is a transcription rather than a judgement: if an entry is missing it will not get built, and if a task names nothing in the manifest, you are about to build unpromised behavior.

An implausibly long plan is information. Thirty entries usually means the cut was drawn too wide.

**STOP. Present the design and the plan, and get approval before implementing.**

### 4. Rebuild, one spec at a time

Work down the task list one task at a time, test-first, with the same gates [delivering-a-story](../delivering-a-story/SKILL.md) uses — one TDD discipline, not two:

1. Write the test for one entry, tagged `@proves` with its ID. **Gate: approval before running it.**
2. Run it. Confirm it fails for the expected reason.
3. Write just enough implementation to pass, tagged `@implements`. **Gate: approval before running again.**
4. Run it. Confirm green.
5. Refactor while the context is fresh. **Gate: approval before refactoring.** If nothing needs it, say so rather than skipping silently.

Write scaffolding tests freely — they are cheap, they make progress visible, and they are expected to be deleted at the next regrowth.

Check the task off as you go, and commit it with the work it describes. A task list updated in a batch at the end was never a plan.

Keep binding tests running throughout. They will fail until the subsystem is substantially rebuilt; that is expected, and their turning green is the signal you are done.

### 5. Verify the invariants

- Every binding test green
- Performance invariants **measured**, not assumed — a threshold nobody measured is not verified
- Architectural invariants checked by inspection, and stated explicitly in your report
- Every caller identified at adoption still works
- **(redraw)** Every entry on the rehoming table accounted for — each one either satisfied in its new home or retired visibly. Read the table back; do not infer it from a green suite, which cannot tell a satisfied promise from a deleted one.
- **(redraw)** The cross-cutting invariants in `docs/system.md` re-verified. A redraw moves behavior across boundaries, which is exactly the move that breaks a property no boundary owns.

If an invariant cannot be satisfied by the new design, stop. Do not weaken the invariant to make the regrowth succeed. Bring it back to the user: either the design is wrong or the invariant was wrong, and that is their call.

### 6. Reconcile the manifest

- Every `@proves` and `@implements` tag references a real manifest entry
- Every manifest entry that should be implemented has a tag
- Specs that no longer apply are **retired visibly**, with what replaced them and why
- Behavior discovered during regrowth that is not promised is recorded as a non-promise
- Subsystem status updated in `docs/subsystems.md`
- Every task in the story checked off, and the story closed
- Nothing describing work state left in the subsystem file — it records intent only
- **(redraw)** Subsystem files created, merged, or deleted to match the new shape; rehomed entries listed in their destination file with their original IDs
- **(redraw)** `docs/subsystems.md` rows added and removed, and a dissolved subsystem's row taken out rather than left reading `under management`
- **(redraw)** `docs/capabilities.md` links still resolve — a capability pointing at a retired entry needs its link swapped or the capability withdrawn, since capability status is derived from the entries it links

**STOP. Report: invariants verified with evidence, specs implemented, entries retired or added, and anything that surprised you. For a redraw, report the rehoming table as executed — every entry, where it landed, and what was retired.**

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Reading the old implementation while rebuilding | Reproduces the shape you deleted. Build from the manifest. |
| Keeping the old code around "just in case" | It is in git. A copy in the tree becomes the design. |
| Weakening an invariant to make the regrowth pass | Invariants are the point. Escalate instead. |
| Asserting performance invariants without measuring | An unmeasured threshold is not verified. |
| Deleting binding tests along with scaffolding | Binding tests survive the cut. They are the referee. |
| A cut that carefully preserves the messy part | The part you flinch from deleting is usually the entropy. |
| Tracking entry progress only in the session | It dies with the session, and a half-regrown subsystem outlives it. |
| Putting the progress table in the subsystem file | That file is intent. Work state belongs to the story, which is deleted when the work is. |
| Regrowing with no story behind it | Nothing records why, and nothing tracks how far. Write the story first, even for a pure-entropy cut. |
| Leaving a row blank on the rehoming table | An entry with no home is a decision for the user, not an omission to fill in later. |
| Renumbering entries to match their new subsystem | The prefix is an address, not a claim. Renumbering makes every tag in git history a lie. |
| Redrawing around a subsystem that is not adopted | You would be rehoming entries that do not exist. Adopt the affected set first. |
| Treating a green suite as proof nothing was orphaned | A deleted promise takes its test with it. Read the rehoming table back, entry by entry. |
| Skipping cross-cutting invariants because no subsystem owns them | That is precisely why a redraw is when they break. |
| Working around a bad boundary instead of proposing a redraw | The decomposition is disposable. Say what a redraw would cost and let the user decide. |
