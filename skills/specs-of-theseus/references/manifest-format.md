# Manifest Format

## Layout

```
docs/theseus/
  manifest.md      # coverage index
  <region>.md      # one file per region
```

Flat. Add a `regions/` subdirectory only when the number of regions makes the directory hard to read.

## IDs

`{REGION}-{TYPE}-{NNN}` — e.g. `BILLING-INV-003`, `CHECKOUT-SPEC-012`.

Types: `INV` (invariant), `SPEC` (behavioral promise), `NON` (non-promise).

**IDs are permanent and never reused.** A retired entry keeps its ID forever; retirement is a
status, not a renumbering. Reusing an ID makes every `@spec` tag in git history a lie.

## manifest.md

```markdown
# Spec Manifest

Regions under Specs of Theseus management. **Regions not listed here are not under management.
Their absence is not drift.**

| Region | File | Status | Adopted | Last regrown |
| --- | --- | --- | --- | --- |
| Billing | billing.md | under management | 2026-08-28 | 2026-09-02 |
| Checkout | checkout.md | adopted — not yet regrown | 2026-09-10 | — |
```

Statuses: `adopted — not yet regrown`, `under management`, `regrowth in progress`.

## Region file

```markdown
# Region: Billing

## Boundary

**Inside:** app/billing/**, lib/invoicing.rb
**Outside:** everything else, notably app/checkout/** which calls in

**Callers in:** CheckoutController (creates invoices), NightlyJob (settles)
**Calls out to:** Stripe API, invoices table, receipts S3 bucket
**Crossing the boundary:** Billing.create_invoice/2, Billing.settle/1,
  invoice.settled event, invoices table schema, receipt PDF format

## Invariants

### BILLING-INV-001 — Invoice totals are never recomputed after settlement
- **Category:** contract
- **Statement:** Once an invoice is settled, its total is immutable; later changes to line item
  prices do not alter it.
- **Binding test:** test/binding/billing_test.rb:42
- **Evidence:** Finance reconciliation depends on this; discovered via NightlyJob caller analysis.
- **Status:** active

### BILLING-INV-002 — Settlement completes within 200ms at p99
- **Category:** performance
- **Statement:** Billing.settle/1 completes in under 200ms at p99 for invoices with up to 500
  line items.
- **Binding test:** test/binding/billing_perf_test.rb:12
- **Evidence:** Checkout blocks on this call; measured 140ms p99 in production.
- **Status:** active

## Specs

### BILLING-SPEC-001 — Invoice creation rejects empty line items
- **Statement:** When create_invoice is called with no line items, the system shall reject the
  request and return an empty_invoice error.
- **Tests:** test/binding/billing_test.rb:88
- **Status:** active

## Non-promises

### BILLING-NON-001 — Invoice IDs are currently sequential
- **Observed:** IDs increment by one, and at least one report sorts by ID assuming chronology.
- **Why not promised:** Incidental to the current primary key. A regrowth may use UUIDs. Callers
  needing ordering must sort by created_at.

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
