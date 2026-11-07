# Updating Evals

![Update Evals](img/3_sot_update_evals.svg)

**Why:** The evals are the spec, so a new requirement starts by changing them — before any design or code. This is test-first development applied to the whole system rather than one function.

**Who:** 👱 🤖 a person and an agent together. People own what the evals say; the agent helps draft them and spots what a story touches.

**In:** The story. The current [evals](evals.md): invariants, contracts, end-to-end tests and monitors.

**Out:** The story and its updated evals, sent to [Redesigning the System](4-redesigning-the-system.md).

## How

1. Read the story's acceptance criteria.
2. Decide which evals it adds, changes or removes — across all four kinds, not only end-to-end tests.
3. Write down any quality the story depends on that isn't an eval yet. If it isn't written down, an agent may change it later.
4. Check that the updated evals don't contradict each other or existing invariants.

The new or changed evals will fail at this point. That's expected — the next two stages make them pass.

## Raise an issue

Raise an issue when the story conflicts with an existing invariant, or needs a contract changed with a system the team doesn't own.
