---
name: specs-of-theseus
description: Use when working in a codebase that has a docs/subsystems.md manifest, when a subsystem has accumulated too much entropy to keep patching, or when new requirements arrive for code already under management. Also use when asked about the spec manifest, invariants, binding tests, regrowing a subsystem, or Specs of Theseus.
---

# Specs of Theseus

The running system is replaceable material; the declared intent is the durable asset. Code and most tests are planks. The **manifest** and its **binding tests** are what make the system the same ship after every plank has been replaced.

Change happens by regeneration, not accretion. Deletion is frightening only while the code is the sole place intent is written down. Once intent lives outside the code, deletion becomes husbandry — entropy accumulates in implementations, never in intent.

Lineage: Chad Fowler's Regenerative Development / Phoenix Architecture.

## Vocabulary

| Term | Meaning |
| --- | --- |
| **Manifest** | `docs/subsystems.md`, with one file per subsystem in `docs/subsystems/`. Authoritative for what the system promises. |
| **Subsystem** | A named area with a boundary *you draw*. The unit that gets cut and regrown. Not permanent. |
| **Entry** | One promise, with a permanent ID. **The unit of obligation** — not the subsystem, not the file. |
| **Invariant** (`INV`) | A property a from-scratch rebuild could silently violate: exterior contract, performance characteristic, high-level architecture. |
| **Spec** (`SPEC`) | A behavioral promise, written in EARS. Most promises are specs. |
| **Non-promise** (`NON`) | Behavior that exists today and is explicitly not promised. |
| **Binding test** | Black-box, entering through the subsystem's public edge, tagged with the entry it proves. Survives the cut. |
| **Scaffolding test** | Anything reaching inside the boundary. Deleted with the code it describes, without mourning. |
| **The cut** | Deciding what to delete before regrowing. |

## The rule everything turns on

**The manifest changes before the code does.** Every time.

The manifest is the promise; code is only its current expression. Reversing the order is how the record starts lying — and a record that lies is worse than no record, because someone acts on it.

Concretely: whatever unit of work you use — ticket, story, issue — it carries a **manifest delta** (entries added, modified, retired) written and approved before a line of code moves. This method has no opinion about your planning process above that line.

## The everyday loop

1. **Write the delta.** Get it approved. A change needing no delta is legitimate — say so out loud rather than inventing one.
2. **Per entry:** failing test → implementation → green → refactor. Use your project's test-driven-development skill here; this method adds nothing to it.
3. **Tag:** `@proves {ID}` on the test, `@implements {ID}` on the code. Bare IDs, comma-separated — no paths, no links, and never a comment restating the entry.
4. **Close:** every delta entry tagged, full suite green.

**If an entry turns out to be wrong mid-build — incorrect, incomplete, impossible — stop and change the entry deliberately.** Never quietly write a different test to fit what you built. That substitution is the failure this whole method exists to prevent.

## Coverage is partial by design

Code outside a listed subsystem is **not drift** — it is simply not yet adopted. Never report it as a violation, and never mass-adopt a codebase to make the manifest look complete. A thousand inferred entries written before you know what a good one looks like is worse than none.

## Routing

| Where you are | What to do |
| --- | --- |
| A change covered by existing entries | The everyday loop above |
| Entries need adding, changing, or retiring | Write the delta, then the loop |
| Existing code with no entries; new behavior with no home; a subsystem that needs rebuilding | [regrowing-a-subsystem](../regrowing-a-subsystem/SKILL.md) |

Entry formats, IDs, and EARS: [manifest.md](references/manifest.md).
Telling intent from accident: [classifying.md](references/classifying.md).

Read a reference when you reach it. Do not reconstruct its content from this file.

## Red flags

Three failures are invisible at the moment they happen. Everything else announces itself.

- **Black sail** — code changed, manifest not. The system works, the record lies, someone acts on the record.
- **Enshrined entropy** — current behavior captured wholesale as binding tests, making the mess permanent in the one artifact meant to outlive it.
- **Silent retirement** — an entry deleted instead of retired visibly. A lost promise breaks no test, because the test went with it.