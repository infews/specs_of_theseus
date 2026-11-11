# Development

![Development](img/4_theseus_development.svg)

**Why:** Each task gets the same fast loop, and the finished story gets the slower checks. A failure anywhere sends the work back to Red/Green/Refactor, so nothing moves on until it's solid.

**Who:** 🧞 an agent does every step. 🧑🏼‍💻 a developer oversees: they answer issues and read a short summary at the end of each task, but don't approve each step. The evals are the gate, and the developer already reviewed the tasks.

**In:** A story with reviewed tasks.

**Out:** A tagged story, sent to [Acceptance](5-acceptance.md).

## How

For each task, until the task list is empty:

1. **Pick Next Task** 🧞 — take the next unchecked task. When the task list is empty, go to Complete Story.
2. **Red/Green/Refactor in Subsystems** 🧞 — write a failing test, make it pass, clean up. Internal tests, including contract tests between subsystems, live here. When a task removes behavior, its code and internal tests are deleted, with no tests added to check it's gone — the full eval suite shows nothing else depended on it.
3. **Migrate to Property Testing** 🧞 — turn the task's example tests into property tests where a rule exists. A property replaces the examples it fully covers; keep a few examples where they document behavior well. This applies to internal tests — eval tests were written in [Update Evals](2-update-evals.md). Failing property tests go back to Red/Green/Refactor.
4. **Run Full Eval Suite** 🧞 — every invariant, contract, end-to-end test and monitor that can run under test. Failing evals go back to Red/Green/Refactor. When everything passes, check off the task, commit, and write a short summary of it for the developer, then pick the next task.

When the task list is empty, the slower checks run once, on the whole story. Failures go back to Red/Green/Refactor, and through the loop again:

5. **Complete Story** 🧞 — confirm every task is checked off and the full eval suite passes, and gather the subsystems the story touched.
6. **Run Mutation Tests** 🧞 — mutate the code in the story's subsystems, and check the tests catch it. Every surviving mutant is either killed by a new test or recorded as equivalent — a change no test could notice — with a one-line reason. If the agent can't tell which, it raises an issue.
7. **Run Controls & Checks** 🧞 — linters, type checks, security scanners, dependency audits, and the eval-link check: every eval has a test, and every `@spec` tag points to a real eval.
8. **Tag Repo** 🧞 — tag the final commit with the story's path, such as `story/0001-user-authentication/0010-login-form`, and send the tagged story to [Acceptance](5-acceptance.md). The tag marks where every eval passes, and it is what Deploy picks up. It means "ready for acceptance", not "accepted".

Commit straight to main. If work-in-progress commits help, use a short-lived branch and squash and rebase it onto main before it lands, so main's history stays linear. See [Commits and tags](working-agreements.md#commits-and-tags).

## Raising Issues

The agent should raise an issue when the same failure keeps returning after several rounds, or when a task can't be done without changing an eval. Agents don't change evals in this stage.
