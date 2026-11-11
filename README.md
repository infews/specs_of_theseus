# Specs of Theseus

A way for a team of people and agents to build software together. People decide what to build and whether it's done; agents decide how. The evals — the system's specs — are what lasts. The code can be replaced plank by plank, like the ship of Theseus, as long as every eval still passes.

It borrows from [Pivotal Labs' flavor of Extreme Programming](https://labspractices.com/guides/tanzu-labs-engineer-faq/) — a product manager who owns the backlog, small stories, test-driven development, acceptance on working software — and from [Chad Fowler's Phoenix Architecture](https://aicoding.leaflet.pub/): durable specifications, disposable code.

**Read the method in [docs/index.md](docs/index.md).** It covers the principles, the five stages, evals, subsystems, the working agreements, and adopting an existing project.

**Status: work in progress.** The method and its skills are being tried on real projects.

## Principles

1. **Evals are the spec; code can be thrown away.**
2. **If you care about it, make it an eval.**
3. **The edges are fixed; the inside can be redrawn.**
4. **Make the smallest change first, then look for something to regrow.**
5. **People decide what gets built and whether it's done; agents decide how.**
6. **Anyone can stop the line.**

Each is explained in [docs/index.md](docs/index.md#principles).

## Skills

The skills ship as a Claude Code plugin, `theseus`, versioned in `.claude-plugin/plugin.json`.

| Skill | Use when |
| --- | --- |
| `theseus:specs-of-theseus` | Entry point: the principles, where things live, and working out which stage the work is in |
| `theseus:adopt-project` | Bringing an existing project into the method: survey, tools, subsystem markers, and an adoption epic of Characterize stories |
| `theseus:product-planning` | Writing epics, breaking them into stories, ordering the backlog |
| `theseus:update-evals` | Taking the top story and changing the evals, with failing tests |
| `theseus:redesign-system` | Planning the smallest change, looking for something to regrow, writing tasks |
| `theseus:develop-story` | Running the Development loop, then completing and tagging the story |

Acceptance has no skill; it depends on each team's process.

The skills restate much of `docs/`: the docs explain the method to people, the skills tell agents what to do. Change both together.

### Shared references

Several skills need the same material: evals, subsystems, project layout, working agreements, and the eval-link checker. Each skill carries its own copy so it works on its own. The originals live in `skills/specs-of-theseus/references/` and `skills/specs-of-theseus/scripts/` — **edit those, never the copies** — then run:

```sh
bin/sync-skill-references
```

`bin/sync-skill-references --check` fails if any copy is out of date, for CI or a pre-commit hook.

## Trying the skills

Load the plugin from this checkout for one session, in the project you're testing on:

```sh
claude --plugin-dir /path/to/specs-of-theseus
```

## Iterating

1. Work in the target project with the plugin loaded
2. Note where a skill was ignored, misread, or gave bad guidance
3. Fix the skill here, run `bin/sync-skill-references` if you changed a shared reference, then start a new session to pick up the change
4. Commit from this repo

**When a run surfaces a gap, change the procedure step — do not add a row warning against the wrong behavior.** A Common Mistakes table is where a skill goes to accrete. If one exceeds five rows, the procedure above it is wrong.

## Diagrams

Edit only `docs/src/0_specs_of_theseus.mmd` and `docs/src/6_adopting.mmd`; the stage diagrams are generated. `bin/build-diagrams` splits the overview into one diagram per stage and renders every diagram to `docs/img/` with `pele-laka export`, using the stylesheet in `docs/src/pele-noto.css`.

The script looks for `pele-laka` in `PELE`, then on the `PATH`, then in a sibling checkout at `../pele-laka`. To install it once (needs Node 20+):

```sh
npm install -g github:infews/pele-laka
```

Google Chrome is optional; the build uses it only for PNG copies, which aren't committed.

## Ruby

The scripts in `bin/` need Ruby 4, pinned in `.ruby-version`. chruby picks it up in an interactive shell. Anywhere chruby doesn't load — CI, editor tasks, agents' shells — the system Ruby runs instead and the scripts fail, so run them through chruby:

```sh
chruby-exec ruby-4.0 -- bin/build-diagrams
```

## History

This version is a clean-sheet rewrite, started in November 2026. Earlier versions were built around a spec manifest with binding tests, and later added epic, capability and system layers. That work, and the design documents behind it, are in the git history before commit `32d871f`.
