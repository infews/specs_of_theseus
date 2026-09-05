---
name: growing-a-subsystem
description: Use when a story needs behavior that has no subsystem yet — greenfield work with no existing code to recover intent from. Use when asked to create a new subsystem, declare specs for something not yet built, or bring new behavior under Specs of Theseus management from the start.
---

# Growing a Subsystem

## Overview

Declaring intent for code that does not exist yet. The greenfield sibling of [adopting-a-subsystem](../adopting-a-subsystem/SKILL.md), and the inverse of it: adoption *recovers* intent from an implementation, growth *declares* it before there is one.

**REQUIRED BACKGROUND:** Read the [specs-of-theseus](../specs-of-theseus/SKILL.md) skill first for the model and vocabulary.

That inversion removes adoption's central difficulty — there are no accidents to tell from intent, because nothing has happened yet. It replaces it with a different one: **everything you write is a guess, and guesses written as invariants are load-bearing forever.**

## What is different from adoption, and why it matters

Adoption's strongest evidence is "read every call site." Here there are no call sites. Its acceptance test is "every binding test green against the existing implementation." Here there is no implementation. Both of its safeguards are gone.

So a grown subsystem is **weaker evidence than an adopted one**, and the manifest should not pretend otherwise. Its invariants have never been checked against an independent implementation. They become trustworthy at the first regrowth, which is the same rule as everywhere else: a subsystem reaches `under management` by being regrown, never by being written down well.

## Checklist

Create a TodoWrite item for each step. Each ends with a stop.

### 1. Draw the boundary, and say it is provisional

Name the subsystem. State what it will own, what will cross its edge — signatures, routes, event shapes, schemas, formats — and what is deliberately outside.

**Record in the file that the boundary is provisional.** Adoption draws a boundary around code that exists and can be checked; this one is drawn around code nobody has written, and it will be wrong somewhere. Expect the first regrowth to move it. A boundary presented as settled will be defended instead of corrected.

**STOP. Present the boundary and get approval before continuing.**

### 2. Declare invariants, sparingly

Same three categories as adoption — exterior contract, performance characteristic, high-level architecture — and the same test: *would a from-scratch rebuild silently violate this?*

**The honest default here is fewer.** Adoption's invariants are discovered under pressure from real callers; these are chosen in a room. A new subsystem with nine invariants has legislated a design nobody has built, which is Procrustean at birth — and the entries most likely to be wrong are the ones that will be hardest to retire, because a binding test will be defending them.

Two guards:

- **A performance invariant with no measurement is an aspiration.** You cannot measure something that does not run. Either it comes from a real constraint elsewhere — a caller's timeout, an SLA — or it waits until there is something to measure.
- **If you cannot say what would break if it were violated, it is not an invariant.** Write it as a spec.

**STOP. Present the invariants and get approval before continuing.**

### 3. Write specs from the story's acceptance criteria

The story's Gherkin is the source. Decompose each scenario into EARS specs per [ears.md](../specs-of-theseus/references/ears.md) — one scenario usually yields several.

Specs are cheap and reversible in a way invariants are not. When a candidate could be either, make it a spec. Promotion later is a paperwork cost; a wrongly enshrined invariant is a permanent one.

### 4. Write the subsystem file

Create `docs/subsystems/<subsystem>.md` per [manifest-format.md](../specs-of-theseus/references/manifest-format.md), and add a row to `docs/subsystems.md` with status `adopted — not yet regrown`. Link both directions, and add the ID prefix to the manifest's prefix column.

Record the origin — the story that caused the subsystem to exist — on the entries. It is the only durable pointer back to the reasoning.

**STOP. Present the subsystem file and get approval before continuing.**

### 5. Hand back to the story

Growth declares intent. It does not build anything.

Return to [delivering-a-story](../delivering-a-story/SKILL.md), which now has entries to write tasks against. Binding tests get written there, alongside the implementation, under TDD.

**This is the one place growth cannot match adoption.** Adoption proves its binding tests against code that already works, so a failure is a finding. Here the binding tests and the code are born together, and a binding test that has only ever been green against the implementation it was written beside has not been independently checked. Say so in the report. The check happens at the first regrowth.

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Declaring invariants at adoption density | Adoption's came from real callers. Yours came from a conversation. Write fewer. |
| A performance invariant with no measurement | Nothing runs yet. Source it from a real external constraint, or wait. |
| Presenting the boundary as settled | It is a guess about code nobody has written. Say so, or it gets defended instead of fixed. |
| Marking the subsystem `under management` | Only a regrowth earns that. It is `adopted — not yet regrown` until then. |
| Writing implementation while here | Growth declares intent. The story builds. |
| Specs invented beyond the story | Unpromised behavior, arriving before anyone asked. The story's acceptance criteria are the scope. |
