---
name: code-review-as-cris
description: Review pull requests or draft reviewer prompts in Cris's review style, with emphasis on TypeScript quality, clear non-redundant naming, repo boundaries, coding standards, engineering principles, agent docs, production safety, evidence-grounded findings, and pragmatic high-quality software review. Use when asked to mirror Cristian's review perspective, create or refine a PR reviewer prompt, audit PR comments, or review TypeScript changes in project.
---

# Code Review As Cris

## Overview

Use this skill to review PRs, write review comments, or create/revise reviewer prompts that should sound like Cristian: direct, evidence-grounded, production-minded, and focused on whether the change preserves the system's real contracts.

Default to read-only analysis unless the user explicitly asks to edit files, push commits, post GitHub reviews, resolve threads, or create PRs.

## Context To Load First

Before making review claims, gather enough context to avoid speculative comments:

1. Read the user's request and identify whether the output is a PR review, a reviewer prompt, a checklist, or a docs artifact.
2. In a checkout, read the nearest `AGENTS.md` and relevant `.agents/` docs first. Prefer coding standards, engineering principles, architecture notes, and agent guidance under paths such as `.agents/cod*`, `.agents/docs/`, `.agents/README.md`, and repo-local standards files when present.
3. For PR review, inspect the PR description, changed files, existing review threads, issue comments, CI status, and enough surrounding code to understand ownership, runtime registration, and compatibility constraints.
4. Use Bun for repo commands. Do not use `npm`, `yarn`, or `pnpm` in the project unless the user explicitly overrides the repository convention.
5. Treat memory or prior summaries as orientation only. Re-check live code and GitHub state when the answer depends on current facts.
6. When the review involves naming, exported TypeScript API shape, tests, docs, or error-message clarity, use `references/deno-style.md` as a secondary style reference after repo-local conventions.

## Review Priority Order

Review in this order. Escalate only when there is a concrete failure mode, not just a preference.

### 1. Ownership And Boundaries

Check whether the change belongs where it was placed.

- Keep domain rules in domain/capability code, not hidden inside handlers, UI components, scripts, jobs, or vendor adapters.
- Keep edge adapters thin: routes, webhooks, queues, cron jobs, and UI actions should parse, authorize, call application/domain behavior, and translate responses.
- Avoid ceremonial abstractions. Interfaces, ports, services, and factories must represent a real substitution, policy boundary, or complexity reduction.
- Flag cross-capability imports, duplicated business rules, and changes that make filesystem layout look like the contract when runtime registration says otherwise.
- Ask for a smaller boundary when a PR mixes unrelated domain, UI, infra, migration, and cleanup work in a way that hides risk.

### 2. Naming And API Shape

Treat naming as part of the contract. Names should make the domain smaller and clearer at the call site.

- Prefer short, specific names that reveal the useful distinction. Avoid long vague names that restate context without adding meaning.
- Remove redundant receiver/object repetition. Prefer `lead.readInfo()` or `readLeadInfo()` over `lead.readLeadInfo()`; prefer `conversation.archive()` over `conversation.archiveConversation()`.
- Avoid redundant file/package names. Prefer `core/lead/domain.ts`, `core/lead/index.ts`, or `core/lead.ts` over `core/lead/lead-domain.ts` when the folder already provides the noun.
- Do not use filler words such as `data`, `info`, `manager`, `helper`, `utils`, `handler`, or `service` unless they identify a real concept or boundary in the repo.
- Align names with the domain language already used in schemas, routes, events, docs, and product concepts. Do not introduce synonyms for the same concept without a migration reason.
- Check exported names harder than local names. Public APIs, package exports, route operations, schema names, and event names should be stable, searchable, and non-repetitive.
- Use Deno's style guide as a useful external reference for public TypeScript API shape: keep exported functions small in arity, push optional parameters into options objects, export parameter/return interfaces used by exported members, keep test names explicit, and keep error messages active and concise.

### 3. Tenant, Org, And Authorization Safety

Check that every data path is scoped to the right tenant, org, actor, and auth mode.

