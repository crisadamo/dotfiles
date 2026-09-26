# Engineering Design Standard

Use this reference to design or evaluate modules, architectures, public APIs, distributed behavior, and data ownership.

## Contents

1. Quality model
2. Complexity and abstraction
3. System structure and ownership
4. System-design principles
5. Failure and distributed behavior
6. API and SDK design
7. Change and migration
8. Contextual choices

## 1. Quality Model

Evaluate quality across four boundaries:

| Boundary | Required question |
|---|---|
| Trust | Where does an external claim become a valid domain fact? |
| Effects | Where do time, randomness, I/O, persistence, concurrency, and vendors enter? |
| Failure | What can partially succeed, repeat, time out, cancel, overload, or become unavailable? |
| Change | How do old callers, deployments, data, and operators coexist with the new version? |

Treat quality as sustained changeability under real constraints, not conformance to a pattern catalog.

## 2. Complexity and Abstraction

### Detect complexity

Use three symptoms:

- **Change amplification:** one conceptual change requires edits across many locations.
- **Cognitive load:** a developer must retain many facts to make a safe change.
- **Unknown unknowns:** important dependencies or failure behavior are difficult to discover.

### Prefer deep modules

A useful module exposes a smaller interface than the complexity it hides. It owns a coherent decision, invariant, protocol, policy, or lifecycle.

Reject abstractions that:

- forward nearly every parameter unchanged;
- mirror a framework or database table without domain policy;
- offer generic names such as manager, helper, service, base, or utils without a clear contract;
- require callers to reproduce validation, ordering, retries, serialization, or provider rules;
- anticipate hypothetical variation with no credible change scenario.

### Design it twice

For medium/high-risk choices, compare a simple design with the strongest credible alternative. Simulate:

- the next likely feature;
- a dependency replacement;
- a failure and recovery path;
- an old/new compatibility period;
- an operator diagnosing an incident.

Prefer the design with lower total cognitive and migration cost, not automatically the fewest current lines.

### Keep layers distinct

Each layer must add a different abstraction:

- domain: facts, invariants, decisions, state transitions;
- application: use-case orchestration and owned capabilities;
- adapters: translation to storage, transport, frameworks, and vendors;
- bootstrap: configuration and composition.

Collapse layers that only rename calls. Keep small capabilities small; do not force a folder template.

## 3. System Structure and Ownership

### Organize around capabilities

Prefer vertical capability ownership over repository-per-table or global mega-services. A capability should expose a factory or API that hides its implementation and dependencies.

### Own durable facts

For every important fact, define:

- authoritative source;
- allowed writers;
- concurrency/consistency rule;
- representation version;
- derived projections and rebuild path;
- retention/deletion behavior;
- migration owner.

Caches, search indexes, UI state, and streams are projections unless explicitly designed as authority.

### Enforce dependency direction

Keep domain policy independent from HTTP frameworks, ORM clients, queue SDKs, environment globals, and vendor SDKs when practical. Let adapters depend on application-owned ports. Enforce important directions with package boundaries, export maps, lint rules, or architecture tests.

### Default to a modular monolith

Split a service only when there is concrete pressure for independent deployment, scaling, fault isolation, data ownership, security isolation, or team autonomy. A network boundary adds latency, partial failure, compatibility, observability, and coordination cost.

## 4. System-Design Principles

Apply these principles as questions, not slogans:

- **Make assumptions explicit.** Record invariants, scale, trust, failure, and stakeholder constraints.
- **Adopt sweeping simplifications.** Remove states, modes, writers, or protocols when one simpler model can serve.
- **Avoid excessive generality.** Generalize only around credible reuse or volatile policy.
- **Design for iteration.** Expect revision and make interfaces, data, and rollout changeable.
- **Use end-to-end reasoning.** Put correctness checks at the layer with enough knowledge; infrastructure may assist but not replace them.
- **Maintain safety margins.** Define capacity, timeout, retry, quota, and data-loss boundaries before reaching them.
- **Prefer one writer.** Single ownership simplifies coordination; otherwise define conflict resolution explicitly.
- **Never modify the only copy.** Use transactional, versioned, or recoverable mutation for critical state.
- **Separate mechanism from policy.** Stabilize mechanisms; keep product decisions explicit and replaceable.
- **Use fail-safe defaults and complete mediation.** Deny or preserve safety when information is missing, and authorize every protected operation.
- **Minimize common mechanism and privilege.** Shared infrastructure and broad authority increase blast radius.
- **Match interfaces to user mental models.** Defaults and names are product decisions.

