---
name: plan-spec
description: "Use when you need the docs/specs stage layout, folder vs single-file plan format, required Date/Owner fields, or rules for promoting between drafts/next/open/done/discarded."
---

# plan-spec

Plan layout for `platform-dev-services` (and the same habits elsewhere under `docs/`).

## System of record

- **`docs/` is SoR. Chat is not.**
- Specs live under `docs/specs/<stage>/`.
- ADRs live under `docs/adrs/` using Jeff Tyree / Art Akerman **section** style (`## Issue`, `## Decision`, …).

## Stages

| Stage | Meaning |
| --- | --- |
| `drafts/` | Early ideas; not scheduled |
| `next/` | Queued / ready to start |
| `open/` | Actively in progress |
| `done/` | Accepted / shipped — keep as SoR |
| `discarded/` | Deliberately abandoned — keep for history |

Promote with `git mv` (see `plan-sync`). Do not leave copies in prior stages.

## Plan shapes

**Folder (preferred for real work):**

```
docs/specs/<stage>/<id>-<slug>/
  requirements.md
  plan.md
  tasks.md
  verification.md
```

**Single-file (thinner work):**

```
docs/specs/<stage>/<id>-<slug>.md
```

## Required header

Every plan MUST have near the top:

```markdown
**Status:** Draft | Next | Open | Done | Discarded
**Date:** YYYY-MM-DD
**Owner:** Daedalus / Cristian   # or Atlas / Athena as appropriate
```

## When to promote

| From → To | When |
| --- | --- |
| drafts → next | Ready to schedule; requirements clear enough to queue |
| next → open | Work started (branch cut / agent dispatched) |
| open → done | Verification passed; slice shipped |
| * → discarded | Explicitly abandoned (wrong approach, locked skip) |

## Habits

- Verify with `bun run check`
- Cloud agents: **grok-4.6**, effort **high**, `fast=false` — **never Fast**
- Argus: **Dev Review Ready**; Argus does **not** merge
- Daedalus owns contracts/architecture; Atlas CoS; Athena product
- Branches: prefer `pds/<id>-<slug>` in this repo
- PR body: **Summary** + **Test plan**
- Private repos under the connected GitHub org

## Index

Keep `docs/specs/README.md` tables in sync with reality (skill `plan-sync`).
