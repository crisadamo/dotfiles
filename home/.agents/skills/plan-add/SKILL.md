---
name: plan-add
description: "Use when adding a new draft plan under docs/specs/drafts — pick the next id, create folder or single-file, fill Date/Owner/Status, and update the specs README index."
---

# plan-add

Add a **new draft** under `docs/specs/drafts/`.

## Steps

1. **Next id** — list existing ids across all stages; take max + 1, zero-padded to 3:

```bash
find docs/specs -maxdepth 2 \( -type d -o -type f -name '*.md' \) \
  | rg -o '[0-9]{3}-' | sort -u
```

2. **Slug** — kebab-case, short (`env-profiles`, `cli-doctor`).
3. **Shape** — folder (real work) vs single `.md` (thin).
4. **Create** with required header:

```markdown
**Status:** Draft
**Date:** YYYY-MM-DD
**Owner:** Daedalus / Cristian
```

Folder template:

```bash
ID=00N
SLUG=my-slug
DIR=docs/specs/drafts/${ID}-${SLUG}
mkdir -p "$DIR"
# write requirements.md plan.md tasks.md verification.md (stubs OK)
```

5. **Index** — add a row to the **drafts** table in `docs/specs/README.md`.
6. **Do not** put new work straight into `open/` unless Cristian asked to start now.

## Owners

- Daedalus — contracts / architecture
- Atlas — CoS / coordination
- Athena — product

## Related

- `plan-write` — flesh the body
- `plan-init` — ensure folders exist