## 5. Failure and Distributed Behavior

### Model failure

Distinguish:

- expected domain outcome;
- invalid input;
- authorization failure;
- retryable dependency failure;
- terminal dependency failure;
- cancellation/deadline;
- overload/rejection;
- programmer defect or broken invariant.

Use stable machine-readable identity, preserve causes, and translate once at the owning boundary.

### Treat time as part of the contract

Propagate caller-owned deadlines and cancellation. Bound concurrency, queues, memory, response sizes, and retries. Avoid layered retry amplification.

Use bounded exponential backoff with jitter at one layer under a retry budget. Record attempts and final classification.

### Assume repetition and partial success

For webhooks, messages, jobs, client retries, and workflow steps:

- use stable idempotency keys;
- atomically persist dedupe with the durable effect when possible;
- reject key reuse with a different payload;
- use outbox/inbox or reconciliation where systems cannot share a transaction;
- prefer idempotent state-setting to blind increments.

Keep the guarantee precise:

- deduplicating delivery does not prove an external effect ran only once;
- an idempotency key is only as strong as the downstream system's documented retention, conflict, and lookup behavior;
- a local lock, lease, or status row cannot resolve a crash or timeout after the external system accepted work;
- at-least-once attempts require an idempotent effect or reconciliation;
- a single-attempt strategy may execute zero or one time and needs an explicit recovery policy;
- an ambiguous outcome must be queried or reconciled before another non-idempotent attempt.

Do not claim exactly-once or business-level at-most-once behavior without an end-to-end argument covering every durable and external boundary.

### Choose the correct coordination primitive

| Primitive | Use for | Central question |
|---|---|---|
| Queue/event stream | decoupling, buffering, fan-out | How are duplicate and out-of-order deliveries handled? |
| Durable workflow | resumable multi-step coordination | What is deterministic and what is a journaled effect? |
| Actor | serialized per-entity state/connections/timers | What is the partition key and durable truth? |
| Statechart | genuinely modal/hierarchical state | Does explicit transition modeling reduce total complexity? |

## 6. API and SDK Design

Design from the consumer's task backward.

Require:

- one obvious common path;
- domain language rather than implementation language;
- small stable surface and useful inference;
- runtime validation at external boundaries;
- explicit errors, cancellation, timeouts, and long-running behavior;
- pagination from the first list API;
- predictable defaults and idempotency where mutation may repeat;
- provider-specific escape hatches without leaking them into the common model;
- examples for success, failure, and migration;
- additive evolution, deprecation, and compatibility policy.

Separate presentation, domain, persistence, specification, and vendor-wire shapes. Translate at owned boundaries; do not let one transport or provider become the domain model.

Use inference-first contracts only when deployments are coordinated. Use an explicit runtime/wire specification for public, polyglot, or independently deployed clients.

Test the built package, declarations, export map, runtime variants, and representative consumers—not only source imports.

## 7. Change and Migration

Prefer additive parallel change:

1. expand schema/API/representation;
2. deploy compatible readers and writers;
3. backfill or migrate with observable progress;
4. switch authority/read paths;
5. validate invariants and rollback assumptions;
6. contract old paths after evidence shows they are unused.

Keep old-format fixtures. Support concurrent old/new deployments. Define rollback after data has changed, not only before deployment.

Give feature flags and compatibility shims an owner, expiry, off-path test, and deletion trigger.

Prefer a local seam and incremental improvement. Require evidence before replacing a working architecture wholesale.

## 8. Contextual Choices

Do not equate these with seniority:

- Effect or another effect system;
- functional or object-oriented style;
- DDD tactical patterns;
- microservices or monorepos;
- event sourcing/CQRS;
- actors or state machines;
- advanced type programming;
- code generation.

Choose them only when the problem's state, failure, concurrency, ownership, compatibility, or lifecycle model repays the learning and operational cost.
