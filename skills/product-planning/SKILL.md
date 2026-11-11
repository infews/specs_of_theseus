---
name: product-planning
description: Specs of Theseus Product Planning — with the product manager in charge — Prioritize Ideas and Choose Epic (people only), then Break Down Epic into small stories with Gherkin acceptance criteria and Prioritize Stories into the backlog. Use whenever the user wants to write or refine an epic, slice an epic into stories, prioritize or reorder the backlog, re-rank a story the product manager rejected, or when the backlog has run out — even if they just say "let's plan the next chunk of work" or "break this feature down".
---

# Product Planning

The team needs one prioritized list of work and a person who owns its order. The product manager leads this stage and makes every priority call. The stage has four steps, each a box in the Specs of Theseus diagram. You take part in the last two; the first two are for people alone.

Your job is to make the PM's decisions easier and better informed — not to make them. Propose, explain your reasoning, and let them choose.

**Say which skill is running.** Start by telling the person: "**Specs of Theseus — Product Planning** (`theseus:product-planning`)", and the story or epic you're on. Say so again whenever you hand off to another skill, naming it.

Read `references/project-layout.md` for the epic and story templates and where the files go. If the project has no `docs/epics/` yet, create it, with an empty `0000-epics.md`, the first time you write anything down.

## 1. Prioritize Ideas 🧑🏻‍🎨 🧑🏾‍⚖️

The designer and the product manager rank ideas into prioritized work — epics, each a body of work that can be released to customers at once. Their order is the order of `docs/epics/0000-epics.md`.

This step is theirs. Don't rank ideas or suggest an order. If they ask, you can write down what they decide: add an entry to `0000-epics.md` for each new epic, in their order.

## 2. Choose Epic 🧑🏾‍⚖️

The product manager picks the next epic to break down. This step is also theirs; it's a business decision. Work comes here when Update Evals finds the backlog empty — tell the PM the backlog is empty and wait for their choice.

## 3. Break Down Epic 🧑🏾‍⚖️ 🧑🏼‍💻 🧞

Now you work with the PM and developers.

**Write the epic** if it doesn't exist yet, from the template, with the PM: Vision, Context, Scope, Success Criteria, Dependencies, Open Questions. Number it after the last epic and link it from `0000-epics.md` where the PM placed it.

Ask questions to reduce ambiguity before breaking it down — a few at a time, grouped by theme:

- **Scope** — what's explicitly out?
- **User intent** — who is the user, and what problem are they solving?
- **Edge cases** — what happens when things go wrong?
- **Success** — how will we know the epic is done, from the user's side?
- **Dependencies** — does it need anything that doesn't exist yet?

Record the answers in the epic. Unresolved ones go in **Open Questions**.

**Check that the areas the epic touches have evals.** List the product areas the epic's stories will touch, and look for each in `docs/evals/` (one file per area). An area with no evals file — or whose edges the epic touches but no eval covers — has behavior nobody has written down, and a redesign there could change it without any eval failing. For each such area, propose a **"Characterize …" story** at the top of the epic, before the stories that change that area. Its acceptance criteria describe what the area does today at its edges. See "Characterization" in `references/evals.md`. The PM decides whether to keep them.

**Slice it into stories** vertically: each story is independently deliverable, accepted on its own on working software, and small enough for one focused pass through the later stages. Thin slices from the user's side, not layers of the system ("show the login form" — not "add the users table").

For each story, write:

- **Narrative** — "As a [role], I want [goal], so that [benefit]."
- **Acceptance Criteria** — Gherkin scenarios: the happy path, then the edge cases that matter. These are what the PM will check at acceptance and what the evals will be written from, so make them concrete enough to test.

Leave **EARS Specifications** and **Implementation Plan** empty; later stages fill them.

Present all the proposed stories to the PM and developers before writing the files. They may split, merge, reorder or cut. Then create them in `docs/epics/<epic>/`, numbered in steps of 10, and link each from the epic's **Resulting Stories**.

## 4. Prioritize Stories 🧑🏾‍⚖️ 🧑🏼‍💻 🧞

Order the stories into the backlog with the PM. Story numbers are the order within an epic. Suggest an order — risky or foundational stories early, dependencies before the stories that need them — and say why. The PM decides. The prioritized backlog goes to Update Evals (`theseus:update-evals`).

Stories also arrive here from outside Break Down Epic:

- **Adoption stories** from `adopt-project`, one per product area. Suggest adopting first the areas upcoming stories will touch.
- **Stories for unintended behavior**, rarely, when characterizing an area turned up behavior the PM wants changed.
- **Rejected stories** from Acceptance — below.

### Rejected stories

A story the PM rejected in Acceptance comes back here and is ranked again against all planned work. Help the PM work out why it was rejected. Usually the evals didn't capture what they wanted — so the fix is to sharpen the acceptance criteria, and the story will get new evals when it's picked up again.

Then put it back in the backlog so the stages run again:

1. **Delete its story tag**, locally and on the remote (`git tag -d <tag>`, `git push --delete origin <tag>`). The tag says "ready for acceptance", and this commit wasn't accepted. Development tags the story again when the new pass is green.
2. **Empty its EARS Specifications and Implementation Plan.** The story now reads as not started. The evals themselves stay in `docs/evals/`, and git history keeps the old plan.
3. **Add a note under its Acceptance Criteria** saying why it was rejected, so the next pass through Update Evals sees it.
4. Renumber it if its priority changed.

## Raise an issue

Use the epic's **Open Questions** (see `references/working-agreements.md`) when:

- an epic can't be split into stories that can each be accepted on their own;
- a story's acceptance criteria are too vague to write evals from;
- the epic depends on something that doesn't exist and nobody owns.
