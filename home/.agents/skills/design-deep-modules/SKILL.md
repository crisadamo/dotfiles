---
name: design-deep-modules
description: >-
  Use when designing or reviewing a module's interface, deciding whether a seam,
  port, adapter, or layer has earned its place, or when a design is accumulating
  many small interfaces (hexagonal/ports-and-adapters classitis) instead of one
  deep module. Operational checklist that uses the codebase-design glossary; do
  not invent competing terms.
---
# Design Deep Modules

Design **deep modules**: a lot of behaviour behind a small interface, placed at a clean seam. One small interface beats a framework of them.

This skill is the operational checklist. The glossary lives in `codebase-design`. Use those terms exactly: **Module**, **Interface**, **Implementation**, **Depth**, **Seam**, **Adapter**, **Leverage**, **Locality**. Do not substitute "component," "service," "API," "signature," or "boundary."

`codebase-design` defines the language and the deletion test. This skill tells you how to apply that language when inventing, shrinking, or refusing an interface.

## North star

A caller should learn a handful of facts and receive a large amount of correct behaviour. Complexity belongs *inside* the module, not in the set of things the caller must assemble.

The Unix/Linux file interface is the canonical example. Five system calls — `open`, `read`, `write`, `lseek`, `close` — hide naming, permissions, buffering, devices, caching, and scheduling. The implementation is enormous; the interface is small. MapReduce is the same shape at another scale: two functions (`map`, `reduce`) hide distribution, fault tolerance, and data movement. Spark's RDD is one interface (partitions, parent dependencies, compute, partitioner, preferred locations) that absorbed what used to be separate frameworks.

The opposite is a **framework of shallow modules**: many ports, many adapters, many types, each contributing almost nothing. Hexagonal / ports-and-adapters architecture, applied as a default folder layout, is often this anti-pattern. Visible seams are not a virtue. A seam that nothing actually varies across is indirection wearing an architectural name.

## When to use

- You are inventing a new module or shrinking an existing interface.
- A design proposes a port, adapter, repository, service, or layer "for testability" or "for clean architecture."
- Callers assemble several objects to do one job.
- You are choosing between one deep function and a family of collaborating types.
- Another skill (`codebase-design`, `design-simplicity-default`, `review-conceptual-integrity`) has flagged a shallow cluster.

Do not use this skill to rename folders or to introduce seams so tests can mock every collaborator. Test through the interface.

## Method

Work in this order. Do not start from ports.

### 1. Name the job, not the layer

State the behaviour in domain language, without architectural nouns.

Prefer: "Given an inbound message, record it on the conversation and emit the effects that follow."

Avoid: "Add a `MessageIngestionPort` and a `ConversationRepositoryAdapter`."

### 2. Propose the smallest interface that does the whole job

Aim for one to three entry points. Write the caller's code first:

```ts
const result = receiveMessage(conversation, inbound);
```

List everything a caller must know: types, ordering, error modes, required configuration, performance. That list *is* the interface (`codebase-design`). Every extra method, options bag, or callback is a cost.

Ask Ousterhout's three questions:

- Can I reduce the number of methods?
- Can I simplify the parameters?
- Can I hide more complexity inside?

### 3. Pull complexity downwards

If a decision is closely related to the module's job, belongs in one place, and would otherwise leak to every caller, put it inside. Defaults beat configuration. Inference beats parameters. The module author suffers so N callers do not.

Do not punt hard cases to the caller "to keep the module simple." A simple implementation with a complex interface is a shallow module. A complex implementation with a simple interface is a deep one.

### 4. Decide whether a seam has earned its place

Use the `codebase-design` rule: **one adapter means a hypothetical seam; two adapters means a real one.**

Classify the dependency (`codebase-design` / DEEPENING.md):

| Category | What to do |
|---|---|
| In-process | Merge. No adapter. Test through the interface. |
| Local-substitutable (PGLite, in-memory fs) | Keep the seam internal. Do not expose a port. |
| Remote but owned | A port is justified if production and test adapters both exist. |
| True external (Stripe, a provider API) | Inject a port. Tests supply a mock adapter. |

A folder named `ports/` with one production adapter and no second use is not a seam. It is a speculative interface.

### 5. Hide internal seams

A deep module may have private, test-only seams inside its implementation. Do not promote them to the external interface so that outer tests can mock them. The **interface is the test surface**. If you want to test *past* the interface, the module is the wrong shape.

### 6. Run the deletion test

Imagine deleting the module.

- If complexity vanishes, it was a pass-through. Delete it.
- If complexity reappears across N callers, it was earning its keep.

Then run the leverage test: after a caller learns the interface, how much behaviour can they exercise? If the answer is "they still have to know the internals," the module is shallow.

### 7. Design it twice when the interface is load-bearing

If the module will have many callers or will define a domain concept, sketch two radically different interfaces before committing (`codebase-design` / DESIGN-IT-TWICE.md). Compare on **depth**, **locality**, and **seam placement**. Prefer the one with fewer facts for the caller to learn.

## Checklist

Before accepting a module:

- [ ] The interface can be stated in a few sentences without listing collaborators.
- [ ] A typical caller uses one to three entry points.
- [ ] The implementation hides decisions (storage, retries, encoding, defaults), not just lines of code.
- [ ] Every exposed seam has two real adapters, or a true external that must vary.
- [ ] Tests cross the same seam callers do.
- [ ] Deleting the module would redistribute complexity to callers, not delete it.
- [ ] No pass-through type exists whose methods only forward to another type with the same shape.

## Anti-patterns

