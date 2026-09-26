---
name: design-conceptual-integrity
description: >-
  Use when designing or implementing a feature, module, or subsystem from
  scratch or when reshaping one — before code, and while writing it. Walk
  problem → constraints → invariants → state → transitions → mechanisms →
  abstractions → implementation. Design-time companion to
  review-conceptual-integrity; do not use this as a PR review substitute.
---
# Design Conceptual Integrity

Build the conceptual model first, then the code. State and transitions before abstractions.

This is the **design-time / planning** companion to `review-conceptual-integrity`. That skill owns review order, evidence rules, and PR vs. whole-codebase modes. This skill owns how you *invent and implement* so that a later review has something coherent to protect.

Do not clone the review skill. Do not produce a scored audit. Produce a design you can implement, and implement it in the same order you designed it.

## North star

`review-conceptual-integrity` states it:

> The system contains the fewest concepts necessary to represent reality accurately, preserve its invariants, and satisfy its constraints.

Brooks called this conceptual integrity: one mind (or a small set of agreeing minds) deciding what the system *is*. The ground-level practice is to refuse the reverse path.

Required direction:

`problem → constraints → invariants → state → transitions → mechanisms → abstractions → implementation`

Forbidden direction:

`framework → class → interface → service → handler → architecture → fit the problem`

Bigtable did this. The data model — a sparse, multidimensional sorted map `(row, column, timestamp) → value`, atomic per row — is the concept. Tablet servers, SSTables, Chubby, and GFS are mechanisms in service of that model. Spanner added an invariant (external consistency via TrueTime) before it added Paxos groups. MapReduce named the computation (`map`, `reduce`) before the master/worker machinery. Spark named the RDD (immutable partitioned data + lineage) before the scheduler. In each case the state and its legal transitions are older than the framework.

## When to use

- You are about to write a feature, service, or module and the shape is not obvious.
- You are rewriting or extracting and must not carry a bad ontology forward.
- A design discussion has started from "we'll use Nest / hexagonal / event sourcing / CQRS."
- Implementation is drifting: new types appearing that were not in the state model.
- `review-conceptual-integrity` failed a change and you are the one who must redesign it.

Do not use this skill to review someone else's PR. Switch to `review-conceptual-integrity`.

## Method

Walk the eight stages in order. Write each stage down — a page, not a deck — before spending design effort on the next. If a later stage forces a change, walk back; do not patch forward.

### 1. Problem

State observable behaviour in one or two sentences. No implementation nouns.

Prefer: "When a message arrives for a lead, the conversation records it and the lead becomes waiting if it was open."

Avoid: "Add a `LeadProcessingOrchestrator` with a message handler pipeline."

If you cannot state the problem without the solution's types, you do not understand it yet.

### 2. Constraints

List the properties of the world that shape the solution. Separate **explicit** from **assumed**.

Usual families: concurrency, ordering, durability, latency, throughput, retries, idempotency, compatibility, transactions, external APIs, the persisted model, multi-tenancy, operations.

Kill assumed constraints that are habits ("we always put a service layer," "we must be hexagonal," "we'll need to scale to ten regions"). A constraint you cannot attribute to a user, a regulator, or a measured runtime is not a constraint.

### 3. Invariants

Write testable sentences that must remain true.

- A message belongs to exactly one conversation.
- A conversation has at most one active assignee.
- A transition commits before its effects become eligible for dispatch.
- Re-delivery does not duplicate a business effect.

Invariants you cannot name will be enforced nowhere, or everywhere (which is the same as nowhere). Invisible invariants are a design failure, not a documentation failure.

### 4. State

Make state explicit before you invent objects.

For each piece of state:

- What is it?
- Which copy is authoritative?
- Who may mutate it?
- Which copies are derived or cached?
- Where is the transactional boundary?

Prefer a small set of records and a status field over a graph of mutable services. If two modules both write the same row, you do not have ownership; you have a race with extra types.

This is the step Dean/Ghemawat taste insists on: **clear ownership of state**. Bigtable tablet servers are stateless; GFS and Chubby own the durable state. That is a design decision, not an implementation accident.

