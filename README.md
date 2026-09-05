# Specs of Theseus

A development process where the running system is replaceable material and the declared intent is the durable asset.

Code and most tests are planks. The **spec manifest** and its **binding tests** are what make the system the same ship after every plank has been replaced. Change happens by regeneration rather than accretion: new requirements trigger a deliberate decision about how much to delete so the system can be rethought *including* them.

Lineage: Chad Fowler's Regenerative Development / Phoenix Architecture. The contribution here is the durable artifact that makes routine deletion survivable.

**Status: experimental.** In use on one real codebase; one subsystem has been through a full adopt-and-regrow cycle. The epic and story layer is new and unexercised.

## Skills

| Skill | Use when |
| --- | --- |
| `specs-of-theseus` | The model and the router — entry point for any work in a managed codebase |
| `refining-an-epic` | A need larger than one story has no epic behind it |
| `slicing-an-epic` | A refined epic needs vertical stories |
| `delivering-a-story` | Working the top story off the backlog — inventory, manifest delta, tasks, TDD |
| `adopting-a-subsystem` | Existing code needs its intent declared before it can be regrown |
| `growing-a-subsystem` | Greenfield behavior with no subsystem yet |
| `regrowing-a-subsystem` | Deleting and rebuilding a subsystem already under management |

Work normally enters at an epic; the subsystem skills are reached through a story. Regrowth has no separate entry point in the flow — when a story's manifest delta is too large to patch, the cut becomes the story's first task.

Still deferred: reconcile (manifest ↔ tags, plus link integrity), live evaluations as a third test tier, doc→code tooling, a CLI, and plugin packaging.

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

## Documents

- [Design](docs/design/2026-08-28-specs-of-theseus-design.md)
- [Adding the intent layer — epics, stories, and tasks](docs/design/2026-09-05-epic-story-integration.md)
- The flow: [intent to tasks](docs/specs-of-theseus-intent.mmd), [building one task](docs/specs-of-theseus-inner-loop.mmd)
- Manifest format, invariants, EARS, and test conventions live in [skills/specs-of-theseus/references/](skills/specs-of-theseus/references/)
