# Update Evals

Evals. Tests by another name. Specifically they are types of tests that verify that the system is working as expected. Since we care about test-driven-development, evals are updated early and run often throughout the work on a story. 

![Update Evals](img/2_theseus_update_evals.svg)

**Why:** The [evals](evals.md) are the runnable specs, so a new requirement starts by changing them — before any design or code. This is test-first development applied to the whole system rather than one function.

**Who:** 🧑🏼‍💻 a developer and 🧞 an agent, together. The developer owns what the evals say; the agent helps draft them and spots what a story touches.

**In:** The prioritized backlog. The current [evals](evals.md): invariants, contracts, end-to-end tests and monitors.

**Out:** The story, its updated evals (the invariants, contracts, end-to-end tests, and monitors) and a failing test for each new or changed eval, reviewed by the developer and sent to [Redesign System](3-redesign-system.md).

## How

1. **Choose Story from Top of Backlog** 🧑🏼‍💻 🧞 — when Deploy signals the work queue is empty, take the story at the top of the backlog. Work is pulled, not pushed, so the product manager's order is what gets built. If the backlog is empty, go back to [Product Planning](1-product-planning.md) to choose the next epic.
2. **Update Evals** 🧑🏼‍💻 🧞 — starting from the story and the current evals:
   - Read the story's acceptance criteria.
   - Decide which evals it adds, changes or removes — across all four kinds, not only end-to-end tests. Removing functionality removes its evals and their tests; nobody keeps tests that check the old behavior is gone.
   - Write down any quality the story depends on that isn't an eval yet. If it isn't written down, an agent may change it later.
   - Check that the updated evals don't contradict each other or existing invariants.
   - Write a failing test for each new or changed eval, tagged with its `@spec` ID. Use the test frameworks the project already uses, under the project's test directory; the developer and agent decide where inside it. An invariant is a rule — "never", "always" — so its test is a property test.
3. **Review Evals & Tests** 🧑🏼‍💻 — the agent stops and the developer reviews the updated evals and, above all, their failing tests. From here on the tests are the gate, so a weak test lets wrong code through. Requested changes go back to Update Evals. Once the developer is satisfied, the evals and tests are committed, and the story, its updated evals and failing tests go on to [Redesign System](3-redesign-system.md).

Writing and reviewing the eval tests here means the agent never writes the tests that grade its own work in Development.

A ["Characterize …" story](evals.md#characterization) describes behavior the system already has, so its tests pass rather than fail, and it skips Redesign System and Development. See [Adopting an Existing Project](6_adopting.md) for its steps.

Don't skip ahead in the backlog. If the top story isn't ready, that's a planning problem — fix the order, not the pick.

The new or changed evals will fail at this point. That's expected — the next two stages make them pass.

## Raising Issues

Developers and Agents can raise an issue when it detects a problem. For example, when the top story depends on work that hasn't been completed or when the story conflicts with an existing eval.
