---
name: plan-write
description: "Use when fleshing requirements.md, plan.md, tasks.md, verification.md (or a single-file plan body) while keeping docs/ as the honest system of record."
---

# plan-write

Flesh plan content. Keep **`docs/` honest** — chat is not SoR.

## Folder plans

| File | Write |
| --- | --- |
| `requirements.md` | Outcome, constraints, nouns, illegal/non-goals, Depends-on, Date/Owner/Status |
| `plan.md` | Approach, risks table, ordering — not a second requirements doc |
| `tasks.md` | Checkboxes; update as work lands |
| `verification.md` | Done-when + prove commands (`bun run check` at minimum) |

## Single-file plans

One `.md` with Date/Owner/Status + outcome + enough tasks/verification to execute. If it grows, convert to a folder (`git mv` file aside, create directory, split).

## Honesty rules

- Do not mark tasks `[x]` until the work exists
- Do not set Status `Done` until verification passes
- Link ADRs with correct relative depth from the stage folder (`docs/specs/<stage>/...` → `docs/adrs/` is `../../../adrs/`)
- Prefer updating the spec over “we decided in Slack”

## Verify

```bash
bun run check
```

## Related

- `plan-sync` — promote stages / fix links
- `plan-dispatch` — hand implementation to a cloud agent
