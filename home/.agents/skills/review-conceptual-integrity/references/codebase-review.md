# Whole-Codebase Conceptual Integrity Review

Use this mode for a repository, application, package family, subsystem, or architecture audit without a primary diff.

## Contents

1. Set scope and confidence
2. Discover the running system
3. Build the system overview
4. Trace behavioral vertical slices
5. Map authority and persisted contracts
6. Derive invariants and transitions
7. Model failure and operations
8. Review ontology, boundaries, and dependencies
9. Establish the minimal system
10. Score conceptual integrity
11. Produce the report

## 1. Set scope and confidence

Define the review boundary: entire repository, selected applications, packages, deployables, or one subsystem. State exclusions explicitly.

Record evidence sources:

- repository instructions and standards;
- manifests, workspaces, build graph, and entrypoints;
- deployment and runtime configuration;
- database schemas, migrations, durable storage, caches, queues, and event contracts;
- public APIs, routes, commands, jobs, and workers;
- domain and application modules;
- tests, fixtures, generated artifacts, and architecture documents;
- representative history when it explains current boundaries.

Classify review confidence:

- **High:** critical runtime roots, vertical paths, persistence, effects, and validation were traced.
- **Medium:** the main architecture is evidenced but important runtime or operational paths remain unverified.
- **Low:** conclusions rely mainly on names, folder layout, or documentation.

Do not claim a whole-codebase review from a file inventory. Report coverage gaps.

## 2. Discover the running system

Identify what actually executes:

- deployable applications and processes;
- HTTP, RPC, CLI, event, scheduled, and background entrypoints;
- runtime composition roots and dependency construction;
- authoritative databases and write paths;
- caches, search indexes, projections, queues, logs, and workflow stores;
- external systems and irreversible side effects;
- schema generation, migrations, and compatibility boundaries;
- configuration and feature gates that select behavior.

Treat docs, directory names, unused code, and generated diagrams as hypotheses until connected to a runtime root or durable contract.

Build a coverage matrix before judging:

| Area | Entrypoint traced | State traced | Effects traced | Tests inspected | Confidence |
|---|---:|---:|---:|---:|---|

Choose areas based on business criticality and architectural leverage, not evenly by folder count.

## 3. Build the system overview

Explain the system at four levels.

### Level 1 — Observable purpose

State in one to three sentences what outcomes the system produces for users or other systems.

### Level 2 — Domain decomposition

List the few major domain capabilities and the vocabulary each owns. Identify shared concepts and suspected synonym drift.

### Level 3 — Runtime topology

Map deployables, synchronous calls, asynchronous delivery, storage, external systems, and operational control paths. Use a small diagram only when it makes ownership or flow materially clearer.

### Level 4 — Authority and dependency direction

State which components own business truth, which coordinate execution, which provide derived views, and which adapt external systems. Identify dependencies that point against the intended authority direction.

The overview must distinguish business authority from execution infrastructure.

## 4. Trace behavioral vertical slices

Select representative flows that expose the architecture. Include at least:

- one common successful write path;
- one read or query path;
- one asynchronous, retried, or scheduled path when present;
- one failure, cancellation, or repair path for a critical operation.

For each slice trace:

`ingress -> authorization/validation -> domain decision -> state transition -> persistence -> effects -> observation/repair`

Record:

- conceptual hops and translations;
- where invariants are checked;
- transaction boundaries;
- duplicate and concurrency behavior;
- canonical versus derived state;
- how errors become visible and repairable;
- which tests prove the path.

Use vertical slices to verify or falsify the folder-level architecture.

## 5. Map authority and persisted contracts

Create a state authority matrix:

| State or contract | Meaning | Authority | Writers | Derived copies | Transaction boundary | Conflict winner |
|---|---|---|---|---|---|---|

Include business entities, event logs, workflow state, idempotency records, outboxes, caches, search indexes, files, and external-provider state when they affect correctness.

Inspect persisted schemas and migrations, not only TypeScript or application types. Determine:

- uniqueness and referential constraints;
- versioning or concurrency controls;
- lifecycle and terminal states;
- nullability and impossible-state representation;
- backward/forward compatibility;
- whether data repair is possible;
- whether two stores compete as truth.

Flag authority that exists only by convention and invariants that durable storage could enforce but does not.

## 6. Derive invariants and transitions

For each critical capability, state:

`state + command/event -> new state + committed effects`

Identify valid, invalid, irreversible, non-commutative, and race-prone transitions. Separate business events from transport or implementation events.

Build an invariant register:

| Invariant | Enforcement point | Durable evidence | Tests | Gaps |
|---|---|---|---|---|

Look for:

- rules duplicated across entrypoints;
- transitions performed outside their owner;
- invariants split between application code and consumers;
- invalid states made representable by the model;
- assumptions about event order or timing that are not encoded.

## 7. Model failure and operations

For critical sequences, stop execution before and after each persistence or external-effect boundary. Examine:

- acknowledged work lost before durable commit;
- commit followed by failed dispatch;
- external success followed by timeout or crash;
- duplicate, reordered, or poison delivery;
- concurrent writers and stale reads;
- dependency outages and retry storms;
- schema or contract skew during deployment;
- manual repair of one broken entity;
- observability of pending, ambiguous, failed, and terminal states.

