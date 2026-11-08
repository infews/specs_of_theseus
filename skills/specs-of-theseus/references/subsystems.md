# Subsystems

Evals are what lasts; subsystems are what gets regrown. A subsystem is a unit an agent could delete and regrow in one task: an interface with one or more units of implementation behind it.

- **Small enough** to rewrite from its interface, checked by the evals, within one story.
- **Big enough** that its inside has room to be redesigned. A one-line helper isn't a subsystem.

## Where subsystems come from

They follow the system's entry points, not its layers:

- **A CLI:** one subsystem per command.
- **A Rails app:** one subsystem per RESTful controller — the controller and the views, helpers and models only it uses. A message queue and its background jobs are subsystems too.

Two kinds:

- **Entry-point subsystems** — commands, controllers, job handlers. Their surface is pinned by evals (CLI syntax, routes, message formats). The inside can be regrown freely; the surface changes only when an eval does.
- **Shared subsystems** — code several subsystems depend on. Their interfaces are internal, so a redesign can reshape them, and their contract tests, freely. The biggest redesigns tend to happen here.

The list is flat. Subsystems depend on each other but never contain each other.

## Marking

A one-line comment at the subsystem's entry point, in the language's comment syntax:

```ruby
# @subsystem Orders
```

The subsystem is the entry point plus everything it uses that doesn't belong to another subsystem. Its public surface is its interface.

- **List them:** search the code for `@subsystem`.
- **See one's boundary:** follow what its entry point uses until you reach another marker.

Nothing else needs maintaining — no manifest, no file list.

## Boundaries move

Redesign redraws boundaries when the intent and evals suggest it:

- **Extract:** code used by more than one subsystem becomes its own shared subsystem, with its own marker.
- **Fold back:** a shared subsystem used by only one other merges back into it, and its marker goes away.

Move markers in the same change as the code. Contract tests between subsystems go with the code they test.
