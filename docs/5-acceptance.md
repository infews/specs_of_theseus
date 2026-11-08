# Acceptance

![Acceptance](img/5_theseus_acceptance.svg)

**Why:** A story isn't done until a person has seen it working. Deploying every completed story keeps the gap between "built" and "accepted" short.

**Who:** ⚙ automation deploys. 🧑🏾‍⚖️ the product manager accepts or rejects, and releases with ⚙ automation.

**In:** A completed story and its tag.

**Out:** New functionality in users' hands, or a rejected story sent back to [Product Planning](1-product-planning.md).

## How

1. **Deploy** ⚙ — when a story tag appears, ship that commit to an environment where it can be tried. Untagged commits are never deployed. Signal that the work queue is empty, so the next story is [chosen](2-updating-evals.md).
2. **Acceptance** 🧑🏾‍⚖️ — the product manager tries the working software against the story's acceptance criteria and accepts or rejects it.
3. **Release** 🧑🏾‍⚖️ ⚙ — accepted stories go out to users.

A rejected story goes back to Prioritization. Usually it means the evals didn't capture what the product manager wanted — fix the evals, not just the code.

## Your team's process

Specs of Theseus has no skill for this stage. How a team deploys, where the product manager tries a story, and how releases reach users all depend on the product, the team and the technology — a web app with continuous delivery, a mobile app behind app-store review, and a CLI published as a package each do it differently.

The method asks only three things of whatever process the team uses:

- **Deploy story tags, and only story tags.**
- **A person accepts or rejects each story** against its acceptance criteria, on working software.
- **Rejected stories go back to Prioritization**, where the agent in [Product Planning](1-product-planning.md) helps rank them again.

## Raising Issues

Automation should raise an issue when a deploy fails, or when a monitor that can only run in production fails after release. Fixing these issues should start at Product Planning.
