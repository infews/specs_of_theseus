# The system layer — making the decomposition disposable

Date: 2026-09-12

## The problem

The method says implementation shape is disposable: patterns, class decomposition, file layout, line count. It says nothing about **subsystem boundaries**, because the boundary is the unit of cutting and therefore survives every cut by construction.

So you can regrow Billing's insides forever and never regrow the decision that Billing is separate from Checkout. Boundaries get drawn early, under maximum ignorance, and become permanently load-bearing. "Entropy accumulates in implementations, not in intent" was always half the story — **decomposition entropy is a third category**, and it had no escape hatch at all. A system whose decomposition had gone wrong had no move available.

The method already half-knew. manifest-format.md: *"An ID is an address, not an assertion… When they diverge — an entry reclassified, **a boundary split** — reclassify deliberately."* It anticipated boundary splits at the ID level and provided no process for one.

A second, smaller gap: cross-cutting promises had no home. "We never lose user data," "all writes are authenticated," "the system degrades read-only when the queue is down" — these are invariants by the ordinary definition, they need binding tests, and they belong to no subsystem. In practice they get written into whichever subsystem happens to touch them, or nowhere.

## The design

Treat the whole product as the outermost boundary: `docs/system.md`.

**It inherits; it does not restate.** The system's spec set *is* the union of its subsystems' spec sets. `TEXT-SPEC-007` is a system promise by virtue of being a Text Acquisition promise. This is the rule the layer turns on — a system entry that copies a subsystem entry is one promise written twice, with two binding tests and no tiebreak when they drift.

So the file is thin, and thinness is the point. It holds the exterior boundary, the cross-cutting invariants, product-level non-promises, and coverage derived from `subsystems.md`. Nothing else.

**The entry, not the subsystem, is the unit of obligation.** This is what makes boundaries disposable without losing anything. A rebuild may choose a different decomposition, so "Billing's invariants hold" is not checkable against a system with no Billing. "Every active entry holds, wherever it now lives" is. Boundaries are scaffolding for cutting; entries are the promise.

**Freedom under constraint.** An agent may propose any decomposition — a new subsystem, merged subsystems, redrawn boundaries — provided every active entry still has a home and still holds, and the cross-cutting invariants hold. Proposed alongside the manifest delta, in the same approval, because a redraw carries the delta's weight and discovering it mid-implementation is how it gets done badly.

**No entry may be orphaned by a redraw.** Every active entry lands somewhere on the other side keeping its ID, or is retired visibly. This is the one failure a redraw can produce that nothing downstream catches: a lost promise breaks no test, because the test went with it. Hence the rehoming table — a transcription from the manifest, presented before anything is deleted, read back after.

**IDs survive redraws.** `BILLING-SPEC-011` inside a merged `Ledger` stays `BILLING-SPEC-011`. Renumbering would make every tag in git history a lie, and the prefix was always an address rather than a claim about the current home.

## Rebuildability

"Could an agent rebuild the whole system?" is now answerable, as a two-tier referee plus an outcome check:

1. Every active entry holds — every `INV` and `SPEC` across every subsystem, verified by its binding test, wherever it now lives. Boundary-independent by construction, which is what lets the decomposition change.
2. Every cross-cutting invariant holds.
3. Every active capability's outcome is met, its evidence being the union of the binding tests of the entries it links.

Tier 3 is the one that gets skipped, because a green suite feels like enough. But a system can satisfy every entry and still fail to deliver what it was for, if the entries were the wrong set — a manifest defect, and the only kind a rebuild surfaces that nothing else does.

Coverage bounds all three, which is why `system.md` records it: unadopted code has no entries, so a green rebuild must not be allowed to imply completeness.

## Scope decisions

**Whole-system regrowth is legal at full coverage and is not the point.** Subsystem regrowth works because the rest of the system stays up and keeps calling in, so the binding suite is a live referee the whole way. Delete everything and there is no referee until the end, rebuilding from a suite that was deliberately never complete. There are no green intermediate states to steer by. It is documented as a limit case with the failure mode stated, so nobody attempts it casually.

**The operation that actually pays is the boundary redraw**, gated on the *affected* subsystems being adopted rather than all of them. That unlocks incrementally, long before full coverage.

**The adoption gate is a trap and is labelled as one.** The method warns never to mass-adopt to make the manifest look complete. Putting a prize behind full coverage is precisely the incentive to adopt badly, and a manifest of rushed entries makes a rebuild worse rather than possible.

## Rejected

**Product-as-subsystem with restated feature entries.** The first version of this idea had `PRODUCT-SPEC-012` for duplicate detection alongside `TEXT-SPEC-007`. Inheritance replaced it and killed the duplication entirely.

**Replacing capabilities.md.** Inheritance yields the *set* of active specs. The capability layer's jobs are grouping and outcome, and neither falls out of a union — the specs stay scattered across subsystem files with nothing naming them "duplicate detection" and nothing saying why it mattered. The two layers are complementary, on different axes: `system.md` is a composition record, `capabilities.md` is a feature projection.

**A separate `redrawing-boundaries` skill.** Folded into `regrowing-a-subsystem` as a mode instead, consistent with the existing stance that regrowth has no entry point of its own.

## What one epic and one story found

Run 2026-09-13, on a hardening epic. Four fixes, all applied:

- **No route to "declare cross-cutting invariants over unmanaged code."** Adoption-shaped work fitting none of the three routing rows, and `system.md` said a `SYSTEM-INV` is "written when a story delivers it" without naming the path. Now a row in the core routing table and in `delivering-a-story` phase 1, plus an explicit path note in `system.md`.
- **The empty cross-cutting section was unguided** — and populating it is the largest single act of declaring intent in a codebase. The near-miss reported was "someone moving faster would fill it with five plausible sentences," which is precisely the aspirational document the method exists to prevent. Now a *Populating it the first time* section: classification gate, default to accident, binding test green before the entry is called an invariant.
- **"They inherit all of its machinery" hid the binding-test requirement** behind indirection to `invariants.md`. Now stated inline and as a rule.
- **`docs/system.md`'s cross-cutting invariants can govern the work rather than the product** — what the suite may depend on, what a fixture may contain. A hardening epic inverts the risk question entirely. `refining-an-epic` now asks in both directions.

Validated without changes: the capability/cross-cutting distinction correctly routed a cross-command property to `capabilities.md` rather than `system.md`, and the *none — delivered in unmanaged code* rule surfaced three zero-entry capabilities and two withdrawals on first write.

## Still open

- The redraw path has never been run, and the rehoming table is the kind of transcription step an agent under time pressure will summarize instead of performing.
- Reconcile still does not exist, so nothing mechanically checks that rehomed entries kept their tags.
- Phase 6 of `delivering-a-story` still does not re-check the story's acceptance criteria — carried over from the capability layer, unresolved.
- Whether cross-cutting invariants should also be listed in the subsystems they constrain. Centrally is DRY but easy to miss during a regrowth; per-subsystem is a pointer rather than a restatement, which is the duplication the method already tolerates for tags. Left central for now, with redraw preconditions forcing the check instead.