# The System

`docs/system.md` is the whole product, treated as the outermost boundary. It exists so that two things the subsystem layer cannot express have a home: **promises that belong to no single subsystem**, and **the decomposition itself being disposable.**

## It inherits; it does not restate

**The system's spec set is the union of its subsystems' spec sets.** `TEXT-SPEC-007` is a system promise by virtue of being a Text Acquisition promise. The system file does not copy it, reference it, or index it.

This is the rule the whole layer turns on. A system entry that restates a subsystem entry is the same promise written twice, with two binding tests, and nothing saying which wins when they drift — the failure the method is most hostile to, at the largest possible scale.

So the file is thin, and thinness is the point. It holds only what is genuinely homeless.

## What it holds

| Section | Contents |
| --- | --- |
| **Exterior boundary** | What crosses the product's edge — UI, public API, CLI, wire formats, third parties called out to |
| **Cross-cutting invariants** | `SYSTEM-INV-nnn` — properties no subsystem owns: "no data is lost on import", "all writes are authenticated", "the system degrades read-only rather than erroring when the queue is down" |
| **Non-promises** | `SYSTEM-NON-nnn` — product-level behavior that exists and is not promised |
| **Coverage** | Derived from `docs/subsystems.md` — which subsystems are adopted, which are under management, what is identified-but-not-adopted |
| **Retired** | Withdrawn system entries, visibly |

Cross-cutting invariants are the reason this file earns its place. Ask where "we never lose user data" lives today: it is not Billing's, not Text Acquisition's, not any one subsystem's. Without a system file it gets written into whichever subsystem happened to touch it — or, more often, nowhere.

They are invariants by the ordinary definition in [invariants.md](invariants.md), and they inherit all of its machinery: a category, evidence, **a binding test**, visible retirement. Nothing new to learn — but the binding test is not optional, and it is the requirement most easily lost in the inheritance. A `SYSTEM-INV` with no binding test is an aspiration with an ID.

## Populating it the first time

**An empty `Cross-cutting invariants` section is the correct initial state**, and a file that stays empty for a while is not a gap. Nothing here is inferred; every entry is declared.

Filling this section for the first time is **the largest single act of declaring intent in a codebase** — and it is dangerous in a specific way, because product-level invariants are exactly the statements that sound obviously true. "No data is lost." "Every write is authenticated." "The system stays responsive under load." Five plausible sentences can be written in two minutes, and every one of them will get a binding test and be faithfully reproduced by every future regrowth forever.

So treat first population as an adoption, not a brainstorm:

- **Run the classification gate** in [invariants.md](invariants.md), with the user, one candidate at a time. Gather from evidence — incidents, escalations, what callers actually rely on — not from what sounds like it ought to be true.
- **Default to accident when unsure, and say so.** An unrecorded promise is recoverable when someone complains. A wrongly enshrined one is permanent.
- **Prove each binding test green against the current system before the entry is written as an invariant.** One that has never passed is a guess. If it fails, that is a finding: either the invariant is wrong or you have found a real bug, and both go back to the user.
- **A short section you can defend beats a complete-looking one.** The same reasoning as partial coverage: an absent entry is recoverable, an enshrined accident is not.

**How work reaches here.** A cross-cutting invariant is written when a story delivers it, like any other entry. The path in is [refining-an-epic](../../refining-an-epic/SKILL.md) — an epic that names the invariant, sliced into stories that declare and prove them. Declaring cross-cutting invariants over code nobody has adopted is adoption-shaped work, but it is not [adopting-a-subsystem](../../adopting-a-subsystem/SKILL.md): there is no boundary to draw, because the boundary is the product's edge and it is already in this file.

## The entry is the unit of obligation, not the subsystem

This is what makes boundaries disposable without losing anything.

A rebuild may choose a different decomposition. So "Billing's invariants hold" is not a checkable statement about a system that no longer has a Billing. The checkable statement is entry-level: **every active entry, wherever it now lives, is satisfied.**

Boundaries are scaffolding for cutting. Entries are the promise. That is why IDs are permanent and why the prefix is an address recording where an entry was *issued*, not a claim about where it lives now — see [manifest-format.md](manifest-format.md).

## Freedom under constraint

> An agent may propose any decomposition — a new subsystem, merged subsystems, redrawn boundaries — provided every active entry still has a home and still holds, and the system's cross-cutting invariants still hold. The decomposition is disposable; the entries are not.

This is the practical payoff. When a new outcome arrives, the honest answer is often not "add specs to the existing subsystem." It may be a new subsystem, or a merge, or a redraw — and under the old model none of those were available, because the boundary was the one thing no cut could reach.

Propose the decomposition alongside the manifest delta, as part of the same approval. Redrawing boundaries is a design decision with the same weight as the delta itself, and it is not something to discover halfway through implementing.

## Boundary redraw

A redraw is a regrowth that spans more than one subsystem. It is reached the same way any regrowth is — from a story whose delta will not fit the shape that exists. See [regrowing-a-subsystem](../../regrowing-a-subsystem/SKILL.md), which carries the procedure.

**Preconditions:**

- Every subsystem the redraw touches is adopted, with binding tests green against current code. Untouched subsystems need not be — the gate is the affected set, not the whole manifest.
- The new decomposition is written down and approved before anything is deleted.
- Every entry in the affected set has a named destination on the other side.

