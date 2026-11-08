# Evals

Evals are the specification of the system. They are what survives a rewrite. Code, internal tests and subsystem boundaries can all be thrown away. Evals can only be changed on purpose, as part of product work, in the [Updating Evals](2-updating-evals.md) stage.

If a quality matters — a behavior, a performance target, a structural rule — it has to be an eval. Otherwise an agent may change it while redesigning.

The idea comes from Chad Fowler's [Evaluations Are the Real Codebase](https://aicoding.leaflet.pub/3mb526js42k26): evaluations "encode what the system must do, independent of how any particular implementation does it." Each eval type is discussed below.

## Writing evals

Each eval is written as an [EARS](https://alistairmavin.com/ears/) requirement with an ID:

```markdown
- `CART-INV-003`: The system shall never allow a cart total below zero.
- `CART-E2E-001`: When a shopper removes the last item, the system shall show an empty cart.
```

The ID is `AREA-KIND-NNN`:

- **AREA** is a product area, such as `CART` or `AUTH` — never a subsystem name. Subsystems get redrawn; the ID must outlive them.
- **KIND** is the kind of eval: `INV`, `CON`, `E2E` or `MON`.

## Linking evals to tests

Whenever possible, an eval is checked by an executable test. That test carries the eval's ID in a comment, in whatever syntax the language uses:

```ruby
# @spec CART-INV-003
```

- **Eval tests are linked.** Every eval ID has at least one test, and every tagged test points to an eval that exists. A check in [Development](4-development.md) enforces both. The tag is also how an agent tells eval tests, which it must keep, from internal tests, which it may delete.
- **Implementation is not linked.** Code is what gets deleted and regrown, and many evals span several subsystems. When an eval fails, its test leads to the code.
- **Internal tests may cite an eval.** They are thrown away along with the code they test, so the tag never goes stale.

An eval that can't run as a test — a monitor that only exists in production — points to the monitor's configuration instead.

## Kinds of Evals

### Invariants

Properties that must always hold, no matter how the system is built.

- Behavioral: "a balance never goes negative."
- Structural: "the billing subsystem never depends on the UI."

Invariants are usually checked with property tests and architecture checks. 

> Invariants are properties that hold regardless of implementation. 
> --([Evaluations Are the Real Codebase](https://aicoding.leaflet.pub/3mb526js42k26)), Chad Fowler

### Contracts

The promises the system makes at its edges: APIs it provides to other systems, and APIs it depends on. Changing one needs agreement from someone outside the system.

Contracts *between subsystems* are not evals. They are internal tests the agent writes to keep its own work honest, and it may delete or rewrite them when it redraws subsystem boundaries.

Fowler draws the same line: tests at the system boundary "verify obligations the system owes the outside world," while tests at the implementation boundary live and die with the code ([Evaluations Are the Real Codebase](https://aicoding.leaflet.pub/3mb526js42k26)). [The Phoenix Primitives](https://aicoding.leaflet.pub/3mjfruwwuck2d) calls the shared contracts the "conservation layer."

### End-to-end tests

Whole user flows through the running system, written from the story's acceptance criteria. These are the closest thing to what the product manager checks at Acceptance. Fowler calls them end-to-end behavioral checks: "The internal path doesn't matter" ([Evaluations Are the Real Codebase](https://aicoding.leaflet.pub/3mb526js42k26)).

### Monitors

Checks on how a live system behaves: latency, error rates, resource use, business signals. They matter most for running services such as web apps.

- Where possible, a monitor should also run under test, so a regression is caught before deploy.
- Some can only run in production.
- A system with no live service, such as a CLI, may still have monitor-like checks — for example, "this command finishes in under a second on the reference data set."

> Monitoring is "evaluation that runs continuously against reality rather than periodically against test fixtures" ([Evaluations Are the Real Codebase](https://aicoding.leaflet.pub/3mb526js42k26)). 
 
[Production Is a Compiler Input](https://aicoding.leaflet.pub/3mjx4erlboc2l) goes further, treating production drift as a reason to regrow.
