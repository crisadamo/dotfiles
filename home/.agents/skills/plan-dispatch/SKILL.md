---
name: plan-dispatch
description: "Use when handing plan implementation to a Cursor cloud agent — Grok 4.6 High normal (never Fast) — with plan paths, verify commands, branch naming, and PR habits in the prompt."
---

# plan-dispatch

Hand work to a Cursor **cloud agent**. Cloud-agent defaults:

| Setting | Value |
| --- | --- |
| Model | **grok-4.6** |
| Effort | **high** |
| Fast | **`false` — NEVER Fast** |

## Before dispatch

1. Plan is under `docs/specs/open/<id>-<slug>/` (or single-file in `open/`).
2. Branch ready: prefer `pds/<id>-<slug>` (or `pds/plan-<id>-<slug>`).
3. Requirements + verification are clear enough to execute without chat archaeology.

## Prompt must include

- Exact paths to the plan files (`requirements.md`, `plan.md`, `tasks.md`, `verification.md`)
- Relevant ADR paths under `docs/adrs/`
- “`docs/` is SoR; do not treat chat as contract”
- “Verify with `bun run check`”
- Branch name `pds/<id>-<slug>`
- PR body: **Summary** + **Test plan**
- Argus: apply **Dev Review Ready** for review; **Argus does not merge**
- Area: this repo is `platform-dev-services` (`pds-`); platform app changes go to `platform`
- Do not expand scope past the open plan

## After agent returns

1. Read the PR / branch diff against the plan
2. Confirm `tasks.md` / `verification.md` match reality
3. Human merges when ready; then `plan-sync` → `done/` and `plan-retro`

## Anti-patterns

- Dispatching from `drafts/` without promoting to `open/`
- Using Fast / low-effort models for plan execution
- Prompting without linking the SoR files
