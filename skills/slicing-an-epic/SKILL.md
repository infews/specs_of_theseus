---
name: slicing-an-epic
description: Use when a refined epic needs to be broken into stories. Use when asked to slice, split, or break down an epic into vertical slices, or to build or reorder the story backlog.
---

# Slicing an Epic

## Overview

Break an epic into slices that are each independently deliverable and independently testable. A slice is vertical: it goes all the way through, from whatever the user touches to whatever persists, for a narrow case — rather than horizontally, one layer at a time.

**Vertical means the full depth available, not necessarily a user-facing surface.** A hardening epic has no user-facing layer to reach: its slices run entry → binding test → fix if red, and that is the whole stack for that work. Such a story is vertical and passes the test. The horizontal failure is delivering *part* of the available depth — the entry without the test, or the test without the fix — not delivering a depth that stops short of a UI that was never involved. `capabilities.md` already blesses epics that deliver no capability; this is the same latitude one level down.

**REQUIRED BACKGROUND:** Read the [specs-of-theseus](../specs-of-theseus/SKILL.md) skill first. Formats live in [work-format.md](../specs-of-theseus/references/work-format.md).

Slicing produces story files and an ordered list. It produces no manifest entries — the delta is written inside the story, when the story is worked.

## Checklist

### 1. Re-read the epic, especially the inventory

The `Subsystems touched` table is the input to slicing. A slice that spans four subsystems is not a slice, it is a coordination project — and the table is where that becomes visible before the story is written rather than after it stalls.

### 2. Propose the slices

Each one:

- **Vertical.** Delivers something observable on its own. "Add the database column" is not a story.
- **Narrow across subsystems.** One or two. Three is a warning; four means re-slice. **For every slice touching more than one, say why they are paired** — and judge the answer, not the count. "The pty harness is a shared cost both need" is a reason; "both are cheap" is a leftover bin wearing a story's clothes. The count tells you to look; the rationale tells you whether the pairing is real.
- **Thin enough to finish.** If you cannot picture it done in a focused session, split it.
- **Independently valuable, or explicitly a prerequisite.** Both are legitimate; being unclear which is not.

Give each a coarse guess at its manifest impact — "probably two new specs on Text Acquisition," "needs Import Pipeline adopted first." A guess, not a commitment. It exists to size the slice and to surface the story that quietly contains an adoption.

**STOP. Present the proposed slices before writing any files.** They will be reordered, split, combined, or cut, and that conversation is cheaper before the files exist.

### 3. Order them

The order of the list in the epic *is* the backlog. There is no separate artifact.

Order by value and by dependency, and put the story that proves the riskiest assumption early. A story that would invalidate the rest of the epic if it failed should not be scheduled last.

### 4. Write the story files

Create them under `docs/epics/<epic>/`, numbered by tens, from the template in [work-format.md](../specs-of-theseus/references/work-format.md). Link each from the epic's `Resulting stories` list and back to the epic.

Fill in the narrative and the Gherkin acceptance criteria. Leave `Manifest delta` and `Tasks` empty — those are written when the story is worked, by [delivering-a-story](../delivering-a-story/SKILL.md), against the manifest as it stands then rather than as it stands now.

**The story file carries no status.** Set each story's initial `not started` beside its link in the epic's `Resulting stories` list, which is the one place a story's state is written.

**STOP. Present the stories and the order.**

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Horizontal slices — "the API story", "the UI story" | Neither is deliverable alone. Cut a narrow case end to end instead. |
| Writing the manifest delta during slicing | It is written against the manifest at the time the story is worked, which is not now. |
| Writing EARS specs in the story | Specs are manifest entries. The story references them; it does not hold them. |
| A story spanning four subsystems | Not a slice. Re-cut it, or split the coordination out and name it. |
| Filing the story files before showing the slices | The reordering conversation is the point of the step. |
| Ordering purely by value, ignoring risk | The story that could invalidate the epic goes early, not last. |
