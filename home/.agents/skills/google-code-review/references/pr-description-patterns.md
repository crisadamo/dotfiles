# Concise PR description patterns

Read this reference when drafting, shortening, or auditing a PR/CL description or repository PR template.

## Observed public samples

Sampled on 2026-08-18. These are observations from Google-owned open-source repositories, not a claim that every public contribution represents Google's internal CL policy.

- [Gemini CLI #28813](https://github.com/google-gemini/gemini-cli/pull/28813): a tiny configuration fix uses `Context & Problem`, `Detailed Changes`, and `Verification`. The context and verification help; a file-by-file section adds little for a three-line diff.
- [Gemini CLI #28790](https://github.com/google-gemini/gemini-cli/pull/28790): a larger retry change uses `Summary`, `Details`, `Related Issues`, `How to Validate`, and a project checklist. The extra detail is justified by mode-dependent behavior and time-based recovery, but the checklist is mostly repository boilerplate.
- [Gemini CLI #28305](https://github.com/google-gemini/gemini-cli/pull/28305): an evaluation feature uses `Summary`, conceptual details, test evidence, and a checklist. Its strongest signal is the concise behavioral outcome plus test count.
- [OSV-Scanner #2808](https://github.com/google/osv-scanner/pull/2808): a focused performance/correctness fix uses `Overview`, `Details`, `Testing`, and a checklist. It explains the duplicate-work problem, preserves output semantics, and names exact tests.
- [OSV-Scanner #2807](https://github.com/google/osv-scanner/pull/2807): a security fix uses `Summary` and `Fix`, with enough data-flow and exploit context to justify the detail. Risk drives length.

## Extracted pattern

Across the useful parts of these descriptions, the stable information architecture is:

1. **Standalone title**: scoped and outcome-oriented; often follows Conventional Commits in repositories that require it.
2. **Problem and why**: identify the broken, missing, unsafe, or costly behavior and its impact.
3. **Conceptual change**: explain the approach and any non-obvious behavior, not every edited file.
4. **Evidence**: give exact tests, commands, manual observations, screenshots, or measurements.
5. **Traceability**: link the issue or design after preserving enough local context.
6. **Risk-shaped extras**: add rollout, rollback, migration, compatibility, or security analysis only when the change warrants them.

Section names vary. Signal matters more than headings.

## Compression rules

Delete or collapse content that merely:

- enumerates files visible in the diff;
- repeats the title in different words;
- narrates the commit sequence;
- says “tests added” without naming evidence;
- copies a bot-generated summary;
- includes empty optional headings;
- checks generic boxes without recording what actually ran;
- repeats an issue description without explaining this change's decision.

Retain detail when it captures:

- a choice among plausible designs;
- a changed contract or compatibility constraint;
- failure behavior, concurrency, retries, persistence, or external effects;
- a migration, rollout, feature flag, rollback, or observability plan;
- a security boundary or exploit path;
- benchmark or user-visible evidence;
- a known limitation or deliberate non-goal.

## Default template

Use this for most changes:

```markdown
## Summary
<State the problem and impact. Explain what changes and why this approach is appropriate in two to four sentences.>

## Validation
- `<command>` — <passed result or relevant count>
- <manual behavior, screenshot, metric, or current check result>

Fixes #<issue>
```

Omit the issue line when there is no issue. Omit a validation bullet only when it is genuinely inapplicable, and state why instead of implying validation occurred.

## Tiny-change template

Use for a narrow documentation, configuration, typo, or mechanical fix:

```markdown
## Summary
<What was wrong, what now happens, and why it matters.>

## Validation
- `<focused command>` — passed
```

Do not add a `Changes` section that restates the one-line diff.

## High-risk template

Add sections only for risks that exist:

```markdown
## Summary
<Problem, impact, chosen behavior, and reason for the approach.>

## Approach
- <Decision-relevant conceptual change>
- <Changed invariant or contract>
- <Known limitation or explicit non-goal>

## Validation
- `<focused command>` — <result>
- `<broader command>` — <result>
- <manual, load, migration, or production-like evidence>

## Risk and rollout
<Failure modes, blast radius, staged rollout or flag, monitoring, and rollback trigger.>

## Compatibility or migration
<Required consumer action, schema sequence, or “No compatibility change” only when useful.>

Fixes #<issue>
```

## Title tests

A good title should answer “what did this change do?” in a history list without opening the PR.

Prefer:

- `Prevent duplicate OSV queries in bulk scans`
- `Restore model availability after transient capacity errors`
- `Make the CLI package a composite TypeScript project`

Avoid:

- `Fix bug`
- `Updates`
- `Phase 1`
- `Address feedback`
- `Changes to retry.ts and tests`

Use repository-required prefixes without letting tags overwhelm the outcome, for example `fix(scanner): deduplicate bulk queries`.

## Audit checklist

Before returning a description, verify:

- The title stands alone and matches the final diff.
- The first paragraph contains both what and why.
- The body records decisions the code cannot explain by itself.
- Validation is exact and truthful.
- Required repository template fields remain intact.
- Optional sections are present only when material.
- Links supplement rather than replace context.
- The description is shorter than the change explanation it replaces, unless risk genuinely requires detail.
