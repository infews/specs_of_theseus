---
name: develop-story
description: Specs of Theseus Development — work a story's reviewed tasks through a strict loop (red/green/refactor, property testing, mutation testing on touched subsystems, controls and checks, full eval suite), then complete the story and tag the commit. Use whenever a story has an Implementation Plan with unchecked tasks, or the user asks to build, implement or finish a story, run the dev loop, or tag a completed story — even if they just say "go" or "keep going" on a story in progress.
---

# Development

Each task goes through the same loop of increasingly strict checks. Any failure sends the work back to red/green/refactor, so nothing moves on until it's solid.

You do every step. A developer oversees: they answer issues and read a short summary after each task, but don't approve each step — the evals are the gate, and they already reviewed the tasks. So work steadily without asking permission, and stop only to raise an issue.

You don't change evals or their tests in this stage. They were written with the developer in Updating Evals, and they grade your work.

## Before starting

Check the project's `CLAUDE.md` or `AGENTS.md` for a command for each step below. If one is missing, ask the developer and record the answer there before going on (see `references/working-agreements.md`). Don't guess a command and don't skip a step — a skipped step is a gate that silently stopped guarding.

## The loop

For each unchecked task in the story's **Implementation Plan**, in order:

1. **Pick the next task.** Note which subsystems it touches.

2. **Red/green/refactor in the subsystems.** Write a failing test, confirm it fails for the right reason, make it pass with the simplest code, refactor while the context is fresh. Use the developer's TDD skill if one is installed (such as `superpowers:test-driven-development`). These are internal tests — including contract tests between subsystems — and may be deleted in a future redesign. Move `@subsystem` markers in the same change as the code they mark.

3. **Migrate to property testing.** Turn the task's example tests into property tests where a rule exists. A property replaces the examples it fully covers; keep a few examples where they document behavior well. This applies only to your internal tests — eval tests already exist. Failing properties go back to step 2. See `references/property-testing.md`.

4. **Mutation testing** — only on the subsystems this task touched. Every surviving mutant is either killed by a new test (back to step 2) or recorded as equivalent — a change no test could notice — with a one-line reason. If you can't tell which, raise an issue. See `references/mutation-testing.md`.

5. **Run controls and checks.** Linters, type checks, security scanners, dependency audits — and the eval-link check, `scripts/check-eval-links.sh`, which confirms every eval has a test and every `@spec` tag names a real eval. Failures go back to step 2.

6. **Run the full eval suite.** Every invariant, contract, end-to-end test and monitor that can run under test — the whole system, not just this story's evals. While a project is still being adopted, the existing tests run too and must pass. Failures go back to step 2.

When everything passes: check off the task, commit, and give the developer a short summary — what changed, which subsystems, anything surprising, any equivalent mutants recorded. Then pick the next task.

## When the task list is empty

7. **Complete the story.** Confirm every task is checked and the full eval suite passes on the final commit.

8. **Tag the repo** with the story's path: `story/<epic>/<story>`, such as `story/0001-user-authentication/0010-login-form`. The tag marks where every eval passes, and it's what deploy picks up — so only tag a green commit.

Tell the developer the story is complete and tagged. It now goes to the team's Acceptance process, which is outside these skills.

## Commits

Commit straight to main. If work-in-progress commits help, use a short-lived branch and squash and rebase it onto main before it lands, so main's history stays linear. No merge commits.

## Raise an issue

In the story's **Issues** section, then stop, when:

- the same failure keeps coming back after several rounds of red/green/refactor;
- a task can't be done without changing an eval or its test;
- you can't tell whether a surviving mutant is equivalent;
- a tool command is missing.
