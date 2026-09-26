---
name: design-simplicity-default
description: >-
  Use when choosing a system shape, adding a concept, adopting a framework, or
  justifying extra machinery. Simplicity is the default bar: a handful of
  functions at the core, everything else encapsulated, and the burden of proof
  on complexity. System-level counterpart to simplicity-complexity-bar.
---
# Simplicity as the Default Bar

The default design is the simplest one that satisfies the problem. Complexity must apply for the job.

This skill is the **system-level** bar: how many concepts the program contains, what sits at the core, and who has the burden of proof. The **local** bar (functions, types, gymnastics) is `simplicity-complexity-bar`. A codebase can pass that skill function-by-function and still fail this one by having twenty good functions where four would do.

## North star

A handful of functions at the core. Everything else is encapsulated behind them.

MapReduce: two functions. Unix: tools that do one thing, composed with a universal interface (text). Spark: a small set of transformations over one data model, not a new framework per algorithm. Prettier: `format(source, options)`. Zod: `parse` / `safeParse`. Linux files: `open` / `read` / `write` / `lseek` / `close`.

These systems are not toy-simple. They are **simple at the point of use** and **strict about what is allowed to exist**. The implementation may be large. The concept count is not.

`review-conceptual-integrity` already says: put the burden of proof on complexity, not simplicity. This skill is how you *design* under that rule, every day, not only at review time.

## When to use

- You are choosing between "add a concept" and "extend an existing function."
- A design proposes a framework, platform, or layer for a problem that still fits in one module.
- You need a default to break a tie. The default is the simpler design.
- A PR grows the ontology (new service, new queue, new entity, new package) and nobody asked whether the old one could hold it.
- You are setting the bar for an AI-generated scaffold that arrived with a complete architecture.

Do not use this skill to demand fewer lines. Line count is not simplicity. Concept count, hop count, and what a new engineer must learn are.

## Method

### 1. Construct the dumb baseline

Write the stupidest design that could work, in the language of `review-conceptual-integrity` shared-method §2:

- What remains if frameworks and patterns are forbidden?
- What concepts survive if this must fit in one file or roughly 200 lines?
- What machinery do the constraints actually require?
- Which exact requirement makes that baseline insufficient?

The baseline is a **control**, not automatically the ship. Every extra concept is a delta against it. If you cannot name the delta, you are decorating.

### 2. Put the burden of proof on the extra concept

To add a type, package, queue, layer, framework, or service, answer all of:

1. What invariant or constraint does it own that the baseline cannot?
2. What concrete second use or hard boundary forces it *now*?
3. What happens to change amplification if we add it? If we don't?
4. Can a reader still explain the system in three to seven sentences?

No answer → do not add it. "Best practice," "so we can scale," "for consistency with the other services," and "the template includes it" are not answers.

### 3. Keep a small core

Identify the core: the functions that apply the domain transitions (`design-conceptual-integrity` stages 4–5). Protect their count.

Typical healthy core:

```ts
apply(state, transition) -> { state, effects } | error
commit(state, effects)   -> void
```

Or, at library scale:

```ts
parse(input) -> data | error
format(source, options) -> string
generateText({ model, prompt }) -> { text }
```

Everything else — HTTP, CLI, logging, retries, provider SDKs, admin pages — is **outside** the core and **behind** it. It may be large. It may not leak new domain nouns into the core.

If the core grows a `Manager`, `Coordinator`, `Engine`, or `Pipeline`, the core has lost.

### 4. Encapsulate the rest

Encapsulation is how a large system stays simple at the point of use. It is not a license to build a framework.

- Hide provider differences behind one function (steal from `generateText`).
- Hide cache, retry, and staleness behind one hook (steal from `useQuery`).
- Hide printer and language edge cases behind one function (steal from `prettier.format`).
- Do not hide a small core behind a large *interface*. That is a shallow module (`design-deep-modules`).

Unix composition is the other half: when two jobs are truly separate, two small tools beat one swiss army knife. `cat` does not grow `-v` (Kernighan & Pike). Build a new function rather than complicate an old one with unrelated features. That is not a contradiction of deep modules: depth is about hiding *related* complexity, not absorbing *unrelated* jobs.

### 5. Prefer composition over frameworks

Spark's lesson: one composable data model (the RDD) replaced a zoo of special-purpose cluster frameworks. Users write `map` / `filter` / `join`; the scheduler reads lineage.

In TypeScript this means:

- Functions that take and return data
- A small number of unions
- Call sites that read top to bottom

It does not mean adopting Effect, Nest, a command bus, or a plugin host so that composition becomes a framework. Those move the concept count into the platform. You still pay it.

Deno std is the Unix reading of the same idea: small, independently useful modules (`join`, `ensureDir`) composed by the caller. Steal the composition. Do not steal a pile of shallow utilities as your *domain* core.

### 6. Re-explain the system

After the design exists, explain it in three to seven sentences using domain and guarantee language. If you need architectural nouns to explain it, the design is the problem.

Good: "A conversation owns its messages. `apply` is the only mutation. HTTP writes through `apply` in a transaction with an outbox. A worker dispatches effects."

