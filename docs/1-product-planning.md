# Product Planning

Product planning is the stage at the front where ideas are taken, sorted, discussed, and then prioritized as work that goes into the main system.

![Product Planning](img/1_theseus_product_planning.svg)

**Why:** The team needs one prioritized list of work and a person who owns its order. This is the Pivotal Labs or XP planning loop, with an agent helping to break epics down.

**Who:** 🧑🏾‍⚖️ the product manager leads. 🧑🏻‍🎨 a designer helps set product priorities. 🧞 an agent helps break down epics into an ordered list of stories, and 🧑🏼‍💻 developers vet its work.

**In:** Ideas. Stories rejected at [Acceptance](5-acceptance.md). While a project is being [adopted](6_adopting.md), its adoption stories to move 

**Out:** A prioritized backlog of stories - the ideas vetted and turned into intent.

## How

1. **Prioritize Ideas** 🧑🏻‍🎨 🧑🏾‍⚖️ — rank ideas into prioritized work. Each epic is a collection of work that is release-able at once to customers.
2. **Choose Epic** 🧑🏾‍⚖️ — pick the next epic to break down and potentially start. This is primarily a business decision, though all team members can contribute information (ideas, intent, technical need).
3. **Break Down Epic** 🧑🏾‍⚖️ 🧑🏼‍💻 🧞 — split the epic into small, independent stories, each with acceptance criteria. First, check whether the product areas the epic touches have evals. For any that don't, the agent proposes a ["Characterize …" story](evals.md#characterization) at the top of the epic, so the area's current behavior is written down before anything changes it.
4. **Prioritize Stories** 🧑🏾‍⚖️ 🧑🏼‍💻 🧞 — order the stories into the backlog. Rejected stories come back here and are ranked again against all planned work. Going back into the backlog deletes the story's tag and clears its evals list and tasks, so it starts again at Update Evals.

When the backlog runs dry, [choosing a story](2-update-evals.md) sends the team back to choose the next epic.

## Raise an issue

An agent should raise an issue when an epic can't be split into stories that can each be accepted on their own, or when a story's acceptance criteria are too vague to write evals from.
