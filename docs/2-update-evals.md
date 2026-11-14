# Update Evals

Evals. Tests by another name. Specifically they are types of tests that verify that the system is working as expected. Since we care about test-driven-development, evals are updated early and run often throughout the work on a story. 

![Update Evals](img/2_theseus_update_evals.svg)

**Why:** the [evals](evals.md) are the runnable specs. A new requirement starts by changing the evals before any design or code. This is test-first development applied to the whole system rather than one function.

**Who:** 🧑🏼‍💻 a developer and 🧞 an agent, together. The developer writes or updates the evals with the agent's help. Together they ensure the story is covered.

**In:** the prioritized backlog's next story and the [evals](evals.md). All of the invariants, contracts, end-to-end tests and monitors need to be reconsidered.

**Out:** the story, its updated evals (the invariants, contracts, end-to-end tests, and monitors) and failing tests for each new or changed eval, reviewed by the developer and sent to [Redesign System](3-redesign-system.md).

## How

1. **Choose Story from Top of Backlog** 🧑🏼‍💻 🧞 — when Deploy signals the work queue is empty, take the story at the top of the backlog. Work is pulled, not pushed, so the product manager's order is what gets built. If the backlog is empty, go back to [Product Planning](1-product-planning.md) to choose the next epic.
2. **Update Evals** 🧑🏼‍💻 🧞 — starting from the story and the current evals:
   - Read the story's acceptance criteria.
   - Decide which evals it adds, changes or removes - across all four kinds, not only end-to-end tests. Removing functionality removes its evals and their tests. When behavior is removed from the system, the associated evals and tests are deleted.
   - Write down any quality the story depends on that isn't an eval yet. If it isn't written down, an agent may change it later.
   - Check that the updated evals don't contradict each other or existing invariants.
   - Write a failing test for each new or changed eval, tagged with its `@spec` ID. Use the test frameworks the project already uses, under the project's test directory. The developer and agent decide where. An invariant is a rule (e.g., "never", "always") so its test is a property test.
3. **Review Evals & Tests** 🧑🏼‍💻 — the agent stops and the developer reviews the updated evals and their failing tests. This sets up test-driven developer later in the process. Requested changes go back to Update Evals. Once the developer is satisfied, the evals and tests are committed, and the story, its updated evals and failing tests go on to [Redesign System](3-redesign-system.md).

Writing and reviewing the eval tests here means the agent never writes the tests that grade its own work in Development.

A ["Characterize …" story](evals.md#characterization) describes behavior the system already has. Its tests pass on first run rather than fail. This story skips Redesign System and Development. See [Adopting an Existing Project](6_adopting.md) for its steps.

Don't skip ahead in the backlog. If the first story at the top of the backlog isn't ready to start, that's a planning problem. Fix the order, not the choice.

The new or changed evals will fail at this point. That's expected. The next two stages make them pass.

## Raising Issues

Developers and Agents can raise an issue when it detects a problem. Like when the top story depends on work that hasn't been completed or when the story conflicts with an existing eval.
