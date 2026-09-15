# Adding the intent layer — epics, stories, and tasks

Date: 2026-09-05

## The problem

Specs of Theseus starts at a subsystem that someone has already decided to work on. It has no answer to *where the work came from*. In practice this shows up two ways:

- Broad intent never gets written down. An epic-sized need arrives, gets mentally decomposed, and the manifest receives its consequences without ever recording the thing that caused them.
- There is no unit of work between "a subsystem" and "a manifest entry." A subsystem is too big to deliver and a manifest entry is too small to prioritize, so the middle is improvised each time.

[the flow diagrams](../../skills/specs-of-theseus/references/intent-to-tasks.mmd) closes both. It also fills in the *steady-state change* path that the [original design](2026-08-28-specs-of-theseus-design.md) explicitly deferred.

## What we take from pivotal-xp, and what we change

`pxp:pivotal-xp` already has the front half of this flow: epic refinement, vertical slicing, story documents with Gherkin acceptance criteria. We take that structure.

We do **not** take its back half. In pxp, the story's implementation plan *is* a list of EARS specs invented on the spot, and those specs live in the story document. Under Specs of Theseus that is backwards: EARS specs are manifest entries, they outlive the story, and the story is disposable.

The rule that resolves it:

> **A story does not contain specs. A story contains a list of edits to the manifest, and the tasks that make the code match.**

This is the same ordering the core skill already enforces — *never change code first and the manifest after* — applied one level up. A story that produces no manifest delta is either an ordinary change under existing specs, or it is unpromised behavior.

## Where the artifacts live

```
docs/
  epics.md              # ordered index of epics — the backlog
  epics/
    0001-photo-import.md
    0001-photo-import/
      0010-detect-duplicates.md
      0020-import-progress.md
  subsystems.md         # the manifest
  subsystems/
    text-acquisition.md
```

Index beside the directory it indexes, same rule as `subsystems.md`. This is a deliberate departure from pxp, which puts the index at `docs/epics/0000-epics.md` — inside, where it sorts among the epics and gets lost.

Epics and stories are **disposable**; the manifest is durable. An epic doc is a record of why a set of manifest changes happened, which is worth keeping, but nothing regrows from it.

---

# New skills

## 1. `refining-an-epic`

**Trigger:** a business need, product idea, or technical spike that is larger than one story.

Derived from pxp Phase 1. Produces `docs/epics/NNNN-name.md` and appends it to `docs/epics.md`.

Changes from pxp:

- **Adds an inventory pass.** Before questions, read `docs/subsystems.md` and name which subsystems the epic plausibly touches, and which of them are unmanaged. An epic whose blast radius is entirely unmanaged code is a different kind of work — say so up front.
- **Adds an "Invariants at risk" section** to the epic template. If the epic looks like it will break an existing `INV` entry, that is the single most important thing to surface at refinement, not at implementation.
- Keeps: scope boundaries, user intent, edge cases, acceptance, dependencies; batched questions.

## 2. `slicing-an-epic`

**Trigger:** a refined epic that needs stories.

Derived from pxp Phase 2. Produces story files under `docs/epics/<epic>/` numbered by tens, linked from the epic's `## Resulting Stories`, in priority order.

Changes from pxp:

- **The slicing heuristic gains a subsystem axis.** A story that touches four subsystems is not vertical, it is a coordination project. Prefer slices that land in one or two.
- **Each story names its expected manifest impact at slice time** — a guess, not a commitment: "probably adds two SPECs to Text Acquisition." Deliberately coarse. It is the input to prioritization and the sanity check on slice size.
- **Backlog order is the order of the list in the epic doc.** No separate prioritization artifact. The `Prioritize` node in the diagram is a reordering of that list.

## 3. `delivering-a-story`

**Trigger:** the top of the backlog. This is the workhorse, and it is the skill the whole diagram is shaped around — nodes `Analyze Inventory` through `Mark Task Complete`.

Six phases:

1. **Analyze inventory.** For each behavior the story requires, decide which of three it is:
   - existing managed subsystem that needs spec changes → phase 2 here
   - existing unmanaged code the story depends on → [adopting-a-subsystem](../../skills/adopting-a-subsystem/SKILL.md)
   - behavior with no home yet → `growing-a-subsystem` (new, below)

   **STOP** — present the routing before touching anything.

2. **Write the manifest delta.** Every entry added, modified, or retired, with its EARS statement and its ID. Manifest first, always. This is where EARS is used — and the only place.

   **STOP** — the delta is the promise. It gets approved before any code moves.

