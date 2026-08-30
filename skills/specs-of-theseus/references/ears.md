# EARS — Easy Approach to Requirements Syntax

Specs are written in EARS so they are unambiguous, individually testable, and readable as a list.
Every spec describes **observable behavior at the subsystem boundary** — never internal mechanics.

## The five patterns

### Ubiquitous — always true
> The system shall `<response>`.

> The system shall record an audit entry for every invoice state change.

### Event-driven — triggered by something happening
> When `<trigger>`, the system shall `<response>`.

> When an invoice is settled, the system shall emit an invoice.settled event.

### State-driven — true while a condition holds
> While `<state>`, the system shall `<response>`.

> While an invoice is in draft, the system shall permit line item edits.

### Optional feature — conditional on configuration
> Where `<feature is present>`, the system shall `<response>`.

> Where receipt emailing is enabled, the system shall send a receipt on settlement.

### Unwanted behavior — error and edge handling
> If `<undesired trigger>`, then the system shall `<response>`.

> If create_invoice is called with no line items, then the system shall reject the request with an
> empty_invoice error.

### Complex — combined conditions
Nest sparingly. Two conditions is usually the limit before the spec should be split.

> While an invoice is settled, if a line item price changes, then the system shall leave the
> invoice total unchanged.

## Rules

- **One behavior per spec.** If the statement needs "and" between two responses, it is two specs.
- **Observable at the boundary.** A spec a caller could not detect is describing implementation.
- **"Shall" for promises.** Not "should", not "will".
- **Name the actor.** "The system" is fine when unambiguous; prefer the subsystem's name when several
  parties are in play.
- **No implementation nouns.** If the statement names a class, table, or private function inside the
  boundary, rewrite it in terms of what is observable.

## Good and bad

| Bad | Why | Better |
| --- | --- | --- |
| The system should handle invalid input gracefully | Untestable; "gracefully" means nothing | If create_invoice receives a negative quantity, then the system shall reject the request with an invalid_quantity error |
| InvoiceValidator shall run before persistence | Names an internal class — Procrustean | When an invoice is created with invalid line items, the system shall reject it and persist nothing |
| The system shall be fast | Not measurable; also this is an invariant, not a spec | Settlement completes in under 200ms at p99 for invoices up to 500 line items |
| When settled, emit an event and email a receipt | Two behaviors | Split into two specs |
