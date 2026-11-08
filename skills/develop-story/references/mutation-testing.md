# Mutation testing

A mutation tool makes small changes to the code — flip a `>` to `>=`, delete a line, return `nil` — and runs the tests against each. A mutant the tests catch is **killed**. One they don't is a **survivor**: a change in behavior no test noticed.

Use the project's mutation tool (its command is in `CLAUDE.md` or `AGENTS.md`). Common ones: Mutant (Ruby), Stryker (JS/TS, C#, Scala), mutmut or cosmic-ray (Python), PIT (Java), cargo-mutants (Rust), go-mutesting (Go).

## Scope

Run it only on the subsystems the current task touched — their files or modules. Mutation testing a whole codebase is slow, and the rest of the system didn't change.

## Handling survivors

For each survivor, decide which it is:

- **A gap in the tests.** The mutant changes behavior someone could observe. Write a test that kills it — back to red/green/refactor.
- **Equivalent.** The mutant changes nothing observable: `i < n` vs `i != n` in a loop that only counts up, a redundant guard, a log message. Record it with a one-line reason so the next run doesn't relitigate it — in the tool's ignore configuration if it has one, otherwise in the task summary.

If you can't tell which it is, raise an issue. Don't call a mutant equivalent to make the step pass; an equivalent mutant that wasn't is a test gap you've hidden.

Survivors in code that a regrow is about to delete don't need killing — note them and move on.
