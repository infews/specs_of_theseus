# Specs of Theseus

A development process where the running system is replaceable material and the declared intent is the durable asset.

Code and most tests are planks. The **spec manifest** and its **binding tests** are what make the system the same ship after every plank has been replaced. Change happens by regeneration rather than accretion: new requirements trigger a deliberate decision about how much to delete so the system can be rethought *including* them.

Lineage: Chad Fowler's Regenerative Development / Phoenix Architecture. The contribution here is the durable artifact that makes routine deletion survivable.

## The principles

1. **Intent lives outside the code.** That is the only reason deletion is safe.
2. **The entry is the unit of obligation** — permanent ID, never reused, retired visibly. Not the subsystem, not the file.
3. **An invariant is what a from-scratch rebuild could silently violate.** Exterior contract, performance characteristic, high-level architecture. Everything else is free.
4. **Binding tests prove invariants and survive the cut.** Everything else is scaffolding and dies with its code.
5. **The manifest changes before the code does.** Reversing the order is how the record starts lying.
6. **Telling intent from accident is human judgment, and defaults to accident.** An unrecorded promise is recoverable; an enshrined one is forever.
7. **Coverage is partial by design.** Unadopted code is not drift.

## Skills

| Skill | Use when |
| --- | --- |
| `specs-of-theseus` | The model, the vocabulary, and the everyday loop — entry point for any work in a managed codebase |
| `regrowing-a-subsystem` | Adopting existing code, growing a new subsystem, or deleting and rebuilding one from its manifest |

Two references sit under `specs-of-theseus/references/`: [manifest.md](skills/specs-of-theseus/references/manifest.md) for entry formats, IDs, and EARS, and [classifying.md](skills/specs-of-theseus/references/classifying.md) for the intent-versus-accident gate.

This method has no opinion about your planning process. Whatever unit of work you use — ticket, story, issue — the only rule it adds is that the unit carries a **manifest delta**, approved before a line of code moves.

**Status: experimental.** In use on one real codebase; one subsystem has been through a full adopt-and-regrow cycle.

## Installing for experimentation

```sh
./install.sh
```

Symlinks each skill into `~/.claude/skills/`, so the skills are live in every project while the files you edit stay here. Run `./install.sh --uninstall` to remove them.

## Iterating

1. Work in the target project with the skills installed
2. Note where a skill was ignored, misread, or gave bad guidance
3. Fix the skill here — the symlink means edits are immediate
4. Commit from this repo

Body edits take effect on the next invocation. Changes to a skill's `name` or `description` need a session restart, since those load at startup.

**When a run surfaces a gap, change the procedure step — do not add a row warning against the wrong behavior.** A Common Mistakes table is where a skill goes to accrete. If one exceeds five rows, the procedure above it is wrong. The first version of these skills reached 19,000 words that way; this one is under 2,500.

## History

Earlier versions carried an epic/story/task layer, a capability layer, and a system layer with a boundary-redraw procedure. All three were cut in September 2026 — the first two as generic or derivable, the third as machinery that had never been run. The design documents that produced them are kept as a record of the reasoning, not as current guidance.

- [Design](docs/design/2026-08-28-specs-of-theseus-design.md)
- [Adding the intent layer — epics, stories, and tasks](docs/design/2026-09-05-epic-story-integration.md)
- [Adding the capability layer — what the software does today](docs/design/2026-09-09-capability-layer.md)
- [The system layer — making the decomposition disposable](docs/design/2026-09-12-system-layer.md)