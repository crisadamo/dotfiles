---
name: deliver-high-quality-software
description: Design, implement, refactor, review, and deliver production software with explicit contracts, complexity-reducing abstractions, failure-aware architecture, safe API evolution, observable boundaries, and risk-based verification. Use for non-trivial software features, APIs and SDKs, libraries, services, workflows, data models, migrations, architecture decisions, reliability improvements, correctness-sensitive TypeScript or TSX work, and requests for senior- or staff-level engineering quality, robust production code, maintainability, best practices, or detailed design review. Apply the standard proportionately and incrementally without turning focused work into an unauthorized rewrite.
---

# Deliver High-Quality Software

Deliver the smallest complete solution that remains trustworthy across four boundaries:

- **Trust:** convert untrusted facts into valid domain values.
- **Effects:** make time, I/O, concurrency, storage, and vendor interactions explicit.
- **Failure:** design partial success, cancellation, retry, duplication, and overload.
- **Change:** protect existing callers, deployments, data, operators, and maintainers.

Optimize sustainable delivery speed through correctness, explicit modeling, maintainability, and diagnosability. Prefer evidence and local context over prestige, fashion, or abstract purity.

## Load the Relevant Standard

Read only the references the task requires:

- Read [references/engineering-standard.md](references/engineering-standard.md) for architecture, module boundaries, domain design, APIs, distributed behavior, data ownership, or any medium/high-risk change.
- Read [references/typescript-standard.md](references/typescript-standard.md) for TypeScript, TSX, JavaScript-with-types, npm packages, public generic APIs, or runtime-schema work.
- Read [references/review-and-verification.md](references/review-and-verification.md) for code/design review, risk classification, verification planning, migrations, security-sensitive changes, or release readiness.

For a small local change, use the core workflow without loading every reference.

When several references apply, synthesize them into one contract/design/failure/evidence narrative. Use their checklists to find omissions, not as repeated output templates.

## Establish Authority and Scope

1. Determine whether the user asked to explain, review, diagnose, design, implement, or publish.
2. Keep review and diagnosis read-only unless implementation is also authorized.
3. For repository-backed work, read the instructions, configuration, nearby code, tests, public call sites, and current data/API contracts needed for the requested scope before proposing a structure.
4. Trace the relevant real path across entrypoint, domain behavior, effects, persistence, external dependencies, and observable output; keep a local pure change local.
5. Separate verified facts, inferences, and open questions.
6. Preserve existing behavior unless a breaking change is explicit and includes a migration path.
7. Prefer a focused patch and a local seam. Propose broad rewrites separately with evidence that their value exceeds migration and compatibility cost.

For a standalone design with no repository or current-contract access, state conditional assumptions, identify decisions that need owner/provider evidence, and make unresolved release blockers explicit. Do not invent local constraints.

## Classify Risk

Choose a proportional workflow:

- **Low:** local, reversible change inside one module with no durable/public contract change. State the contract, implement, and run focused checks.
- **Medium:** new capability, cross-module dependency, internal API, meaningful state transition, or moderate migration. Write a short design brief, compare a credible alternative, and obtain evidence at the changed seam.
- **High:** public API, durable schema, auth/security, money, distributed coordination, new service, foundational abstraction, or irreversible migration. Use the full design and pre-mortem workflow in the review reference before implementation.

Do not lower the risk tier merely because the diff is small.

For a review-only request, the tier controls scrutiny and severity, not authorization to produce or implement a complete redesign. Lead with evidenced findings and identify context that the supplied artifact cannot establish.

## Define the Contract

Before implementation, state as much of the following as the risk warrants:

- intended outcome and consumer;
- invariants and valid state transitions;
- ordering of parsing, normalization, validation, defaulting, and mutation when order changes meaning;
- non-goals and smallest acceptable scope;
- trust boundaries and authorization requirements;
- source of truth, ownership, and consistency rule;
- expected failures and caller-visible behavior;
- time, concurrency, ordering, delivery/attempt semantics, and idempotency requirements;
- compatibility with old clients, deployments, and stored data;
- scale, resource, security, and operational constraints;
- verification evidence and rollback condition.

If essential behavior remains ambiguous, resolve it from source evidence or ask only the question that materially changes the solution.

## Design Deliberately

