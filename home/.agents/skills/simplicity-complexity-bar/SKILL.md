---
name: simplicity-complexity-bar
description: >-
  Use when implementation complexity is rising (long functions, high cyclomatic
  complexity, TypeScript type gymnastics, clever abstractions) and you must
  decide whether that complexity is imposed by the domain or invented by the
  code. Local/code-level bar: complexity is allowed only when the problem is
  complex.
---
# Complexity Only When the Problem Is Complex

Complexity is a budget, not a style. Spend it on the domain — concurrency, invariants, partial failure, real polymorphism — not on code gymnastics.

This skill is the **local** bar: functions, types, control flow, and cleverness inside a module. The **system** bar (small core, burden of proof on every extra concept) is `design-simplicity-default`. Do not merge the two in your head: a deep module may hide essential complexity and still fail this skill if the hiding is done with unreadable TypeScript.

## North star

Ousterhout's definition: complexity is anything in the structure of the system that makes it hard to understand or modify. Its symptoms are **change amplification** (one change, many edits), **cognitive load** (too much to hold), and **unknown unknowns** (it is unclear what matters).

Those symptoms are legitimate when the *problem* produces them: a distributed write with retries and idempotency is actually hard. They are illegitimate when the *code* produces them: a five-layer mapped type, a 40-branch function that could be a table, a generic that exists for one call site.

Unix taste: do one thing well. Spark taste: compose simple transformations (`map`, `filter`, `join`) rather than invent a new framework per algorithm. MapReduce taste: the user writes two total functions; the library absorbs the messy parts. The messy parts were essential (machines fail). The user code was not.

## When to use

- A function, type, or control-flow graph is hard to read and you must decide keep vs. compress.
- A change introduces conditional types, branded stacks, monadic wrappers, or "type-level programming" for a single use.
- A review comments on cyclomatic complexity, nesting, or "this should be simpler" without a rule.
- AI-generated code arrived with defensive branches, redundant types, and speculative generics.
- You are tempted to add an Effect-style, result-type, or DI framework to make ordinary business logic "correct by construction."

Do not use this skill to demand that every function be five lines. Ousterhout is explicit: split only when splitting *reduces total system complexity*. A 60-line function that is one complete idea beats eight 8-line functions that must be read together.

## Method

### 1. Separate essential from accidental

Write one sentence: "What about reality makes this hard?"

Legitimate sources (essential):

- Persistence, concurrency, ordering, idempotency
- Distributed failure, retries, partial effects
- External APIs you do not control
- Security, compatibility, demonstrated performance
- A real invariant that is locally hard to enforce

Illegitimate sources (accidental):

- Type-level programming that restates a runtime check
- Framework ceremony (layers, containers, result wrappers) with one use
- Speculative extension points
- Cleverness that could be a `switch`, a table, or two functions
- Duplicated validation in types *and* runtime *and* comments

If you cannot point at a property of the world, the complexity is invented. Remove it.

### 2. Prefer obvious control flow

Default shape for TypeScript:

- Straight-line function
- Early returns for guards
- One `switch` on a discriminated union for domain cases
- Loops you can see

Treat the following as expensive and requiring a domain reason:

- Nested callbacks / promise pyramids that a single `async` function would flatten
- Visitors, strategies, or command buses for a closed set of three cases
- Recursion where a loop is the model
- State hidden in hooks, closures, or thread-locals when an argument would do

Cyclomatic complexity is a smell, not a quota. A function with eight branches that match eight domain states is fine. A function with eight branches that handle null, undefined, empty string, and "just in case" is not.

### 3. Ban TypeScript judo unless it removes a class of bugs

Allowed type complexity (usually):

- A discriminated union that *is* the domain (`type Result = { ok: true; value: T } | { ok: false; reason: Reason }`)
- `z.infer<typeof Schema>` as the single source of truth
- Narrow generics that the compiler uses at every call site (`function parse<T>(schema: Schema<T>, input: unknown): T`)

Forbidden without a second concrete use and a written invariant:

- Conditional types more than one level deep
- `infer` chains, mapped remapping, and `any`/`unknown` ping-pong
- Brand stacking (`type UserId = Brand<Brand<string, "Id">, "User">`) for values that are only ever strings at rest
- Wrapper types that exist to make a library happy (`TaskEither<E, Either<E2, Option<A>>>`)
- Home-grown "type-safe" DI / effect systems for a handful of functions

Effect.ts and similar typed-effect libraries can encode real failure and dependency graphs. They are a *framework*. Adopt one only when the problem has many I/O dependencies, typed failure modes, and structured concurrency that plain functions cannot keep honest. For ordinary business logic they are TypeScript judo. This skill does not adopt them.

### 4. Keep functions short *and* whole

Each function should do one complete thing. "Complete" matters as much as "one."

