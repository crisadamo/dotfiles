# Shared Conceptual Review Method

Apply this method in both PR and Whole-Codebase Review modes.

## Contents

1. Reconstruct the problem
2. Establish the minimal baseline
3. Pressure-test abstractions
4. Review naming and ontology
5. Test ownership and boundaries
6. Trace indirection and generalization
7. Classify complexity
8. Test failure and change behavior
9. Compress the model
10. Review AI-generated code

## 1. Reconstruct the problem

State the observable behavior in one or two sentences without borrowing implementation nouns.

Prefer:

> When a lead receives an inbound message, update its conversation state and trigger the required downstream effects.

Avoid:

> Add a `LeadProcessingOrchestrator`.

Identify shaping constraints such as concurrency, ordering, durability, latency, throughput, retries, idempotency, compatibility, transactions, external APIs, the persisted model, and operations. Separate explicit requirements from assumptions introduced by the implementation.

Make state explicit:

- What state exists?
- Which copy is authoritative?
- Who owns and may mutate it?
- Which copies are derived or duplicated?
- Where are the transactional boundaries?

Describe meaningful domain transitions before implementation calls. Prefer `MessageReceived`, `OpportunityAssigned`, or `AppointmentScheduled` over `process`, `handle`, `execute`, `run`, or `sync`.

Infer testable invariants, for example:

- An opportunity has at most one active owner.
- A message belongs to exactly one conversation.
- A transition commits before its effects become eligible for dispatch.
- Repeated delivery cannot duplicate a business effect.

Flag important invariants that remain invisible, scattered, or impossible to identify.

## 2. Establish the minimal baseline

Construct the dumbest plausible implementation that could satisfy known requirements.

Ask:

- What remains if frameworks and patterns are forbidden?
- What concepts survive if this must fit in one file or roughly 200 lines?
- What is the minimum machinery required by the constraints?
- Which exact requirement makes that baseline insufficient?

Do not automatically recommend the naive design. Use it as the control against which every additional concept must justify itself.

## 3. Pressure-test abstractions

For each significant abstraction determine:

1. What real domain or runtime concept does it represent?
2. Which invariant does it own or protect?
3. Why does it need independent identity, lifecycle, or state?
4. What exact property disappears if it is deleted?
5. Why is a function or module insufficient?
6. What evidence establishes abstraction pressure?

Legitimate pressure may include:

- multiple concrete implementations already exist;
- a volatile external dependency requires isolation;
- an invariant needs one enforcement point;
- state has an independent lifecycle;
- a transaction, security, failure, performance, deployment, or scaling boundary exists;
- policy genuinely varies.

Do not accept “separation of concerns,” “clean architecture,” “flexibility,” “best practice,” “future scalability,” or hypothetical second implementations without evidence.

Treat these names as review triggers, not automatic errors:

`Manager`, `Handler`, `Processor`, `Service`, `Helper`, `Utils`, `Coordinator`, `Orchestrator`, `Engine`, `Context`, `Provider`, `Factory`, `Strategy`, `Controller`, `Repository`, `Adapter`, `Base*`, `Abstract*`, `Generic*`, `Common*`, `Core*`.

For a stateless service, manager, helper, handler, or processor, explicitly ask: “Why is this not a function?”

Objects and classes earn their existence when they naturally represent identity, owned mutable state, lifecycle, real polymorphism, or an invariant-bearing aggregate.

## 4. Review naming and ontology

Treat naming problems as potential modeling problems.

For each important concept ask:

- Does this entity exist in the domain or runtime?
- Would experienced engineers infer approximately the same responsibility from its name?
- Is it distinct from neighboring concepts?
- Is one idea represented by several names?
- Does one name combine unrelated ideas?
- Does the name identify a thing or vaguely describe activity?

Search for synonym drift such as `Lead`, `Contact`, `Prospect`, `Customer`, `Opportunity`, `ConversationUser`, and `Participant`. Flag duplicate concepts, but do not collapse genuinely distinct domain meanings merely to reduce vocabulary.

