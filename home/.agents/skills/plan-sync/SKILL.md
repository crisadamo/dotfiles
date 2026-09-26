---
name: plan-sync
description: "Use when moving a plan between docs/specs stages with git mv, updating README index tables, and fixing relative links after a depth or path change."
---

# plan-sync

Move plans between stages and keep indexes/links true.

## Promote / discard

```bash
# examples
git mv docs/specs/drafts/00N-slug docs/specs/next/00N-slug
git mv docs/specs/next/00N-slug docs/specs/open/00N-slug
git mv docs/specs/open/00N-slug docs/specs/done/00N-slug
git mv docs/specs/open/00N-slug.md docs/specs/discarded/00N-slug.md
```

Same pattern for single-file plans (`.md` ↔ `.md`).

## After every move

1. Update **Status** line in the plan header to match the stage.
2. Move the row in `docs/specs/README.md` to the correct stage table (remove from old table).
3. Fix relative links:
   - Sibling specs under the same stage: `../001-architecture/` stays valid when both are in `done/`
   - ADRs from `docs/specs/<stage>/<id>/file.md` → `../../../adrs/<adr>.md`
   - From a single-file at `docs/specs/<stage>/00N.md` → `../../adrs/<adr>.md`
4. Do **not** leave a stale copy in the old stage.

## Link check smoke

```bash
rg -n '\.\./\.\./adrs/|\.\./\.\./\.\./adrs/' docs/specs -g '*.md'
rg -n 'docs/specs/00[0-9]' docs/specs AGENTS.md README.md docs/ -g '*.md' || true
```

## Commit

Sync is a docs move — still follow Cristian’s commit instructions. Do not push scaffolding until OK’d.
