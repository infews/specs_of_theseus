# Telling Intent from Accident

The hardest part of bringing code under management, and the step that decides whether the manifest inherits the subsystem's entropy or sheds it.

A subsystem cannot be trusted to describe itself. Its observable behavior mixes deliberate promises, accidents people now depend on, bugs that became load-bearing, and side effects nobody knows exist. Capture behavior wholesale and you enshrine the entropy in the one artifact meant to outlive it. Capture only what someone can articulate and you delete things real users depend on.

## The invariant test

> **Would a from-scratch rebuild, by someone who never saw the original, silently violate this?**

That single question separates invariants from everything else. Three categories qualify:

- **Exterior contract** — signatures, routes, status codes, event and message shapes, visible schema, file and wire formats, CLI flags, error types, auth rules.
- **Performance characteristic** — latency at a stated percentile, throughput, memory and connection ceilings, batch sizes, timeout and retry behavior. Always with a number, a workload, and a measurement method.
- **High-level architecture** — what it may depend on, what must stay separable, ordering, idempotency, transactional boundaries, failure and degradation behavior, where state may live.

**Not invariants, and free to change:** internal class decomposition, design patterns, file layout, line count, language and library choices, private function names, internal data structures.

## Gathering candidates

Strongest evidence first. **Do not judge while gathering** — judging while gathering suppresses inconvenient findings.

| Evidence | Strength | Why |
| --- | --- | --- |
| Actual callers, and what each relies on | Strongest | Observed dependency, not claimed intent — including things the subsystem never meant to promise |
| Exterior surface | Strong | The observable contract |
| Production behavior — latency, throughput, resource ceilings | Strong | Without it, performance invariants are guesses |
| Architectural constraints — ordering, idempotency, transactionality | Strong | The most commonly missed category; nothing fails loudly when one is violated |
| Docs, comments, tickets | Medium | States past intent, frequently stale |
| Existing tests | **Weak** | They assert implementation at least as often as intent, and a test asserting an accident makes it look deliberate |

## The gate

**Classify every candidate with the user, one at a time. Do not classify alone** — this step requires the human, and it is the reason the skill exists.

| Classification | Meaning | Result |
| --- | --- | --- |
| **Invariant** | Must survive a total rewrite | `INV` entry + binding test |
| **Spec** | A promise, but does not constrain a rewrite | `SPEC` entry |
| **Accident** | Happens today, not promised | `NON` entry, with the reason |
| **Bug we are fixing** | The regrowth should behave differently | `SPEC` entry for the intended behavior, noting the old |
| **Don't care** | Not worth recording | nothing |

**Default to accident when unsure, and say so out loud.** An unrecorded promise is recoverable — someone complains and you add it. A wrongly enshrined accident is permanent: it gets a binding test, and every future regrowth faithfully reproduces it forever.

**When a candidate could be either a spec or an invariant, make it a spec.** Promotion later costs paperwork; a wrongly enshrined invariant costs forever.

**Write each decision down as it is made**, not at the end. These decisions cost the user's attention and cannot be reconstructed from the code — which is the whole reason this step exists. A long list will outlast a session, and losing it means asking the same questions twice.

## Greenfield is the same gate with worse evidence

Declaring intent for code that does not exist yet removes the central difficulty — there are no accidents to tell from intent, because nothing has happened yet. It replaces it with a different one: **everything you write is a guess, and guesses written as invariants are load-bearing forever.**

Candidates come from the acceptance criteria rather than from callers. Two consequences:

- **Write fewer invariants.** Adoption's come from real callers under real pressure; yours came from a conversation. A new subsystem with nine invariants has legislated a design nobody has built.
- **A performance invariant with no measurement is an aspiration.** Nothing runs yet. Either it comes from a real external constraint — a caller's timeout, an SLA — or it waits.

Say in the report that the entries have never been checked against an independent implementation. That check happens at the first regrowth.