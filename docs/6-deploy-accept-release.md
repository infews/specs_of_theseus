# Deploy, Accept, Release

**Why:** A story isn't done until a person has seen it working. Deploying every completed story keeps the gap between "built" and "accepted" short.

**Who:** ⚙ automation deploys. 👱 the product manager accepts or rejects. 👱 ⚙ a person and automation release.

**In:** A completed story.

**Out:** New functionality in users' hands, or a rejected story sent back to [Product Planning](1-product-planning.md).

## How

1. **Deploy** ⚙ — ship the completed story to an environment where it can be tried. Tell [Choosing a Story](2-choosing-a-story.md) the work queue is empty, so the next story starts.
2. **Acceptance** 👱 — the product manager tries the working software against the story's acceptance criteria and accepts or rejects it.
3. **Release** 👱 ⚙ — accepted stories go out to users.

A rejected story goes back to Prioritization. Usually it means the evals didn't capture what the product manager wanted — fix the evals, not just the code.

## Raise an issue

Raise an issue when a deploy fails, or when a monitor that can only run in production fails after release.