Bad: "The inbound adapter publishes to the application bus. A handler in the application layer invokes the domain service, which uses the unit of work to coordinate repositories and domain events."

## Checklist

- [ ] A dumb baseline exists on paper.
- [ ] Every concept not in the baseline has a written justification (invariant, constraint, or second use).
- [ ] The core is a handful of functions (or one deep module) that apply state transitions.
- [ ] Peripheral machinery does not add domain nouns.
- [ ] Related complexity is encapsulated; unrelated jobs are separate functions.
- [ ] The system can be explained in three to seven sentences without framework vocabulary.
- [ ] Removing any proposed framework still leaves a working mental model.

## Anti-patterns

**Architecture as default.** Hexagonal folders, a DI container, a CQRS split, or microservices adopted before the baseline fails. This is the reverse path (`design-conceptual-integrity`).

**Feature accretion.** One function grows flags for unrelated jobs (`process(ctx, { mode, dryRun, async, version2 })`). Build a new function. McIlroy: do not complicate old programs with new features.

**Platform souvenir.** A shared "core" package of base classes, result types, and logger wrappers that every service must import. The concept tax is paid on every change.

**Simplicity as fewer files.** One 3,000-line file that is five domains is not a small core. One domain split across fifteen pass-through files is not a small core either. Count concepts, not files.

**Framework envy.** Effect.ts, Nest, or a home-grown actor runtime because another team looks "more serious." Seriousness is invariants and state ownership.

**AI scaffold.** A generated app with auth, users, roles, repositories, and a queue, when the request was a script. Delete back to the baseline.

## Pass / fail tests

**Pass.** The working core is `apply` + `commit`. HTTP, a worker, and a CLI all call them. New engineers read one file to learn the domain.

**Pass.** Zod / Prettier / `generateText` shape: one or two entry points, large hidden behaviour, no obligatory subclassing.

**Pass.** A proposed workflow engine is rejected because three transitions and a status column suffice.

**Fail.** A new entity is added "for symmetry" with a neighbouring module. No invariant.

**Fail.** Six packages for one deployable, each with its own `index.ts` barrel and types that re-export each other.

**Fail.** The README's architecture diagram has more boxes than the problem has nouns.

**Fail.** "We'll keep it simple by using the standard service/repository/controller split." That split is already three concepts. Show why one function lost.

## Concrete examples

### Default: the core is two functions

```ts
export function apply(invoice: Invoice, event: InvoiceEvent): ApplyResult {
  // domain transitions only
}

export async function commit(result: ApplyResult, db: Db): Promise<void> {
  await db.transaction(async (tx) => {
    await tx.saveInvoice(result.invoice)
    await tx.saveOutbox(result.effects)
  })
}
```

HTTP handler, cron, and test suite all call these. No `InvoiceService`.

### Complexity that earned its place

A second function `applyRefund` appears when refunds have different invariants (window, partial vs full, tax reversal). It is a new job, not a flag on `apply`. The core is still a handful.

### Complexity that did not

```ts
export class InvoiceOrchestrator {
  constructor(
    private readonly pipeline: Pipeline<InvoiceContext>,
    private readonly policies: PolicyRegistry,
    private readonly uowFactory: UnitOfWorkFactory,
  ) {}
}
```

Nothing in the baseline required a pipeline, a registry, or a factory. Burden of proof failed.

### Composition, not a framework

```ts
const text = (await generateText({ model, prompt: buildPrompt(lead) })).text
const parsed = Note.safeParse(JSON.parse(text))
if (!parsed.success) return { ok: false, reason: "invalid_note" }
return { ok: true, note: parsed.data }
```

Three deep modules composed. No agent framework, no custom effect system. Cloudflare Agents (MIT-licensed) and Effect.ts can do more; they also impose a concept tax. Use them only when the baseline cannot express durable agent state or typed failure graphs — and even then, keep *your* core as data + functions.

## What NOT to do

- Do not treat this skill as a license to under-design distributed failure, security, or invariants. Those are essential; they still belong in a small core.
- Do not collapse this skill into `simplicity-complexity-bar`. If you are arguing about a type or a function body, use that one. If you are arguing about whether a concept should exist, use this one.
- Do not use "simple" to mean "I already understand this framework." Familiarity is not simplicity for the next reader.
- Do not add extension points for hypothetical second implementations.
- Do not praise deletion of tests, checks, or names that carry invariants. That is not simplicity; that is lost integrity (`design-conceptual-integrity`).
- Do not require a framework's absence as dogma. Require that the framework beat the baseline on a named constraint.

## Related skills

- `simplicity-complexity-bar` — local/code-level complexity budget.
- `design-deep-modules` — the shape of the handful of functions (small interface, large behaviour).
- `design-conceptual-integrity` — how to discover which handful of functions the domain actually needs.
- `review-conceptual-integrity` — review-time burden of proof and concept counting (shared-method §2, §7, §9).
- `codebase-design` — deletion test and leverage; use them as evidence in the burden-of-proof answers.
