# Work Format — Epics, Stories, and Tasks

Epics and stories are **disposable**. They record why a set of manifest changes happened, which is worth keeping, but nothing regrows from them. The manifest is the durable asset; this layer is how work reaches it.

## Layout

```
docs/
  epics.md                        # ordered index — the backlog
  epics/
    0001-photo-import.md
    0001-photo-import/
      0010-detect-duplicates.md
      0020-import-progress.md
  subsystems.md                   # the manifest
  subsystems/
    text-acquisition.md
  capabilities.md                 # what the software does today
```

The index sits *beside* the directory it indexes, same rule as `subsystems.md`. Inside, it sorts among the epics and gets lost.

An epic's stories live in a directory named for the epic file minus its extension. Number epics sequentially (`0001`, `0002`) and stories by tens (`0010`, `0020`, `0030`) so one can be inserted between two others without renumbering.

## epics.md — the backlog

```markdown
# Epics

Ordered. The top of the list is what gets worked next.

| Epic | Status | Opened | Closed |
| --- | --- | --- | --- |
| [0002 — Import progress](epics/0002-import-progress.md) | in progress | 2026-09-04 | — |
| [0001 — Photo import](epics/0001-photo-import.md) | done | 2026-08-20 | 2026-09-01 |
```

Statuses: `open`, `in progress`, `done`, `abandoned`. An abandoned epic keeps its row and its file — the reasoning that killed it is worth more than the tidiness of deleting it.

**Order is priority.** There is no separate prioritization artifact; reprioritizing is reordering this table.

## Epic template

```markdown
# 0002 — Import progress

Part of the [backlog](../epics.md).

## Vision

What is the high-level goal? What problem are we solving, and for whom?

## Context

Why now? What motivated this work?

## Scope

**In scope:** ...

**Out of scope:** ...

## Subsystems touched

Read [docs/subsystems.md](../subsystems.md) before writing this section. A guess, refined during slicing.

| Subsystem | Status | Expected impact |
| --- | --- | --- |
| [Text Acquisition](../subsystems/text-acquisition.md) | under management | probably two new specs |
| Import pipeline | **not managed** | adoption needed, or a new subsystem |

## Invariants at risk

Entries this epic might break, including the cross-cutting ones in [docs/system.md](../system.md) that no subsystem's inventory will surface. Empty is a valid answer, but check rather than assume — an epic that breaks an invariant needs to know at refinement, not at implementation.

- [TEXT-INV-002](../subsystems/text-acquisition.md#text-inv-002) — the epic changes the default page window, which is what this invariant measures against.
- [SYSTEM-INV-001](../system.md#system-inv-001) — bulk import runs longer, widening the window in which an interruption could leave partial state.

## Success criteria

How will we know this is done, from the user's side?

## Dependencies

## Open questions

## Resulting stories

Order is the backlog. The status after each link is **the only place a story's state is written.**

- [ ] [0010 — Detect duplicates](0002-import-progress/0010-detect-duplicates.md) — *in review*
- [x] [0020 — Progress bar](0002-import-progress/0020-progress-bar.md) — *accepted*
- [ ] [0030 — Cancel an import](0002-import-progress/0030-cancel-an-import.md) — *not started*
```

## Story template

````markdown
# 0010 — Detect duplicates

Part of [0002 — Import progress](../0002-import-progress.md).

## Narrative

As a *role*, I want *goal*, so that *benefit*.

## Acceptance criteria

```gherkin
Feature: Detect duplicates

  Scenario: An identical file is imported twice
    Given a library containing report.pdf
    When the same file is imported again
    Then it is recorded as a duplicate
    And the library still contains one copy
```

## Manifest delta

Written before any code moves. This is the story's promise, and the only place EARS appears.

