# Redesign System

This step is all about an agent looking at the requested new work and doing a deeper consideration of how the subsystems (classes, functions, modules, etc.) could change. These then turn into tasks for the story. 


![Redesign System](img/3_theseus_redesign_system.svg)

**Why:** Each story is a chance to reconsider the design, not just extend it. Without this step, a codebase grows by patches. With it, any subsystem can be deleted and regrown while the evals keep the system correct.

**Who:** 🧞 an agent plans the redesign and writes the tasks. It doesn't need permission to rewrite a subsystem — the evals are the guardrails, and coding-style skills (such as the superpowers plugins) shape what good code looks like. 🧑🏼‍💻 a developer then reviews the tasks with the agent.

**In:** The story. The updated [evals](evals.md) (the invariants, contracts, end-to-end tests, and monitors) and their failing tests. The current code.

**Out:** A story with reviewed tasks, sent to [Development](4-development.md).

## How

1. **Redesign System** 🧞 — starting from the story, the updated evals and their failing tests, and the current code:
   - Work out which subsystems the updated evals touch.
   - Plan the smallest change that makes the new evals pass. If the story removed evals, that includes deleting the code that served them.
   - Look for something to regrow. Is there a subsystem that could be deleted and rewritten into a better design that still meets every eval? "Better" is judged against the evals — invariants and monitors set the constraints — and the team's coding-style skills.

   The result is a plan for the redesigned subsystems, and the tasks to get there.
2. **Add Tasks to Story** 🧞 — write the tasks into the story. Each task is small enough for one pass through the Development loop.
3. **Review Tasks** 🧑🏼‍💻 🧞 — the developer and agent check that the tasks cover the evals, are small enough, and come in a sensible order. The story with its tasks goes on to [Development](4-development.md).

Internal, subsystem boundaries are not fixed. The agent can redraw them as long as no eval breaks: extract code that several subsystems share into a subsystem of its own, or fold a shared subsystem back into its only user. Entry-point subsystems (e.g., commands, controllers) have surfaces pinned by evals, so the biggest redesigns tend to happen in shared subsystems, whose interfaces are internal. See [Subsystems](subsystems.md) for what a subsystem is and how it's marked. Contract tests between subsystems go with the code they test.

## Raising Issues

The agent should raise an issue when the evals contradict each other, or when meeting them would mean breaking an invariant or an external contract.

It should also raise an issue before a redesign that would change behavior no eval or existing test checks. A regrow there could break something and nothing would fail. The developer helps decide what's next — write the missing eval, add tests first, or make the smaller change instead. This matters most while a project is still being [adopted](6_adopting.md), when the existing tests are standing in for evals that haven't been written yet.
