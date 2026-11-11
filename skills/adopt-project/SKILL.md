---
name: adopt-project
description: Bring an existing ("legacy") project into Specs of Theseus — Survey Project (edges, existing tests, constraints), Record Tools, Mark Subsystems, and Write Adoption Epic, with one characterization story per product area so its first evals can be written. Use whenever the user wants to start using Specs of Theseus on a codebase that has no docs/evals/, asks to characterize or onboard an existing system, write the first evals for legacy code, or figure out what a system already promises before changing it.
---

# Adopting an Existing Project

The other stages assume evals exist and only change them. An existing project has behavior but no written spec, so its first evals are read out of what the system already does.

This skill runs the Adopt Project steps of the adoption diagram, each a box in it, and sets up the work. The adoption stories are then ranked in `product-planning` (Prioritize Stories), and their evals written story by story through `update-evals`, like any other story — adoption doesn't need to finish before real work starts.

You work with a developer throughout. The product manager joins to write the adoption epic, and decides whether surprising behavior is intended.

**Say which skill is running.** Start by telling the person: "**Specs of Theseus — Adopting an Existing Project** (`theseus:adopt-project`)", and the story or epic you're on. Say so again whenever you hand off to another skill, naming it.

## 1. Survey Project 🧑🏼‍💻 🧞

Build a picture of what the system promises and what already protects it. Read the code, not just the README.

- **Edges** — where the outside world touches the system: CLI commands, HTTP routes, message and job handlers, scheduled tasks, and the external APIs and services it calls. These become contracts and end-to-end evals.
- **Rules already enforced** — validations, database constraints, guard clauses, assertions. These are candidate invariants.
- **Existing tests** — what they cover, how, and where they're thin. Note areas with little or no coverage; they matter later.
- **Runtime checks** — monitoring config, dashboards, alerts, SLOs. Candidate monitors.
- **Tools** — the commands for tests, linters, type checks, CI. Note which Development steps have no tool yet (property testing and mutation testing often don't).
- **Product areas** — group the edges by what they're for: cart, checkout, auth. These become eval areas (`CART`, `AUTH`) and adoption stories.

Write the survey up for the developer: the areas, their edges, existing coverage, and gaps. Agree on the areas before going on.

## 2. Record Tools 🧑🏼‍💻 🧞

Add a command for each Development step to the project's `CLAUDE.md` or `AGENTS.md`: tests, property testing, mutation testing, controls and checks, the full eval suite. Where a step has no tool, raise an issue proposing one; the developer decides. See `references/working-agreements.md`.

## 3. Mark Subsystems 🧞

Add `@subsystem` markers at the entry points the survey found — one per command, controller, or job handler — and for any clearly shared code. This is the only step that touches source files, and it adds comments only: don't move code, restructure anything, or change behavior. You're labeling what exists. Run the existing tests afterwards to show nothing changed. See `references/subsystems.md`.

## 4. Write Adoption Epic 🧑🏾‍⚖️ 🧑🏼‍💻 🧞

Write it with the product manager and developer, from the survey's product areas and edges and the subsystems you marked. Write the epic as `product-planning` writes any epic — it sets up `docs/epics/` if the project has none (layout in `references/project-layout.md`). Write an epic, "Adopt Specs of Theseus", with one Characterize story per product area: "Characterize the cart", "Characterize checkout". To characterize an area is to write evals and tests for what it does today — see "Characterization" in `references/evals.md`.

On a small system, write a story for every area. On a large one, ask the PM which areas upcoming work will touch, and write stories for those; Break Down Epic in `product-planning` proposes Characterize stories for the rest when a later epic touches them.

Each story's acceptance criteria describe the area's current behavior at its edges, in Gherkin — what the survey found. Each story also names the entry-point subsystems it covers. On a small system, every marked entry point should land in some story, so none is left uncharacterized. Add the epic to `0000-epics.md` where the PM wants it.

The adoption stories go next to **Prioritize Stories** in `product-planning`, where the PM ranks them against the backlog — adopt first the areas upcoming stories will touch. Hand off there, naming it. From the backlog, each story goes through `update-evals`, whose "Characterize stories" section covers Write Evals, Run Evals, Review Evals & Tests and Complete Story.

## While adoption is under way

Until a product area is adopted, some of the system's behavior isn't written down as evals, and a regrow could change it without any eval failing. So until adoption is complete, **the project's existing tests stand in for the missing evals**: they must keep passing, and no redesign may delete them. When an area is adopted, its tests are sorted into eval tests and internal tests like any others.

Tell the developer this when you hand off. The thinner the existing tests in an area, the more `redesign-system` will raise issues before regrowing there — that's expected, and it's a reason to adopt that area sooner.

## Raise an issue

When the survey finds behavior that looks unintended (offer to record it as a story for the PM; don't change it), a step with no tool, or an edge whose owner is unclear (see `references/working-agreements.md`).