Identify whether recovery follows from durable state or from temporal hope. Separate queue delivery from business correctness.

Assess operability:

- Can an operator find the authoritative state?
- Can ambiguous outcomes be reconciled?
- Are retries bounded, visible, and repairable?
- Can one entity be replayed or repaired safely?
- Do metrics and logs express domain transitions or only infrastructure activity?

## 8. Review ontology, boundaries, and dependencies

Build a concept inventory grouped by:

- domain entities and value concepts;
- commands, events, and transitions;
- application operations;
- state owners and persistence concepts;
- infrastructure adapters and external providers;
- cross-cutting policies;
- generic frameworks and extension points.

Identify duplicate names, synonyms, concepts with several meanings, and abstractions whose responsibility cannot be stated precisely.

Map important dependencies and test whether boundaries correspond to domain ownership, transactions, failure, deployment, external systems, security, performance, scaling, or organizational autonomy.

Evaluate local reasoning:

- Can a behavior be found where an engineer predicts?
- How many conceptual hops are required?
- Do policy and mechanics mix?
- Are package boundaries stronger than import paths suggest?
- Does shared code contain real stable concepts or merely convenience?

## 9. Establish the minimal system

Describe the smallest architecture that could preserve the identified invariants and constraints. This is a comparison baseline, not a rewrite proposal.

Classify current machinery:

- **ESSENTIAL:** forced by reality or a hard constraint.
- **JUSTIFIED:** earns its operational or conceptual cost.
- **QUESTIONABLE:** pressure is not established.
- **REMOVE/COLLAPSE:** materially obscures the system without protecting a needed property.

Then perform a compression pass:

- collapse competing authorities;
- merge overlapping concepts;
- remove pass-through layers;
- replace speculative interfaces with concrete code;
- centralize invariant enforcement;
- make derived state explicitly disposable;
- replace framework vocabulary with domain transitions;
- align packages and runtime boundaries with real ownership.

Prefer small, reviewable simplification slices. Do not propose a grand rewrite unless the conceptual model is irreparably false and evidence supports that conclusion.

## 10. Score conceptual integrity

Score each dimension from 1 to 5:

1. Problem decomposition
2. Domain and ontology precision
3. Invariant quality
4. State ownership clarity
5. Boundary and dependency quality
6. Abstraction necessity
7. Failure and concurrency clarity
8. Local reasoning
9. Operability and repairability
10. Overall simplicity

Use:

- **5:** exceptionally clear, coherent, and near-minimal;
- **4:** strong with localized drift;
- **3:** workable but meaningfully improvable;
- **2:** systemic conceptual friction;
- **1:** fundamentally confused or unsafe.

Report `Total: X / 50`. Do not inflate scores. Explain each dimension with evidence.

## 11. Produce the report

Use this structure.

### 1. Executive Judgment

Choose exactly one:

- **CONCEPTUALLY STRONG**
- **STRONG WITH LOCALIZED DRIFT**
- **WORKABLE BUT NEEDS TARGETED SIMPLIFICATION**
- **SYSTEMIC CONCEPTUAL FRICTION**
- **CONCEPTUAL MODEL NEEDS REWORK**

Give the highest-leverage reason and confidence level.

### 2. System in One Sentence

State the observable system purpose without framework terminology.

### 3. Scope, Evidence, and Coverage

List reviewed areas, exclusions, refs or revision state, coverage matrix, validation performed, and confidence limitations.

### 4. Detailed System Overview

Provide:

- observable purpose;
- domain decomposition;
- runtime topology;
- authority and dependency direction;
- major external systems and effects.

### 5. Behavioral Breakdown

Summarize each traced vertical slice, its transitions, transaction boundaries, and failure behavior.

### 6. State and Authority Map

Present the authority matrix and call out duplicate or ambiguous truth.

### 7. Invariants and Failure Model

Present the invariant register, strongest guarantees, missing enforcement, races, retries, ambiguous outcomes, and repair paths.

### 8. Concept and Boundary Assessment

Describe vocabulary quality, concept count, dependency direction, abstraction pressure, local reasoning, and change amplification.

### 9. Conceptual Integrity Score

Present all ten dimensions and the total.

### 10. Findings

Order findings by impact. Use:

#### `[SYSTEMIC | HIGH | MEDIUM | LOW] Finding title`

- **Evidence:** Exact paths and lines.
- **Observed:** What the system does.
- **Why this matters:** Consequence for correctness, comprehension, or change cost.
- **Pressure test:** The question the architecture must answer.
- **Simpler model:** A materially simpler alternative when one exists.
- **Validation gate:** Evidence or experiment needed before acting.

### 11. Essential vs Accidental Complexity

List the major concepts and classify them as ESSENTIAL, JUSTIFIED, QUESTIONABLE, or REMOVE/COLLAPSE.

### 12. Compression Opportunities

Propose the smallest ordered simplification slices. For each give expected conceptual deletion, protected invariant, migration risk, and validation gate.

### 13. Strong Decisions Worth Preserving

Identify mechanisms that genuinely protect invariants or make the system easier to reason about. Do not add praise without evidence.

### 14. Open Questions

List unknowns that could materially change the review. Distinguish missing evidence from design defects.

### 15. Final Mental Model

Explain the intended architecture in three to seven sentences using domain, authority, transition, and guarantee language. This is the compact model an engineer should retain.
