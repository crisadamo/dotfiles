---
name: engineering-practice
description: >-
  Turn product ideas into precise requirements, state and invariant
  specifications, simple deep modules, usable APIs, verified implementations,
  and operable systems. Use for principal-level engineering, conceptual
  integrity, architecture or API design, PRDs/specs/ADRs, substantive TypeScript
  features, reliability work, or rigorous design/code review. Also use when
  explicitly asked to apply this practice to a small change; scale the process
  to the risk. Preserve the requested mode and scope.
---
# Engineering Practice

Deliver the smallest complete solution whose behavior, failure modes, and evolution can be explained and checked. Optimize for user outcomes, sound contracts, and low cost of understanding and change. Treat this as a decision process, not a requirement to produce many documents or use a particular framework.

## Start with the requested work

Identify the mode: **shape, design, build, review, or maintain**. Infer it from the request; ask only when the distinction changes what is authorized. Review remains read-only. A design request ends with a concrete design; a build request continues through implementation and evidence. Publishing, messaging, merging, and deployment follow the user's actual authorization.

Read repository instructions and trace the affected path: consumer → entrypoint → policy/state owner → effects/storage → observable result. Inspect callers, contracts, tests, and deployment assumptions. Label facts, inferences, and unknowns. Do useful reversible work while resolving uncertainty; ask only a question that materially changes the solution. Never invent requirements, traffic numbers, provider guarantees, or business decisions.

Choose effort by consequences, not diff size:

| Scope | Minimum useful record |
| --- | --- |
| Local, reversible, no contract change | Intent, changed behavior, focused evidence in the response/PR |
| New behavior or cross-module contract | One short work record: requirements, model, choice, slice, verification |
| Durable/public contract, concurrency, security, money, migration, or foundational API | Explicit failure/compatibility model; alternatives; evidence at the real seam; rollout and recovery |

Use [assets/work-record.md](assets/work-record.md) as one living record. Split a PRD, spec, design, or ADR only when it has an independent audience or lifetime. Omit irrelevant sections with a short reason; do not fill placeholders to simulate completeness.

## Two mandatory spec passes

Whenever this practice produces a PRD, spec, ADR, or work record that someone will build from:

- **Pass 1: codebase grounding (mandatory, before any spec text).** Explore the repo first and record a Codebase Grounding section with file:line evidence: ID/reference fields as the repo names them (e.g. `organizationPublicId`, not `org_id`; `newId()` public IDs vs internal bigint), table/column naming, timestamps, JSON/enum style, where schemas/migrations live, type/namespace names, worker/job structure (queue helpers, signature verification, dedup ids, retries), route naming, feature-config and tool naming, and the closest existing pattern. Every name in the spec comes from that list or is marked NEW with the convention it follows.
- **Pass 2: grounding re-check + adversarial review (mandatory, after the spec is written, before build).** One pass, two jobs: (a) re-compare every name, type, table, and pattern in the spec against the repo and fix drift; (b) actively try to break the spec: question assumptions, find missing edge cases and failure modes, flag over-specification (logic/tables/endpoints not needed for the outcome) and under-specification (ambiguous contracts), and challenge whether what's specified is what should be built. Record findings and resolutions in the spec (a short 'Pass 2 review' section). Prefer a different reviewer than the writer (e.g. Daedalus writes, Argus or Athena challenges). No dispatch until Pass 2 is recorded and its blockers are resolved or escalated to Cris.

## Run the decision sequence