**Hexagonal classitis.** A `ports/` directory, an `adapters/` directory, and a `domain/` directory, each type a thin wrapper. The caller now learns `LeadRepository`, `LeadPolicy`, `ClockPort`, `IdGenerator`, `EventPublisher`, and a `LeadService` that sequences them. That is a framework of shallow modules. Collapse to the deep module that owns the transition.

**Pass-through layers.** `route → controller → service → manager → repository` where each hop renames data. Each hop is a shallow module. Remove hops that add no semantics.

**Interface-for-one-implementation.** A TypeScript `interface` with a single concrete class, introduced "for SOLID" or "for testing." One adapter is a hypothetical seam. Delete the interface until a second adapter exists.

**Temporal decomposition.** Modules named after steps (`ValidateInput`, `NormalizePayload`, `PersistRow`, `EmitEvent`) that all share the same knowledge. Design around the knowledge to hide (Parnas / Ousterhout), not the order of steps.

**Options as a second interface.** A 20-field options bag whose meaning is undocumented informal interface. Either infer the values or hide them. Configuration the author could have defaulted is complexity pushed upward.

**Testing past the interface.** Exporting internals or injecting every collaborator so a unit test can assert on mocks. That freezes a shallow shape.

**Depth-as-line-count.** Padding an implementation to look deep. Depth is **leverage**, not a ratio of implementation lines to interface lines (`codebase-design` rejected framing).

## Pass / fail tests

**Pass.** A caller writes `const { text } = await generateText({ model, prompt })` and receives provider selection, retries, tool loops, and usage. They did not implement those.

**Pass.** `schema.parse(input)` validates, coerces, and type-narrows. The schema combinators are the interface; the parser is hidden.

**Pass.** `useQuery({ queryKey, queryFn })` gives caching, staleness, retries, deduplication, and background refresh. The cache is not the caller's problem.

**Pass.** `prettier.format(source, { parser: "typescript" })` reprints a language. The printer, comments, and edge cases are inside.

**Fail.** Creating `IUserRepository`, `UserRepository`, `UserRepositoryAdapter`, `InMemoryUserRepository`, and `UserService` to save one row. Four interfaces, one job.

**Fail.** A "domain service" whose methods are one-line delegates to a repository. Deletion test: complexity vanishes.

**Fail.** Ports for `Clock`, `Uuid`, and `Logger` in a module that has one production adapter each and is never swapped. Hypothetical seams.

**Fail.** A hexagonal folder tree whose test suite mocks every port and never exercises a real transition.

## Concrete examples

### Shallow: a framework of ports

```ts
export interface ClockPort { now(): Date }
export interface IdPort { next(): string }
export interface ConversationRepo {
  get(id: string): Promise<Conversation | null>
  save(c: Conversation): Promise<void>
}
export interface PublisherPort { publish(e: Event): Promise<void> }

export class ReceiveMessageService {
  constructor(
    private clock: ClockPort,
    private ids: IdPort,
    private repo: ConversationRepo,
    private publisher: PublisherPort,
  ) {}

  async execute(id: string, inbound: Inbound): Promise<void> {
    const c = await this.repo.get(id)
    if (!c) throw new Error("missing")
    c.messages.push({ ...inbound, id: this.ids.next(), at: this.clock.now() })
    await this.repo.save(c)
    await this.publisher.publish({ type: "received", id })
  }
}
```

The caller learns four ports and a service to perform one transition. Each port is shallow. The service is a sequencer.

### Deep: one interface, complexity inside

```ts
export type ReceiveResult =
  | { ok: true; conversation: Conversation }
  | { ok: false; reason: "not_found" | "closed" | "duplicate" }

export function receiveMessage(
  conversation: Conversation,
  inbound: InboundMessage,
): ReceiveResult {
  if (conversation.status === "closed") return { ok: false, reason: "closed" }
  if (conversation.messages.some((m) => m.id === inbound.id)) {
    return { ok: false, reason: "duplicate" }
  }
  return {
    ok: true,
    conversation: {
      ...conversation,
      messages: [...conversation.messages, inbound],
      status: "waiting",
    },
  }
}
```

The transition is the interface. Persistence, clocks, and IDs are either in-process details or internal seams. Tests call `receiveMessage`. If a database later appears, it is an adapter behind this function, not a new public port per collaborator.

### Deep at library scale

```ts
const User = z.object({ email: z.string().email(), age: z.number().int() })
type User = z.infer<typeof User>
const result = User.safeParse(input)
```

One concept (schema), two operations (`parse` / `safeParse`), large hidden behaviour (combinators, error paths, type inference). Steal this shape.

## What NOT to do

- Do not introduce a port because a blog post said clean architecture requires one.
- Do not expose every collaborator "so the module stays testable." Test through the interface.
- Do not split a deep module into many small classes to satisfy a line-count or file-count habit. That is classitis (Ousterhout).
- Do not invent synonyms for the `codebase-design` glossary. If you need a new term, you are probably renaming a seam.
- Do not treat hexagonal architecture, SOLID, or DI containers as evidence of depth. They are often a factory for shallow modules.
- Do not confuse a large TypeScript `interface` keyword block with a deep **Interface**. The latter includes invariants, errors, and ordering, and should still be small.
- Do not use this skill as a substitute for `review-conceptual-integrity` (review-time) or `design-conceptual-integrity` (design-time order). Depth is one property of a module, not the whole conceptual model.

## Related skills

- `codebase-design` — glossary and deletion test. Read it if any term is unclear.
- `design-simplicity-default` — system-level burden of proof; this skill is the module-level shape.
- `simplicity-complexity-bar` — when implementation complexity is allowed; this skill is about *where* that complexity sits (inside, not on the interface).
- `design-conceptual-integrity` — design the state and transitions first; then give them a deep module.
- `review-conceptual-integrity` — review-time counterpart; do not clone its order here.
