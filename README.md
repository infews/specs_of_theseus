# Specs of Theseus

A development process where the running system is replaceable material and the declared intent is
the durable asset.

Code and most tests are planks. The **spec manifest** and its **binding tests** are what make the
system the same ship after every plank has been replaced. Change happens by regeneration rather
than accretion: new requirements trigger a deliberate decision about how much to delete so the
system can be rethought *including* them.

Lineage: Chad Fowler's Regenerative Development / Phoenix Architecture. The contribution here is
the durable artifact that makes routine deletion survivable.

**Status: experimental.** Untested against real work.

## Skills

| Skill | Use when |
| --- | --- |
| `specs-of-theseus` | The model and the router — entry point for any work in a managed codebase |
| `adopting-a-region` | An existing subsystem needs its intent declared before it can be regrown |
| `regrowing-a-region` | Deleting and rebuilding a region already under management |

Deferred until the process has survived real use: steady-state change (epic → invariant impact →
manifest update → cut → regrow), reconcile (manifest ↔ `@spec` tags), a CLI, and plugin packaging.

## Installing for experimentation

```sh
./install.sh
```

Symlinks each skill into `~/.claude/skills/`, so the skills are live in every project while the
files you edit stay here. Run `./install.sh --uninstall` to remove them.

## Iterating

1. Work in the target project with the skills installed
2. Note where a skill was ignored, misread, or gave bad guidance
3. Fix the skill here — the symlink means edits are immediate
4. Commit from this repo

Body edits take effect on the next invocation. Changes to a skill's `name` or `description` need a
session restart, since those load at startup.

## Documents

- [Design](docs/design/2026-08-28-specs-of-theseus-design.md)
- Manifest format, invariants, EARS, and test conventions live in
  [skills/specs-of-theseus/references/](skills/specs-of-theseus/references/)
