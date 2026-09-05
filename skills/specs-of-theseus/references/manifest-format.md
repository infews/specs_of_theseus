# Manifest Format

## Layout

```
docs/
  subsystems.md         # the manifest — coverage index
  subsystems/
    billing.md          # one file per subsystem
    checkout.md
```

The manifest sits *beside* the directory it indexes, not inside it. Inside, it sorts alphabetically among the subsystem files and gets lost; beside, it is adjacent to the folder and cannot be missed.

Keep the subsystem directory flat. Group into subdirectories only when the number of files makes it hard to read.

## IDs

`{SUBSYSTEM}-{TYPE}-{NNN}` — e.g. `BILLING-INV-003`, `CHECKOUT-SPEC-012`.

Types: `INV` (invariant), `SPEC` (behavioral promise), `NON` (non-promise).

**IDs are permanent and never reused.** A retired entry keeps its ID forever; retirement is a status, not a renumbering. Reusing an ID makes every tag in git history a lie.

**An ID is an address, not an assertion.** Both the subsystem and the type segment record the classification *at the time the entry was issued*. The manifest is authoritative for what an entry is now. When they diverge — an entry reclassified, a boundary split — reclassify deliberately rather than pretending the ID is live.

The `{SUBSYSTEM}` segment is a short prefix, mapped to its file by the prefix column in `docs/subsystems.md`. That column is what makes a bare ID a complete address, which is why code annotations need no path.

### Reclassification

Entries cannot change type, because the type is in the ID. Two cases, priced differently:

- **`NON` → `SPEC` or `INV`.** The promise genuinely changed: something not promised now is. Retire the `NON` visibly and issue a new entry. This is the record working, not churn.
- **`SPEC` → `INV`.** The promise did not change — only what you learned about whether it constrains a rewrite. Issue the new `INV` ID and retire the `SPEC` with the reason *reclassified, not withdrawn — see `BILLING-INV-009`*, noting that behavior is unchanged so no code moves. Tags migrate at the next regrowth.

Do not reclassify to give an entry emphasis. `SPEC` → `INV` needs an answer to *would a from-scratch rebuild silently violate this?* that changed, not a feeling that the entry is important.

## subsystems.md — the manifest

```markdown
# Spec Manifest

Subsystems under Specs of Theseus management. **Subsystems not listed here are not under management.
Their absence is not drift.**

| Subsystem | Prefix | File | Status | Adopted | Last regrown |
| --- | --- | --- | --- | --- | --- |
| Billing | `BILLING-` | [subsystems/billing.md](subsystems/billing.md) | under management | 2026-08-28 | 2026-09-02 |
| Checkout | `CHECKOUT-` | [subsystems/checkout.md](subsystems/checkout.md) | adopted — not yet regrown | 2026-09-10 | — |
```

Statuses: `adopted — not yet regrown`, `under management`, `regrowth in progress`.

### Identified but not adopted

Areas you have looked at and deliberately not brought under management. Optional, and worth keeping the moment there is one.

```markdown
| Subsystem | Files | Why not yet adopted |
| --- | --- | --- |
| Import pipeline | [lib/import/](../lib/import/) | Touched by epic 0002 but outside its story's boundary. Adopt when something regrows it. |
```

This is not a backlog and not a debt register. It exists so that an area nobody adopted looks different from an area nobody noticed — without it, the honest reading of an absence is that no one has looked.

Work state never lives in a subsystem file. `regrowth in progress` says a subsystem is mid-flight; the story driving it says how far. A subsystem file describes intent only.

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

<a id="billing-inv-001"></a>
### BILLING-INV-001 — Invoice totals are never recomputed after settlement
- **Category:** contract
- **Statement:** Once an invoice is settled, its total is immutable; later changes to line item
  prices do not alter it.
- **Binding test:** [billing_test.rb](../../test/binding/billing_test.rb) —
  "settled invoice total is immutable when line item prices change"
