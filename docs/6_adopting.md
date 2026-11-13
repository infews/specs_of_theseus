# Adopting an Existing Project

What if you haven't started using Specs of Theseus for a project, how do you start? You adopt the project. An existing project has behavior but no written spec, so its first work is to infer evals out of the existing tests.

![Adopting an Existing Project](img/6_adopting.svg)

**Who:** 🧑🏼‍💻 a developer and 🧞 an agent do most of the work. 🧑🏾‍⚖️ the product manager helps write the adoption epic, ranks its stories, and decides whether surprising behavior is intended.

**In:** A working project's code and existing tests, with no evals.

**Out:** An adopted system, evals and passing tests for every product area, and an empty work queue for the normal flow. No behavior changes.

## How

The `adopt-project` skill runs the Adopt Project steps:

1. **Survey Project** 🧑🏼‍💻 🧞 — find the system's edges: CLI commands, routes, message handlers, external APIs it calls. Find what already exists: tests, validations, database constraints, monitoring, CI, and the commands that run tests and linters. Note where the existing tests are thin. Group the edges into product areas.
2. **Record Tools** 🧑🏼‍💻 🧞 — write a command for each [Development](4-development.md) step into the project's `CLAUDE.md` or `AGENTS.md`. Where a step has no tool, the developer decides. See [Tools](working-agreements.md#tools).
3. **Mark Subsystems** 🧞 — add `@subsystem` comments at the entry points the survey found. This is the only step that touches source files, and it adds comments only: no code moves, nothing is restructured, and no behavior changes. See [Subsystems](subsystems.md).
4. **Write Adoption Epic** 🧑🏾‍⚖️ 🧑🏼‍💻 🧞 — with the product manager, write one ["Characterize …" story](evals.md#characterization) per product area. To characterize an area is to write evals and tests that record what it does today, so they pass the first time they run. One story per area, such as "Characterize the cart", with acceptance criteria describing what the area does today at its edges. Each story names the marked entry-point subsystems it covers. On a small system, write a story for every area. On a large one, write stories for the areas upcoming work will touch; [Break Down Epic](1-product-planning.md) proposes Characterize stories for the rest when a later epic touches them.

The adoption stories then join the normal flow — `product-planning` for step 5, `update-evals` for steps 6 to 10:

5. **Prioritize Stories** 🧑🏾‍⚖️ 🧑🏼‍💻 🧞 — the product manager ranks them against the rest of the backlog. Adopt first the areas upcoming stories will touch.
6. **Choose Story from Top of Backlog** 🧑🏼‍💻 🧞 — like any other story. When no adoption stories are left, the system is adopted, and the empty work queue hands back to the normal flow.
7. **Write Evals** 🧑🏼‍💻 🧞 — like Update Evals for any story, except the evals describe what the system already does:
   - **Work from the outside in.** Contracts and end-to-end tests first — they sit at the edges, where behavior is visible without reading the code. Then invariants, often found in validations, database constraints and existing tests. Then monitors, from existing dashboards and alerts.
   - **Pin current behavior.** The eval tests are characterization tests: they record what the system does, so they should pass.
   - **Raise an issue for behavior that looks wrong.** It's rare, but if the current behavior looks unintended, raise an issue: describe the behavior, and offer to record it as a new story for the product manager to rank. Either way, the eval pins what the system does today — adoption changes no behavior. If the behavior is changed later, that story's own Update Evals changes the eval.
   - **Sort the existing tests** in that area. Tests that check an eval get its `@spec` tag. The rest become internal tests, which a redesign may delete.
8. **Run Evals** 🧞 — run the new evals' tests. A failing eval means the eval or its test doesn't yet match what the system does, so it goes back to Write Evals. Loop until every eval passes.
9. **Review Evals & Tests** 🧑🏼‍💻 — the developer reviews the evals and tests, as for any story. Requested changes go back to Write Evals. Once the developer is satisfied, the evals and tests are committed and go to Complete Story.
10. **Complete Story** 🧞 — once the eval-link check passes, the story is checked off in its epic. An adoption story builds nothing, so it skips Redesign System and Development. The completed story goes back to Choose Story for the next one.

## While Adoption Is Under Way

Until a product area is adopted, some of the system's behavior isn't written down as evals. A regrow could change it and no eval would fail.

So, until adoption is complete, **the project's existing tests stand in for the missing evals.** They must keep passing, and no redesign may delete them. When their area is adopted, they're sorted into eval tests and internal tests like any others.

The team doesn't have to finish adoption before starting real work. On a large system, adoption usually goes epic by epic: Break Down Epic spots areas an epic touches that have no evals, and puts Characterize stories at the top of that epic. The existing tests are the safety net meanwhile, and the need for it shrinks as adoption goes on.
