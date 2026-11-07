# Redesigning the System

![Redesign System](img/4_sot_redesign_system.svg)

**Why:** Each story is a chance to reconsider the design, not just extend it. Without this step, a codebase grows by patches. With it, any subsystem can be deleted and regrown while the evals keep the system correct.

**Who:** 🤖 an agent. It doesn't need permission to rewrite a subsystem — the evals are the guardrails, and coding-style skills (such as the superpowers plugins) shape what good code looks like.

**In:** The story. The updated evals. The current code.

**Out:** A redesign plan and a list of tasks, attached to the story and sent to [Development](5-development.md).

## How

1. **Process the updated evals.** Work out which subsystems they touch.
2. **Plan the smallest change** that makes the new evals pass.
3. **Look for something to regrow.** Is there a subsystem that could be deleted and rewritten into a better design that still meets every eval? "Better" is judged against the evals — invariants and monitors set the constraints — and the team's coding-style skills.
4. **Write the tasks.** Each task is small enough for one pass through the Development loop. Add them to the story.

Subsystem boundaries are not fixed. The agent can redraw them, merge subsystems or split them, as long as no eval breaks. Contract tests between subsystems go with the code they test.

## Raise an issue

Raise an issue when the evals contradict each other, or when meeting them would mean breaking an invariant or an external contract.