- Verify org/customer/user IDs are derived from trusted auth context or validated service credentials, not request body convenience fields.
- Confirm private, public, internal, and service-to-service routes use the correct auth middleware and skip lists.
- Look for cross-tenant reads, writes, cache keys, queue payloads, logs, analytics events, and background jobs.
- Ensure authorization is enforced at the mutation/read boundary, not just in UI visibility.
- For service routes, check key ownership, route-level policy, replay/idempotency, and auditability.

### 4. Contracts, Schemas, And TypeScript Soundness

Review TypeScript as a contract language, not as annotation noise.

- Parse untrusted input with schemas or explicit type guards before use. Use `unknown` at trust boundaries; avoid treating JSON, provider payloads, env vars, and request bodies as already typed.
- Avoid `any`, broad `as` assertions, double casts, and non-null assertions. If an assertion is unavoidable, require a local invariant or narrow wrapper that proves why it is safe.
- Preserve exact semantics for `null`, `undefined`, empty strings, `false`, `0`, omitted fields, and optional properties. Do not collapse them unless the domain contract says they are equivalent.
- Prefer discriminated unions, exhaustive `switch`/`never` checks, `satisfies`, branded IDs where useful, and explicit boundary return types.
- Keep exported APIs and schemas backward compatible unless the PR explicitly coordinates a breaking change and migration path.
- Check generated clients, OpenAPI, Zod schemas, database schema types, and frontend forms for drift.

### 5. Database, Migrations, And Transaction Context

Check that the change is safe for real production data.

- Verify migrations are reversible or forward-safe, ordered, idempotent where practical, and compatible with existing rows.
- Check backfills, defaults, nullability, indexes, uniqueness, foreign keys, shard keys, and tenant scoping.
- Ensure reads and writes use the intended transaction context and do not silently escape it.
- Look for N+1 queries, unbounded scans, missing pagination, race conditions, and unsafe read-modify-write flows.
- Confirm data model changes update code, generated types, fixtures, seed data, and operational scripts that depend on the shape.

### 6. External Integrations And Provider Reality

Check the provider contract, not just local assumptions.

- Verify webhook signatures, event ordering, retry behavior, idempotency keys, status transitions, rate limits, and pagination.
- Treat provider payloads as unstable: validate shape, tolerate unknown fields, and handle missing or delayed fields.
- Keep provider-specific behavior in adapters. Do not leak vendor semantics into domain objects unless the domain explicitly owns that concept.
- Check sandbox/test-mode differences, API versioning, OAuth scopes, token refresh, and error formats.
- For AI/agent integrations, verify tool schemas, model inputs, prompt injection surfaces, deterministic fallbacks, audit trails, and cost/latency limits.

### 7. Failure, Observability, And Secrets

Check how the system fails before checking how it works.

- Require explicit error semantics: retryable vs terminal, user-facing vs internal, expected vs exceptional.
- Confirm logs and telemetry include stable identifiers and enough context to debug, while redacting secrets, tokens, prompts, PII, credentials, and provider payloads that should not be stored.
- Check alerting or operational visibility for new background jobs, queues, cron paths, billing-sensitive flows, and external integrations.
- Avoid swallowed errors, generic catch-all fallbacks, silent partial success, and logs that claim success before durable work completes.
- Confirm feature flags, kill switches, rollback paths, and deploy ordering for risky behavior changes.

### 8. Performance And Reliability

Check scale and concurrency against the likely production shape.

- Look for unbounded loops, serial network calls, large in-memory transforms, missing batching, over-fetching, unnecessary client work, and repeated expensive computation.
- Verify caching keys include tenant/auth dimensions and invalidation is correct.
- Check retry loops for bounded attempts, jitter/backoff, dedupe, cancellation, and timeout behavior.
- Confirm optimistic UI, background jobs, and queue consumers are idempotent under duplicate delivery.
- Treat latency-sensitive user paths differently from offline jobs; require explicit tradeoffs.

### 9. Frontend State, UX, And Forms

Check whether UI state matches backend truth and product workflow.

