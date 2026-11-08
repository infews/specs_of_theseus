# Adopting an Existing Project

The stages assume evals already exist and only change them. An existing project has behavior but no written spec, so its first evals are read out of what the system already does.

**Who:** 🧑🏼‍💻 a developer and 🧞 an agent. 🧑🏾‍⚖️ the product manager decides whether surprising behavior is intended.

**In:** A working project with no evals.

**Out:** An "Adopt Specs of Theseus" epic, with one story per product area, ready for [Updating Evals](2-updating-evals.md).

## How

1. **Survey the project.** Find its edges — CLI commands, routes, message handlers, external APIs it calls. Find what already exists: tests, validations, database constraints, monitoring, CI, and the commands that run tests and linters. Note where the existing tests are thin.
2. **Write the adoption epic.** One story per product area, such as "Characterize the cart." Order them by the backlog: adopt first the areas upcoming stories will touch.
3. **Record the tools** in the project's `CLAUDE.md` or `AGENTS.md`. See [Tools](working-agreements.md#tools).
4. **Mark subsystems** at the entry points. See [Subsystems](subsystems.md).

Each adoption story then goes through [Updating Evals](2-updating-evals.md) like any other, except its evals describe what the system already does:

- **Work from the outside in.** Contracts and end-to-end tests first — they sit at the edges, where behavior is visible without reading the code. Then invariants, often found in validations, database constraints and existing tests. Then monitors, from existing dashboards and alerts.
- **Pin current behavior.** The eval tests are characterization tests: they record what the system does, not what it should do.
- **Raise an issue for behavior that looks wrong.** The product manager decides whether it's intended. If it isn't, the eval records the intended behavior and fixing it becomes a new story.
- **Sort the existing tests** in that area. Tests that check an eval get its `@spec` tag. The rest become internal tests, which a redesign may delete.

An adoption story builds nothing, so it skips Redesigning the System and Development.

## While adoption is under way

Until a product area is adopted, some of the system's behavior isn't written down as evals. A regrow could change it and no eval would fail.

So, until adoption is complete, **the project's existing tests stand in for the missing evals.** They must keep passing, and no redesign may delete them. When their area is adopted, they're sorted into eval tests and internal tests like any others.

The team doesn't have to finish adoption before starting real work. Stories can run alongside adoption; the existing tests are the safety net, and it shrinks on its own as adoption goes on.
