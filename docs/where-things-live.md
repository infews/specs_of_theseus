# Where Things Live

Everything lives in the project's repo, under `/docs`.

```
docs/
  epics/
    0000-epics.md                  # index of all epics
    0001-user-authentication.md    # an epic
    0001-user-authentication/      # its stories
      0010-login-form.md
      0020-password-validation.md
  evals/
    auth.md                        # one file per product area
    cart.md
```

## Epics and Stories

Epics and stories are Markdown files in `docs/epics/`.

- **Epics** are named with a 4-digit number and a short slug: `0001-user-authentication.md`. Each new epic is linked from the index, `0000-epics.md`.
- **Stories** live in a folder named after their epic: `0001-user-authentication/`. They are numbered in steps of 10 — `0010`, `0020`, `0030` — so stories split out or discovered later can slot in between. The numbering reflects the prioritization from the Product Planning stage.

### An epic

```markdown
# User Authentication

## Vision
What's the goal? What problem are we solving, and for whom?

## Context
Why now? What background does the team need?

## Scope
### In Scope
### Out of Scope

## Success Criteria
How will we know the epic is done, from the user's point of view?

## Dependencies
Anything this needs that doesn't exist yet — other teams, services, data.

## Open Questions
Anything unresolved. Issues raised during epic breakdown go here.

## Resulting Stories
- [Login form](0001-user-authentication/0010-login-form.md)
```

The epic is written in [Product Planning](1-product-planning.md). Epic breakdown adds its stories to **Resulting Stories**, and each is checked off or struck through when it's accepted — or, for a "Characterize story," when its evals are committed.

### A story

````markdown
# Login Form

## Narrative
As a [role], I want [goal], so that [benefit].

## Acceptance Criteria
```gherkin
Feature: Login form

  Scenario: Successful login
    Given a registered user
    When they submit valid credentials
    Then they see their dashboard
```

## EARS Specifications
- `AUTH-E2E-001`
- `AUTH-INV-002`

## Implementation Plan
- [ ] Extract session handling into its own subsystem
- [ ] Add the login form

## Issues
````

A story's sections show where it is. There's no separate status to keep in sync. 

- Empty EARS Specifications means not started
- An Implementation Plan with unchecked tasks means in Development
- A story tag means in Acceptance
- A checked-off story in its epic means done. 
- A ["Characterize …" story](evals.md#characterization) never gets a plan or a tag: it's checked off as soon as its evals are committed. 
- A rejected story's tag is deleted and its EARS Specifications and Implementation Plan are emptied, so it reads as not started again.

Each section is filled in by a different stage:

- **Narrative** and **Acceptance Criteria** — [Product Planning](1-product-planning.md), during epic breakdown.
- **EARS Specifications** — [Update Evals](2-update-evals.md). It lists the IDs of the evals the story adds, changes or removes; the evals themselves live in `docs/evals/`.
- **Implementation Plan** — [Redesign System](3-redesign-system.md). A plain checklist of tasks, checked off during [Development](4-development.md).
- **Issues** — any stage, when someone gets stuck. See [Issues](working-agreements.md#issues).

## Evals

Evals live in `docs/evals/`, one file per product area, grouped by kind. Each eval is one list item: its `AREA-KIND-NNN` ID, then its EARS text. Each one is checked by a test in the project's own language. The tests always live in the project's test directory. They have the eval's ID in a `@spec` comment. A monitor that only runs in production points to its configuration instead. See [Evals](evals.md).

```markdown
# Cart

## Invariants
- `CART-INV-003`: The system shall never allow a cart total below zero.

## End-to-end
- `CART-E2E-001`: When a shopper removes the last item, the system shall show an empty cart.

## Monitors
- `CART-MON-001`: The system shall add an item to a cart within 200 ms at p95.
  - Monitor: `config/monitors/cart.yml`
```

When an eval is retired, its line and its tests are deleted. IDs are never reused.

## In the code

- **Subsystems** are marked with a `@subsystem` comment at their entry point. See [Subsystems](subsystems.md).
- **Tool commands** for each Development step live in the project's `CLAUDE.md` or `AGENTS.md`. See [Tools](working-agreements.md#tools).

## In git

- **Story tags** mark the commit where a story's evals all pass. Then it's ready for acceptance: `story/0001-user-authentication/0010-login-form`. See [Commits and tags](working-agreements.md#commits-and-tags).
