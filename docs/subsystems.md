# Subsystems

Evals are what lasts; subsystems are what gets regrown. A subsystem is a unit an agent could delete and regrow in one task: an interface with one or more units of implementation behind it.

- **Small enough** to rewrite from its interface and checked by the evals within one story.
- **Big enough** that its inside has room to be redesigned.

Subsystems usually follow the system's entry points, not its layers. Some examples:

- **A CLI:** one subsystem per command. Classes that several commands share become a subsystem of their own.
- **A Rails app:** one subsystem per RESTful controller — the controller and the views, helpers and models only it uses. A message queue and its background jobs are subsystems too.

Subsystems should start with the System's entry points - e.g., commands, controllers, or background job handlers. Their interfaces are pinned by evals: CLI syntax, routes, message formats. Their insides can be regrown freely; their surface changes only when an eval does.

Shared subsystems may develop over time. This would be code that multiple subsystems depend on. Their interfaces are internal, so a redesign can reshape them and their contract tests freely.

The list of subsystems is flat. Subsystems may depend on each other but never contain each other.

## Marking a Subsystem

Put a one-line comment at the subsystem's entry point, in whatever syntax the language uses:

```ruby
# @subsystem Orders
```

The subsystem is the entry point plus everything it uses that doesn't belong to another subsystem. Its public surface is the interface. To list the subsystems, search for `@subsystem`; to see one's boundary, follow what its entry point uses until you reach another marker. Nothing else needs maintaining.

## Boundaries move

Boundaries follow the intent and the evals, and a redesign redraws them in [Redesigning the System](3-redesigning-the-system.md):

- **Extract:** code used by more than one subsystem becomes its own shared subsystem.
- **Fold back:** a shared subsystem used by only one other merges back into it.

A redesign moves the markers in the same change as the code.
