# Specs of Theseus

A way for a team of people and agents to build software together. People decide what to build and whether it's done. Agents decide how. The evals — the system's specs — are what lasts; the code can be replaced, plank by plank, like the ship of Theseus.

![Specs of Theseus overview](img/0_specs_of_theseus.svg)

## Roots

Specs of Theseus borrows from:

- **[Pivotal Labs' flavor of Extreme Programming (XP)](https://labspractices.com/guides/tanzu-labs-engineer-faq/)** — a product manager who owns a prioritized backlog, small stories, test-driven development, and acceptance of every story on working software.
- **[Chad Fowler's Phoenix Architecture](https://aicoding.leaflet.pub/)** — durable specifications, disposable code. Any part of the system can be deleted and regrown, as long as the specs still hold.

## Principles

1. **Evals are the spec; code can be thrown away.** Any subsystem can be rewritten as long as every eval still passes.
2. **If you care about it, make it an eval.** Anything that isn't an eval, the agent is free to change.
3. **The edges are fixed; the inside can be redrawn.** Contracts with other systems are evals. Contracts between subsystems are disposable tests.
4. **Make the smallest change first, then look for something to regrow.** XP keeps each step small; Phoenix keeps the design from piling up patches.
5. **People decide what gets built and whether it's done; agents decide how.** People own prioritization, evals and acceptance.
6. **Anyone can stop the line.** At any step, an agent can raise an issue and hand the work back to a person. An open [issue](working-agreements.md#issues) blocks the work until a person answers it.

## The stages

| Stage | Who | Turns | Into |
|---|---|---|---|
| [Product Planning](1-product-planning.md) | 🧑🏻‍🎨 🧑🏾‍⚖️ 🧑🏼‍💻 🧞 | An idea | A prioritized backlog |
| [Updating Evals](2-updating-evals.md) | 🧑🏼‍💻 🧞 | The top story and the current evals | Updated evals |
| [Redesigning the System](3-redesigning-the-system.md) | 🧑🏼‍💻 🧞 | Updated evals and the code | A story with reviewed tasks |
| [Development](4-development.md) | 🧑🏼‍💻 🧞 | A story with tasks | A completed, tagged story |
| [Acceptance](5-acceptance.md) | 🧑🏾‍⚖️ ⚙ | A tagged story | New functionality in users' hands |

More on the method:

- [Evals](evals.md) — the four kinds, how they're written, and how they link to tests.
- [Subsystems](subsystems.md) — the units underneath the system; an agent modifies, deletes, and regrows the subsystems.
- [Working Agreements](working-agreements.md) — raising issues, tools, and commits and tags.
- [Where Things Live](where-things-live.md) — how epics, stories and evals are written and stored.

## Legend

- 🧑🏻‍🎨 a designer
- 🧑🏾‍⚖️ a product manager
- 🧑🏼‍💻 a developer
- 🧞 an agent
- ⚙ automation, such as CI/CD
- In the diagrams, boxes are activities and arrows are the artifacts passed between them.
