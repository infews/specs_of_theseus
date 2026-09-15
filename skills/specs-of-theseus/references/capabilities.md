# Capabilities

`docs/capabilities.md` answers the question no other artifact is the right shape for: **what does this software do today, and why was it worth having?** The four-artifact split is in the core skill; this file is the detail behind one row of it.

The manifest already holds the features. `TEXT-SPEC-007 — When a file with an existing content hash is imported, the system shall record it as a duplicate` *is* duplicate detection. Two things stop the union of active `SPEC` entries from being readable as a feature list, and this file supplies both.

**The axis.** Subsystem boundaries are drawn for regrowth — what can be cut and rebuilt together. Features are user-visible capabilities. The two decompositions cross-cut, so one feature is several entries in several subsystem files, and no amount of coverage assembles them back into the thing a person would name.

**The outcome.** A spec says what happens. It never says who benefits or what got better. That lives in the epic's Vision and Success criteria — and epics are disposable.

## A projection, not a second source of truth

**A capability holds no promises.** Every promise it names is a link to a manifest entry. The only durable information original to this file is the outcome sentence.

**When the capability and the manifest disagree, the manifest wins, always.** That fixed direction of authority is what keeps a third document from becoming a third thing that can lie.

## Layout

One file. No directory, no index — the value is reading it end to end, and splitting it destroys that. If it grows long, group with headings rather than files.

```
docs/
  capabilities.md       # what the software does today
  epics.md              # the backlog
  subsystems.md         # the manifest
```

## Template

```markdown
# Capabilities

What this software does today. Each capability links the manifest entries that promise it;
the entries are authoritative. **Derived status:** a capability is active while every entry
it links is active.

Grouping here is for reading, not for cutting. The subsystem is the unit that gets deleted
and regrown — see [subsystems.md](subsystems.md).

<a id="cap-duplicate-detection"></a>
## Duplicate detection

- **Outcome:** Importing a library twice no longer silently doubles it. Users stopped
  hand-auditing after every bulk import.
- **Promised by:** [TEXT-SPEC-007](subsystems/text-acquisition.md#text-spec-007),
  [TEXT-SPEC-004](subsystems/text-acquisition.md#text-spec-004)
- **Delivered by:** [0002 — Import progress](epics/0002-import-progress.md)

<a id="cap-import-progress"></a>
## Import progress reporting

- **Outcome:** A long import shows how far along it is, so an operator can tell a stall
  from slow work without reading logs.
- **Promised by:** *none — delivered in unmanaged code*
- **Delivered by:** [0002 — Import progress](epics/0002-import-progress.md)

## Withdrawn

<a id="cap-legacy-currency-import"></a>
## Legacy currency import

- **Withdrawn:** 2026-09-02
- **Why:** Upstream removed the legacy catalogue; no caller has used one since 2025.
- **Was promised by:** [BILLING-SPEC-004](subsystems/billing.md#billing-spec-004) *(retired)*
```

The `Delivered by` link is a convenience, not the record. It points into the disposable layer and is expected to dangle eventually; the outcome sentence is what has to survive, which is why it lives here rather than being fetched from the epic.

## Written at epic close

The harvest happens once per epic, at close — not per story and not per entry.

That moment is the right one because everything needed is already written and nobody has to author anything new: the epic's Vision and Success criteria are in user language, written by whoever knew why the work mattered, and closing the epic is a step that already exists. It is also the only moment the work layer looks backward. Epics and stories are forward-facing documents; this is where one of them is read for what it turned out to deliver rather than what it planned to.

An epic may close into one capability, several, or none. None is legitimate — an epic that hardened settlement or paid down entropy delivered no new capability, and inventing one to fill the section is worse than leaving it empty.

## Status is derived, and that costs a maintenance obligation

A capability has no status field. It is active while every entry it links is active.

That only works if the link list is kept current, which makes retirement the maintenance hook: **retiring a manifest entry includes updating every capability that links it.** Swap in the replacement entry, or drop the link, or withdraw the capability. Retirement is already a visible, ceremonious act, so this rides along with something that cannot be done silently.

Without that obligation neither reading of a mixed list is right — *active if any entry is active* makes capabilities immortal, and *active if all are* lets one incidental retirement kill a live feature.

## The three browse queries

The file exists to be traversed, and every hop is a grep or a link.

| Question | Path |
| --- | --- |
| What code implements this spec? | `grep '@implements TEXT-SPEC-007'` |
| What code implements this capability? | capability → its entries → the union of those greps |
| What proves this capability works? | capability → its entries → `grep '@proves ...'` |

The third is worth naming: those binding tests are durable, black-box and outcome-level, which makes them the **executable acceptance criteria** for the feature. A story's Gherkin is disposable; this is what it becomes.

It is also the third tier of the rebuild referee in [system.md](system.md). A rebuild can satisfy every entry and still fail to deliver what the system was for, if the entries were the wrong set — and checking outcomes against their evidence is the only way that surfaces. An outcome whose entries cannot demonstrate it is a manifest defect, not a capability defect.

**An outcome that applies to the whole product, regardless of feature, is a cross-cutting invariant rather than a capability** — "no data is lost on import" belongs in `docs/system.md` with a binding test. The distinction is ownership: a capability is delivered by specific entries, a cross-cutting invariant is owed by everything.

**The queries return tagged code, not implementing code.** Reconcile — checking manifest against tags — does not exist yet, so an untagged implementation is invisible and the answer is silently incomplete. Report it as what it is until that gap closes.

## Rules

- **A capability is a view, never a cut unit.** It groups code across subsystems for reading. The subsystem is what gets deleted and regrown, because its boundary was drawn for that. Regrowing along a capability line crosses boundaries that exist for a reason.
- **No code tag points at a capability.** There is no `@satisfies`. A tag naming a capability would open a second ID space against the one-space, tier-neutral design in [tests.md](tests.md), and would put a pointer to a view inside durable code. Code points at entries; capabilities point at entries; that is the whole graph.
- **A capability with no linked entries is legal and is the most informative line in the file.** It says the feature is real and nothing promises it. Epics routinely touch unmanaged code, so this will happen; write `*none — delivered in unmanaged code*` rather than omitting the capability. An unpromised feature that is visible is a finding, and one that is absent is indistinguishable from a feature nobody built.
- **The outcome is one or two sentences about the world, not the system.** "Users stopped hand-auditing after every bulk import," not "the importer compares content hashes." The second is the spec's job and is already written down.
- **Withdrawal is visible**, same as retirement. Record when and why; never delete a capability outright.
- **Every entry reference is a link, to its anchor.** These are markdown files linking to markdown files.
- **Every capability carries an explicit anchor** — `<a id="cap-duplicate-detection"></a>`, for the same reason manifest entries do: GitHub derives anchors from the whole heading, and an explicit one survives a rewording.
