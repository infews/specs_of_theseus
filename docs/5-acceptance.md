# Acceptance

![Acceptance](img/5_sot_acceptance.svg)

**Why:** A story isn't done until a person has seen it working. Deploying every completed story keeps the gap between "built" and "accepted" short.

**Who:** ⚙ automation deploys. 🧑🏾‍⚖️ the product manager accepts or rejects, and releases with ⚙ automation.

**In:** A completed story and its tag.

**Out:** New functionality in users' hands, or a rejected story sent back to [Product Planning](1-product-planning.md).

## How

1. **Deploy** ⚙ — when a story tag appears, ship that commit to an environment where it can be tried. Untagged commits are never deployed. Signal that the work queue is empty, so the next story is [chosen](2-updating-evals.md).
2. **Acceptance** 🧑🏾‍⚖️ — the product manager tries the working software against the story's acceptance criteria and accepts or rejects it.
3. **Release** 🧑🏾‍⚖️ ⚙ — accepted stories go out to users.

A rejected story goes back to Prioritization. Usually it means the evals didn't capture what the product manager wanted — fix the evals, not just the code.

## Raising Issues

Automation should raise an issue when a deploy fails, or when a monitor that can only run in production fails after release. Fixing these issues should start at Product Planning.