- **Evidence:** Finance reconciliation depends on this; discovered via NightlyJob caller analysis.
- **Origin:** [0004 — Settlement hardening](../epics/0004-settlement-hardening.md)
- **Status:** active

<a id="billing-inv-002"></a>
### BILLING-INV-002 — Settlement completes within 200ms at p99
- **Category:** performance
- **Statement:** Billing.settle/1 completes in under 200ms at p99 for invoices with up to 500
  line items.
- **Binding test:** [billing_perf_test.rb](../../test/binding/billing_perf_test.rb) —
  "settle completes within 200ms at p99"
- **Evidence:** Checkout blocks on this call; measured 140ms p99 in production.
- **Status:** active

## Specs

<a id="billing-spec-001"></a>
### BILLING-SPEC-001 — Invoice creation rejects empty line items
- **Statement:** When create_invoice is called with no line items, the system shall reject the
  request and return an empty_invoice error.
- **Tests:** [billing_test.rb](../../test/binding/billing_test.rb) —
  "create_invoice rejects an empty line item list"
- **Status:** active

## Non-promises

<a id="billing-non-001"></a>
### BILLING-NON-001 — Invoice IDs are currently sequential
- **Observed:** IDs increment by one, and at least one report sorts by ID assuming chronology.
- **Why not promised:** Incidental to the current primary key. A regrowth may use UUIDs. Callers
  needing ordering must sort by created_at.

## Retired

<a id="billing-spec-004"></a>
### BILLING-SPEC-004 — Invoices could be issued in legacy currency codes
- **Retired:** 2026-09-02
- **Replaced by:** BILLING-SPEC-019 (ISO 4217 only)
- **Why:** Legacy codes were removed from the upstream catalogue; no caller has used one since
  2025. Re-adding this would require reinstating the conversion table deleted in the same change.
```

## Rules

- **Invariants and specs are different classes.** Most specs are not invariants. Do not promote a spec to an invariant to give it emphasis.
- **A performance invariant states a measurable threshold**, a workload it holds under, and how it was measured. Otherwise it is an aspiration.
- **Evidence is required on invariants.** "Why do we believe this is a promise and not an accident?" is the question adoption exists to answer; record the answer.
- **Retirement is visible.** Never delete an entry outright. Record what replaced it and why, so a later proposal to re-add it meets the reasoning that removed it.
- **No implementation detail.** If an entry names a class, function, or pattern inside the boundary, it is Procrustean — rewrite it as an observable property or delete it.
- **Every file path is a link.** Code, tests, directories — anything the manifest names, a reader should be able to open from where they are standing. Use paths relative to the file doing the linking (`../../` from `docs/subsystems/`), which resolve in GitHub and in an IDE alike.
- **Reference tests by name, not line number.** Line numbers are wrong within a week and wrong silently. Link the test file and quote the test's name; the name survives edits and is greppable after a regrowth moves everything.
- **Link both directions.** The manifest links to each subsystem file; each subsystem file links back to the manifest. Anyone who arrives at a subsystem file by grep — which is most arrivals — must be able to find the index from where they landed. An entry in one direction only is half-wired.
- **Every entry carries an explicit anchor.** `<a id="billing-inv-001"></a>` above the heading. Required, not cosmetic: GitHub derives an anchor from the *whole* heading, so `#billing-inv-001` does not resolve against `### BILLING-INV-001 — Invoice totals are…`. The explicit anchor also survives a title rewording, which the derived one does not.
- **Markdown links belong in markdown files; code comments carry bare IDs.** A story linking to an entry renders and resolves. A path written into a code comment does not render on GitHub, rots silently on any file move, and breaks the grep people actually type.
- **Record the origin.** The story or epic that introduced the entry, as a link. It is the only durable pointer back to the disposable layer, and it answers "why is this promised?" without re-deriving it.
- **A subsystem file describes intent, never work state.** No progress tables, no checklists, no in-flight status. Those belong to the story driving the change and are deleted with it. The one part of a subsystem file that changes often is the manifest's status column, not the file itself.
