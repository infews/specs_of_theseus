---
name: specs-of-theseus
description: Entry point for the Specs of Theseus method — evals as the durable spec, disposable code, and a team of people and agents working through product planning, updating evals, redesign, and development. Use whenever a project has docs/epics/ or docs/evals/, or the user mentions Specs of Theseus, evals, the backlog, the next story, raising an issue, @spec or @subsystem markers, or asks "what's next?" in such a project. Also use when the user wants to start using the method on a project. Figures out which stage the work is in and hands off to the right stage skill.
---

# Specs of Theseus

A method for a team of people and agents to build software. The evals — the system's specification — are what lasts. The code can be replaced plank by plank, like the ship of Theseus, as long as every eval still passes.

## Principles

Keep these in mind at every stage; the stage skills assume them.

1. **Evals are the spec; code can be thrown away.** Any subsystem can be rewritten as long as every eval still passes.
2. **If you care about it, make it an eval.** Anything that isn't an eval, an agent is free to change — so a quality nobody wrote down is a quality nobody protected.
3. **The edges are fixed; the inside can be redrawn.** Contracts with other systems are evals. Contracts between subsystems are disposable tests.
4. **Make the smallest change first, then look for something to regrow.** Small steps keep work safe; regrowing keeps the design from piling up patches.
5. **People decide what gets built and whether it's done; agents decide how.** People own prioritization, what the evals say, and acceptance.
6. **Anyone can stop the line.** When stuck, raise an issue. An open issue blocks the work until a person answers it.

## The stages

| Stage | Who | Skill |
|---|---|---|
| Adopting an existing project (once, before the stages) | developer, agent, PM for intent | `adopt-project` |
| Product Planning — idea → epic → prioritized stories | PM leads, designer, developer, agent | `product-planning` |
| Updating Evals — choose the top story, change the evals, write failing eval tests | developer, agent | `update-evals` |
| Redesigning the System — smallest change, look for something to regrow, tasks | agent, then reviewed with developer | `redesign-system` |
| Development — the per-task loop, then complete and tag the story | agent, developer oversees | `develop-story` |
| Acceptance — deploy the tag, PM accepts or rejects, release | automation, PM | none: this depends on the team's own process |

## Find where the work is

Work this out from the project's files rather than asking — the files are the record. Read `references/project-layout.md` for where everything lives.

1. **Open issues first.** Look in the `## Issues` section of every story and the `## Open Questions` section of every epic for unchecked items without an answer. If any exist, stop: show them to the person and wait. Nothing else moves while an issue is open.
2. **No `docs/evals/` but there is code?** The project hasn't been adopted. Use `adopt-project`.
3. **A story in progress?** A story's sections show its stage — there's no status field to keep in sync:
   - Checked off or struck through in its epic's **Resulting Stories** → done (accepted, or an adoption story that's finished).
   - **EARS Specifications** empty → not started.
   - **EARS Specifications** filled, **Implementation Plan** empty → `redesign-system`.
   - **Implementation Plan** has unchecked tasks, or all checked but no `story/<epic>/<story>` git tag yet → `develop-story`.
   - Tagged → in Acceptance. Nothing for an agent to do until it's accepted or rejected.
4. **Nothing in progress?** Take the top of the backlog with `update-evals`. The backlog is the stories not yet started, in epic order from `docs/epics/0000-epics.md`, then by story number.
5. **Backlog empty?** Back to `product-planning` to choose and break down the next epic.

Say which stage you found and why, then follow that stage's skill.

## Shared references

The stage skills point here for the details they share. Read only what the task needs.

- `references/project-layout.md` — where epics, stories and evals live; the epic and story templates.
- `references/evals.md` — the four kinds of eval, EARS format, `AREA-KIND-NNN` IDs, linking evals to tests with `@spec`.
- `references/subsystems.md` — what a subsystem is, `@subsystem` markers, extracting and folding back.
- `references/working-agreements.md` — raising issues, finding tool commands, commits and story tags.
- `scripts/check-eval-links.sh` — checks every eval has a test and every `@spec` tag points to a real eval.
