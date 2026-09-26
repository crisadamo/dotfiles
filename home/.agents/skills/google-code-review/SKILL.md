---
name: google-code-review
description: Review pull requests, changelists, commits, diffs, or patches using Google's Engineering Practices, and draft or rewrite concise PR/CL titles and descriptions. Use when asked to review code like Google, assess whether a change improves code health, structure review findings or comments, judge CL size and review readiness, or shorten a lengthy or messy pull request description.
---

# Google Code Review

Apply Google's code-health standard without turning review into a search for perfection. Treat “CL” and “pull request” as equivalent unless the repository distinguishes them.

## Select the task

- **Review**: inspect a diff, branch, commit, or PR and report actionable findings.
- **Description**: draft, audit, or shorten a PR/CL title and body.
- **Combined**: review the change first, then make the description accurately reflect the reviewed diff.
- **Review process**: assess CL size, comment quality, review latency, pushback, or readiness.

Read [references/google-engineering-practices.md](references/google-engineering-practices.md) when applying or explaining the source principles. Read [references/pr-description-patterns.md](references/pr-description-patterns.md) whenever writing, rewriting, or auditing a PR description or repository template.

## Establish authority and evidence

1. Read repository-local instructions, `CONTRIBUTING`, style guides, PR templates, and required checks before applying generic guidance.
2. Confirm the review base and head. Inspect the actual diff, affected code in context, tests, callers, and persisted or public contracts.
3. Default to a focused change review. Expand to a whole repository only when the user asks.
4. Keep review read-only unless the user explicitly asks to edit code, post comments, approve, or request changes.
5. Do not claim a test or check passed unless it was run or its current result was inspected. Separate verified facts from inferences.

## Gate the change shape

Prefer one self-contained conceptual change with its related tests. Ask for a split when unrelated refactoring, formatting, generated output, and behavior changes obscure one another.

Do not judge size by line count alone. Consider conceptual breadth, number of subsystems, reviewer context, generated code, risk, and rollbackability. A large deletion or trusted mechanical rewrite can be easier to review than a small distributed behavior change.

For an oversized change, review the intent and major design first. Return the earliest useful design or decomposition feedback instead of spending time on low-level details that may disappear.

## Review in risk order

1. Read the title and description. State the intended behavior and why the change should exist.
2. Inspect the most important implementation boundary or the tests that reveal intended behavior.
3. Check design and system fit before local correctness.
4. Inspect every changed line and enough surrounding context to understand its effect.
5. Trace consumers and contracts when the change affects APIs, schemas, persistence, authentication, concurrency, money, time, migrations, retries, or external effects.
6. Verify tests and operational evidence in proportion to risk.

Evaluate:

- **Design**: Does the change belong here, preserve boundaries, and reduce or contain complexity?
- **Functionality**: Does it serve users and callers, including edge cases and failure paths?
- **Complexity**: Is it the simplest complete change, without speculative functionality?
- **Tests**: Would tests fail for the regression? Are assertions meaningful and at the right level?
- **Clarity**: Are names, comments, docs, and APIs understandable to future readers?
- **Consistency**: Does it follow repository rules without elevating personal preference into a blocker?
- **Specialized risk**: Does security, privacy, accessibility, concurrency, performance, internationalization, or another domain require an expert reviewer?

## Apply the approval standard

Favor approval once the change definitely improves the code health of the affected system, even if it is not perfect.

- Block defects, unsafe behavior, broken contracts, unjustified complexity, missing material tests, or design choices that reduce code health.
- Do not block on personal taste. Repository style guides and established local conventions outrank reviewer preference.
- When multiple approaches are technically sound, accept the author's choice.
- Do not defer complexity introduced by this change to an unspecified cleanup. For pre-existing adjacent debt, request a concrete follow-up only when it need not block this change.
- Treat genuine production, legal, or security emergencies specially: prioritize correctness and speed, then require a follow-up review. A soft deadline is not an emergency.

## Write review comments

Comment on the code, never the author. Explain the consequence and the reason before prescribing a solution. Give direct guidance when the safe fix is narrow; otherwise describe the requirement and let the author choose the implementation.

Label intent explicitly:

- `Required:` must be resolved before approval.
- `Suggestion:` or `Optional:` would improve the change but does not block it.
- `Nit:` minor polish or non-authoritative style.
- `FYI:` educational context with no action expected.

Use this shape for a material finding:

```text
Required: <failure mode or violated invariant> — <file:line>

<What can happen, under what conditions, and why the current code permits it.>
<Smallest acceptable direction or validation needed.>
```

Prefer one complete comment at the narrowest useful location. Avoid vague requests, repeated comments for the same root cause, performative praise, and nits that obscure production risks.

## Draft a concise PR description

Write for the reviewer now and the engineer searching history later.

1. Use a short, standalone title phrased as an imperative outcome. Follow repository conventions such as Conventional Commits when required.
2. Explain **what changes** and **why it is needed**. Include decisions or constraints the diff cannot reveal.
3. Report concrete validation with exact commands, observed behavior, or current check results.
4. Add risk, rollout, rollback, migration, screenshots, benchmarks, or compatibility notes only when material.
5. Link issues and design documents, but preserve enough context that the description remains useful if a link becomes unavailable.
6. Remove file-by-file narration, commit diaries, generic claims, duplicated bot summaries, and empty optional sections. Preserve mandatory repository template fields.
7. Re-read the final diff and refresh the description before handoff or merge.

Default to two sections for ordinary changes:

```markdown
## Summary
<Problem and impact. What this change does and why this approach is appropriate.>

## Validation
- `<exact command>` — <result>
- <manual or operational evidence, when relevant>

Fixes #<issue>
```

For a tiny change, one short paragraph plus one validation bullet is enough. For high-risk changes, add only the relevant sections, usually `Risk and rollout`, `Compatibility or migration`, or `Rollback`.

## Return the result

For a review, return:

1. Material findings in descending severity, each with an exact location, failure mode, evidence, and required direction.
2. Open questions only when the answer could change the verdict.
3. A verdict: `Request changes`, `Approve with comments`, or `Approve within reviewed scope`.
4. Validation performed and residual risks or unverified areas.

If there are no material findings, say so directly; do not invent nits to make the review look thorough.

For description work, return a paste-ready title and Markdown body. Keep explanatory commentary outside the proposed body and brief. For combined work, finish the review before drafting the description so the description matches the actual change and its evidence.