3. **Extract work.** Turn the delta into an ordered task list in the story document. See *Task format* below.

   **STOP** — present the plan.

4. **TDD each task.** Red / green / refactor, delegating to a `test-driven-development` skill.

5. **Annotate.** `@proves` on the test, `@implements` on the code, per [tests.md](../../skills/specs-of-theseus/references/tests.md). Check the task off.

6. **Close the story.** Full suite green, every task checked, manifest and code agree, story marked done in the epic.

**When the delta is large enough that patching would distort the subsystem, phase 3's first task is a cut** — the story hands off to [regrowing-a-subsystem](../../skills/regrowing-a-subsystem/SKILL.md) and resumes after. This is how regrowth enters the flow, and it is why the diagram has no separate regrowth node.

## 4. `growing-a-subsystem`

**Trigger:** a story needs behavior that has no subsystem, managed or otherwise.

Greenfield sibling of `adopting-a-subsystem`. Same output — a boundary, a subsystem file, a manifest row — but the elicitation is inverted. Adoption reads callers and infers intent; growth has no callers and must declare it.

Why it is a separate skill rather than a branch inside adoption: adoption's core discipline is *telling intent from accident*, and its strongest evidence source is "read every call site." Neither exists here. Half of `adopting-a-subsystem` would be dead text.

What it needs that adoption does not:

- **Invariants are chosen, not discovered.** The three categories still apply, but the honest default is *fewer*. A new subsystem with nine invariants has legislated a design nobody has built yet — that is Procrustean at birth.
- **The boundary is provisional.** Adoption draws a boundary around code that exists; growth draws one around code that does not, and it will be wrong. Say so in the file, and expect the first regrowth to move it.
- **It reaches "under management" the same way everything does** — by being regrown. A grown subsystem is `adopted — not yet regrown` until then.

---

# Changes to existing skills

## `specs-of-theseus` (core)

- **New vocabulary rows:** Epic, Story, Task, Manifest delta.
- **New routing entries** for the four new skills, and a routing rule that reads off the diagram: work enters at an epic; a subsystem-level skill is reached *through* a story, except for entropy-driven regrowth with no product change, which may still be entered directly.
- **Embed the flow diagram.** It is the clearest statement of the method we have and belongs in the skill, not just in `docs/`.
- **New common mistake: "Specs written in the story."** The story is disposable; a spec written there is lost at the next cut. Specs live in the manifest.
- **New common mistake: "Story with no manifest delta."** Either it is an ordinary change under existing specs — fine, say so — or it is shipping unpromised behavior.
- **New red flag:** "I'll write the epic up after we know what we built."

## `adopting-a-subsystem`

- **New entry context.** Adoption is now usually reached *from a story*, not stood up on its own. Add a note at the top: when adopting mid-story, adopt only the boundary the story needs, and record the rest as identified-but-not-adopted rather than widening the cut.
- **Remove the standalone tracking note** at the head of the checklist — task tracking is now the story's job (see below).
- **Keep the "write each decision down as it is made" paragraph** at step 3. It predates this plan and survives it: classification decisions cost the user's attention and cannot be reconstructed from the code, so a long list that outlasts a session must not be held in the session.

## `regrowing-a-subsystem`

- **New entry context**, mirroring adoption's: reached from a story when the delta is too large to patch, or directly when entropy alone is the driver.
- **Delete the `## Regrowth in progress` section from the subsystem file.** This supersedes the in-flight change. The subsystem file is pure declared intent; the story document is where work state belongs, and it already has the right lifetime — created for the work, closed when the work is done, never claiming to describe the current system. A regrowth with no story behind it gets a story, which is a fair price for making it visible.
- **Rewrite "Tracking the work"** accordingly: two levels remain, but they are now TodoWrite for session steps and *the story's task list* for spec-by-spec progress.
- **Step 3** produces tasks in the story rather than a table in the subsystem file. Step 6 no longer deletes a section; it verifies the story's tasks are all checked.
- Keep both new Common mistakes rows, retargeted at the story.

## `references/ears.md`

- **Add a scope note:** EARS is for manifest entries only. Tasks are not written in EARS, Gherkin acceptance criteria are not written in EARS, and epics certainly are not.
- Absorb pxp's Gherkin→EARS decomposition technique, which we do not currently have and now need — it is the bridge from a story's acceptance criteria to manifest entries.
- We do **not** adopt `pxp:ears-specifications` as a dependency. Its semantic-ID scheme (`{FEATURE}-{TYPE}` with `TYPE` in `UI`/`API`/`DATA`/`NAV`/`BE`/`PROC`) is structurally identical to ours and means something different. Two schemes that look the same and are not is worse than two that look different. See *Conflicts* below.

