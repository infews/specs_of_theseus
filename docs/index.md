# Specs of Theseus

A way for a team of people and agents to build software together. People decide what to build and whether it's done. Agents decide how. The evals — the system's specs — are what lasts; the code can be replaced, plank by plank, like the ship of Theseus.

![Specs of Theseus overview](img/0_specs_of_theseus.svg)

## Roots

Specs of Theseus borrows from two places:

- **[Pivotal Labs' flavor of XP](https://labspractices.com/)** — a product manager who owns a prioritized backlog, small stories, test-driven development, and acceptance of every story on working software.
- **[Chad Fowler's Phoenix Architecture](https://aicoding.leaflet.pub/)** — durable specifications, disposable code. Any part of the system can be deleted and regrown, as long as the specs still hold.

## Principles

1. **Evals are the spec; code can be thrown away.** Any subsystem can be rewritten as long as every eval still passes.
2. **If you care about it, make it an eval.** Anything that isn't an eval, the agent is free to change.
3. **The edges are fixed; the inside can be redrawn.** Contracts with other systems are evals. Contracts between subsystems are disposable tests.
4. **Make the smallest change first, then look for something to regrow.** XP keeps each step small; Phoenix keeps the design from piling up patches.
5. **People decide what gets built and whether it's done; agents decide how.** People own prioritization, evals and acceptance.
6. **Anyone can stop the line.** At any step, an agent can raise an issue and hand the work back to a person.

## The stages

| Stage | Who | Turns | Into |
|---|---|---|---|
| [Product Planning](1-product-planning.md) | 👱 🤖 | An idea | A prioritized backlog |
| [Choosing a Story](2-choosing-a-story.md) | 👱 🤖 | The backlog | One story |
| [Updating Evals](3-updating-evals.md) | 👱 🤖 | A story and the current evals | Updated evals |
| [Redesigning the System](4-redesigning-the-system.md) | 🤖 | Updated evals and the code | A story with tasks |
| [Development](5-development.md) | 🤖 | A story with tasks | A completed story |
| [Deploy, Accept, Release](6-deploy-accept-release.md) | ⚙ 👱 | A completed story | New functionality in users' hands |

The four kinds of eval are defined in [Evals](evals.md).

## Legend

- 👱 a person, sometimes a product manager, sometimes a developer
- 🤖 an agent
- ⚙ automation, such as CI/CD
- In the diagrams, boxes are activities and arrows are the artifacts passed between them.

## Open items

- The diagrams don't yet show Acceptance as a 👱 step.
- The diagrams don't yet show "raise an issue" arrows back to a person.
- The overview and the Story Planning diagram disagree on when updated evals are saved to the repo.
