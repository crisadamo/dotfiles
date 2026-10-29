# Evidence, review, release, maintenance

## Trace claims to checks

Map requirement/invariant → failure scenario → enforcing boundary → check → result/limitation. Label `verified`, `model-only`, `inferred`, or `unknown`. A test name is not a passing test; a unit test is not production isolation evidence.

| Risk | Useful evidence |
| --- | --- |
| Domain decision | Examples, boundaries, properties, counterexample traces |
| Concurrency | Controlled interleavings plus real transaction/CAS integration |
| External effect | Provider contract, ambiguous-outcome recovery, idempotency/reconciliation |
| Protocol/package | Wire conformance, serialization, built consumers |
| Resource lifetime | Failure, cancellation, early exit, cleanup assertions |
| Migration | Old/new readers and writers, resumable backfill, restore rehearsal |
| Latency/capacity | Comparable workloads, baseline/treatment, percentiles, resource use |
| Authorization | Negative entrypoint tests with tenant/owner separation |
| Critical UX | User-visible outcomes, loading/error/recovery, accessibility |

Ask what relevant defect makes each test fail. Literal assertions, properties, snapshots, and negative assertions can all be useful. Do not mechanically ban absence checks or spies: “no unauthorized effect occurred” may be the requirement. Avoid asserting the fixture against itself or restating implementation constants without testing behavior.

Reproduce a bug before fixing it. Keep performance conditions comparable and report uncertainty. Use a targeted mutation or broken model when useful to confirm the check detects its intended defect; do not make mutation testing universal ceremony.

## Calibrate review

Establish intent, exact diff/base, and environment. Trace callers and owners. Prioritize correctness, security, compatibility, and material maintainability regressions. Inspect context to understand changed behavior, without turning the review into an unrelated audit.

Each finding needs location, reachable trace, violated contract, consequence, evidence, and fix direction. Separate defects, unresolved material risks, and optional alternatives. Challenge overcomplicated requirements as well as implementations.

Ask what each abstraction hides/owns and which change becomes local. Size, branches, casts, and repetition are investigation signals. `unknown` at a trust boundary is often correct. One evidenced bug outweighs unsupported reviewer consensus.

Accept a change that meets the contract, passes required checks, addresses material regressions, and improves or preserves code health. Do not require perfection. Surface unresolved decisions with alternatives and tradeoffs; stop broadening once scoped risks are sufficiently covered.

## Model reliability

At each remote/durable boundary establish authority, atomic commit, business-operation versus attempt identity, deduplication scope/retention, stale-owner behavior, reordering/lost acknowledgements, and uncertain outcomes. Include deadlines, cancellation, bounded work, overload, restart behavior, and recovery ownership.

An outbox couples local state with delivery intent, not exactly-once remote effects. A lease permits recovery but cannot prevent a paused worker from running later. Fence writes at the invariant's owner. Compensation is a new business action that can fail, not a database rollback.

## Release and maintain

Choose signals that answer “is this working?”: user outcome, failure rate, latency distribution, saturation/backlog age, recovery success. Ground thresholds in evidence or mark proposed targets. Assign owners, redacted correlation IDs, actionable alerts, and runbook entrypoints.

For durable changes specify compatibility window, deployment order, bounded/resumable backfill, and removal conditions. State whether rollback restores code, data, both, or neither. Rehearse repair/restoration when corruption/loss is a material risk. Retire old readers/writers before incompatible cleanup. Prepare rollout evidence before seeking any needed deployment approval.

After adoption/incidents compare outcomes with assumptions. Track escaped defects, change effort, recovery time, flaky tests, and caller friction when useful; avoid vanity scores. Turn repeated mistakes into stronger ownership, types, constraints, or regression scenarios. Update the single source of truth. Record intentional debt with consequence, owner, and removal trigger. Revisit ADRs when their assumptions fail.
