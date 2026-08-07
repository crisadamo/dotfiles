# Review and Verification Standard

Use this reference to classify risk, prepare or review designs, audit code, plan verification, and determine release readiness.

## Contents

1. Risk tiers
2. Design brief
3. Pre-mortem
4. Review scorecard
5. Risk-to-evidence matrix
6. Verification order
7. Hard stops
8. Handoff format

## 1. Risk Tiers

| Tier   | Examples                                                                                                                                  | Implementation/release process                                                                       |
| ------ | ----------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| Low    | local reversible implementation inside one module                                                                                         | contract, focused test, diff review                                                                  |
| Medium | new capability, cross-module dependency, internal API, meaningful state change, moderate migration                                        | short design brief, credible alternative, seam evidence, independent review                          |
| High   | public API, durable schema, auth/security, money, distributed coordination, new service, foundational abstraction, irreversible migration | full brief, two designs, pre-mortem, staged rollout, rollback, independent reviewers, broad evidence |

Risk follows blast radius, irreversibility, data/security exposure, distributed failure, and compatibility—not line count.

For review-only work, use the tier to determine scrutiny and severity. Do not require the reviewer to author the full implementation process when the supplied artifact cannot establish it; report missing design or runtime evidence as a scoped finding or limitation.

## 2. Design Brief

For medium/high-risk work, document:

1. Problem, consumers, stakeholders, and non-goals.
2. Requirements, invariants, and success measures.
3. Existing behavior and constraints.
4. Trust boundaries, authorization, and sensitive data.
5. Source of truth, writers, consistency, and concurrency.
6. Proposed modules, APIs, and dependency direction.
7. Failure, timeout, retry, cancellation, idempotency, and overload behavior.
8. Scale assumptions and safety margins.
9. Strongest credible alternative and why it loses.
10. Likely future-change simulations.
11. Migration, compatibility, rollout, rollback, and cleanup.
12. Observability and verification evidence.
13. Open questions and assumptions still needing evidence.

Revise the brief after criticism and implementation learning. Do not preserve a false history.

## 3. Pre-Mortem

Ask before implementation or release:

- What if each dependency is slow, unavailable, or returns malformed data?
- What if an external effect succeeds and the local durable write fails?
- What if the same operation runs twice or out of order?
- What if two writers race?
- What if old and new deployments overlap?
- What if migration stops partway?
- What if authorization context is missing or stale?
- What if load, payload size, or cardinality is 10x?
- What if cancellation occurs at every await/effect boundary?
- What evidence lets an operator distinguish these cases?

Require the design to answer relevant scenarios or explicitly accept the risk.

## 4. Review Scorecard

Evaluate each dimension as **missing**, **plausible**, or **evidenced**. Do not average away a critical missing dimension.

| Dimension       | Review questions                                                                             |
| --------------- | -------------------------------------------------------------------------------------------- |
| Contract        | Are outcome, invariants, failures, non-goals, and compatibility explicit?                    |
| Trust/security  | Are all inputs, identities, authority, and safe defaults enforced at every operation?        |
| Complexity      | Does the abstraction hide a decision? Is change amplification bounded?                       |
| Ownership       | Is durable truth and writer/consistency policy explicit?                                     |
| API             | Is the common path obvious, behavior stable, and evolution additive?                         |
| Time/failure    | Are deadlines, cancellation, retries, idempotency, and partial success designed?             |
| Migration       | Can old/new code and data coexist? Is rollback real after mutation?                          |
| Evidence        | Do tests/prototypes/measurements falsify the important risks at real seams?                  |
| Operations      | Are outcomes, versions, attempts, dependencies, correlation, and redaction observable?       |
| Discoverability | Can a new human or agent find ownership, entrypoints, commands, invariants, and constraints? |

For high-risk work, require every critical dimension to be evidenced before release or formally accepted by the accountable owner.

### Findings-first code review

Lead with actionable defects, ordered by consequence:

- **P0:** active or imminent catastrophic failure; stop release or operation.
- **P1:** likely correctness, security, data-loss, or severe reliability defect; fix before merge/release.
- **P2:** material maintainability, compatibility, diagnosability, or edge-case risk; fix deliberately.
- **P3:** optional improvement with bounded impact; do not present as a blocker.

For each finding, provide the smallest useful code/location reference, a concrete trigger or failure scenario, the user/system consequence, what evidence supports the claim, and a focused fix direction. Do not inflate style preferences into defects. If review scope is limited to a snippet or document, state which repository, runtime, deployment, and test claims remain unverified.

## 5. Risk-to-Evidence Matrix

| Risk                    | Evidence                                                               |
| ----------------------- | ---------------------------------------------------------------------- |
| Pure decision/invariant | unit table and property test where combinatorial                       |
| Parser/codec            | invalid/boundary cases, round trip, old fixtures                       |
| Type/public declaration | type tests and built consumer fixture                                  |
| Adapter/provider        | shared contract suite; controlled failure fake                         |
| Database semantics      | real-engine integration, concurrency/transaction tests                 |
| Schema migration        | old/new reader-writer matrix, backfill and rollback rehearsal          |
| Distributed delivery    | duplicate, out-of-order, timeout, retry, and reconciliation tests      |
| Workflow/replay         | deterministic clock, replay, cancellation, serialization versions      |
| API compatibility       | old-client/downstream contract and additive diff checks                |
| Performance/capacity    | representative workload with defined safety margin                     |
| Security                | threat-boundary review, authorization negative tests, redaction checks |
| Critical journey        | focused end-to-end test in the supported runtime                       |

Mocks establish behavior of the code under an assumption; they do not establish the assumption is true.

## 6. Verification Order

1. Reproduce the bug or core invariant.
2. Run the narrowest unit/property/type/contract test.
3. Run the affected package's type check and tests.
4. Exercise the real changed boundary.
5. Exercise relevant failure and compatibility scenarios.
6. Run lint, formatting, build, and package checks.
7. Run broader integration/end-to-end/downstream suites in proportion to blast radius.
8. Inspect the final diff and generated/migration artifacts.
9. Record commands, results, limitations, and residual risk.

## 7. Hard Stops

Do not call the work complete when a relevant item is unresolved:

- external data is trusted through a cast rather than evidence;
- authorization is missing, bypassable, or checked only on some paths;
- an important fact has unclear ownership or multiple uncoordinated writers;
- retries can repeat a non-idempotent effect;
- remote work has no deadline/cancellation or unbounded concurrency;
- public/durable behavior changes without compatibility and migration;
- rollback assumes durable mutation did not occur;
- a critical database/runtime/provider claim is tested only by mocks;
- sensitive data may enter logs, errors, traces, or analytics;
- the operator cannot distinguish failure classes;
- required verification did not run and the limitation is hidden.

Escalate rather than inventing missing authority, requirements, or production evidence.

## 8. Handoff Format

Use this structure for design and implementation handoff. For code review, use the findings-first format in section 4, followed by verification limits and residual risk.

Lead with the outcome, then report:

### Contract

- outcome, scope, invariants, and compatibility;

### Design

- boundaries, ownership, public APIs, and important tradeoffs;

### Failure and operations

- error/time/concurrency/idempotency behavior and telemetry;

### Evidence

- exact verification performed and results;

### Remaining risk

- assumptions, unverified surfaces, rollout/rollback, and next action.

Keep reports proportionate. Do not bury the outcome under process narration.
