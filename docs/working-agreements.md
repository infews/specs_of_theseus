# Working Agreements

How the team — people and agents — works together across every stage.

## Issues

When an agent is stuck, or finds a problem it can't settle on its own, it raises an issue: it writes the issue down, stops, and tells the person in the session.

- **Where:** in an `## Issues` section of the story the agent is working on. Issues raised before a story exists — during epic breakdown — go in the epic's `## Open Questions` section.
- **What:** the stage, what the agent was doing, what's wrong, and the question a person has to answer.
- **Blocking:** an open issue stops the work. No agent continues the story, or the epic, until a person writes an answer under the issue and marks it resolved.

```markdown
## Issues

- [ ] **Redesigning the System** — `CART-INV-003` says a total can't go below zero, but `CART-E2E-007` expects a refund to make it negative. Which one is right?
  - Answer: _..._
```

## Tools

Tools depend on the language and the project, so the method doesn't pick them. The commands live in the project's own agent instructions — `CLAUDE.md` or `AGENTS.md` — next to whatever is already there for running tests and linters. 

Specs of Theseus adds a tool requirement for each step of the [Development](4-development.md) loop: test framework(s), property testing, mutation testing, controls and checks, and the full eval suite.

When an agent needs to do something and doesn't know how — a missing command, a tool that isn't installed, a step with no tool at all — it asks a person and records the answer in that file. Asking is [raising an issue](#issues): the work waits for the answer. The agent never guesses and never skips the step.

## Commits and tags

Teams choose their own workflow, but trunk-based development leads to better outcomes, so the method aims for a linear history on main, in git:

- **By default, commit straight to main.**
- **If work-in-progress commits help** — a complex story, an experiment — use a short-lived branch. Before it lands, squash it, rebase it onto main, and fast-forward main. No merge commits.

Completing a story tags the final commit with the story's path:

```
story/0001-user-authentication/0010-login-form
```

The tag marks the commit where all of the story's evals pass. Deploy runs on story tags only, never on plain commits. A tag also gives the team a known-good point to roll back to.

If several stories are in progress at once, a short-lived branch per story keeps them out of each other's way; the same squash-and-rebase rule applies.
