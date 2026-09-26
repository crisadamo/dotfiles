---
name: plan-status
description: "Use when listing what is in each docs/specs stage (drafts/next/open/done/discarded) or summarizing open/in-progress plan work for Cristian or Atlas."
---

# plan-status

Summarize the plan board from disk (SoR), not from memory.

## Commands

```bash
cd "$(git rev-parse --show-toplevel)"

echo '=== drafts ==='
ls -1 docs/specs/drafts

echo '=== next ==='
ls -1 docs/specs/next

echo '=== open ==='
ls -1 docs/specs/open

echo '=== done (tail) ==='
ls -1 docs/specs/done | tail -20

echo '=== discarded ==='
ls -1 docs/specs/discarded
```

For each **open** entry, peek Status/Date/Owner:

```bash
# folder plans
rg -n '^\*\*(Status|Date|Owner):\*\*' docs/specs/open -g '*.md'
# plus single-file
```

## Report shape

Keep it short for Cristian / Atlas:

| Stage | Ids | Notes |
| --- | --- | --- |
| open | … | owner + one-line outcome |
| next | … | |
| drafts | … | |
| discarded | … | only if relevant |

Cross-check `docs/specs/README.md` tables; if drift, fix with `plan-sync`.

## Demo entries

Anything marked **DEMO ONLY** is fictional — say so in the summary (or omit if Cristian already knows).
