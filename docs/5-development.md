# Development

![Development](img/5_sot_development.svg)

**Why:** Each task gets the same loop of increasingly strict checks. A failure anywhere sends the work back to red/green/refactor, so nothing moves on until it's solid.

**Who:** 🤖 an agent.

**In:** A story with tasks.

**Out:** A completed story and its code, sent to [Deploy](6-deploy-accept-release.md).

## How

For each task, until the task list is empty:

1. **Pick the next task.**
2. **Red/green/refactor in subsystems.** Write a failing test, make it pass, clean up. Internal tests, including contract tests between subsystems, live here.
3. **Migrate to property testing.** Turn example tests into property tests where they fit. Failing properties go back to step 2.
4. **Mutation testing.** Mutate the code and check the tests catch it. Surviving mutants go back to step 2.
5. **Run controls and checks.** Linters, type checks, security scanners, dependency audits. Failures go back to step 2.
6. **Run the full eval suite.** Every invariant, contract, end-to-end test and monitor that can run under test. Failures go back to step 2. When everything passes, pick the next task.

When the task list is empty, **complete the story**: commit the code and send the story on.

## Raise an issue

Raise an issue when the same failure keeps returning after several rounds, or when a task can't be done without changing an eval. Agents don't change evals in this stage.
