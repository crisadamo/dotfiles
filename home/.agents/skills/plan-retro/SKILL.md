---
name: plan-retro
description: "Use after a plan reaches done (or is discarded) to record outcomes, decide whether to write/update an ADR, and keep discarded vs done distinctions honest."
---

# plan-retro

After **done** or **discarded**, close the loop in SoR.

## Done checklist

1. `verification.md` evidence is real (`bun run check` and named smokes).
2. `tasks.md` checkboxes match what shipped.
3. Status → `Done`; plan sits under `docs/specs/done/`.
4. `docs/specs/README.md` **done** table has the row.
5. **ADR?** If a durable choice closed alternatives (vendor, storage, auth, skip Infisical, etc.), add/update `docs/adrs/<id>-<slug>.md` with Tyree/Akerman sections. Link Related requirements back to the spec path under `done/`.
6. PR merged by a human; Argus only reviewed (**Dev Review Ready**).

## Discarded vs done

| | done | discarded |
| --- | --- | --- |
| Meaning | Shipped / accepted | Explicitly abandoned |
| Keep files? | Yes | Yes (history) |
| Reuse id? | No | No — new work gets a new id |
| ADR? | Often | Sometimes (record the skip / anti-decision) |

## What to write (short)

In Notes or a brief section on the plan / ADR:

- What we learned
- What we will not do again
- Follow-ups → new draft ids via `plan-add` (do not reopen a done folder for unrelated scope)

## Habits

- Daedalus owns contract/architecture retros that touch ADRs
- Atlas tracks board hygiene (`plan-status`)
- Athena confirms product outcome on product-facing plans
