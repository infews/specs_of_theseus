---
name: update-evals
description: Specs of Theseus Update Evals — choosing the top story from the backlog, then changing the system's evals (invariants, contracts, end-to-end tests, monitors) to describe it as EARS requirements, writing a failing test for each, and stopping for the developer's review, before any design or code. Use whenever the user wants to start the next story, pick up work from the backlog, write or change evals, write acceptance or characterization tests for a story, or work through a Characterize story ("characterize the cart") — even if they just say "what's next?" or "let's start on login".
---

# Update Evals

The evals are the system's spec, so a new requirement starts by changing them — before any design or code. This stage ends with the story's evals written down and a failing test for each one.

The stage has three steps, each a box in the Specs of Theseus diagram. In the first two you work with a developer: they own what the evals say; you draft them, spot what the story touches, and write the tests. The third is the developer's review, and you stop for it.

**Say which skill is running.** Start by telling the person: "**Specs of Theseus — Update Evals** (`theseus:update-evals`)", and the story or epic you're on. Say so again whenever you hand off to another skill, naming it.

Read `references/evals.md` before writing any eval. It has the four kinds, the EARS patterns and the ID format.

## 1. Choose Story from Top of Backlog 🧑🏼‍💻 🧞

Start a story when the work queue is empty: no story is in Update Evals, Redesign System or Development. A story already tagged and waiting in Acceptance doesn't block the next one — Deploy is what signals the queue is empty.

Take the story at the top of the backlog: the first not-started story, in epic order from `docs/epics/0000-epics.md`, then by story number. Don't skip ahead — the PM's order is what gets built. If the top story isn't ready, that's a planning problem: raise an issue rather than picking a different one.

If the backlog is empty, hand back to `product-planning` — its Choose Epic step — so the PM can choose the next epic.

A story the PM rejected comes back with a note in its acceptance criteria saying why. Its earlier evals are still in `docs/evals/`; this pass changes them.

## 2. Update Evals 🧑🏼‍💻 🧞

Starting from the story and the current evals, work through these with the developer.

**Work out which evals the story changes.** Read the story's acceptance criteria and the current evals in `docs/evals/`. Decide which evals it **adds, changes or removes** — across all four kinds, not just end-to-end:

- **End-to-end** — each acceptance scenario usually yields one or more.
- **Invariants** — rules the scenarios imply ("never", "always", "only").
- **Contracts** — any change at the system's edge: an API it provides, or one it calls.
- **Monitors** — performance or reliability the story depends on.

**Removing functionality** removes its evals. Don't add evals or tests that check the old behavior is gone — a test for something that no longer exists protects nothing. Unless the absence is itself a requirement the PM cares about ("the system shall not export card numbers"), in which case it's a new eval like any other.

Then look for qualities the story relies on that aren't evals yet. Say them out loud to the developer. If nobody writes them down, a later redesign is free to change them.

**Check for contradictions** between the new and changed evals, and against every existing invariant. A contradiction here is cheap; found during development it's expensive.

**Write the evals** in the product area's file in `docs/evals/` (create the folder and file if they don't exist yet) (format in `references/project-layout.md`). Use the next unused number for each area and kind. Retired evals: delete the line and their tests; never reuse an ID. List the IDs the story adds, changes or removes in its **EARS Specifications** section.

**Write a failing test for each** new or changed eval, tagged `@spec <ID>`, using the test frameworks the project already uses. An invariant is a rule, so its test is a property test.

- **Where:** under the project's existing test directory (`test/`, `spec/`, `tests/`…) — never a new top-level folder. Agree with the developer where inside it.
- **Naming:** where test names are strings (`describe`/`it`, `test "…"`), the name should still read as a sentence. If you put the eval ID in the name, put it at the end: `it "shows an empty cart when the last item is removed (CART-E2E-001)"`. The `@spec` comment is the link either way.

Run them and confirm each fails for the expected reason — not a syntax error or a missing fixture. A changed eval's old test should now fail; a removed eval's tests are deleted.

Writing the eval tests here, with the developer, means the agent in Development never writes the tests that grade its own work.

## 3. Review Evals & Tests 🧑🏼‍💻

Stop. This step is the developer's: they review the updated evals and, above all, the failing tests. The tests matter most — from here on they are the gate, and a weak test lets wrong code through.

Hand them what they need: each eval next to its test, what each test checks and how it fails now, and anything you weren't sure of. Then wait.

- **Requested changes** go back to step 2. Make them, rerun the tests, and return here for another review.
- **Once the developer is satisfied,** commit the evals and tests. The story, its updated evals and the failing tests go on to `redesign-system`.

## Characterize stories

A "Characterize …" story describes behavior the system already has (see "Characterization" in `references/evals.md`). It comes from an "Adopt Specs of Theseus" epic, or from the top of any epic, where Break Down Epic proposed it for an area with no evals. The adoption diagram splits step 2 into a loop — **Write Evals** 🧑🏼‍💻 🧞 and **Run Evals** 🧞 — and ends with **Complete Story** 🧞 instead of going on to Redesign System.

**Write Evals** 🧑🏼‍💻 🧞 — as in step 2, with three differences:

- **Work from the outside in.** Contracts and end-to-end first — they sit at the edges, visible without reading code. Then invariants, often found in validations, database constraints and existing tests. Then monitors, from existing dashboards and alerts.
- **Pin current behavior.** These are characterization tests: they record what the system does, so they pass, not fail.
- **Raise an issue for behavior that looks wrong.** It's rare, but if the current behavior looks unintended, raise an issue: describe the behavior, and offer to record it as a new story for the PM to rank in `product-planning`. Either way, the eval pins what the system does today — characterizing changes no behavior. If the behavior is changed later, that story's own Update Evals changes the eval.

Also sort the area's existing tests: tag the ones that check an eval with its `@spec`; the rest become internal tests.

**Run Evals** 🧞 — run the new evals' tests. A failing eval means the eval or its test doesn't match what the system does yet: go back to Write Evals and fix it. Loop until every eval passes.

**Review Evals & Tests** 🧑🏼‍💻 — the same as step 3: stop for the developer. Requested changes go back to Write Evals. Once they're satisfied, commit the evals and tests — but go on to Complete Story, not `redesign-system`.

**Complete Story** 🧞 — once the eval-link check passes (`scripts/check-eval-links.sh`), check the story off in the epic's **Resulting Stories**. Characterize stories build nothing, so they skip Redesign System and Development. Go back to Choose Story for the next one. In an adoption epic, when no Characterize stories are left, the system is adopted, and the work queue is empty for the normal flow.

## Raise an issue

In the story's **Issues** section (see `references/working-agreements.md`) when:

- the top story depends on work that hasn't been done;
- the story conflicts with an existing invariant;
- it needs a contract changed with a system the team doesn't own;
- the acceptance criteria are too vague to turn into evals.