### 5. Transitions

Name the legal changes to that state. Use domain events / commands as names, not `process`, `handle`, `execute`, `run`, or `sync`.

```ts
type ConversationState = "open" | "waiting" | "closed"

type Transition =
  | { type: "message_received"; inbound: InboundMessage }
  | { type: "agent_replied"; body: string }
  | { type: "closed"; reason: string }
```

Draw, in text, which states accept which transitions and what they produce (new state + effects). Illegal transitions are part of the model. Do not leave them as thrown strings inside a service.

If you cannot list the transitions, you are not ready for mechanisms.

### 6. Mechanisms

Only now choose machinery: a table, a queue, a transaction, a lock, a retry, a cron, an HTTP call.

Each mechanism must protect an invariant or satisfy a constraint. "We use a queue" is not a reason. "Effects must become eligible only after the transition commits, so we write the outbox in the same transaction" is a reason.

Prefer the dumbest mechanism that works. An extra table with a status column beats a workflow engine that exists to look distributed.

Unix taste applies: compose small mechanisms rather than adopting a framework that owns your state machine.

### 7. Abstractions

An abstraction earns its place when it represents a real concept, owns an invariant, or has an independent lifecycle. Apply the deletion test from `codebase-design` and the pressure questions from `review-conceptual-integrity`:

1. What real domain or runtime concept is this?
2. Which invariant does it own?
3. Why does it need independent identity, lifecycle, or state?
4. What disappears if it is deleted?
5. Why is a function insufficient?
6. What concrete second use or hard boundary forces it?

Do not accept "separation of concerns," "clean architecture," "flexibility," or "for testability" as answers. Those are how reverse-path designs justify themselves.

Names that should trigger extra skepticism: `Manager`, `Handler`, `Processor`, `Service`, `Helper`, `Utils`, `Coordinator`, `Orchestrator`, `Engine`, `Context`, `Provider`, `Factory`, `Strategy`. For a stateless one, ask: why is this not a function?

Give surviving abstractions a **deep module** (`design-deep-modules`). Do not explode them into ports.

### 8. Implementation

Write the code in the same order:

1. Types for state and transitions.
2. Pure functions that apply transitions and preserve invariants.
3. Persistence / I/O adapters only where a real seam exists.
4. Wiring last, and as little of it as possible.

Tests follow the model: examples of transitions, illegal transitions, and invariant violations. They do not follow the folder tree.

If implementation invents a new concept that was not in stages 1–7, stop. Either the model was incomplete (walk back) or the concept is accidental (delete it).

## Checklist

Before writing production code:

- [ ] Problem statement has no implementation nouns.
- [ ] Constraints are attributed (user, regulator, measured runtime) or dropped.
- [ ] Invariants are testable sentences.
- [ ] Authoritative state and its owner are named.
- [ ] Transitions are a closed, named set with illegal cases.
- [ ] Each mechanism maps to an invariant or constraint.
- [ ] Each abstraction survives the deletion / pressure test.
- [ ] The implementation order matches the model order.

While writing code:

- [ ] New types are either state, transitions, or earned abstractions.
- [ ] No framework noun appeared that the model did not ask for.
- [ ] A reader can reconstruct stages 1–5 from the types alone.

## Anti-patterns

**Reverse path.** Picking Nest, hexagonal folders, event sourcing, or "the service pattern" and pouring the problem in. This is the failure mode `review-conceptual-integrity` exists to catch. Do not start there.

**Hidden state.** Caches treated as truth, derived fields written back, two writers for one row, agent memory becoming business record.

**Verb objects.** `MessageProcessor.process()` as the model. The model is `MessageReceived` on a conversation.

**Mechanism-first.** "We'll put it on the queue and figure out exactly-once later." Exactly-once (or at-least-once + idempotency) is an invariant. Choose it in stage 3, not in ops.

**Abstraction souvenir.** A `BaseEntity`, `GenericRepository`, or `Outcome<T>` brought along from the last project. It did not walk this path.

