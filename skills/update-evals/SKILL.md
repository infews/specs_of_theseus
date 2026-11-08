---
name: update-evals
description: Specs of Theseus Updating Evals — choosing the top story from the backlog, then changing the system's evals (invariants, contracts, end-to-end tests, monitors) to describe it as EARS requirements, and writing a failing test for each, before any design or code. Use whenever the user wants to start the next story, pick up work from the backlog, write or change evals, write acceptance or characterization tests for a story, or work through an adoption story ("characterize the cart") — even if they just say "what's next?" or "let's start on login".
---

# Updating Evals

The evals are the system's spec, so a new requirement starts by changing them — before any design or code. This stage ends with the story's evals written down and a failing test for each one.

You work with a developer. They own what the evals say; you draft them, spot what the story touches, and write the tests. Show your drafts and get their agreement before writing files — the evals are the one artifact the rest of the work answers to.

Read `references/evals.md` before writing any eval. It has the four kinds, the EARS patterns and the ID format.

## 1. Choose the story

When nothing is in progress, take the story at the top of the backlog: the first not-started story, in epic order from `docs/epics/0000-epics.md`, then by story number. Don't skip ahead — the PM's order is what gets built. If the top story isn't ready, that's a planning problem: raise an issue rather than picking a different one.

If the backlog is empty, hand back to `product-planning` to choose the next epic.

## 2. Work out which evals the story changes

Read the story's acceptance criteria and the current evals in `docs/evals/`. Decide which evals it **adds, changes or removes** — across all four kinds, not just end-to-end:

- **End-to-end** — each acceptance scenario usually yields one or more.
- **Invariants** — rules the scenarios imply ("never", "always", "only").
- **Contracts** — any change at the system's edge: an API it provides, or one it calls.
- **Monitors** — performance or reliability the story depends on.

Then look for qualities the story relies on that aren't evals yet. Say them out loud to the developer. If nobody writes them down, a later redesign is free to change them.

## 3. Check for contradictions

Check the new and changed evals against each other and against every existing invariant. A contradiction here is cheap; found during development it's expensive.

## 4. Write the evals

Add them to the product area's file in `docs/evals/` (format in `references/project-layout.md`). Use the next unused number for each area and kind. Retired evals: delete the line and their tests; never reuse an ID.

List the IDs the story adds or changes in its **EARS Specifications** section.

## 5. Write a failing test for each

For each new or changed eval, write a test tagged `@spec <ID>`, using the test frameworks the project already uses. Agree with the developer where the eval tests live. An invariant is a rule, so its test is a property test.

Run them and confirm each fails for the expected reason — not a syntax error or a missing fixture. A changed eval's old test should now fail; a removed eval's tests are deleted.

Writing the eval tests here, with the developer, means the agent in Development never writes the tests that grade its own work.

Commit the evals and tests. The story moves on to `redesign-system`.

## Adoption stories

A story from an "Adopt Specs of Theseus" epic describes behavior the system already has. The steps are the same, with three differences:

- **Work from the outside in.** Contracts and end-to-end first — they sit at the edges, visible without reading code. Then invariants, often found in validations, database constraints and existing tests. Then monitors, from existing dashboards and alerts.
- **Pin current behavior.** These are characterization tests: they record what the system does, so they should pass, not fail.
- **Raise an issue for behavior that looks wrong.** The PM decides whether it's intended. If not, the eval records the intended behavior and the fix becomes a new story.

Also sort the area's existing tests: tag the ones that check an eval with its `@spec`; the rest become internal tests. Adoption stories build nothing, so they skip Redesign and Development. Once the evals and tests are committed and the eval-link check passes (`scripts/check-eval-links.sh`), check the story off in the epic's **Resulting Stories**.

## Raise an issue

In the story's **Issues** section (see `references/working-agreements.md`) when:

- the top story depends on work that hasn't been done;
- the story conflicts with an existing invariant;
- it needs a contract changed with a system the team doesn't own;
- the acceptance criteria are too vague to turn into evals.
