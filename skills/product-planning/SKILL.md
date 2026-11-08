---
name: product-planning
description: Specs of Theseus Product Planning — turning ideas into epics, breaking an epic into small stories with Gherkin acceptance criteria, and ordering the backlog, with the product manager in charge. Use whenever the user wants to write or refine an epic, slice an epic into stories, prioritize or reorder the backlog, re-rank a story the product manager rejected, or when the backlog has run out — even if they just say "let's plan the next chunk of work" or "break this feature down".
---

# Product Planning

The team needs one prioritized list of work and a person who owns its order. The product manager leads this stage and makes every priority call; a designer helps set product priorities; you help break epics down and suggest an order; developers vet your work.

Your job is to make the PM's decisions easier and better informed — not to make them. Propose, explain your reasoning, and let them choose.

Read `references/project-layout.md` for the epic and story templates and where the files go.

## 1. Choose an epic

The PM picks the next epic. An epic is a body of work that can be released to customers at once. If it doesn't exist yet, write it from the template with the PM: Vision, Context, Scope, Success Criteria, Dependencies, Open Questions. Number it after the last epic and add it to `docs/epics/0000-epics.md` in the position the PM chooses.

Ask questions to reduce ambiguity before breaking it down — a few at a time, grouped by theme:

- **Scope** — what's explicitly out?
- **User intent** — who is the user, and what problem are they solving?
- **Edge cases** — what happens when things go wrong?
- **Success** — how will we know the epic is done, from the user's side?
- **Dependencies** — does it need anything that doesn't exist yet?

Record the answers in the epic. Unresolved ones go in **Open Questions**.

## 2. Break the epic into stories

Slice vertically: each story is independently deliverable, accepted on its own on working software, and small enough for one focused pass through the later stages. Thin slices from the user's side, not layers of the system ("show the login form" — not "add the users table").

For each story, write:

- **Narrative** — "As a [role], I want [goal], so that [benefit]."
- **Acceptance Criteria** — Gherkin scenarios: the happy path, then the edge cases that matter. These are what the PM will check at acceptance and what the evals will be written from, so make them concrete enough to test.

Leave **EARS Specifications** and **Implementation Plan** empty; later stages fill them.

Present all the proposed stories to the PM and developers before writing the files. They may split, merge, reorder or cut. Then create them in `docs/epics/<epic>/`, numbered in steps of 10, and link each from the epic's **Resulting Stories**.

## 3. Prioritize

Order the stories with the PM. Story numbers are the order within an epic, and the order of `0000-epics.md` is the order of epics. Suggest an order — risky or foundational stories early, dependencies before the stories that need them — and say why. The PM decides.

### Rejected stories

When the PM rejects a story at acceptance, it comes back here and is ranked again against all planned work. Help the PM work out why it was rejected. Usually the evals didn't capture what they wanted — so the fix is to sharpen the acceptance criteria, and the story will get new evals when it's picked up again. Renumber it if its priority changed.

## Raise an issue

Use the epic's **Open Questions** (see `references/working-agreements.md`) when:

- an epic can't be split into stories that can each be accepted on their own;
- a story's acceptance criteria are too vague to write evals from;
- the epic depends on something that doesn't exist and nobody owns.
