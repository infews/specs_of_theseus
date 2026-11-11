# Evals

Evals are the system's specification — what survives a rewrite. Code, internal tests and subsystem boundaries can all be thrown away. Evals change only on purpose, as product work, in the Update Evals stage.

If a quality matters — a behavior, a performance target, a structural rule — it has to be an eval. Otherwise an agent may change it while redesigning.

## The four kinds

| Kind | ID | What it pins down | Usually tested with |
|---|---|---|---|
| **Invariant** | `INV` | A property that always holds, whatever the implementation. Behavioral ("a balance never goes negative") or structural ("billing never depends on the UI"). | Property tests; architecture checks |
| **Contract** | `CON` | A promise at the system's edge: an API it provides to other systems, or one it depends on. Changing one needs agreement from outside the system. | Contract tests at the boundary |
| **End-to-end** | `E2E` | A whole user flow through the running system, from a story's acceptance criteria. The internal path doesn't matter. | The project's end-to-end / system tests |
| **Monitor** | `MON` | How the live system behaves: latency, error rates, resource use, business signals. | A test where possible; otherwise production monitoring |

**Contracts between subsystems are not evals.** They're internal tests the agent writes during development and may delete when it redraws boundaries. Only contracts at the system's edge are fixed.

**Monitors** should also run under test where possible, so a regression is caught before deploy. Some can only run in production. A system with no live service, like a CLI, can still have monitor-like checks — "this command finishes in under a second on the reference data set."

## Writing an eval

Each eval is one EARS requirement with an ID `AREA-KIND-NNN`:

- **AREA** — a product area, such as `CART` or `AUTH`. Never a subsystem name: subsystems get redrawn, and the ID must outlive them.
- **KIND** — `INV`, `CON`, `E2E` or `MON`.
- **NNN** — the next unused number in that area and kind. IDs are never reused.

The five EARS patterns:

| Pattern | Form |
|---|---|
| Ubiquitous | The system shall [behavior]. |
| Event-driven | When [trigger], the system shall [response]. |
| State-driven | While [state], the system shall [behavior]. |
| Optional | Where [feature is enabled], the system shall [behavior]. |
| Unwanted | If [unwanted condition], then the system shall [response]. |

One requirement per eval. "When X, the system shall A and B" is two evals. If a single test can't prove it, split it.

One Gherkin scenario usually becomes several evals:

```gherkin
Scenario: Successful login
  Given a registered user
  When they submit valid credentials
  Then a session is created
  And they are redirected to the dashboard
```

- `AUTH-E2E-001`: When a registered user submits valid credentials, the system shall show their dashboard.
- `AUTH-INV-001`: The system shall never create a session without valid credentials.

## Linking evals to tests

Whenever possible, an eval is checked by an executable test, written in the project's own test frameworks. The test carries the eval's ID in a comment, in whatever syntax the language uses:

```ruby
# @spec CART-INV-003
```

- **Eval tests live under the project's test directory** (`test/`, `spec/`, `tests/`…), wherever the developer chooses inside it — never in a new top-level folder.
- **Test names read as sentences.** Where frameworks name tests with strings (`describe`/`it`, `test "…"`), an eval ID in the name goes at the end: `it "shows an empty cart when the last item is removed (CART-E2E-001)"`. The `@spec` comment is the link; the ID in the name is optional.
- **Eval tests are linked.** Every eval ID has at least one test; every `@spec` tag points to an eval that exists. `scripts/check-eval-links.sh` checks both. The tag is how an agent tells eval tests, which it must keep, from internal tests, which it may delete.
- **Implementation is not linked.** Never put `@spec` in production code. Code is what gets deleted and regrown, and many evals span several subsystems. A failing eval's test leads to the code.
- **Internal tests may cite an eval** they serve. They're thrown away with the code they test, so the tag never goes stale. (An internal test with a `@spec` tag still counts as linked — keep that in mind before deleting one.)

## Characterization

Most evals describe behavior a story is adding, so their tests fail until Development makes them pass. Some describe behavior the system **already has** but nobody wrote down. Writing those is **characterizing** an area, and their tests are **characterization tests** — a term from Michael Feathers' *Working Effectively with Legacy Code* (https://en.wikipedia.org/wiki/Characterization_test): run the code, observe what it does, and write a test that expects exactly that, odd parts included.

- A characterization test **passes the first time it runs**. Its job is to catch a change, not to judge whether the behavior is right.
- A **"Characterize …" story**, such as "Characterize the cart", writes evals and characterization tests for one product area's current behavior. It builds nothing, so it skips Redesign System and Development.
- If the current behavior looks wrong, the eval still pins it. Raise an issue and offer to record a story to change it; that story's own Update Evals changes the eval later.

## Removing functionality

When a story removes behavior, its evals are retired: delete the eval lines and their tests. Don't keep or add tests that check the old behavior is gone — they protect nothing. The full eval suite still passing is what shows the removal broke nothing else. If the absence itself matters ("the system shall not export card numbers"), that's a new eval.

An eval that can't run as a test — a production-only monitor — has a `Monitor:` line pointing at its configuration instead. See `project-layout.md`.
