# Working agreements

How people and agents work together across every stage.

## Raising an issue

When you're stuck, or find a problem you can't settle on your own, raise an issue: write it down, stop, and tell the person in the session. Raising an issue is not a failure — guessing past a problem is.

- **Where:** the `## Issues` section of the story you're working on. Before a story exists (during epic breakdown), the epic's `## Open Questions`.
- **What:** the stage, what you were doing, what's wrong, and the specific question a person has to answer. Offer the options you see, with your recommendation.
- **Blocking:** an open issue stops that story or epic. Don't continue it until a person has written an answer under the issue and checked it off.

```markdown
## Issues

- [ ] **Redesigning the System** — `CART-INV-003` says a total can't go below zero, but `CART-E2E-007` expects a refund to make it negative. Which is right? I'd keep the invariant and change the refund eval to cap at zero.
  - Answer: _..._
```

When the answer arrives, record it under the issue, check it off, and carry on from where you stopped.

## Tools

The method doesn't choose tools; the project does. Commands live in the project's `CLAUDE.md` or `AGENTS.md`, next to whatever is already there for tests and linters. Development needs a command for each of:

- running tests (the project's frameworks)
- property testing
- mutation testing, scoped to a set of files or modules
- controls and checks — linters, type checks, security scanners, dependency audits
- the full eval suite

**When you need to do something and don't know how** — a missing command, a tool that isn't installed, a step with no tool at all — ask the person and record the answer in that file. Asking is raising an issue: the work waits. Don't guess a command and don't skip the step; a skipped step is a gate that silently stopped guarding.

## Commits and story tags

Aim for a linear history on main.

- **By default, commit straight to main.**
- **If work-in-progress commits help** — a complex story, an experiment — use a short-lived branch. Before it lands, squash it, rebase onto main, and fast-forward main. No merge commits.

Completing a story tags its final commit with the story's path:

```
story/0001-user-authentication/0010-login-form
```

The tag marks the commit where all of the story's evals pass. Deploy runs on story tags only, so only tag when everything passes.
