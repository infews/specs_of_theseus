# Manifest Format

```
docs/
  subsystems.md         # the coverage index
  subsystems/
    billing.md          # one file per subsystem
```

The index sits *beside* the directory it indexes. Inside, it sorts alphabetically among the subsystem files and gets lost.

## IDs

`{PREFIX}-{TYPE}-{NNN}` — `BILLING-INV-003`, `CHECKOUT-SPEC-012`. Types: `INV`, `SPEC`, `NON`.

**IDs are permanent and never reused.** A retired entry keeps its ID forever; retirement is a status, not a renumbering. An ID is an *address*, not an assertion — the prefix records where an entry was issued, so an entry rehomed by a boundary change keeps its original ID. Renumbering would make every tag in git history a lie.

Entries cannot change type, because the type is in the ID. To reclassify, retire the old entry visibly and issue a new one, noting that behavior is unchanged so no code moves.

## subsystems.md

```markdown
# Spec Manifest

Subsystems under management. **Subsystems not listed here are not under management.
Their absence is not drift.**

| Subsystem | Prefix | File | Status | Adopted | Last regrown |
| --- | --- | --- | --- | --- | --- |
| Billing | `BILLING-` | [subsystems/billing.md](subsystems/billing.md) | under management | 2026-08-28 | 2026-09-02 |
| Checkout | `CHECKOUT-` | [subsystems/checkout.md](subsystems/checkout.md) | adopted — not yet regrown | 2026-09-10 | — |
```

Statuses: `adopted — not yet regrown`, `under management`, `regrowth in progress`. The prefix column is what makes a bare ID in a code comment a complete address.

Keep an **Identified but not adopted** table the moment there is one entry for it — otherwise an area nobody adopted looks identical to an area nobody noticed.

## Subsystem file

```markdown
# Subsystem: Billing

Part of the [spec manifest](../subsystems.md).

## Boundary

**Inside:** [app/billing/](../../app/billing/)
**Outside:** everything else, notably [app/checkout/](../../app/checkout/) which calls in

**Callers in:** CheckoutController (creates), NightlyJob (settles)
**Calls out to:** Stripe API, invoices table, receipts S3 bucket
**Crossing the boundary:** Billing.create_invoice/2, invoice.settled event, receipt PDF format

## Invariants

<a id="billing-inv-001"></a>
### BILLING-INV-001 — Invoice totals are never recomputed after settlement
- **Category:** contract
- **Statement:** Once an invoice is settled, its total is immutable; later line item price
  changes do not alter it.
- **Binding test:** [billing_test.rb](../../test/binding/billing_test.rb) —
  "settled invoice total is immutable when line item prices change"
- **Evidence:** Finance reconciliation depends on it; found via NightlyJob caller analysis.
- **Status:** active

## Specs

<a id="billing-spec-001"></a>
### BILLING-SPEC-001 — Invoice creation rejects empty line items
- **Statement:** When create_invoice is called with no line items, the system shall reject
  the request and return an empty_invoice error.
- **Tests:** [billing_test.rb](../../test/binding/billing_test.rb) — "rejects an empty list"
- **Status:** active

## Non-promises

<a id="billing-non-001"></a>
### BILLING-NON-001 — Invoice IDs are currently sequential
- **Observed:** IDs increment by one; at least one report sorts by ID assuming chronology.
- **Why not promised:** Incidental to the primary key. A regrowth may use UUIDs.

## Retired

<a id="billing-spec-004"></a>
### BILLING-SPEC-004 — Invoices could be issued in legacy currency codes
- **Retired:** 2026-09-02 · **Replaced by:** BILLING-SPEC-019 (ISO 4217 only)
- **Why:** Removed from the upstream catalogue; no caller has used one since 2025.
```

## EARS — how a spec statement is written

One behavior per statement, observable at the boundary, "shall" for promises.

| Pattern | Form |
| --- | --- |
| Ubiquitous | The system shall `<response>`. |
| Event-driven | When `<trigger>`, the system shall `<response>`. |
| State-driven | While `<state>`, the system shall `<response>`. |
| Optional feature | Where `<feature is present>`, the system shall `<response>`. |
| Unwanted behavior | If `<undesired trigger>`, then the system shall `<response>`. |

If the statement needs "and" between two responses, it is two specs. Two nested conditions is the limit before splitting.

## Rules

- **No implementation detail.** An entry naming a class, table, pattern, or private function inside the boundary is **Procrustean** — it cuts the implementation to fit the bed and robs regeneration of the freedom that makes it worth doing. Rewrite it as an observable property, or delete it.
- **Retirement is visible.** Never delete an entry outright. Record what replaced it and why, so a later proposal to re-add it meets the reasoning that removed it.
- **Evidence is required on invariants.** *Why do we believe this is a promise and not an accident?* — record the answer.
- **A performance invariant states a threshold, a workload, and how it was measured.** Otherwise it is an aspiration.
- **Every entry carries an explicit anchor.** `<a id="billing-inv-001"></a>` above the heading — GitHub derives anchors from the whole heading, so `#billing-inv-001` will not otherwise resolve.
- **Reference tests by name, never line number.** Line numbers are wrong within a week and wrong silently.
- **Every path in a markdown file is a link; every ID in a code comment is bare.** A path in a comment rots on any file move, breaks the grep people actually type, and does not render on GitHub.
- **Link both directions.** Most arrivals at a subsystem file are by grep; the index must be reachable from where you landed.
- **A subsystem file describes intent, never work state.** No progress tables, no checklists.