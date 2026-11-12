# Specs of Theseus

A way for a team of people and agents to build software together. People decide what to build and whether it's done. Agents decide how. The evals — the system's specs — are what lasts; the code can be replaced, plank by plank, like the ship of Theseus.

## Why Another System?

The short answer is because this works for me. Your mileage _will_ vary.

However, I was looking for a system that was built on known, working principles. Yet could adapt to agents alone or in some variant of agentic software factories. And in such a system, I expect that software developers will be applying _more_ rigor in the craft, but at higher levels of abstraction. 

![Specs of Theseus overview](img/0_specs_of_theseus.svg)

## Roots

Specs of Theseus borrows from:

- **[Pivotal Labs' flavor of Extreme Programming (XP)](https://labspractices.com/guides/tanzu-labs-engineer-faq/)** — a product manager who owns a prioritized backlog, small stories, coding using test-driven development, and acceptance of every story before shipping working software.
- **[Chad Fowler's Phoenix Architecture](https://aicoding.leaflet.pub/)** — software is defined with durable specifications, but implemented with disposable code. Any part of the system can be deleted and regrown, as long as the evals still hold.

## Principles

1. **Evals are the spec; code can be thrown away.** Any subsystem can be rewritten as long as every eval still passes.
2. **If you care about it, make it an eval.** Anything that isn't an eval, the agent is free to change.
3. **The edges are fixed; the inside can be redrawn.** Contracts with other systems are evals. Contracts between subsystems are disposable tests.
4. **Make the smallest change first, then look for something to regrow.** XP keeps each step small; Phoenix keeps the design from piling up patches.
5. **People decide what gets built and whether it's done; agents decide how.** People own prioritization, evals and acceptance.
6. **Anyone can stop the line.** At any step, an agent can raise an issue and hand the work back to a person. An open [issue](working-agreements.md#issues) blocks the work until a person answers it.

## The Stages

| Stage | Who | Turns | Into |
|---|---|---|---|
| [Product Planning](1-product-planning.md) | 🧑🏻‍🎨 🧑🏾‍⚖️ 🧑🏼‍💻 🧞 | Ideas | A prioritized backlog |
| [Update Evals](2-update-evals.md) | 🧑🏼‍💻 🧞 | The top story and the current evals | Reviewed evals and their failing tests |
| [Redesign System](3-redesign-system.md) | 🧑🏼‍💻 🧞 | The story, updated evals, failing tests and the code | A story with reviewed tasks |
| [Development](4-development.md) | 🧑🏼‍💻 🧞 | A story with reviewed tasks | A tagged story |
| [Acceptance](5-acceptance.md) | 🧑🏾‍⚖️ ⚙ | A tagged story | New functionality in users' hands |

More on the method:

- [Evals](evals.md) — the four kinds, how they're written, and how they link to tests.
- [Subsystems](subsystems.md) — the units underneath the system; an agent modifies, deletes, and regrows the subsystems.
- [Working Agreements](working-agreements.md) — raising issues, tools, and commits with tags.
- [Where Things Live](where-things-live.md) — how epics, stories and evals are written and stored.
- [Usage](usage.md) — installing the `theseus` Claude Code plugin and working with its skills.
- [Adopting an Existing Project](6_adopting.md) — writing the first evals for a project that has none.
- [About](about.md) — who wrote this, and where to find more.

## Legend

- 🧑🏻‍🎨 a designer
- 🧑🏾‍⚖️ a product manager
- 🧑🏼‍💻 a developer
- 🧞 an agent
- ⚙ automation, such as CI/CD

In the diagrams:

- **Boxes are activities; arrows are the artifacts passed between them.** Each box shows who does it, then names the activity with a verb.
- **Box shapes:** a box with double side borders is a work activity; a plain box is a choice or bookkeeping step, such as Choose Epic or Tag Repo.
- **Box colors:** green means people and an agent work together; red means an agent works alone; no color means people or automation, without an agent.
- **Dotted arrows** are returns that happen only sometimes, such as a rejected story or a reviewer's requested changes.
- **A role on a stage's title** means that person watches the whole stage. On Development, 🧑🏼‍💻 means the agent does the work while the developer oversees, answering issues and reading summaries.