| Entry | Change | Statement |
| --- | --- | --- |
| [TEXT-SPEC-007](../../subsystems/text-acquisition.md#text-spec-007) | add | When a file with an existing content hash is imported, the system shall record it as a duplicate and shall not add a second copy. |
| [TEXT-SPEC-004](../../subsystems/text-acquisition.md#text-spec-004) | modify | *(was: ...)* Now also covers the duplicate path. |
| [TEXT-NON-002](../../subsystems/text-acquisition.md#text-non-002) | retire | Superseded by TEXT-SPEC-007. |

## Tasks

- [x] `TEXT-SPEC-007` — hash a file on import
- [x] `TEXT-SPEC-007` — reject a second file with a matching hash
- [ ] `TEXT-SPEC-007` — return the duplicate result shape to callers
- [ ] `TEXT-SPEC-004` — extend the window test to the duplicate path
````

**A story file carries no status.** Its state lives in one place: beside its link in the epic's `Resulting stories` list. Statuses are `not started`, `in progress`, `in review`, `accepted`, `rejected`; the checkbox is ticked at `accepted`. A rejected story goes back to the top of the backlog with the reason recorded; it does not become a new story.

One location, for the reason the manifest has one: **two places to write a status are two places to forget one.** A story file saying `in progress` beside an epic checkbox saying done is the same failure as a manifest that disagrees with the code — and the story file's five values against the checkbox's two meant they could disagree in ways the checkbox could not even express.

The story file is not statusless in practice. Its **task checkboxes** show where the work actually is, in more detail than a status word ever did, and they are already committed alongside the code they describe.

## Task format

A task is **one red/green/refactor cycle**, and it names the manifest entry it serves.

Tasks are not written in EARS. EARS is for manifest entries — a task is a step toward one, not a promise, and writing it as a promise duplicates the entry in a place that gets deleted.

Several tasks per entry is normal and is what "small steps" means. The relationship runs both ways and both directions are checked:

- **An entry in the delta with no tasks will not get built.** Catch it when the plan is written, not at close.
- **A task with no entry is unpromised behavior.** Either it belongs to an entry nobody wrote down, or it should not be built.

An implausibly long task list is information. Thirty tasks usually means the story was sliced too wide, not that the work is hard.

## Closing an epic — the harvest

Epics and stories are forward-facing. They say what work will be done, and they are never read again to find out what the software does. Closing an epic is the one moment the work layer looks backward, and it is where the epic's reasoning is harvested before the file becomes archaeology.

Flipping the status to `done` in `epics.md` is half the close. The other half: **fold what the epic delivered into `docs/capabilities.md`** — a named capability, an outcome sentence in user language, and links to the manifest entries its stories promised.

Nothing new gets authored. The epic's `Vision` and `Success criteria` are already written from the user's side by whoever knew why the work mattered; the harvest moves that sentence somewhere durable and attaches the entries to it. Format and rules in [capabilities.md](capabilities.md).

An epic may close into one capability, several, or none. **None is legitimate** — an epic that hardened settlement or paid down entropy delivered no new capability, and inventing one to fill the section is worse than an empty harvest.

## Rules

- **A story does not contain specs.** It contains edits to the manifest and the tasks that make code match. A spec written into a story is lost at the next cut, which is the one thing the method exists to prevent.
- **The delta comes before the code, always.** This is the core skill's *never change code first and the manifest after*, one level up.
- **A story with no manifest delta is one of two things.** An ordinary change under existing specs — legitimate, say so explicitly and close it — or unpromised behavior, which is a defect.
- **Every entry reference is a link, to its anchor.** `../../subsystems/text-acquisition.md#text-spec-007`, not a bare ID. These are markdown files linking to markdown files, so the links render and resolve. Code comments are the opposite case and carry bare IDs.
- **Epics and stories are disposable; do not put durable knowledge in them.** If something learned during a story must survive, it belongs in the manifest as a spec, a non-promise, or evidence on an invariant.
- **Close the loop upward.** A finished story's status is set in its epic's list — one edit, one place. A finished epic is closed in `epics.md` *and harvested into `capabilities.md`*. An epic whose stories are all done but which still reads `in progress` is the same failure as a manifest that disagrees with the code. An epic closed without a harvest is quieter and worse: the software gained a feature that nothing outside the deleted layer records.
- **Status is written once, at the level above.** A story's state lives in its epic; an epic's state lives in `epics.md`. Never copy a status downward into the thing it describes — that is the duplication this layer just removed.
