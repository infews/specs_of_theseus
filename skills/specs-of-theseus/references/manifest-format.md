# Manifest Format

## Layout

```
docs/
  subsystems.md         # the manifest — coverage index
  subsystems/
    billing.md          # one file per subsystem
    checkout.md
```

The manifest sits *beside* the directory it indexes, not inside it. Inside, it sorts alphabetically
among the subsystem files and gets lost; beside, it is adjacent to the folder and cannot be missed.

Keep the subsystem directory flat. Group into subdirectories only when the number of files makes it
hard to read.

## IDs

`{SUBSYSTEM}-{TYPE}-{NNN}` — e.g. `BILLING-INV-003`, `CHECKOUT-SPEC-012`.

Types: `INV` (invariant), `SPEC` (behavioral promise), `NON` (non-promise).

**IDs are permanent and never reused.** A retired entry keeps its ID forever; retirement is a
status, not a renumbering. Reusing an ID makes every tag in git history a lie.

## subsystems.md — the manifest

```markdown
# Spec Manifest

Subsystems under Specs of Theseus management. **Subsystems not listed here are not under management.
Their absence is not drift.**

| Subsystem | File | Status | Adopted | Last regrown |
| --- | --- | --- | --- | --- |
| Billing | [subsystems/billing.md](subsystems/billing.md) | under management | 2026-08-28 | 2026-09-02 |
| Checkout | [subsystems/checkout.md](subsystems/checkout.md) | adopted — not yet regrown | 2026-09-10 | — |
```

Statuses: `adopted — not yet regrown`, `under management`, `regrowth in progress`.

A subsystem at `regrowth in progress` carries a `## Regrowth in progress` section in its file
listing every entry being rebuilt. Entry states: `not started`, `in progress`, `green`. The section
is written when the regrowth is planned and deleted when it completes — it is the one part of a
subsystem file that is not durable, and the only part describing work rather than intent.

## Subsystem file

```markdown
# Subsystem: Billing

Part of the [spec manifest](../subsystems.md).

## Boundary

**Inside:** [app/billing/](../../app/billing/), [lib/invoicing.rb](../../lib/invoicing.rb)
**Outside:** everything else, notably [app/checkout/](../../app/checkout/) which calls in

**Callers in:** CheckoutController (creates invoices), NightlyJob (settles)
**Calls out to:** Stripe API, invoices table, receipts S3 bucket
**Crossing the boundary:** Billing.create_invoice/2, Billing.settle/1,
  invoice.settled event, invoices table schema, receipt PDF format

## Invariants

### BILLING-INV-001 — Invoice totals are never recomputed after settlement
- **Category:** contract
- **Statement:** Once an invoice is settled, its total is immutable; later changes to line item
  prices do not alter it.
- **Binding test:** [billing_test.rb](../../test/binding/billing_test.rb) —
  "settled invoice total is immutable when line item prices change"
- **Evidence:** Finance reconciliation depends on this; discovered via NightlyJob caller analysis.
- **Status:** active

### BILLING-INV-002 — Settlement completes within 200ms at p99
- **Category:** performance
- **Statement:** Billing.settle/1 completes in under 200ms at p99 for invoices with up to 500
  line items.
- **Binding test:** [billing_perf_test.rb](../../test/binding/billing_perf_test.rb) —
  "settle completes within 200ms at p99"
- **Evidence:** Checkout blocks on this call; measured 140ms p99 in production.
- **Status:** active

## Specs

### BILLING-SPEC-001 — Invoice creation rejects empty line items
- **Statement:** When create_invoice is called with no line items, the system shall reject the
  request and return an empty_invoice error.
- **Tests:** [billing_test.rb](../../test/binding/billing_test.rb) —
  "create_invoice rejects an empty line item list"
- **Status:** active

## Non-promises

### BILLING-NON-001 — Invoice IDs are currently sequential
- **Observed:** IDs increment by one, and at least one report sorts by ID assuming chronology.
- **Why not promised:** Incidental to the current primary key. A regrowth may use UUIDs. Callers
  needing ordering must sort by created_at.

## Regrowth in progress

Started 2026-09-01 on branch `regrow-billing`. Delete this section at reconcile.

| Entry | State |
| --- | --- |
| BILLING-INV-001 | green |
| BILLING-INV-002 | green |
| BILLING-SPEC-001 | in progress |
| BILLING-SPEC-002 | not started |

## Retired

### BILLING-SPEC-004 — Invoices could be issued in legacy currency codes
- **Retired:** 2026-09-02
- **Replaced by:** BILLING-SPEC-019 (ISO 4217 only)
- **Why:** Legacy codes were removed from the upstream catalogue; no caller has used one since
  2025. Re-adding this would require reinstating the conversion table deleted in the same change.
```

## Rules

- **Invariants and specs are different classes.** Most specs are not invariants. Do not promote a
  spec to an invariant to give it emphasis.
- **A performance invariant states a measurable threshold**, a workload it holds under, and how it
  was measured. Otherwise it is an aspiration.
- **Evidence is required on invariants.** "Why do we believe this is a promise and not an accident?"
  is the question adoption exists to answer; record the answer.
- **Retirement is visible.** Never delete an entry outright. Record what replaced it and why, so a
  later proposal to re-add it meets the reasoning that removed it.
- **No implementation detail.** If an entry names a class, function, or pattern inside the boundary,
  it is Procrustean — rewrite it as an observable property or delete it.
- **Every file path is a link.** Code, tests, directories — anything the manifest names, a reader
  should be able to open from where they are standing. Use paths relative to the file doing the
  linking (`../../` from `docs/subsystems/`), which resolve in GitHub and in an IDE alike.
- **Reference tests by name, not line number.** Line numbers are wrong within a week and wrong
  silently. Link the test file and quote the test's name; the name survives edits and is greppable
  after a regrowth moves everything.
- **Link both directions.** The manifest links to each subsystem file; each subsystem file links back
  to the manifest. Anyone who arrives at a subsystem file by grep — which is most arrivals — must be
  able to find the index from where they landed. An entry in one direction only is half-wired.
