# Project layout

Everything lives in the project's repo.

```
docs/
  epics/
    0000-epics.md                  # index of all epics, in priority order
    0001-user-authentication.md    # an epic
    0001-user-authentication/      # its stories
      0010-login-form.md
      0020-password-validation.md
  evals/
    auth.md                        # one file per product area
    cart.md
```

- **Subsystems** are marked in the code with `@subsystem` comments. See `subsystems.md`.
- **Eval tests** live wherever the project keeps tests, tagged with `@spec`. See `evals.md`.
- **Tool commands** live in the project's `CLAUDE.md` or `AGENTS.md`. See `working-agreements.md`.
- **Story tags** live in git: `story/0001-user-authentication/0010-login-form`.

## Epics

Named with a 4-digit number and a short slug: `0001-user-authentication.md`. Each new epic is added as a link to the list in `0000-epics.md`; the order of that list is the order of the epics.

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

When a story is accepted, check it off or strike it through in **Resulting Stories**.

## Stories

Stored in a folder named after the epic, numbered in steps of 10 — `0010`, `0020`, `0030` — so stories split out or discovered later can slot in between. The numbering is the priority order within the epic.

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

Each section belongs to a stage:

| Section | Filled in by |
|---|---|
| Narrative, Acceptance Criteria | Product Planning (epic breakdown) |
| EARS Specifications — IDs of the evals the story adds or changes | Updating Evals |
| Implementation Plan — a plain checklist of tasks | Redesigning the System; checked off in Development |
| Issues | any stage |

## Eval files

One markdown file per product area in `docs/evals/`, grouped by kind. Each eval is one list item: its ID, then its EARS text. A monitor that can only run in production says where it's configured.

```markdown
# Cart

## Invariants
- `CART-INV-003`: The system shall never allow a cart total below zero.

## Contracts
- `CART-CON-001`: When the payments API returns a decline, the system shall leave the order unpaid.

## End-to-end
- `CART-E2E-001`: When a shopper removes the last item, the system shall show an empty cart.

## Monitors
- `CART-MON-001`: The system shall add an item to a cart within 200 ms at p95.
  - Monitor: `config/monitors/cart.yml`
```

When an eval is retired, delete its line and its tests. Never reuse an ID.