**Design by folder.** `domain/`, `application/`, `infrastructure/` created before state is known. Folders are not a conceptual model.

## Pass / fail tests

**Pass.** A one-page note lists states, transitions, and three invariants. The PR is mostly a function `apply(state, transition)` plus a small writer. Review against `review-conceptual-integrity` is boring, which is the goal.

**Pass.** Bigtable-shaped: one data model sentence, then mechanisms. Callers never see tablet-server internals.

**Fail.** Implementation begins with `generate module UserService`. Types appear after classes.

**Fail.** The first commit is a folder tree and empty ports. The problem statement is still missing.

**Fail.** Two modules mutate `leads.status` for different reasons, with no named owner and no named transitions.

**Fail.** A workflow engine is introduced to sequence three steps that are already a state machine.

## Concrete examples

### Design note (what to write before code)

```
Problem: inbound provider webhooks must become messages on exactly one conversation.
Constraints: at-least-once delivery from the provider; we must not double-apply side effects.
Invariant: same provider message id ⇒ one conversation row, one effect set.
State: Conversation { id, status, messages[] }; authoritative in Postgres.
Transitions: MessageReceived | AgentReplied | Closed.
Mechanism: persist conversation + outbox row in one transaction; dispatcher reads outbox.
Abstraction: none beyond Conversation and the apply() function. Provider HTTP is an adapter.
```

### Implementation that follows the note

```ts
type Status = "open" | "waiting" | "closed"

type Conversation = {
  id: string
  status: Status
  messages: InboundMessage[]
}

type Transition =
  | { type: "message_received"; inbound: InboundMessage }
  | { type: "closed"; reason: string }

export function apply(
  conversation: Conversation,
  transition: Transition,
): { conversation: Conversation; effects: Effect[] } | { error: "illegal" | "duplicate" } {
  if (transition.type === "message_received") {
    if (conversation.status === "closed") return { error: "illegal" }
    if (conversation.messages.some((m) => m.id === transition.inbound.id)) {
      return { error: "duplicate" }
    }
    return {
      conversation: {
        ...conversation,
        messages: [...conversation.messages, transition.inbound],
        status: "waiting",
      },
      effects: [{ type: "notify_assignee", conversationId: conversation.id }],
    }
  }
  return {
    conversation: { ...conversation, status: "closed" },
    effects: [],
  }
}
```

Persistence wraps `apply`. It does not replace it.

### Reverse-path counterexample (do not do this)

```ts
export abstract class BaseHandler<T extends ICommand> {
  abstract execute(cmd: T, ctx: RequestContext): Promise<Result<void>>
}
export class InboundWebhookOrchestrator extends BaseHandler<WebhookCommand> {
  constructor(
    private readonly pipeline: IMiddleware[],
    private readonly uow: IUnitOfWork,
  ) { super() }
}
```

No problem, no invariants, no state, no transitions. A reviewer using `review-conceptual-integrity` will reject this, correctly.

## What NOT to do

- Do not duplicate `review-conceptual-integrity`. No scoring, no coverage labels, no "confirmed / inferred / unknown" evidence protocol unless you are also reviewing.
- Do not skip stages because the feature "is small." Small features are how accidental ontologies start.
- Do not prescribe DDD, hexagonal, event sourcing, CQRS, actors, or microservices without pressure from stages 2–5.
- Do not treat this skill as a substitute for `design-deep-modules`. After the model exists, give it a deep interface.
- Do not write the abstractions first "so the team can parallelize." Parallel work on the wrong ontology is waste.
- Do not let AI start from a framework template. Give it the design note from stages 1–7 and forbid new nouns.

## Related skills

- `review-conceptual-integrity` — review-time owner of the same order. Use it after this, not instead of it.
- `design-deep-modules` — shape of the module that hosts the state machine.
- `design-simplicity-default` — burden of proof on every extra concept this walk might be tempted to add.
- `simplicity-complexity-bar` — keep the implementation of `apply` obvious; essential complexity lives in the transitions, not in types.
- `codebase-design` — glossary if you need to talk about the seam around the model.
