Here it is. React to any section by name.

1. The model

A system is inputs → work → outputs, situated in a context.

- Inputs — data, options, commands it accepts
- Context — external dependencies, constraints that hold whatever the implementation is, and the current implementation itself
- Outputs — what it produces, given those inputs, in that context

Systems compose. The implementation of a system is other systems, same shape all the way down. Two systems are wired when one's output artifact and another's input artifact have the same name — that match is the only join, and it needs no registry.

The product is the top system. Its outputs are described by capabilities: the acceptance criteria currently supported.

Durable: system descriptions, capabilities, and their tests. Disposable: implementation, scaffolding tests, epics, stories, tasks, plans. The implementation is context — which is why deleting it is unremarkable rather than brave.

Gone from the old model: invariants, specs, non-promises, the classification taxonomy, boundary redraw, system.md, orphaned-entry bookkeeping, capabilities-as-projection.

2. The artifacts

docs/
systems.md            # index: name, file, status
systems/
billing.md          # Inputs / Context / Outputs
capabilities.md       # supported acceptance criteria, in Gherkin

The index stays dumb — name, file, status. It does not restate each system's inputs and outputs, because that's a second copy that drifts. The wiring is derivable by grepping artifact names across system files. If you want a picture of the graph, generate it; never maintain it.

System file, three sections. Inputs are shapes. Context is plain declarative statements. Outputs are EARS, one line per input→output pair, each with an ID.

Tags get cut in half. @proves {ID} on tests, and nothing on implementation code. @implements existed to answer "what code satisfies this?" — but the unit of deletion is now the system boundary, so you delete by path and read the system whole. That query doesn't need answering anymore.

One open choice: capabilities.md as a curated Gherkin document, each scenario naming its test — works in any stack. Or, if you run Cucumber, the .feature files are the capability list and the document disappears entirely. I'd take the document unless your target project already has a Gherkin runner.

3. The walk and the three moves

A story asks for a change in product outputs. Walk the wiring to find the systems implicated — from the top if the work is large, straight to the emitting system if you already know which artifact changes. The walk is the inventory; the method doesn't prescribe its direction.

Per system, one of three: build (doesn't exist), change (exists and is described), adopt (exists, undescribed). Change has two flavors — patch it, or delete and rebuild — and that's a sizing judgment made when you write the output delta, not a separate ceremony.

4. What pxp becomes

(Partly superseded by §6, which moves the impact step and adds a capabilities skill. Kept for the reasoning.)

Phases 1, 2, 4 and the approval gates are untouched. Two changes:

Phase 3 stops deriving EARS-per-task. It becomes: walk the wiring → system inventory with a move per system → output delta per system → then tasks, in plain imperative prose, no IDs, no EARS. Tasks and promises stop being the same objects.

Phase 5 gains one mechanical step: promote the story's satisfied acceptance criteria into docs/capabilities.md. Nothing is authored — the Gherkin already exists.

The story template's ## EARS Specifications section is replaced by ## System inventory and ## Output delta.

5. The skills

One skill, two references, roughly 1,200 words total:

- specs-of-theseus/SKILL.md — the model, the walk, the three moves, and what's durable
- references/system-file.md — the three sections, EARS, IDs, wiring by artifact name
- references/adopting.md — the one hard question, would we write an acceptance criterion for this?

regrowing-a-subsystem dissolves. It existed to argue that deletion is safe; the model now makes that structural — the implementation is context. An e6. Three skills, two plugins (2026-10-04)

Order of work, agreed: story → impact → tasks. Impact comes before tasks because the record changes before the code does. Working impact out from tasks would put the code plan ahead of the descriptions.

Impact has two levels:

- Product level: a story's acceptance criteria are written as a delta against docs/capabilities.md (scenarios added, changed, retired). This needs no systems.
- System level: walk down from the capabilities being changed to the systems that produce them; per system, a move (build, change, adopt) and an output delta. This is Specs of Theseus.

The split:

- PXP — epic → story → impact → tasks → TDD → accept. Owns the process, the approval gates, and the docs/epics/ layout (0000-epics.md, 0001-name.md, 0001-name/0010-story.md). Must stand alone.
- Capabilities skill — the product-level impact. Defines the capabilities.md format (each scenario names its proving test), writing acceptance criteria as a delta, applying the delta at acceptance (add, modify, retire — never just append), and the Cucumber alternative. Used at story writing and story acceptance.
- Specs of Theseus — the system-level impact. One skill plus two references, as in §5. The product is the top system and capabilities are its outputs, so the capabilities delta is the top system's output delta and the walk starts there.

Tasks are a plain checklist in the story file either way, replacing the story template's EARS Specifications and Implementation Plan sections. Their content depends on how deep impact went:

- PXP alone: tasks come straight from the acceptance criteria. "Add the empty-cart guard to checkout."
- With Specs of Theseus: tasks come from each system's move and output delta. Some are structural ("Delete app/billing/ and rebuild against the Billing outputs"), some are per output ("Prove BILLING-OUT-004"); adopting adds describing the system first.

Assumptions in the above, not yet confirmed:

- The capabilities skill lives in PXP, because that's where the Gherkin originates and PXP must stand alone. A third plugin pays off only if someone wants capabilities without either.
- PXP detects Specs of Theseus the way it detects superpowers TDD: a fallback chain in phase 3. If present, it does the system walk and produces tasks; if not, PXP goes from the capabilities delta straight to tasks. Specs of Theseus depends on PXP's layout, never the reverse.
- PXP's @spec tag goes away. Tests proving a system output carry @proves {ID}; other tests carry nothing.
- PXP's TDD skill keeps red/green/refactor and every approval gate; only the tag changes.

7. Open questions

- Does standalone PXP still need EARS at all? If tasks are plain prose and Gherkin carries acceptance, pxp:ears-specifications might move to Specs of Theseus (system Outputs) and leave PXP simpler.
- Is the PXP simplification done now, alongside this work, or is Specs of Theseus designed against today's PXP phases 3 and 5 and PXP changed afterwards?
- Capabilities retirement: changing or retiring a scenario means finding and changing its proving test — the silent-retirement risk again, at product level. Is the scenario naming its test enough, or does that test also carry an @proves tag so grep finds it?
- Dropping @implements (§2) — still the least-confident call. Is "what code satisfies this?" a query you actually run?
- capabilities.md as a curated document versus Cucumber .feature files (§2) — now owned by the capabilities skill.
- Is a capabilities skill one skill, or is it a reference inside PXP's main skill?

To resume the conversation that produced §6 and §7, from this directory:

claude --resume ebe1bfa0-2da4-4306-9b96-640c8fe2b509
  