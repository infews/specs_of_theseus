# Specs of Theseus — Design

Date: 2026-08-28

## Concept

The running system is replaceable material. The declared intent is the durable asset.

Code and most tests are planks. The **spec manifest** and its **binding tests** are what make the
system the same ship after every plank has been replaced. Change happens by regeneration rather
than accretion: new requirements trigger a deliberate decision about how much to delete so the
system can be rethought *including* them.

Lineage: Chad Fowler's Regenerative Development / Phoenix Architecture. The contribution here is
the durable artifact that makes routine deletion survivable — a manifest of intent that outlives
any particular implementation, and an inventory that stays accurate as code comes and goes.

### Why deletion is the routine move

Normal development accretes because deletion is frightening: the code is the only place the
intent is written down, so throwing it away loses knowledge. Once intent lives outside the code,
deletion stops being destructive and becomes husbandry. Entropy accumulates in implementations,
not in intent, so periodically discarding implementations is how the system stays young.

## Durable vs disposable

| Durable | Disposable |
| --- | --- |
| Spec manifest (invariants, specs, non-promises, retirements) | Implementation code |
| Binding tests — full-system, outcome-level, proving invariants | Scaffolding tests — unit tests on implementation details |
| Exterior contracts, performance characteristics, high-level architecture | Internal patterns, class decomposition, line count |

We care less — but not zero — about implementation shape. It is free to change so long as the
invariants hold.

## Artifacts

```
docs/subsystems/
  manifest.md      # coverage index: which subsystems are under management
  <subsystem>.md      # per subsystem: invariants, specs, non-promises, retired entries
```

Coverage is **partial by design**. The manifest states what it speaks for; code outside a covered
subsystem is not a violation, it is simply not yet under management.

Entry types, all with stable IDs `{SUBSYSTEM}-{TYPE}-{NNN}`:

- **Invariant** (`INV`) — must survive a total rewrite. Categories: contract, performance,
  architecture. Always has at least one binding test. Performance invariants state a measurable
  threshold or they are not invariants.
- **Spec** (`SPEC`) — a behavioral promise, written in EARS. Binding-tested when observable at the
  boundary; scaffolding-tested otherwise.
- **Non-promise** (`NON`) — behavior that exists today and is explicitly *not* promised, with the
  reason. Stops the same debate recurring, and tells a regenerating agent not to reproduce
  something merely because it appears in git history.
Retirement is a **status**, not a type: an entry keeps its ID forever and is moved to a Retired
section recording what replaced it and why. IDs are never reused, or every `@spec` tag in git
history becomes a lie.

Invariants and specs are separate classes, not the same thing at different strengths. Most specs
are not invariants. The cut decision needs a short, high-status list to check against.

`@spec` tags in code and tests carry the IDs, giving the manifest-to-reality thread.

## Failure modes the process must resist

- **Procrustean specs** — specs that legislate implementation detail, cutting the code to fit the
  bed. A spec that constrains internal shape is a defect in the manifest.
- **Black sail** — the manifest says one thing, reality another, and someone acts on the record.
  Drift is the central risk; reconcile exists to catch it.
- **Enshrined entropy** — capturing current behavior wholesale into binding tests, making the mess
  permanent in the one artifact that is supposed to be durable.

## Skills

- **`specs-of-theseus`** (core) — the model and the router. Holds vocabulary and formats as
  references; decides whether a subsystem is under management and dispatches accordingly.
- **`adopting-a-subsystem`** — brownfield entry point. Boundary → invariant candidates → human
  classification → subsystem file → binding tests proven green against the *existing* implementation.
- **`regrowing-a-subsystem`** — the engine. Cut, redesign, TDD back to green, verify invariants,
  re-tag, update the manifest. Reused by both entry points.

Deferred until after the first real regeneration: steady-state change (epic → invariant impact →
manifest update → choose the cut → regrow) and reconcile (manifest ↔ tags). Also deferred: CLI,
plugin packaging, CI drift enforcement, whole-codebase adoption.

## First test case

A specific high-entropy subsystem in an existing codebase. Skills are symlinked from this repo
into `~/.claude/skills/` so they are live in the target project while remaining editable here.