## `references/tests.md`

Two changes to the annotation format, both driven by real tags on parkive's `theseus-vocabulary-migration` branch.

### Tags carry the ID and nothing else

```ruby
# @implements TEXT-SPEC-001, TEXT-SPEC-002
```

No path, no markdown link. **Decided 2026-09-05: deferred pending tooling.** A hand-written path in a comment duplicates a derivable fact, rots silently on any file move with nothing failing, and breaks the grep people actually type (`grep '@implements TEXT-SPEC-001'`). It also does nothing for the doc→code direction, which is what future tooling would actually provide: that tool indexes the codebase for tags, so it already knows the file.

Multi-ID tags stay comma-separated, as they are today. The one-entry-per-line rule was only ever a workaround for link length, and the length is gone.

### The tag is a pointer, not a summary

The failure observed in practice was not verbose tags — those were already terse. It was the line *above* them:

```ruby
# Public so the accuracy harness measures the window the tool ships.
# @implements TEXT-INV-002, TEXT-SPEC-001
```

against `TEXT-INV-002 — The accuracy harness measures the window the tool ships`. The same sentence in two places, one of which will not be maintained — and the unmaintained copy is the one a reader is standing next to.

**Rule: never restate the entry; freely explain the mechanism.** This one is correct and should stay, because it explains why *this code* satisfies the entry, which is not in the manifest:

```ruby
# @implements TEXT-SPEC-003 — omitting the flags is pdftotext's "whole document"
```

With links deferred, this is the only annotation change that ships — and it makes comments strictly shorter.

## `references/manifest-format.md`

- Remove the `## Regrowth in progress` section from the subsystem template and the paragraph describing it.
- **Add an explicit anchor above every entry heading**, so *markdown* files can link to it:

  ```markdown
  <a id="text-inv-001"></a>
  ### TEXT-INV-001 — A PDF with no text layer yields no text
  ```

  Required, not cosmetic: GitHub derives the anchor from the whole heading, so `#text-inv-001` does not resolve against `### TEXT-INV-001 — A PDF with no text layer…`. The explicit anchor also survives a title rewording, which the derived one does not.

  This survives the decision to skip links in code comments, because the linking that remains is markdown→markdown — a story's task list citing the entry it edits, the manifest citing an entry directly — and that is where markdown actually renders. **The rule that falls out: markdown links belong in markdown files; code comments carry bare IDs.**
- **Add a prefix column to `docs/subsystems.md`** mapping the ID prefix to its file (`TEXT-` → `subsystems/text-acquisition.md`). One line per subsystem, maintained in one place. It is what makes an ID a complete address without a path in any comment, and what a future doc→code tool reads to resolve one.
- **Add the reclassification rule** and the *ID is an address, not an assertion* framing — see Conflicts 2.
- **Add a `Origin` field to entries** — the story or epic that introduced them. One link. It makes the manifest answer "why is this promised?" without re-deriving it, and it is the only durable pointer back to the disposable layer.

## New reference: `references/work-format.md`

Epic and story templates, and the task format.

### Task format

A task is one red/green/refactor cycle, and it names the manifest entry it serves:

```markdown
## Tasks

- [x] `TEXT-SPEC-007` — reject a PDF with no extractable text layer
- [x] `TEXT-SPEC-007` — return the empty_text error shape to callers
- [ ] `TEXT-SPEC-008` — fall back to OCR when the text layer is empty
- [ ] `TEXT-INV-002` — re-measure p99 after the OCR path lands
```

Several tasks per entry is normal and expected — that is what "small steps" means. Zero tasks for an entry in the delta means it will not get built. A task with no entry means unpromised behavior.

---

# Conflicts that need resolving

These are places where the two methods disagree and one has to win.

## 1. Annotation tags

pxp annotates with `@spec {ID}` on both test and implementation. Specs of Theseus uses `@proves` on tests and `@implements` on code, and dropped `@spec` deliberately — it collided with `SPEC` as an entry type and read as a category claim rather than a reference.

**Decided: Specs of Theseus wins, for now.** No change to `tests.md`. Revisit only if a third tier (live evaluations) needs a verb that neither covers.

