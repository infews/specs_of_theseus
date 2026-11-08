# Property testing

An **example test** checks one case: "a cart with a $10 item and a $5 refund has a total of $5." A **property test** checks a rule against many generated cases: "for any series of adds and refunds, the total is never below zero." The library generates the inputs and, when it finds a failure, shrinks it to the smallest case that still fails.

Use the project's property-testing library (its command is in `CLAUDE.md` or `AGENTS.md`). Common ones: Hypothesis (Python), fast-check (JS/TS), PropCheck or Rantly (Ruby), jqwik (Java), proptest (Rust), StreamData (Elixir), gopter or `testing/quick` (Go).

## Finding the property

Look at a group of example tests and ask what rule they're all instances of. Patterns that often fit:

- **Invariant** — something always true after any operation: totals never negative, a list stays sorted, IDs stay unique.
- **Round trip** — encode then decode returns the input; save then load is unchanged.
- **Idempotence** — doing it twice equals doing it once: normalizing, deduplicating.
- **Equivalence to a simpler model** — the optimized version agrees with a slow obvious one.
- **Metamorphic** — a known change to the input causes a known change to the output: adding an item raises the total by its price.

If no rule exists — the examples are genuinely unrelated cases — keep them as examples. Not every test should become a property.

## Migrating

1. Write the property next to the examples it generalizes.
2. Run it. A failure is a real finding: the shrunk case is a bug or a wrong assumption. Back to red/green/refactor.
3. Delete the examples the property fully covers. Keep one or two that make the behavior easy to read.

Keep generators honest: constrain them to valid inputs the code is meant to accept, not to inputs that happen to pass.
