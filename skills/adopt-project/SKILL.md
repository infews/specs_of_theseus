---
name: adopt-project
description: Bring an existing ("legacy") project into Specs of Theseus — survey its edges, existing tests, constraints and tools, mark its subsystems, and write an adoption epic with one characterization story per product area so its first evals can be written. Use whenever the user wants to start using Specs of Theseus on a codebase that has no docs/evals/, asks to characterize or onboard an existing system, write the first evals for legacy code, or figure out what a system already promises before changing it.
---

# Adopting an existing project

The other stages assume evals exist and only change them. An existing project has behavior but no written spec, so its first evals are read out of what the system already does.

This skill does the survey and sets up the work. The evals themselves are written story by story through `update-evals`, like any other story — adoption doesn't need to finish before real work starts.

You work with a developer. The product manager decides whether surprising behavior is intended.

## 1. Survey the project

Build a picture of what the system promises and what already protects it. Read the code, not just the README.

- **Edges** — where the outside world touches the system: CLI commands, HTTP routes, message and job handlers, scheduled tasks, and the external APIs and services it calls. These become contracts and end-to-end evals.
- **Rules already enforced** — validations, database constraints, guard clauses, assertions. These are candidate invariants.
- **Existing tests** — what they cover, how, and where they're thin. Note areas with little or no coverage; they matter later.
- **Runtime checks** — monitoring config, dashboards, alerts, SLOs. Candidate monitors.
- **Tools** — the commands for tests, linters, type checks, CI. Note which Development steps have no tool yet (property testing and mutation testing often don't).
- **Product areas** — group the edges by what they're for: cart, checkout, auth. These become eval areas (`CART`, `AUTH`) and adoption stories.

Write the survey up for the developer: the areas, their edges, existing coverage, and gaps. Agree on the areas before going on.

## 2. Record the tools

Add a command for each Development step to the project's `CLAUDE.md` or `AGENTS.md`: tests, property testing, mutation testing, controls and checks, the full eval suite. Where a step has no tool, raise an issue proposing one; the developer decides. See `references/working-agreements.md`.

## 3. Mark subsystems

Add `@subsystem` markers at the entry points — one per command, controller, or job handler — and for any clearly shared code. Don't restructure anything; this is labeling what exists. See `references/subsystems.md`.

## 4. Write the adoption epic

Create `docs/epics/` and `docs/evals/` if needed (layout in `references/project-layout.md`). Write an epic, "Adopt Specs of Theseus", with one story per product area: "Characterize the cart", "Characterize checkout".

Each story's acceptance criteria describe the area's current behavior at its edges, in Gherkin — what the survey found. Order them with the PM by the backlog: adopt first the areas upcoming stories will touch. Add the epic to `0000-epics.md` where the PM wants it.

Each story then goes through `update-evals`, which has a section on adoption stories: work from the outside in, pin current behavior, raise issues for behavior that looks wrong, and sort the existing tests.

## While adoption is under way

Until a product area is adopted, some of the system's behavior isn't written down as evals, and a regrow could change it without any eval failing. So until adoption is complete, **the project's existing tests stand in for the missing evals**: they must keep passing, and no redesign may delete them. When an area is adopted, its tests are sorted into eval tests and internal tests like any others.

Tell the developer this when you hand off. The thinner the existing tests in an area, the more `redesign-system` will raise issues before regrowing there — that's expected, and it's a reason to adopt that area sooner.

## Raise an issue

When the survey finds behavior that looks unintended, a step with no tool, or an edge whose owner is unclear (see `references/working-agreements.md`).
