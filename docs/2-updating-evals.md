# Updating Evals

![Update Evals](img/2_sot_update_evals.svg)

**Why:** The evals are the spec, so a new requirement starts by changing them — before any design or code. This is test-first development applied to the whole system rather than one function.

**Who:** 🧑🏼‍💻 a developer and 🧞 an agent, together. The developer owns what the evals say; the agent helps draft them and spots what a story touches.

**In:** The prioritized backlog. The current [evals](evals.md): invariants, contracts, end-to-end tests and monitors.

**Out:** The story and its updated evals, sent to [Redesigning the System](3-redesigning-the-system.md).

## How

1. **Choose a story.** When the work queue is empty, take the story at the top of the backlog. Work is pulled, not pushed, so the product manager's order is what gets built. If the backlog is empty, go back to [Product Planning](1-product-planning.md) to choose the next epic.
2. **Read the story's acceptance criteria.**
3. **Decide which evals it adds, changes or removes** — across all four kinds, not only end-to-end tests.
4. **Write down any quality the story depends on that isn't an eval yet.** If it isn't written down, an agent may change it later.
5. **Check that the updated evals don't contradict** each other or existing invariants.

Don't skip ahead in the backlog. If the top story isn't ready, that's a planning problem — fix the order, not the pick.

The new or changed evals will fail at this point. That's expected — the next two stages make them pass.

## Raising Issues

Developers and Agents can raise an issue when the top story depends on work that hasn't been done yet, when the story conflicts with an existing invariant, or when it needs a contract changed with a system the team doesn't own.