- Extract a helper when it has an independently meaningful name and can be understood without its caller.
- Do not extract a helper that is only understandable next to its caller (Ousterhout's "conjoined methods").
- Do not split a function to satisfy a line limit. Split to hide a decision.

A good long function: one algorithm, locals you can see, no hidden mutation. A bad short function: `process(ctx)` that calls `handle(ctx)` that calls `execute(ctx)`.

### 5. Prefer data over packed behaviour

When a decision can live in data, put it in data.

```ts
const TRANSITIONS: Record<State, ReadonlyArray<EventType>> = {
  open: ["message_received", "closed"],
  waiting: ["agent_replied", "closed"],
  closed: [],
}
```

This is simpler than a class hierarchy or a strategy map of closures. Rust taste applies in TypeScript: pack the data, write plain functions over it. Do not pack a zoo of methods onto an anemic class, and do not pack a zoo of closures into an "engine."

### 6. Measure with the three symptoms

For the code in front of you, answer:

1. **Change amplification** — If the domain rule changes, how many sites move?
2. **Cognitive load** — What must a reader hold to edit this safely?
3. **Unknown unknowns** — Is it obvious which files and invariants matter?

If all three are high and the problem is a single-row update, you failed this skill.

## Checklist

- [ ] I can name the real-world property that forces this complexity.
- [ ] Control flow is visible: guards, one switch, no hidden engines.
- [ ] Types model the domain; they do not re-encode the program.
- [ ] No generic / conditional type exists for a single call site.
- [ ] Functions are whole ideas, not fragments and not god-objects.
- [ ] A new engineer can modify the happy path without learning a framework.
- [ ] Accidental branches (null, default, "should never happen") have been deleted or turned into invariants.

## Anti-patterns

**Pseudo-typed complexity.** Types that look rigorous and do not constrain runtime behaviour. `as` casts at the edges of an elaborate generic. The reader pays cognitive load; production does not get safety.

**Framework as sophistication.** Introducing Effect, Nest-style DI, a result monad, or a command bus because the team wants "serious" code. The problem was a function.

**Extract-until-tiny.** Many five-line functions that leak the same knowledge. Total complexity went up. Local metrics went down.

**Defensive everything.** Optional chaining through six levels, default empty objects, `try/catch` that swallows. This hides invariant violations instead of making state explicit (`design-conceptual-integrity`).

**AI-shaped code.** Extra helpers, extra types, extra `undefined` checks, comments that narrate. Review the result, not the provenance; compress it (`review-conceptual-integrity` § AI-generated code).

**Clever one-liners.** Dense `reduce` / `flatMap` chains that a `for` loop would make obvious. Cleverness is accidental complexity.

## Pass / fail tests

**Pass.** A billing function is 80 lines because proration, tax, and currency rounding are actually hard. The types are a few unions. The tests are examples of invoices.

**Pass.** A parser uses a discriminated union and one switch. Adding a node type is one new variant and one new case.

**Pass.** Zod schema is the type. No parallel handmade interface.

**Fail.** A 15-line feature adds three generic helpers, two branded types, and a `Result` wrapper used once.

**Fail.** `type DeepReadonly<T> = ...` 40 lines, used to freeze one config object. `as const` would do.

**Fail.** Cyclomatic complexity is low because the branches moved into a plugin registry that nobody can search.

**Fail.** "We need Effect because errors should be typed" — there are three error cases and they are already a union.

## Concrete examples

### Accidental: TypeScript judo

```ts
type DeepPartial<T> = T extends Function
  ? T
  : T extends Array<infer U>
    ? Array<DeepPartial<U>>
    : T extends object
      ? { [K in keyof T]?: DeepPartial<T[K]> }
      : T

type Patch<T> = DeepPartial<T> & { id: T extends { id: infer I } ? I : never }

export function applyPatch<T extends { id: string }>(
  entity: T,
  patch: Patch<T>,
): T {
  return { ...entity, ...patch } as T
}
```

The domain operation is "change some fields." The types do not make that safer than:

```ts
export function applyLeadPatch(
  lead: Lead,
  patch: Partial<Pick<Lead, "title" | "ownerId">>,
): Lead {
  return { ...lead, ...patch }
}
```

### Essential: domain complexity, kept obvious

```ts
export function applyPayment(invoice: Invoice, event: PaymentEvent): Invoice {
  if (invoice.status === "void") return invoice
  if (event.amountMinor <= 0) return invoice

  const paid = invoice.paidMinor + event.amountMinor
  if (paid < invoice.totalMinor) {
    return { ...invoice, paidMinor: paid, status: "partial" }
  }
  if (paid === invoice.totalMinor) {
    return { ...invoice, paidMinor: paid, status: "paid" }
  }
  return {
    ...invoice,
    paidMinor: invoice.totalMinor,
    status: "paid",
    overpayMinor: paid - invoice.totalMinor,
  }
}
```

The branches are the domain. No strategy objects. No type-level ledger.

### Accidental: ceremony around a function

```ts
export class UpdateTitleCommand {}
export class UpdateTitleHandler {
  constructor(private readonly repo: ILeadRepo) {}
  async handle(cmd: UpdateTitleCommand & { id: string; title: string }) {
    const lead = await this.repo.get(cmd.id)
    lead.title = cmd.title
    await this.repo.save(lead)
  }
}
```

The problem is not complex. A function `setLeadTitle(lead, title)` is the bar.

## What NOT to do

- Do not enforce a maximum function length or a cyclomatic quota as a linter religion. Use the three symptoms.
- Do not split this skill's job from `design-simplicity-default`. If the *system* is growing extra concepts, use that skill. If a *function or type* is doing gymnastics, use this one.
- Do not reject essential complexity. Distributed exactly-once, tax law, and calendar math are allowed to look hard.
- Do not adopt a typed-effects framework to satisfy this skill. If you need one, the problem statement should already mention concurrency and failure graphs.
- Do not "simplify" by deleting an invariant and hoping callers remember it.
- Do not rewrite working obvious code into a generic masterpiece.

## Related skills

- `design-simplicity-default` — system-level default bar and burden of proof.
- `design-deep-modules` — hide essential complexity behind a small interface; this skill forbids hiding it behind unreadable code.
- `design-conceptual-integrity` — find the state and transitions first; those are the legitimate source of complexity.
- `review-conceptual-integrity` — review-time classification of essential vs. accidental (shared-method §7). This skill is how you *write* so that review passes.
