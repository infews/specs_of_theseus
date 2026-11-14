# Development

And now it's time to write software, and validate that the work solves the business problem while not disrupting existing functionality.

![Development](img/4_theseus_development.svg)

**Why:** each task gets the same fast loop, and the completed story gets the slower checks. A failure anywhere sends the work back to Red/Green/Refactor, so nothing moves on until it's solid.

**Who:** 🧞 an agent does every step. 🧑🏼‍💻 a developer oversees: they answer issues and read a short summary at the end of each task, but don't approve each step. The evals are the gate, and the developer already reviewed the tasks.

**In:** a story with reviewed tasks.

**Out:** a tagged story, sent to [Acceptance](5-acceptance.md).

## How

The 🧞 agent moves through these steps until the task list is empty:

1. **Pick Next Task**
    - Take the next unchecked task. When the task list is empty, go to Complete Story.
2. **Red/Green/Refactor in Subsystems**
    - Write a failing test, make it pass, clean up. Internal tests, including contract tests between subsystems, live here.
    - When a task removes behavior, its code and internal tests are deleted, with no tests added to check that the behavior is gone. The full eval suite shows nothing else depended on it.
3. **Migrate to Property Testing**
    - Turn the task's example tests into property tests where a rule exists. A property test replaces the examples it fully covers.
    - Leave a few example tests where they document behavior well. This applies to internal tests. Eval tests were written in [Update Evals](2-update-evals.md). 
    - Failing property tests go back to Red/Green/Refactor for re-work.
4. **Run Full Eval Suite**
  - Every invariant, contract, end-to-end test and monitor that can run under test. 
  - Failing evals go back to Red/Green/Refactor for re-work
  - When everything passes, check off the task, commit, and write a short summary of it for the developer, then pick the next task.

When the task list is empty, the slower checks run once against all of the code from the one story. Failures go back to Red/Green/Refactor, and through the loop again:

5. **Complete Story**
  - Confirm every task is checked off and the full eval suite passes
  - Gather the subsystems the story touched.
6. **Run Mutation Tests**
  - Mutate the code in the story's subsystems, and check the tests catch it. 
  - Every surviving mutant is either killed by a new test or recorded as equivalent (a change that no test could notice) with a one-line reason. 
  - The agent raises an issue here if the mutations are inconclusive.
7. **Run Controls & Checks**
    - Run linters, type checks, security scanners, dependency audits, and the eval-link check: every eval has a test, and every `@spec` tag points to a real eval.
8. **Tag Repo**
    - Tag the final commit with the story's path, such as `story/0001-user-authentication/0010-login-form`
    - Send the tagged story to [Acceptance](5-acceptance.md). 
    - The tag marks where every eval passes, and it is what any Deploy automation picks up.

Commit straight to the repository's `main` branch. If work-in-progress commits help, use a short-lived branch and squash and rebase it onto `main` as saved state. The repo's `main` branch should keep linear history. See [Commits and tags](working-agreements.md#commits-and-tags).

## Raising Issues

The agent should raise an issue when the same failure keeps returning after several rounds, or when a task can't be done without changing an eval. Agents don't change evals in this stage.
