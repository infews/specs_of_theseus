# Adding the capability layer — what the software does today

Date: 2026-09-09

## The problem

The method had two artifacts answering two questions, and a third question with nowhere to go.

| Question | Artifact |
| --- | --- |
| How did we get here? | `docs/epics.md` and its stories |
| What must survive a rebuild? | `docs/subsystems.md` |
| What does it do today? | — |

Epics and stories are forward-facing. They define work, are never read back to find out what exists, and superseded ones stay written — so reconstructing today's behavior from them gives a confidently wrong answer. That is the same defect the method already refuses to accept when it says the code cannot be the record of intent: **a log is not a state.**

## What was actually missing

The first framing was that the manifest lacks features. It does not. `TEXT-SPEC-007 — When a file with an existing content hash is imported, the system shall record it as a duplicate` *is* duplicate detection, written in EARS, in a durable file, tagged from code and tests. The union of active `SPEC` entries is what the software promises to do.

Three things stop that union from being usable as a feature list, and only the third is new information:

**The vocabulary hid it.** Nothing said the `SPEC` union was the feature record. Fixed with a sentence.

**The axis is wrong.** Subsystem boundaries are drawn for regrowth — what can be cut and rebuilt together. Features are user-visible capabilities. The two decompositions cross-cut, so one feature is several entries in several files, and no amount of coverage reassembles them. This does not improve with tooling; it needs a projection on a different axis.

**The outcome is nowhere.** A spec says what happens, never who benefits or what got better. That lives in the epic's `Vision` and `Success criteria` — in the disposable layer. This is the only genuinely durable information the new artifact adds.

A related defect fell out: manifest-format.md required an `Origin` link on every entry and called it "the only durable pointer back to the disposable layer." A durable record was holding its sole path to *why* inside storage the method gives permission to delete.

## Rejected alternatives

**Business outcome as a fourth invariant category.** Every `INV` carries a binding test. "Finance can reconcile month-end without manual adjustment" has no binding test — it is an outcome in the world, not a property of the system. Admitting it either breaks the every-invariant-is-tested rule or forces a test that asserts something narrower than the claim and quietly becomes the claim.

Worth recording a wobble found on the way: invariants.md defines an invariant by *would a from-scratch rebuild silently violate this?*, and `BILLING-SPEC-001` (reject empty line items) passes that test as cleanly as any `INV` does. The `INV`/`SPEC` line is drawn by category, not by that question. Left alone here — but it means the outcome layer was never going to find a home by widening the categories.

**A code tag naming the capability** (`@satisfies 0002/0010#AC-1`, or a capability ID). Rejected: it opens a second ID space against the one-space, tier-neutral design in tests.md, and puts a pointer to a view inside durable code. Code points at entries; capabilities point at entries.

**Executable Gherkin as the binding suite.** Forces a tool choice on every project using the method, and makes acceptance criteria durable while the method says stories are disposable.

**The closed-epic list as feature history.** An event log again, with superseded features listed forever.

**Nothing — declare it out of scope.** Defensible, and the right answer if the only cost of a third document were the document. It lost because the axis problem is permanent: nothing derived from a subsystem-shaped record will ever read as a feature list, so a project that needs one has to maintain a fiction elsewhere anyway.

## The design

`docs/capabilities.md`, one file, written at epic close.

**A projection, not a source of truth.** Every promise is a link to a manifest entry. The one thing original to the file is the outcome sentence. When it disagrees with the manifest, the manifest wins — a fixed direction of authority is what stops a third document becoming a third thing that can lie.

**Harvested at epic close.** The hook already exists and previously did nothing but flip a status. Nothing new is authored: the epic's `Vision` and `Success criteria` are already in user language, written by whoever knew why the work mattered. One write per epic, not per story or per entry. An epic may harvest into none — hardening and entropy epics deliver no capability, and inventing one is worse than an empty harvest.

**Status is derived**, not stated: active while every linked entry is active. That costs a maintenance obligation, now in manifest-format.md — retiring an entry includes updating every capability that links it. Without it neither reading works: *any active* makes capabilities immortal, *all active* lets one incidental retirement kill a live feature. Retirement is the right hook because it is already an act that cannot be done silently.

**A view, never a cut unit.** The subsystem remains what gets deleted and regrown. Two decompositions that both group code is an attractive nuisance, so the rule is written in three places.

**Capabilities with no entries are legal**, and are the most informative line in the file: the feature is real and nothing promises it. Epics routinely touch unmanaged code, so this will happen. Same logic as *identified but not adopted* — an unpromised feature that is visible is a finding; one that is absent is indistinguishable from a feature nobody built.

## What this closed on the way

The story's Gherkin acceptance criteria had no thread — written during slicing, never referenced again, not even at story close. They now have a destination: an AC becomes a manifest entry, and the entry's binding test is the durable, executable form of the criterion. Capability → entries → `@proves` is the acceptance evidence for a feature.

## What one epic and one story found

Run 2026-09-13. `capabilities.md` was reported as the highest-yield artifact of the run and produced no friction. Writing it surfaced three capabilities linking zero entries and two withdrawals that had not been considered, so the *none — delivered in unmanaged code* rule paid off on first use. The capability-versus-cross-cutting distinction also made a call that would otherwise have gone wrong: a cross-command property looked like it belonged in `system.md`, and "a capability is delivered by specific entries, a cross-cutting invariant is owed by everything" put it in the right file.

No changes needed. The prediction that the harvest would be the weak point is still untested — this run closed no epic.

## Still open

- **Phase 6 does not re-check the story's acceptance criteria.** A story can close with every task green and an unmet AC. The proposed fix is an AC↔entry check in phase 2 and an acceptance read-back in phase 6; not written yet.
- **Reconcile still does not exist.** The browse queries return *tagged* code, not implementing code, so an untagged implementation is silently invisible.
- **The `INV`/`SPEC` line is justified by a test both sides pass.** Noted above, not resolved.