Cost: parkive carries ~414 `@spec` tags under the pxp convention. Its manifest already has the coexistence policy for this — annotations migrate to manifest IDs at regrowth, not at adoption — so the two schemes coexist until each area is regrown. That policy should be backported into `manifest-format.md`; it was already on the backport list.

## 2. ID schemes

`AUTH-API-001` (pxp) and `BILLING-SPEC-001` (theseus) are the same shape with different middles. Under one repo they are indistinguishable at a glance and impossible to grep apart without knowing the type vocabulary.

**Decided: one ID space, theseus's.** The middle segment is `INV`/`SPEC`/`NON` and nothing else. The first segment is a subsystem, not a feature — features are epics, and epics are disposable, so an ID keyed to one would outlive its own namespace.

Both segments stay even though `@proves`/`@implements` now carry the direction, because they carry something else: the class. `@proves BILLING-001` cannot tell you whether you are looking at the referee for a regrowth or a scaffolding test that happens to cite an entry, and that is the distinction the method turns on. It also keeps the core drift check a single regex — every `INV-` in the binding directory — rather than a manifest lookup per tag.

**New rule for `manifest-format.md`: reclassification.** The cost of class-in-ID is that entries cannot change class, and the method actively produces candidates (adoption defaults to accident, and "someone complains and you add it" is a `NON` becoming a promise). Two cases, priced differently:

- **NON → SPEC/INV** — the promise genuinely changed. Retire the `NON` visibly. That is the record working, not churn.
- **SPEC → INV** — nothing about the promise changed, only what you learned about whether it constrains a rewrite. Issue the new `INV` ID and retire the `SPEC` with the reason *reclassified, not withdrawn — see `BILLING-INV-009`*, noting that behavior is unchanged so no code moves. Tags migrate at the next regrowth under the coexistence policy.

The framing that makes both survivable, and which belongs in the reference: **an ID is an address, not an assertion.** It records the classification at issue time. The manifest is authoritative, and when they diverge you reclassify rather than pretending the ID is live. The same applies to the `{SUBSYSTEM}` segment when a boundary splits.

## 3. Approval gates

pxp gates every transition inside the TDD cycle: before running the test, before writing the implementation, before running again, before refactoring. Theseus gates at phase boundaries only.

**Decided: keep pxp's gating.** They are cheap to prompt through when the developer wants speed, and the pause is where the developer gets context they would otherwise have to reconstruct from a diff. Theseus's phase STOPs stay as well — they gate different things. The phase STOPs approve *what is promised*; the per-step gates approve *how it gets built*.

Two consequences:

- **Import the enforcement apparatus, not just the gate list.** pxp's *What counts as approval* section and its *Common Rationalizations* table are what make the gates hold; without them the gates decay into narration. pxp says this itself — violating the letter is violating the spirit.
- **`regrowing-a-subsystem` step 4 gets the same gates.** It is the same TDD loop, and two different TDD disciplines inside one method is worse than either.

## 4. Which TDD skill

pxp defers to `superpowers-ruby` → `superpowers` → its own fallback. Theseus currently inlines the cycle in regrowth step 4.

**Decided: delegate, same lookup order, with an inline fallback.** Add the theseus-specific additions on top: annotate with `@proves`/`@implements`, and check the task off.

---

# Sequencing

1. `references/work-format.md` — templates and task format first; everything else references it.
2. `refining-an-epic`, `slicing-an-epic` — self-contained, no dependencies on the rest.
3. `growing-a-subsystem`.
4. `delivering-a-story` — depends on all of the above.
5. Core skill routing, vocabulary, diagram.
6. Edits to `adopting-` and `regrowing-`, including removing `## Regrowth in progress`.
7. `install.sh` — add the four new skills to `SKILLS=(...)`.

Note that step 7 will break the parkive symlinks again if any skill is renamed; nothing here renames one, but the new skills need installing before parkive can use them.

# Still deferred

- Live evaluations (Fowler's third tier) — production monitors carrying `@proves`.
- A `reconcile` skill — manifest ↔ tags, plus link integrity, plus the story/task check.
- **Tooling** — doc→code navigation generated from a tag index. When it exists it needs somewhere to write: a section in the subsystem file explicitly marked as machine-owned, so nobody hand-edits it. Links in code comments are deferred to the same conversation.
- Deploy, capacity, and acceptance (`O`, `Q` in the diagram). These are team process, not agent work. The only artifact they need is a status line on the story, which the template will carry.
