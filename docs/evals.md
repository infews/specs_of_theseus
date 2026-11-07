# Evals

Evals are the specification of the system. They are what survives a rewrite. Code, internal tests and subsystem boundaries can all be thrown away; evals can only be changed on purpose, in [Updating Evals](3-updating-evals.md).

If a quality matters — a behavior, a performance target, a structural rule — it has to be an eval. Otherwise an agent may change it while redesigning.

There are four kinds.

## Invariants

Properties that must always hold, no matter how the system is built.

- Behavioral: "a balance never goes negative."
- Structural: "the billing subsystem never depends on the UI."

Invariants are usually checked with property tests and architecture checks.

## Contracts

The promises the system makes at its edges: APIs it provides to other systems, and APIs it depends on. Changing one needs agreement from someone outside the system.

Contracts *between subsystems* are not evals. They are internal tests the agent writes to keep its own work honest, and it may delete or rewrite them when it redraws subsystem boundaries.

## End-to-end tests

Whole user flows through the running system, written from the story's acceptance criteria. These are the closest thing to what the product manager checks at Acceptance.

## Monitors

Checks on how a live system behaves: latency, error rates, resource use, business signals. They matter most for running services such as web apps.

- Where possible, a monitor should also run under test, so a regression is caught before deploy.
- Some can only run in production.
- A system with no live service, such as a CLI, may still have monitor-like checks — for example, "this command finishes in under a second on the reference data set."
