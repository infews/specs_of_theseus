# Evals

Evals are the specification of the system. They remain constant despite any rewrite. Code, internal tests and subsystem boundaries can all be thrown away. Evals can only be changed on purpose as part of product work. This happens in the [Update Evals](2-update-evals.md) stage of a story's lifecycle.

If a quality matters (a behavior, a performance target, a structural rule) it has to be an eval. Otherwise, an agent may change it while redesigning.

The idea comes from Chad Fowler's [Evaluations Are the Real Codebase](https://aicoding.leaflet.pub/3mb526js42k26): evaluations "encode what the system must do, independent of how any particular implementation does it." Each eval type is discussed below.

## Writing evals

Each eval is written as an [EARS](https://alistairmavin.com/ears/) requirement with an ID:

```markdown
- `CART-INV-003`: The system shall never allow a cart total below zero.
- `CART-E2E-001`: When a shopper removes the last item, the system shall show an empty cart.
```

The ID is `AREA-KIND-NNN`:

- **AREA** is a product area, such as `CART` or `AUTH`, never a subsystem name. When subsystems get redrawn, the ID persists.
- **KIND** is the kind of eval: `INV`, `CON`, `E2E` or `MON`.

## Linking evals to tests

Whenever possible, an eval is checked by an executable test. The test is tagged with the eval's ID in a comment, in whatever syntax the language uses:

```ruby
# @spec CART-INV-003
```

- **Eval tests live under the project's test directory**. Directories like `test/`, `spec/` or `tests/`
- **Test names read as sentences.** Where tests are named with strings, as with `describe`/`it`, an eval ID in the name goes at the end: `it "shows an empty cart when the last item is removed (CART-E2E-001)"`.
- **Eval tests are linked.** Every eval ID has at least one test, and every tagged test points to an eval that exists. A check in [Development](4-development.md) enforces both. The tag is also how an agent tells eval tests, which it must keep, from internal tests, which it may delete.
- **Implementation is not linked.** Code is what gets deleted and regrown, and many evals span several subsystems. When an eval fails, its test leads to the code.
- **Internal tests may cite an eval.** They are thrown away along with the code they test.

An eval that can't run as a test, such as a monitor that only exists in production, points to the monitor's configuration instead.

When a story removes functionality, its evals are retired and their tests deleted. Tests that check old behavior is gone protect nothing. The rest of the evals still passing is all that is necessary. If the absence itself matters, that's a new eval.

## Characterization

Most evals describe behavior a story is adding, so their tests fail until Development makes them pass. Some describe behavior the system already has but nobody wrote down. Writing those is **characterizing** an area, and their tests are [characterization tests](https://en.wikipedia.org/wiki/Characterization_test), a term from Michael Feathers's [*Working Effectively with Legacy Code*](https://www.oreilly.com/library/view/working-effectively-with/0131177052/: 
- Run the code
- Observe what it does
- Write a test that expects exactly that (odd parts included).

A characterization test passes the first time it runs. Its job is to catch a change, not to judge whether the behavior is right. A **"Characterize …" story**, such as "Characterize the cart", writes evals and characterization tests for one product area's current behavior. It builds nothing, so it skips Redesign System and Development.

Characterize stories come from [adopting an existing project](6_adopting.md), or from Break Down Epic in [Product Planning](1-product-planning.md), when an epic touches an area that has no evals yet.

## Kinds of Evals

### Invariants

Properties that must always hold, independent of how the system is built.

- Behavioral: "a balance never goes negative."
- Structural: "the billing subsystem never depends on the UI."

Invariants are usually checked with property tests and architecture checks. 

> Invariants are properties that hold regardless of implementation. 
> --([Evaluations Are the Real Codebase](https://aicoding.leaflet.pub/3mb526js42k26)), Chad Fowler

### Contracts

The promises the system makes at its edges: APIs it provides to other systems, and APIs it depends on. Changing one needs agreement from someone outside the system.

Contracts *between subsystems* are not evals. They are internal tests the agent writes to design parts of the system. The agent may delete or rewrite them when it redraws subsystem boundaries.

Fowler draws the same line: tests at the system boundary "verify obligations the system owes the outside world," while tests at the implementation boundary live and die with the code ([Evaluations Are the Real Codebase](https://aicoding.leaflet.pub/3mb526js42k26)). [The Phoenix Primitives](https://aicoding.leaflet.pub/3mjfruwwuck2d) calls the shared contracts the "conservation layer."

### End-to-end tests

Whole user flows through the running system, written from the story's acceptance criteria. These are the closest thing to what the product manager checks at Acceptance. Fowler calls them end-to-end behavioral checks: "The internal path doesn't matter" ([Evaluations Are the Real Codebase](https://aicoding.leaflet.pub/3mb526js42k26)).

### Monitors

Checks on how a live system behaves: latency, error rates, resource use, business signals. They matter most for running services such as web apps.

- Where possible, a monitor should also run under test, so a regression is caught before deploy.
- Some can only run in production.
- A system with no live service, such as a CLI, may still have monitor-like checks. A performance characteristic could be a monitor: "this command finishes in under a second on the reference data set."

> Monitoring is "evaluation that runs continuously against reality rather than periodically against test fixtures" ([Evaluations Are the Real Codebase](https://aicoding.leaflet.pub/3mb526js42k26)). 
 
[Production Is a Compiler Input](https://aicoding.leaflet.pub/3mjx4erlboc2l) goes further, treating production drift as a reason to regrow.