1. **Frame the outcome.** Identify the consumer, painful current behavior, desired observable outcome, non-goals, constraints, and success measure. Separate product requirements from a proposed implementation. Read [references/problem-and-spec.md](references/problem-and-spec.md) when shaping an idea or defining behavior.
2. **Specify correctness.** Write the smallest domain vocabulary, authoritative state, ownership, invariants, and transitions needed to distinguish correct from incorrect behavior. For concurrent work, include safety, progress conditions, failure assumptions, and the operation's commit point. Specify what must be true before choosing how to achieve it. A pure transformation can use input/output laws instead of a state machine.
3. **Sketch the caller's experience.** Write one ordinary usage example and one failure/cancellation example before internals. Derive types and operation signatures from those examples. Make the common operation complete; avoid forcing callers to coordinate internal stages.
4. **Choose the shape.** Start with the simplest viable baseline. For consequential choices compare one structurally different alternative against the same contract. Name the deciding evidence, tradeoff, and condition that would reverse the decision. Read [references/design.md](references/design.md). Record durable decisions with [assets/adr.md](assets/adr.md), without duplicating the spec.
5. **Build a vertical slice.** Implement an observable requirement through its real boundaries, including a meaningful failure. Keep domain decisions near their state owner; isolate effects where that clarifies semantics. For TypeScript read [references/typescript.md](references/typescript.md). Use the project's toolchain. Do not commit broken scaffolding to a deployable branch.
6. **Try to disprove it.** Map each material requirement/invariant to evidence at the seam where it could fail. Read [references/verification-and-operations.md](references/verification-and-operations.md). Exercise races, retries, restarts, mixed versions, and limits only where applicable. Use bounded models for difficult interleavings; explicitly distinguish a model result from production evidence.
7. **Simplify and judge.** Look for one ownership or representation change that eliminates repeated coordination, hidden policy, or incompatible states. Preserve the contract and migration safety. Distinguish defects, demonstrated maintainability regressions, and optional alternatives. A line-count threshold or personal taste is not a blocker.
8. **Release and learn.** For production changes, define signals, stop/rollback conditions, ownership, and a feasible data recovery path. Remove obsolete callers/flags only after compatibility permits it. Convert recurring failures into a stronger type, constraint, test, or local instruction; do not merely append more prose.

Revisit the model when implementation reveals a missed requirement or repeated workaround. Explain the changed assumption and update the affected record/tests. Do not silently expand scope or insist on a disproven sketch.

## Preserve conceptual integrity

- Give each concept one meaning, each authoritative fact one owner, and each invariant a clear enforcement location. Distinguish authoritative state from caches, derived views, and telemetry.
- Judge a module by the useful capability and policy it hides relative to what a caller must know. A deep module is not a deep call chain, a giant class, or a mandatory interface.
- Remove accidental complexity. Retain essential domain distinctions, trust checks, compatibility behavior, and recovery mechanisms until evidence shows they are unnecessary.
- Treat KISS, DRY, SOLID, YAGNI, tell-don't-ask, and open/closed as heuristics whose value depends on the contract. Prefer a concrete change/failure scenario over a slogan.
- Separate mechanism from policy only when the boundary hides a real decision. Prefer a function or cohesive module; use classes for owned lifecycle/state and interfaces for real substitutability or a contract seam.
- Do not claim exactly-once external effects from a local lock, queue acknowledgement, dedupe row, lease, or fencing token. State the scope of the guarantee and handle uncertain external outcomes.

## Review and finish

For review, give each finding a location, reachable scenario, consequence, evidence, and smallest credible fix. Trace available context before reporting; qualify what cannot be verified. Consensus among reviewers is a lead to investigate, not proof. Do not manufacture findings to fill a quota.

For normal delivery, one focused self-review and one verification pass are the starting point. After fixes, rerun affected checks. Broaden only for a concrete remaining risk or repository gate. If two review/fix rounds expose the same unresolved design dispute, surface the exact decision or blocker; do not loop until all nits disappear. Material blockers still block; optional polish does not.

Do not require particular models, subagent tools, worktrees, package managers, or cloud services. Use additional reviewers only when requested or separately authorized; a single agent can execute this practice. Inspect actual capabilities before using harness-specific features.

Conclude with the result, decisive design choice, checks actually run, and material residual risk. Label completion accurately: designed, implemented, locally verified, production-verified, or blocked. Never substitute a long checklist for evidence.

## Load supporting material selectively

- [references/patterns.md](references/patterns.md): commit-pinned TypeScript examples; choose by engineering question, not repository prestige.
- [references/sources-and-adoption.md](references/sources-and-adoption.md): primary sources, pstack/Cursor review, and mapping from the existing dotfiles skills.
- [assets/worked-example.md](assets/worked-example.md): product idea → spec → design decision → implementation/test → production obligations for a retryable job.
- [assets/lease-job.ts](assets/lease-job.ts) and [assets/lease-job.test.mjs](assets/lease-job.test.mjs): executable state/transition example with bounded exploration. These demonstrate the model, not a durable queue implementation.
