---
name: regrowing-a-region
description: Use when deleting and rebuilding a region that is already in docs/theseus/manifest.md — because entropy has made it unmaintainable, or because new requirements are large enough that patching would distort it. Use when asked to regrow, regenerate, or rewrite a subsystem from its specs.
---

# Regrowing a Region

## Overview

Delete the implementation inside a boundary and rebuild it from declared intent. The binding tests
are the referee; the manifest is the brief. Everything else inside the boundary is free.

**REQUIRED BACKGROUND:** Read the `specs-of-theseus` skill first for the model and vocabulary.

This is deliberate, reversible, and ordinary. Git holds the old implementation if the regrowth
fails. What must not be lost is intent, and intent lives in the manifest.

## Preconditions

Verify all of these before deleting anything. If any is unmet, stop and fix it first.

- [ ] The region is in `docs/theseus/manifest.md` with a drawn boundary
- [ ] Every invariant has at least one binding test
- [ ] All binding tests are **green against the current implementation** (run them; do not assume)
- [ ] The working tree is clean and committed, on a branch
- [ ] If new requirements are driving this, they are already in the manifest as specs — the
      regrowth is built from the manifest, so intent that is not in the manifest will not exist

## Checklist

Create a TodoWrite item for each step.

### 1. Choose the cut

State exactly what will be deleted: implementation files, scaffolding tests, dead configuration.
State what is kept: binding tests, the manifest, anything outside the boundary.

The cut should be as large as the boundary allows. A timid cut preserves the shape you are trying
to escape — the parts you flinch from deleting are usually the parts carrying the entropy.

Flag anything inside the boundary you are unsure about rather than quietly keeping it.

**STOP. Present the cut and get approval before deleting.**

### 2. Cut

Delete it. Do not read the old implementation for guidance afterward, and do not keep a copy in the
tree "for reference" — it is in git.

Copying the old structure defeats the purpose. If the old implementation held knowledge that is not
in the manifest, that is a manifest defect: go back, add the spec, then continue.

### 3. Design the regrowth

Design from the manifest, not from memory of what was there. Cover: the internal decomposition, how
each invariant will be satisfied, and how the specs map onto the new shape.

Invariants constrain the design. Nothing else does — internal patterns, decomposition, and file
layout are yours to choose.

**STOP. Present the design and get approval before implementing.**

### 4. Rebuild, one spec at a time

Work spec by spec, test-first:

1. Write the test for one spec, tagged with its ID
2. Watch it fail
3. Write just enough implementation to pass
4. Tag the implementation with `@spec`

Write scaffolding tests freely — they are cheap, they make progress visible, and they are expected
to be deleted at the next regrowth.

Keep binding tests running throughout. They will fail until the region is substantially rebuilt;
that is expected, and their turning green is the signal you are done.

### 5. Verify the invariants

- Every binding test green
- Performance invariants **measured**, not assumed — a threshold nobody measured is not verified
- Architectural invariants checked by inspection, and stated explicitly in your report
- Every caller identified at adoption still works

If an invariant cannot be satisfied by the new design, stop. Do not weaken the invariant to make
the regrowth succeed. Bring it back to the user: either the design is wrong or the invariant was
wrong, and that is their call.

### 6. Reconcile the manifest

- Every `@spec` tag references a real manifest entry
- Every manifest entry that should be implemented has a tag
- Specs that no longer apply are **retired visibly**, with what replaced them and why
- Behavior discovered during regrowth that is not promised is recorded as a non-promise
- Region status updated in `docs/theseus/manifest.md`

**STOP. Report: invariants verified with evidence, specs implemented, entries retired or added,
and anything that surprised you.**

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Reading the old implementation while rebuilding | Reproduces the shape you deleted. Build from the manifest. |
| Keeping the old code around "just in case" | It is in git. A copy in the tree becomes the design. |
| Weakening an invariant to make the regrowth pass | Invariants are the point. Escalate instead. |
| Asserting performance invariants without measuring | An unmeasured threshold is not verified. |
| Deleting binding tests along with scaffolding | Binding tests survive the cut. They are the referee. |
| A cut that carefully preserves the messy part | The part you flinch from deleting is usually the entropy. |
