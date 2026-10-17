---
name: regrowing-a-subsystem
description: Use when existing code needs its intent declared before it can be changed safely, when new behavior needs a subsystem that does not exist yet, or when a subsystem's implementation should be deleted and rebuilt from its declared intent. Use when asked to adopt, characterize, extract invariants from, grow, regrow, regenerate, or rewrite a subsystem.
---

# Regrowing a Subsystem

Declare what must survive, delete the implementation inside a boundary, rebuild from the manifest. The binding tests are the referee; the manifest is the brief. Everything else inside the boundary is free.

This is deliberate, reversible, and ordinary. Git holds the old implementation. What must not be lost is intent, and intent lives in the manifest.

**REQUIRED BACKGROUND:** Read [specs-of-theseus](../specs-of-theseus/SKILL.md) first for the model and vocabulary.

## Three ways in

| Situation | Start at |
| --- | --- |
| Existing code, no entries — *adopt* | Step 1. Classification is the work; steps 4–8 may be a separate later job. |
| New behavior, no code, no entries — *grow* | Step 1, with candidates from the acceptance criteria. Then build under the everyday loop; there is nothing to cut. |
| Entries exist, the implementation must go — *regrow* | Step 4. |

**Adopt only the boundary the work in front of you needs.** Record the rest as identified-but-not-adopted. Widening coverage under delivery pressure is exactly how entropy gets enshrined.

## 1. Draw the boundary

Name the subsystem. State what is inside and outside, in files and modules. Then map the edges: who calls in and what each depends on, what it calls out to, and what crosses — signatures, routes, event shapes, schemas, formats, flags.

The boundary is one you **draw**, not one you discover. It may follow the existing module structure, but in a high-entropy area that structure is often *the* entropy. Draw the smallest defensible boundary around the behavior worth promising. If no clean edge exists, say so and propose a smaller subsystem.

**STOP. Present the boundary and get approval.**

## 2. Classify

Gather candidates and walk them with the user, per [classifying.md](../specs-of-theseus/references/classifying.md). Write each decision down as it is made.

**STOP. Present the classification and get approval.**

## 3. Write the entries and prove them

Create `docs/subsystems/<name>.md` and add a manifest row with status `adopted — not yet regrown`, per [manifest.md](../specs-of-theseus/references/manifest.md). Record the boundary in the file — the cut depends on it.

Write a binding test for every invariant and **run them against the code as it stands. Every one must pass before anything is deleted.** A binding test never green against the current ship is a guess, and the regrowth would be measured against a guess.

When one fails, that is a finding, not a defect in the test: either the invariant was stated wrong or you have found a real bug. Take it back to the user and reclassify.

**STOP. Report which tests pass and any invariant that turned out to be false.**

The subsystem is now adopted. **It is not under management** — that status is earned by a regrowth, never by writing intent down well.

## 4. Choose the cut

Preconditions, all verified rather than assumed:

- [ ] The subsystem is in the manifest with a drawn boundary
- [ ] Every invariant has at least one binding test
- [ ] Every binding test is **green against the current implementation** — run them
- [ ] New requirements driving this are already in the manifest; intent not in the manifest will not exist
- [ ] Clean tree, committed, on a branch

State exactly what will be deleted — implementation files, scaffolding tests, dead configuration — and what is kept: binding tests, the manifest, everything outside the boundary.

**The cut should be as large as the boundary allows.** A timid cut preserves the shape you are trying to escape; the parts you flinch from deleting are usually the parts carrying the entropy. Flag anything you are unsure about rather than quietly keeping it.

**STOP. Present the cut and get approval before deleting.**

## 5. Cut

Delete it. **Do not read the old implementation afterward, and do not keep a copy in the tree "for reference"** — it is in git, and a copy in the tree becomes the design.

If the old code held knowledge that is not in the manifest, that is a manifest defect: go back, add the entry, then continue.

## 6. Rebuild

Design from the manifest, not from memory of what was there. Invariants constrain the design; nothing else does.

Then work entry by entry under the everyday loop — failing test, implementation, green, refactor, tag. Write scaffolding tests freely; they are cheap and expected to die at the next regrowth.

Binding tests will fail until the subsystem is substantially rebuilt. That is expected, and their turning green is the signal you are done.

**An implausibly long plan is information.** Thirty entries usually means the cut was drawn too wide.

## 7. Verify

- Every binding test green
- Performance invariants **measured**, not assumed — an unmeasured threshold is not verified
- Architectural invariants checked by inspection and stated explicitly in your report
- Every caller identified at step 1 still works

**If an invariant cannot be satisfied by the new design, stop.** Do not weaken it to make the regrowth succeed. Either the design is wrong or the invariant was, and that is the user's call.

## 8. Reconcile

- Every `@proves` and `@implements` tag names a real entry, and every entry that should be implemented has a tag
- Entries that no longer apply are retired visibly, with what replaced them
- Behavior discovered during regrowth that is not promised is recorded as a `NON`
- Status updated to `under management`
- Nothing describing work state left in the subsystem file

**STOP. Report: invariants verified with evidence, entries implemented, entries retired or added, and anything that surprised you.**