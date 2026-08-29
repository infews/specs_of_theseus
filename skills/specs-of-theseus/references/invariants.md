# Invariants

An invariant is a property that must hold after the implementation has been deleted and rebuilt
from scratch by someone who never saw the original.

That test — *would a from-scratch rebuild silently violate this?* — is what separates invariants
from everything else.

## The three categories

### Exterior contract
What crosses the boundary and what callers may rely on.

Function and method signatures, HTTP routes and status codes, event and message shapes, database
schema visible to others, file and wire formats, CLI flags and exit codes, error types and
conditions, authentication and authorization rules.

### Performance characteristic
What the region must cost. Always with a number, a workload, and a measurement method.

Latency at a stated percentile, throughput, memory and connection ceilings, batch sizes, timeout
and retry behavior, startup time.

> Settlement completes in under 200ms at p99 for invoices up to 500 line items, measured by
> test/binding/billing_perf_test.rb against seeded production-shaped data.

Not: "settlement should be fast."

### High-level architecture
Structural properties a rewrite could violate without any test noticing.

What the region may and may not depend on, what must remain separable, ordering guarantees,
idempotency, transactional boundaries, isolation and consistency requirements, failure and
degradation behavior, where state may live.

## What is not an invariant

Internal class decomposition, design patterns, file layout, line count, language and library
choices, private function names, internal data structures. All of these are free.

An entry naming any of them is **Procrustean** — it cuts the implementation to fit the bed and
robs regeneration of the freedom that makes it worth doing.

## Eliciting candidates

Gather from evidence, strongest first. Do not judge while gathering — judging while gathering
suppresses inconvenient findings.

1. **Callers.** Read every call site. What does each actually rely on — including things the region
   never meant to promise? This is the strongest evidence, because it is observed dependency
   rather than claimed intent.
2. **Exterior surface.** Enumerate everything crossing the boundary.
3. **Production behavior.** Latency, throughput, resource use, failure rates. Source of performance
   invariants; without this they are guesses.
4. **Architectural constraints.** Ordering, idempotency, transactionality, separability. The most
   commonly missed category, because nothing fails loudly when one is violated.
5. **Docs, comments, tickets.** Past intent, frequently stale.
6. **Existing tests.** Weak evidence. Tests assert implementation at least as often as intent, and
   a test asserting an accident makes it look deliberate.

## The classification gate

Every candidate is classified **with the user**, one at a time. This is the step that decides
whether the manifest inherits the region's entropy or sheds it.

| Classification | Meaning | Result |
| --- | --- | --- |
| **Invariant** | Must survive a total rewrite | `INV` entry + binding test |
| **Spec** | A promise, but does not constrain a rewrite | `SPEC` entry |
| **Accident** | Happens today, not promised | `NON` entry with reason |
| **Bug we are fixing** | Regrowth should behave differently | `SPEC` entry for intended behavior, note the old |
| **Don't care** | Not worth recording | nothing |

**Default to accident when unsure, and say so.** An unrecorded promise is recoverable — someone
complains and you add it. A wrongly enshrined accident is permanent: it gets a binding test, and
every future regrowth faithfully reproduces it forever.

## Why non-promises are worth writing down

A `NON` entry costs a line and does two jobs. It stops the same debate recurring every time someone
rediscovers the behavior. And it tells a regenerating agent not to reproduce something merely
because it found it in git history — without the entry, the honest inference from old code is that
the behavior was intended.
