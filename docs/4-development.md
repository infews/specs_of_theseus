# Development

![Development](img/4_sot_development.svg)

**Why:** Each task gets the same loop of increasingly strict checks. A failure anywhere sends the work back to red/green/refactor, so nothing moves on until it's solid.

**Who:** 🧞 an agent does every step. 🧑🏼‍💻 a developer oversees the stage and answers its issues.

**In:** A story with reviewed tasks.

**Out:** A completed story and a tagged commit, sent to [Acceptance](5-acceptance.md).

## How

For each task, until the task list is empty:

1. **Pick the next task.**
2. **Red/green/refactor in subsystems.** Write a failing test, make it pass, clean up. Internal tests, including contract tests between subsystems, live here.
3. **Migrate to property testing.** Turn example tests into property tests where they fit. Failing properties go back to step 2.
4. **Mutation testing.** Mutate the code and check the tests catch it. Surviving mutants go back to step 2.
5. **Run controls and checks.** Linters, type checks, security scanners, dependency audits, and the eval-link check: every eval has a test, and every `@spec` tag points to a real eval. Failures go back to step 2.
6. **Run the full eval suite.** Every invariant, contract, end-to-end test and monitor that can run under test. Failures go back to step 2. When everything passes, pick the next task.

When the task list is empty:

7. **Complete the story.** Check off its tasks.
8. **Tag the repo.** Tag the final commit with the story's path, such as `story/0001-user-authentication/0010-login-form`. The tag marks where every eval passes, and it is what Deploy picks up.

Commit straight to main. If work-in-progress commits help, use a short-lived branch and squash and rebase it onto main before it lands, so main's history stays linear. See [Commits and tags](working-agreements.md#commits-and-tags).

## Raising Issues

The agent should raise an issue when the same failure keeps returning after several rounds, or when a task can't be done without changing an eval. Agents don't change evals in this stage.