Require responsibilities to be stated without repeating the concept's name.

Weak:

> `MessageProcessor` processes messages.

Strong:

> Converts provider webhooks into canonical inbound-message events.

## 5. Test ownership and boundaries

For every mutable state item, identify one conceptual authority and the permitted mutation paths.

Watch for:

- services mutating each other's tables;
- caches treated as authoritative;
- business rules split across unrelated handlers;
- the same transition implemented in several modules;
- consumers independently enforcing one invariant;
- runtime or agent infrastructure silently becoming business truth.

Require a boundary to correspond to a real property: domain ownership, transaction, failure, deployment, external system, security, performance, scaling, or organizational autonomy.

Reject boundaries justified only by folder conventions, mandatory service layers, repository conventions, vague coupling claims, or hypothetical future value.

## 6. Trace indirection and generalization

Follow important behavior end-to-end. Record each conceptual hop, not merely each file.

For a chain such as:

`route -> controller -> service -> manager -> processor -> repository -> ORM`

ask what semantics each hop contributes. A layer that only forwards parameters or renames data is suspicious.

Optimize for the fewest conceptual hops needed to understand behavior, not the fewest files.

Look for premature generalization:

- generic types with one concrete use;
- interfaces with one implementation;
- configuration for values that never vary;
- plugin systems with one plugin;
- factories with one product;
- strategies with one strategy;
- extension points without known extensions;
- reusable frameworks extracted before reuse exists.

Ask which concrete second use forced the abstraction. If none exists, require another strong boundary to justify it.

## 7. Classify complexity

Separate:

- **Essential complexity:** reality imposed by persistence, concurrency, ordering, distributed failure, retries, partial effects, external APIs, security, compatibility, or demonstrated performance requirements.
- **Accidental complexity:** indirection, speculative extension points, overlapping abstractions, generic APIs, framework ceremony, unnecessary state, duplicate representations, or needless translation.

Count the important concepts a developer must learn: domain objects, services, managers, interfaces, states, queues, events, processors, wrappers, configuration, and lifecycle concepts.

Ask whether the behavior justifies that concept count. A small feature adding many architectural nouns deserves strong scrutiny.

Perform the deletion test:

- Can behavior move to an existing owner?
- Can a wrapper or forwarding layer disappear?
- Can overlapping concepts collapse?
- Can a speculative interface or configuration be removed?
- Can objects become functions?
- Can explicit code replace a framework?

Do not delete mechanically. Compress the conceptual model while preserving correctness and ownership.

## 8. Test failure and change behavior

For stateful or distributed behavior, stop execution before and after every meaningful step. Examine duplicate execution, partial persistence, lost effects, reordering, retries, idempotency, races, stale reads, concurrent workers, ambiguous external success, and recovery.

Prefer failure handling that follows from the state model over patches distributed across handlers.

Apply the local reasoning test:

> How much unrelated code must an engineer understand to modify this behavior safely?

Apply the change amplification test using one likely requirement. Do not reward speculative extensibility; determine whether the change lands in the concept that logically owns it or requires scattered surgery.

## 9. Compress the model

Explain the design in three to seven sentences using domain and guarantee language. If explanation requires many implementation artifacts, investigate whether the design is over-modeled.

Ask repeatedly:

- What real concept is this?
- What invariant does it protect?
- Who owns this state?
- Why does it exist separately?
- What breaks if it is deleted?
- Why is it generic?
- What concrete second implementation exists?
- Could the caller do this directly?
- Is this one concept wearing several names?
- Are several concepts actually one?
- Can another engineer predict where this behavior lives?
- Can the system be explained without framework vocabulary?

## 10. Review AI-generated code

Assume generated code has a higher prior probability of speculative abstractions, defensive wrappers, generic helpers, redundant types, duplicated validation, excessive indirection, pattern imitation, verbose error handling, fake extensibility, obvious comments, and inconsistent vocabulary.

Do not reject code because it was generated. Review the result and ask whether cheap generation created expensive maintenance.
