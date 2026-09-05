# Binding and Scaffolding Tests

Two kinds of test, and the difference decides what survives a cut.

| | Binding | Scaffolding |
| --- | --- | --- |
| **Proves** | An invariant or a spec — anything with a manifest entry | An implementation detail works |
| **Scope** | Full-system, black-box, through the subsystem's public edge | Units, classes, functions inside the boundary |
| **Survives the cut** | Yes — it is the referee for the regrowth | No — deleted with the code it describes |
| **May reach inside the boundary** | Never | Freely |
| **Written when** | At adoption, proven green against existing code | During regrowth, as you build |

## Marking

A regenerating agent must be able to tell at a glance what it may delete. Two signals, both required:

**Location.** Binding tests live in a dedicated directory — `test/binding/`, `spec/binding/`, or whatever matches the project's convention. Segregation by directory means the cut can delete by path without reading every file.

**Tags.** Every binding test carries the IDs it proves:

```ruby
# @proves BILLING-INV-001
test "settled invoice total is immutable when line item prices change" do
  ...
end
```

Implementation carries tags too, so the manifest-to-reality thread runs both ways:

```ruby
# @implements BILLING-SPEC-001, BILLING-SPEC-002
def create_invoice(line_items)
```

Two verbs, one ID space. Tests **prove**; code **implements**. The ID says which kind of entry it is, so the tag never has to — which is why neither verb is `@spec`: that would collide with `SPEC` as an entry type and read as a category claim rather than a reference.

**The tag does not restate the tier.** There is no `@binding` marker: referencing a manifest entry is what makes a test binding, so a separate tag would only be a second place to forget. Location carries the tier; the tag carries the reference. Keeping the tag tier-neutral also means anything else that establishes an entry — a production monitor, say — can carry `@proves` unchanged.

## The tag is a pointer, not a summary

Tag with the ID. Do not restate the entry in a comment beside it:

```ruby
# Public so the accuracy harness measures the window the tool ships.   <- delete this
# @implements TEXT-INV-002
```

against `TEXT-INV-002 — The accuracy harness measures the window the tool ships`. The same sentence in two places, only one of which anyone will maintain — and the unmaintained copy is the one a reader is standing next to.

**Explaining the mechanism is different, and welcome.** This earns its place, because why *this code* satisfies the entry is not in the manifest and could not be:

```ruby
# @implements TEXT-SPEC-003 — omitting the flags is pdftotext's "whole document"
```

**Bare IDs, comma-separated. No paths, no markdown links.** A path in a comment rots silently on any file move, breaks the grep people actually type, and does not render on GitHub, which shows source as plain text. Markdown links belong in markdown files; the manifest's prefix column is what turns a bare ID into a complete address.

## Writing binding tests

**Black box, always.** Enter through the same door callers use. A test that reaches inside the boundary is scaffolding wearing a badge — it will break during regrowth for reasons that have nothing to do with intent, and it will be deleted or weakened under pressure at exactly the moment it was supposed to be authoritative.

**Prove them against the existing implementation before deleting anything.** A binding test that has never been green against the current system is a guess. If one fails at adoption, that is a finding: either the invariant was stated wrong or you have found a real bug. Take it back to the user and reclassify.

**Performance invariants need real measurement.** A binding test for a performance invariant runs a representative workload and asserts the stated threshold. Assert at the percentile the invariant names, on data shaped like production. A performance test that runs three records and passes instantly is proving nothing.

**Architectural invariants are often checkable.** Dependency direction, module separability, and transactional boundaries can frequently be asserted mechanically — import graphs, isolated boots, fault injection. Where a check is genuinely not automatable, say so in the invariant entry and verify it by inspection during regrowth, explicitly and in writing.

## Writing scaffolding tests

Write them freely. They are cheap, they make progress visible, and TDD needs them. Test whatever internal structure helps you build.

Expect to delete them at the next regrowth, and do not mourn. **"Deleting these loses coverage" is the wrong frame** — the coverage that matters is the binding suite, which survives. Scaffolding tests describe a decomposition that no longer exists.
