---
name: plan-init
description: "Use when bootstrapping or verifying docs/specs stage folders exist, or when opening the path for a new draft before writing content."
---

# plan-init

Bootstrap / verify the plan stage folders. Does **not** invent product scope — that is `plan-add` / `plan-write`.

## Do this first

```bash
cd "$(git rev-parse --show-toplevel)"
mkdir -p docs/specs/{drafts,next,open,done,discarded}
ls -la docs/specs/
```

Ensure `docs/specs/README.md` exists and describes stages (see `plan-spec`). If missing, recreate from the repo’s current README pattern — do not invent a second protocol.

## Opening a new draft path

1. Find next free id (scan all stage folders for `NNN-*`).
2. Decide folder vs single-file (`plan-spec`).
3. Create empty path only — then `plan-add` / `plan-write` fill content.

```bash
# Example folder draft
mkdir -p docs/specs/drafts/00N-example-slug

# Example single-file draft
: > docs/specs/drafts/00N-example-slug.md
```

## Commit policy (scaffolding)

**Do not commit or push plan-skill scaffolding** (new skills, empty stage trees, demo-only walkthroughs) **until Cristian says OK.** Leave changes local / staged for review.

## Related

- `plan-add` — create the draft entry with Date/Owner
- `plan-spec` — layout rules