1. Start with the simplest design that satisfies the contract.
2. For medium/high-risk work, compare at least one credible alternative. Evaluate likely change, failure, migration, and debugging scenarios rather than aesthetic preference.
3. Organize around capabilities and reasons to change. Give every important fact one durable owner.
4. Create deep modules: expose a small honest interface that hides a meaningful decision or complexity.
5. Keep domain policy independent from delivery frameworks and infrastructure when that separation makes invariants clearer.
6. Own ports in the application/domain language; translate vendors, storage, transport, and framework shapes in adapters.
7. Add an interface only for real volatility, substitution, policy enforcement, or a meaningful contract seam.
8. Pull complexity downward so callers do not repeat validation, ordering, retry, serialization, or provider rules.
9. Keep each layer at a different abstraction. Delete pass-through layers that only rename calls.
10. Use functions, classes, actors, statecharts, queues, workflows, code generation, or effect systems only when their lifecycle and failure model justify the cost.

## Rehearse Change and Failure

Before finalizing a non-trivial design, simulate:

1. the most likely next feature;
2. replacement or version change of a major dependency;
3. timeout, cancellation, partial failure, and recovery;
4. duplicate or out-of-order delivery where applicable;
5. concurrent old/new deployments and stored representations;
6. a production incident that another engineer must diagnose;
7. growth beyond the current safety margin.

Revise designs with excessive change amplification, cognitive load, hidden coupling, or unknown operational behavior.

## Implement With Explicit Evidence

- Validate external values at their boundary; pass trusted domain values inward.
- Encode meaningful invalid states out of the model when the protection exceeds the ceremony.
- Make expected failures, retryability, cancellation, resource lifetime, and partial success explicit.
- Keep framework entrypoints thin: authenticate, parse, invoke, translate, and emit telemetry.
- Preserve causal chains and stable error identity. Separate safe public messages from diagnostic detail.
- Propagate deadlines and cancellation through every remote capability.
- Bound concurrency and retries. Add jitter and idempotency where repetition is possible.
- Distinguish duplicate detection, idempotent retries, at-most-once attempts, at-most-once business effects, and exactly-once claims. Across an external effect, handle ambiguous outcomes through a provider-supported idempotency contract and result lookup/reconciliation; never infer the guarantee from a local lock or dedupe row.
- Keep durable schema and API evolution additive until old readers, writers, and callers have migrated.
- Use structured, correlated, redacted telemetry at ownership boundaries.
- Treat casts, unsafe adapters, reflection, generated boundaries, and concurrency assumptions as evidence obligations: state why they are sound and test or check the invariant.
- Match existing conventions unless they create a demonstrated correctness, security, compatibility, or operability risk.
- Avoid unrelated cleanup and speculative generality.

## Verify in Risk Order

1. Reproduce or test the core invariant first.
2. Test pure decisions and state transitions.
3. Test parsing, serialization, persistence, transactions, package exports, and adapters at the real promised seam.
4. Exercise failure paths: invalid input, timeout, cancellation, retry, duplicate delivery, partial success, replay, and old-version compatibility as applicable.
5. Run affected type checks, lint, tests, and builds.
6. Expand verification in proportion to blast radius: integration, end-to-end, migration, load, security, and downstream compatibility.
7. Inspect the final diff for accidental public changes, weakened checks, hidden state transitions, leaked sensitive data, stale flags, and unrelated churn.
8. Report exactly what ran, what passed, what could not run, and what risk remains.

Never substitute a mock for evidence about a real database, runtime, package, network protocol, or provider contract. Use local or in-memory substitutes only when their semantics faithfully represent the production contract.

## Self-Review Before Handoff

Confirm that:

- the solution satisfies the stated contract and non-goals;
- the abstraction hides complexity rather than relocating it;
- data ownership and dependency direction are explicit;
- error, timing, concurrency, and compatibility behavior are reviewable;
- API names and defaults match the consumer's mental model;
- the common path is simple and advanced capability has an escape hatch;
- verification maps to production risks rather than implementation details;
- operators can identify the operation, version, dependency, attempt, outcome, and safe context;
- rollout, rollback, migration, and cleanup are covered when required;
- instructions, entrypoints, commands, and invariants are discoverable to humans and coding agents.

If a critical dimension lacks evidence, do not present the work as complete.

## Communicate the Result

Lead with the outcome. Then state:

1. the contract and material design decisions;
2. the boundaries and invariants protected;
3. the important tradeoffs and rejected alternatives;
4. the verification evidence;
5. remaining risks, assumptions, and next actions.

Be precise about uncertainty. Do not claim guarantees, compatibility, performance, or verification that was not established.

For review requests, lead with actionable findings ordered by impact. Give each finding a tight location, failure scenario, consequence, evidence level, and fix direction. Distinguish defects from optional improvements; if there are no findings, say so and name residual verification gaps.