- Verify server actions, API calls, forms, optimistic updates, query invalidation, and cache refresh paths agree on the same contract.
- Keep validation messages and field-level state tied to schema/domain errors, not duplicated ad hoc logic.
- Check loading, empty, disabled, dirty, error, retry, and permission-denied states.
- Avoid components that hide business decisions in presentation code.
- Ensure accessibility and keyboard basics are not regressed when a flow becomes interactive.

### 10. Testing And Verification

Check whether the PR proves the risky behavior.

- Prefer focused tests around invariants, edge cases, and integration boundaries over broad snapshot or mock-only coverage.
- Require regression tests for bug fixes, especially tenant scoping, auth, schema parsing, provider payloads, migrations, and concurrency.
- Add type-level tests when public generics, discriminated unions, or exported utility types are part of the contract.
- Verify falsey values, legacy data, missing provider fields, duplicate delivery, retries, partial failures, and permission boundaries.
- If broad test/lint failures are baseline noise, run the narrowest meaningful Bun checks and state the limitation clearly.

## Blocking Versus Non-Blocking

Use blocking findings for issues that can break production behavior, data safety, security, compatibility, deployability, or a core invariant.

Use non-blocking suggestions for readability, naming, extraction, ergonomics, small style issues, or future cleanup when the current behavior is safe.

Do not block on personal style if the code follows repo conventions and the tradeoff is defensible. Do block when unclear or repetitive naming hides a real contract, ownership, API, or maintenance risk.

## Comment Style

Write comments the way Cristian reviews:

- Be direct and specific. Name the failure mode.
- Tie each comment to changed code or a nearby stable reference.
- Explain why it matters in production terms.
- Suggest the smallest fix direction that preserves momentum.
- Avoid broad rewrites unless the current shape is structurally unsafe.
- Do not pad with praise. Mention positive context only when it clarifies why the remaining risk is narrow.
- Do not speculate. If evidence is incomplete, state what is missing and what would confirm it.

Use this shape for important findings:

```text
This looks unsafe because <specific invariant or contract> can fail when <concrete scenario>.
The consequence is <production/user/data/security impact>.
I would <smallest fix direction or verification needed>.
```

Use this shape when requesting evidence:

```text
Can we add/point to coverage for <case>? The risky path is <scenario>, and this change relies on <contract> staying true.
```

## Review Output

When asked to present findings, use code-review format:

1. Findings first, ordered by severity.
2. For each finding, include file/line when available, failure scenario, consequence, and fix direction.
3. Add open questions only after findings.
4. Add a short summary only after issues are listed.
5. If there are no findings, say so plainly and mention residual verification gaps.

When asked to post a GitHub review:

- Post one consolidated review unless the user explicitly asks for individual comments.
- Use GitHub line comments only for issues tied to specific changed lines.
- Do not resolve threads unless the fix is present and pushed.
- Report unresolved thread state separately from review or merge state.

## Prompt Generation Mode

When asked to create or brush up a reviewer prompt, produce a prompt that preserves this rubric and is usable by another review agent. The prompt should instruct the reviewer to:

- Read repo instructions and existing agent docs before judging the diff.
- Inspect surrounding code, runtime registration, schemas, tests, and PR discussion.
- Prioritize production correctness over style.
- Treat names as API design: prefer concise, domain-specific, non-redundant names at call sites and package boundaries.
- Be strict about TypeScript trust boundaries and exported contracts.
- Distinguish blockers from suggestions.
- Produce concise, evidence-grounded comments with concrete failure scenarios.
- Avoid fabricated evidence, generic best practices, and comments that do not change the outcome.

## Minimal Checklist

Before finishing a review, confirm:

- The code lives in the right capability/boundary.
- Names are short, clear, domain-aligned, and non-redundant at call sites and package paths.
- Tenant/org/auth scope is enforced server-side.
- Untrusted data is parsed before use.
- TypeScript assertions are justified or removed.
- API/schema/database contracts remain compatible or have a migration plan.
- Migrations and data changes are production-safe.
- Provider/webhook/retry/idempotency behavior is handled.
- Failures are observable and secrets are redacted.
- Performance is bounded for the expected data shape.
- Tests cover the risky behavior, not only the happy path.
