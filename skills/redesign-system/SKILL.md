---
name: redesign-system
description: Specs of Theseus Redesigning the System — given a story's updated evals and failing eval tests, plan the smallest change that makes them pass, look for a subsystem worth deleting and regrowing into a better design, redraw @subsystem boundaries, and turn it into tasks reviewed with the developer. Use whenever a story has its evals written but no implementation plan, or the user asks to plan a story, break it into tasks, redesign or regrow a subsystem, extract shared code, or decide whether a rewrite is safe.
---

# Redesigning the System

Each story is a chance to reconsider the design, not just extend it. Without this step a codebase grows by patches; with it, any subsystem can be deleted and regrown while the evals keep the system correct.

You plan the redesign and write the tasks on your own — the evals are the guardrails, and the team's coding-style skills shape what good code looks like. You don't need permission to rewrite a subsystem. Then you review the tasks with a developer before Development starts.

Read `references/subsystems.md` for what a subsystem is, how they're marked, and extracting and folding back.

## 1. Process the updated evals

Read the story's **EARS Specifications**, the evals they name in `docs/evals/`, and their failing tests. Run the failing tests to see where they fail. List the current subsystems (search the code for `@subsystem`) and work out which ones the evals touch.

## 2. Plan the smallest change

What's the least change that makes the new evals pass, without breaking any existing one? Write it down. This is the baseline — it's always a valid plan.

## 3. Look for something to regrow

Now ask whether there's a better design that still meets every eval. Is there a subsystem that could be deleted and rewritten into something simpler, clearer, or easier to change for the next likely story?

- **"Better" is judged against the evals** — invariants and monitors set the constraints — **and the team's coding-style skills.** Not your taste alone.
- **Extract** code that several subsystems now share into a shared subsystem of its own. **Fold back** a shared subsystem that only one other still uses.
- **Entry-point subsystems** (commands, controllers, job handlers) have surfaces pinned by evals, so their insides can change but not their surface. **Shared subsystems** have internal interfaces; the biggest redesigns tend to happen there.
- Contract tests between subsystems go with the code they test — rewrite or delete them along with it.

A regrow is only safe where something would catch a mistake. **Before planning a redesign that would change behavior no eval or existing test checks, raise an issue** and let the developer help decide: write the missing eval, add tests first, or make the smaller change instead. This matters most while a project is still being adopted — until then, the project's existing tests stand in for the evals not yet written, and no redesign may delete them.

If nothing is worth regrowing, say so. The smallest change is a fine plan.

## 4. Add tasks to the story

Write the plan as a plain checklist in the story's **Implementation Plan**. Each task:

- is small enough for one pass through the Development loop;
- names the subsystems it touches (Development scopes mutation testing to them);
- comes in an order where each task leaves every eval that passed before still passing.

Put a regrow's extraction or rewrite before the tasks that depend on it. Include marker moves in the task that moves the code.

## 5. Review the tasks with the developer

Walk the developer through the plan: the smallest change, what (if anything) you chose to regrow and why, and the tasks. Check together that the tasks cover every eval in the story, are small enough, and come in a sensible order. Adjust from their feedback.

When they're satisfied, the story moves on to `develop-story`.

## Raise an issue

In the story's **Issues** section (see `references/working-agreements.md`) when:

- the evals contradict each other;
- meeting them would mean breaking an invariant or an external contract;
- a redesign would change behavior no eval or existing test checks.
