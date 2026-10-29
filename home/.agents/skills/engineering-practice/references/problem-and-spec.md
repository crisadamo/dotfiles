# From idea to a testable contract

## Product intent

Begin with a concrete consumer and situation. Describe current behavior, why it hurts, and what becomes possible after the change. Include a representative journey and its unhappy path. For an API, the consumer writes the call and handles its result; for a service, include the operator diagnosing failure.

Write observable obligations with stable identifiers when several artifacts refer to them. Example: “R1: after a worker loses ownership, its late completion cannot replace the current result.” “Use a queue” is a design proposal unless it is an external constraint.

For success measures distinguish baseline, target, measurement, and source. When numbers are missing, state a planning assumption and validation task. Do not fabricate an SLO. Capture non-goals and existing behavior to preserve. Include accessibility, discoverability, feedback, and recovery where they affect the experience.

## Distinguish artifacts

| Artifact | Question | Does not replace |
| --- | --- | --- |
| Brief/PRD | Who needs what, why, and how will success be measured? | Correctness conditions |
| Behavioral spec | What observable behavior is allowed or forbidden? | Infrastructure choices |
| Design/sketch | How will the contract be implemented? | Product justification |
| ADR | Why this consequential choice; what would change it? | The full spec |
| Evidence record | Which claims were checked, how, and with what limits? | Actual verification |

A small feature can answer all five in one page. Update authoritative documents rather than creating competing versions. Use IDs/links instead of repeated paragraphs.

## State before mechanisms

1. Define terms and identities: tenant, business operation, attempt, resource version, event, session.
2. List authoritative variables, their owner, derived facts, and initialization.
3. Write invariants over reachable states, including authorization/tenant boundaries when relevant.
4. Define operations as guard → state change → result/allowed effect. Include rejection and retry semantics.
5. Identify the linearization/transaction point. Types do not make read/check/write atomic.
6. Define progress under explicit scheduler, worker, network, fairness, and dependency assumptions. Safety and liveness require different evidence.
7. State relevant failures: process loss, duplicates, reordering, network uncertainty, clock behavior, partial persistence, overload, malformed data.

Specify correctness before choosing classes, endpoints, databases, or engines. For a pure transformation, use input/output laws rather than a state machine.

For difficult concurrent protocols, use a small model or TLA+/PlusCal with explicit assumptions. Check safety across interleavings and look for deadlock/starvation. Record bounds/properties and map abstract transitions to implementation commit points. Model checking cannot establish a database's isolation or provider behavior.

## Plan for learning

Resolve the assumption most likely to invalidate the design first. Then deliver an end-to-end slice. Each slice needs an outcome, boundary, dependency, and acceptance evidence. Separate refactors from behavior changes when that improves review and rollback.

For durable/public changes, describe old/new readers and writers, deployment order, resumable backfill, and when cleanup becomes safe. Update the spec or implementation intentionally when evidence reveals a mismatch; state which changed and why.