**The rule that makes it safe:**

> **No entry may be orphaned by a redraw.** Every active entry lands in some subsystem on the other side, keeping its ID. Losing an entry in a redraw is losing a promise silently, which no amount of green tests will catch.

An entry that genuinely should not survive is **retired**, visibly, with what replaced it and why. Retirement is a decision; orphaning is an accident, and the difference is the entire point.

**IDs do not change.** `BILLING-SPEC-011` moving into a merged `Ledger` subsystem stays `BILLING-SPEC-011`. Renumbering would make every tag in git history a lie. Record the move in the manifest so the prefix stops being misleading — that is the reclassification case manifest-format.md already anticipates.

## Whole-system regrowth

Legal once every subsystem is adopted. **Rarely the right move**, and worth stating why rather than leaving it as an aspiration.

Subsystem regrowth works because the rest of the system stays up and keeps calling in, so the binding suite is a live referee the whole way down. Delete everything and there is no referee until the end — you are rebuilding a product from a suite that was deliberately never complete, since non-promises exist by design and scaffolding carries real weight. There are no green intermediate states to steer by.

The useful operation this unlocks is not the total rebuild. It is the boundary redraw above, available as soon as the *affected* subsystems are adopted, long before full coverage.

**The adoption gate is also a trap worth naming.** SKILL.md warns never to mass-adopt a codebase to make the manifest look complete. Putting a prize behind full coverage is exactly the incentive to adopt badly, and a manifest of rushed entries makes a regrowth worse, not possible. Adopt because a regrowth is coming, never to unlock a milestone.

## Rebuildability — what "could an agent rebuild this?" requires

The question is answerable, and the answer is a two-tier referee. A rebuild is correct when:

1. **Every active entry holds** — every `INV` and `SPEC` across every subsystem, verified by its binding test, wherever the entry now lives.
2. **Every cross-cutting invariant holds** — the `SYSTEM-INV` set.
3. **Every active capability's outcome is met** — see [capabilities.md](capabilities.md). A capability's binding evidence is the union of the binding tests of the entries it links, which is what makes an outcome checkable rather than aspirational.

Tier 1 is boundary-independent by construction, which is what lets the decomposition change. Tier 3 is the one people skip, because a green suite feels like enough — but a system can satisfy every entry and still fail to deliver the thing it was for, if the entries were the wrong set. That is a manifest defect, and it is the only kind a rebuild can surface that nothing else can.

**Coverage bounds all three.** Unadopted code has no entries, so a rebuild would silently omit it. `docs/system.md` records coverage for exactly this reason: to make the gap visible rather than letting a green rebuild imply completeness.

## Template

```markdown
# System

Part of the [spec manifest](subsystems.md). What this system does today is in
[capabilities.md](capabilities.md).

This file inherits every subsystem's specs; it does not restate them. It holds only what no
single subsystem owns.

## Exterior boundary

**Crossing the edge:** HTTP API under /api/v1, the CLI, the import file formats,
the webhook payloads
**Calls out to:** Stripe, S3, the email provider

## Coverage

Derived from [subsystems.md](subsystems.md). Whole-system regrowth requires all subsystems
adopted; boundary redraws require only the affected ones.

- Under management: Billing, Text Acquisition
- Adopted, not yet regrown: Checkout
- Identified but not adopted: Import pipeline

## Cross-cutting invariants

<a id="system-inv-001"></a>
### SYSTEM-INV-001 — No user data is lost on import failure
- **Category:** architecture
- **Statement:** A failed or interrupted import leaves the library exactly as it was; no
  partial state is visible to any caller.
- **Binding test:** [system_test.rb](../test/binding/system_test.rb) —
  "an interrupted import leaves the library unchanged"
- **Evidence:** Two support escalations in 2026 traced to partial imports.
- **Status:** active

## Non-promises

<a id="system-non-001"></a>
### SYSTEM-NON-001 — Errors currently surface as JSON in the CLI
- **Observed:** CLI errors are printed as raw JSON rather than formatted text.
- **Why not promised:** Incidental to sharing the API serializer. A regrowth may format them.

## Retired
```

## Rules

- **Inherit, never restate.** A system entry duplicating a subsystem entry is two promises where there was one.
- **Cross-cutting only.** If one subsystem owns it, it belongs to that subsystem. "Important" is not a reason to promote an entry here, exactly as "important" is not a reason to promote a spec to an invariant.
- **Every `SYSTEM-INV` has a binding test, green against the current system before the entry is written.** No exception. An untested cross-cutting invariant is the most expensive kind of aspiration, because every future regrowth will be measured against it.
- **Empty is a valid state; complete-looking is suspicious.** Populate through the classification gate, one candidate at a time, never in one sitting.
- **Coverage is derived**, not maintained. It reads from `subsystems.md`; it never disagrees with it.
- **No entry is orphaned by a redraw.** Retire deliberately or rehome; never lose one quietly.
- **IDs survive redraws.** The prefix is an address, not a claim about the current home.
- **The system file describes intent, never work state** — same as any subsystem file.
- **Adopt because a regrowth is coming**, never to unlock whole-system regrowth.