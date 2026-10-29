# Worked example: retryable report jobs

This is a design exercise and executable **decision core**, not a deployed queue. Its assumptions are intentionally explicit. The persistence/API adapter and production rollout remain design obligations.

## Product brief

A customer requests a report. Workers may crash or respond late. Customers need one stable visible terminal outcome and the ability to cancel. Operators need abandoned work to become eligible for recovery.

R1: an obsolete worker cannot replace the current report result.
R2: a committed terminal outcome never changes.
R3: abandoned work can be reclaimed, up to a configured attempt limit.
R4: invalid time/configuration cannot establish a lease.
Non-goals: scheduling fairness, progress percentages, billing, arbitrary external tool execution, physical cancellation of a paused process.

Proposed product signals: successful reports, queue age, completion latency, expired leases, stale completion rejections, attempts exhausted. Targets require observed workload and product agreement; none are invented here.

## Specification

One job has immutable policy, monotonic attempt number, and status: queued, running, succeeded, cancelled, or failed. Running owns an expiry; succeeded owns its result. Initialize queued at attempt zero. Tenant/job identity and row version live in the persistence envelope, outside this pure model.

| Transition | Guard | Result |
| --- | --- | --- |
| Claim | queued or expired running; attempts remain | Increment attempt, establish lease |
| Claim | expired final attempt | Fail with attempts exhausted |
| Complete | current attempt, running, strictly before expiry | Store result, become succeeded |
| Cancel | queued or running | Become cancelled |
| Any command on terminal state | always | Reject change, return same snapshot |

I1: terminal states are absorbing. I2: only the current unexpired attempt can publish success. I3: attempts never decrease or exceed the limit. I4: one decision does not mutate its input.

All transitions are applied atomically per tenant/job against the row version read. Time is sampled from the state owner's authoritative clock at the transaction boundary, with a nondecreasing-time assumption. Client/worker time is not accepted as authority. The expiry comparison must still hold at the actual commit point; a stale precomputed decision cannot be committed after an arbitrary delay. Production must address clock regression and transaction duration.

Progress is conditional: a dispatcher eventually retries abandoned jobs, storage remains available, and some worker finishes before expiry. Infinite failure cannot guarantee success. Exhaustion settles only when a recovery claim occurs. No fairness/liveness proof is provided by the bounded safety exploration.

## API sketch and ADR

Desired service usage (design only): `jobs.claim(jobId)` returns a scoped attempt token; `jobs.complete(jobId, token, result)` returns a terminal result or stale/expired rejection. Caller authentication and job/tenant scoping occur inside the service boundary. Workers do not manipulate flags or allocate attempt numbers.

Decision: one atomic per-job state owner, with attempt fencing. Alternative: independent `isRunning`, `isDone`, and `cancelled` flags coordinated by callers. Choose the first because it localizes the terminal-outcome invariant and stale-worker check. Keep a pure core for deterministic exploration, with one persistence adapter owning atomicity and time. An established durable workflow service is another implementation option if orchestration needs already justify its operational cost.

Revisit when lease renewal, multi-step compensation, cross-region ownership, or measured dispatcher contention becomes a requirement. Do not prebuild those mechanisms.

The implementation exposes `createJob(policy)` and `step(snapshot, command)` for the decision core. A durable adapter must load/validate a snapshot, call `step`, and conditionally commit against its version. A losing CAS must reread/re-evaluate with fresh authoritative time; it must not blindly retry the stale write.

## Delivery and evidence

The assets follow types → operations → tests. Run with Node 24 or another runtime supporting TypeScript stripping:

```sh
node --test assets/lease-job.test.mjs
```

This executes TypeScript but does **not** type-check it. Use the project's TypeScript compiler with strict checking as an additional gate. Tests cover stale attempts, exact expiry, cancellation/completion ordering, bounded attempts, invalid input, and mutation. The explorer enumerates a finite state/time domain and reports its bounds/count; it cannot certify unbounded concurrency or persistence.

Production slices: (1) real database CAS/transaction with two racing workers; (2) API auth and cross-tenant negative tests; (3) dispatcher restart/recovery and admission limits; (4) result storage, telemetry, and limited rollout. Verify cancellation versus completion in both commit orders and crash after accepting work but before acknowledging it. Distinguish command rejection from a transport-uncertain response; support reading the authoritative outcome.

## Release and limitations

The model protects a **published job result**, not arbitrary external effects. A stale worker can still send a message or charge a card unless the effect's owner enforces an appropriate operation identity/fence or provides reconciliation. This example makes no exactly-once claim.

Use tenant-scoped authorization, validated persisted records, resource limits, and a real storage transaction before production. Bound payload/result size, concurrency, and backlog. Start with a single existing storage owner when sufficient; measure hot-key contention before partitioning.

Rollout proposal: canary the new worker path; compare completion/error/queue-age signals and stale-write rejections with the baseline. Stop on violated terminal-state invariants or regression beyond agreed targets. Roll back compatible code while retaining already-valid terminal outcomes; do not reset jobs and silently repeat effects. Version stored records, support mixed workers during migration, and remove the old path only when no old writer remains.
