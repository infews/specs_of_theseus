---
name: develop-story
description: Specs of Theseus Development — work a story's reviewed tasks through a loop (Pick Next Task, Red/Green/Refactor, Migrate to Property Testing, Run Full Eval Suite), then Complete Story, Run Mutation Tests on the subsystems it touched, Run Controls & Checks, and Tag Repo. Use whenever a story has an Implementation Plan with unchecked tasks, or the user asks to build, implement or finish a story, run the dev loop, or tag a completed story — even if they just say "go" or "keep going" on a story in progress.
---

# Development

Each task goes through the same fast loop; the finished story then gets the slower checks. Any failure sends the work back to Red/Green/Refactor, so nothing moves on until it's solid. Each numbered step is a box in the Specs of Theseus diagram.

You do every step. A developer oversees: they answer issues and read a short summary after each task, but don't approve each step — the evals are the gate, and they already reviewed the tasks. So work steadily without asking permission, and stop only to raise an issue.

You don't change evals or their tests in this stage. They were written with the developer in Update Evals, and they grade your work.

**Say which skill is running.** Start by telling the person: "**Specs of Theseus — Development** (`theseus:develop-story`)", and the story or epic you're on. Say so again whenever you hand off to another skill, naming it.

## Before starting

Check the project's `CLAUDE.md` or `AGENTS.md` for a command for each step below. If one is missing, ask the developer and record the answer there before going on (see `references/working-agreements.md`). Don't guess a command and don't skip a step — a skipped step is a gate that silently stopped guarding.

## The loop

For each unchecked task in the story's **Implementation Plan**, in order:

1. **Pick Next Task** 🧞 — take the next unchecked task. Note which subsystems it touches. When the task list is empty, go to Complete Story (step 5).

2. **Red/Green/Refactor in Subsystems** 🧞 — write a failing test, confirm it fails for the right reason, make it pass with the simplest code, refactor while the context is fresh. Use the developer's TDD skill if one is installed (such as `superpowers:test-driven-development`). These are internal tests — including contract tests between subsystems — and may be deleted in a future redesign. Move `@subsystem` markers in the same change as the code they mark. Internal tests go under the project's test directory, like every other test.

   When a task removes behavior, delete its code and the internal tests that covered it. Don't write tests that check it's gone — Run Full Eval Suite is what shows nothing else depended on it.

3. **Migrate to Property Testing** 🧞 — turn the task's example tests into property tests where a rule exists. A property replaces the examples it fully covers; keep a few examples where they document behavior well. This applies only to your internal tests — eval tests already exist. Failing property tests go back to Red/Green/Refactor. See `references/property-testing.md`.

4. **Run Full Eval Suite** 🧞 — every invariant, contract, end-to-end test and monitor that can run under test — the whole system, not just this story's evals. While a project is still being adopted, the existing tests run too and must pass. Failing evals go back to Red/Green/Refactor.

   When everything passes: check off the task, commit, and give the developer a short summary — what changed, which subsystems, anything surprising. Then go back to Pick Next Task.

## When the task list is empty

The slower, story-wide checks run once, on the finished story. A failure in either goes back to Red/Green/Refactor — through Migrate to Property Testing and Run Full Eval Suite again — and then on through Pick Next Task, whose list is still empty, back here.

5. **Complete Story** 🧞 — confirm every task is checked and the full eval suite passes. List the subsystems the story touched, from its tasks and the code that changed; that list is the scope for the next step.

6. **Run Mutation Tests** 🧞 — on the story's subsystems, and only those. Every surviving mutant is either killed by a new test (back to Red/Green/Refactor) or recorded as equivalent — a change no test could notice — with a one-line reason. If you can't tell which, raise an issue. See `references/mutation-testing.md`.

7. **Run Controls & Checks** 🧞 — linters, type checks, security scanners, dependency audits — and the eval-link check, `scripts/check-eval-links.sh`, which confirms every eval has a test and every `@spec` tag names a real eval. Failing checks go back to Red/Green/Refactor.

8. **Tag Repo** 🧞 — tag the final commit with the story's path: `story/<epic>/<story>`, such as `story/0001-user-authentication/0010-login-form`. Push the tag. The tag marks where every eval passes, and it's what Deploy picks up — so only tag a green commit.

Tell the developer the story is complete and tagged, with a short summary of the mutation testing — survivors killed, and any equivalent mutants recorded. The tagged story now goes to the team's Acceptance process, which is outside these skills. Once it's deployed, the work queue is empty and the next story can start in `update-evals`.

## Commits

Commit straight to main. If work-in-progress commits help, use a short-lived branch and squash and rebase it onto main before it lands, so main's history stays linear. No merge commits.

## Raise an issue

In the story's **Issues** section, then stop, when:

- the same failure keeps coming back after several rounds of Red/Green/Refactor;
- a task can't be done without changing an eval or its test;
- you can't tell whether a surviving mutant is equivalent;
- a tool command is missing.
