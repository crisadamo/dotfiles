---
name: Factory PR babysit
description: >-
  Use when babysitting open factory eng PRs (CI/conflicts/review) via the
  existing cloud agent until human-merge — ours only (crisadamo / factory agent
  / floor-enrolled); never merge.
---
---
name: Factory PR babysit
description: >-
  Use when babysitting open factory eng PRs (CI failures, conflicts, review
  comments) via the existing Cursor cloud agent — enroll, check cycle, or
  GitHub/cron wake — until human-merge ready or closed. Never merge. Only
  PRs that are ours (crisadamo / factory cloud agent / floor-enrolled).
---
# Factory PR babysit

Watch open **factory / ours** PRs after implement opens them until human-merge or closed. Fix CI, conflicts, and actionable review via the **existing** cloud agent on that PR. Never merge. Never second cloud agent on the same workstream.

Ideas adapted from personal `pr-babysit` references. Do **not** import that monolith (no Grok worktrees, `/loop`, Graphite-first harness, or session state files under `~/.grok`).

## Owners

| Role | Does |
| --- | --- |
| Argus | Runs the fix loop (CloudAgent reply) |
| Atlas (floor) | Watchlist, surfaces human-merge ready, refuses thrash |
| Daedalus | Taste re-DRR after babysit pushes a taste fix — not auto-approved by babysit |
| Human | Merge only |

## Watchlist (ours only)

A PR is **on babysit** when **any** of:

1. `CloudAgent find_by_pr` returns a factory-owned cloud agent (Atlas / Argus / Daedalus / this workstream), or
2. PR author login is `crisadamo`, or
3. Floor explicitly enrolled it, or
4. Linked Linear factory ticket (Athena → Daedalus → Argus) with an active cut we opened

It is **not** on babysit when authored by teammates, Codex/Claude Code humans, PostHog bots, or other orgs — even if Cris is a requested reviewer or resolves a thread. On those wakes: stay quiet (no reply, no launch, no user ping).

It leaves when:

- Merged or closed, or
- Floor removes it (rare)

Process stacks **bottom-up** (walk `baseRefName` ↔ open PR `headRefName` chains). Prefer one babysit action per stack group per cycle.

Cron backup iterates **enrolled/ours** open factory PRs only — never a full-repo stranger scan.

## Hard rules

1. **Never merge.**
2. **One cloud agent per workstream** — `find_by_pr` → `reply` that agent. Do not launch a parallel agent on the same PR.
3. Model lock on every reply: `grok-4.7`, `reasoning_effort: xhigh`, `fast: false`.
4. **≤3 code-fix pushes per PR per cycle.** Cap-blocked threads still get a substantive technical reply (what to change, where, why) — never “Will fix” / “Ack”.
5. Inject repo **Code Review Memory** top patterns into every fix reply (exact path from factory runbook — never paraphrase near-homophones).
6. Force-push only with lease-safe tooling (`--force-with-lease` or stack CLI that does the same).
7. Do not narrate “replied to cloud agent” without the tool call in the same turn.
8. Quiet when nothing actionable (healthy / pending only) **or** when the PR is not ours.

## Check cycle (one PR)

Resolve repo + PR number from the wake or watchlist. **Ownership gate first** — if not ours, stop. Then query PR state (mergeable, checks, review decision, unresolved threads).

Evaluate in order:

### 1. Merged or closed

Drop from babysit. If merged and factory-owned, factory merge retro owns writeback — babysit does not duplicate it.

### 2. Merge conflicts

Reply the cloud agent: rebase/restack onto the correct base (stack parent from PR Plan DAG, else default branch). Verify build/typecheck instruction in the reply. Comment once after push summarizing the restack.

### 3. CI failed

Pull failed check names + failed log tails. Reply the cloud agent with:

- Exact failing check
- Failure excerpt
- Concrete fix ask
- Past issues to avoid (Code Review Memory + subsystem playbook landmines)

One failing check = one fix action toward the cap.

### 4. Changes requested / unresolved threads

Classify each item:

| Source | Action |
| --- | --- |
| Bot CQ (Greptile / Codex) P0/P1 | CloudAgent reply fix now |
| Daedalus / Argus taste (concrete seam) | CloudAgent reply fix → then request Daedalus re-DRR |
| Human reviewer | CloudAgent may draft the fix; do not claim human-merge ready until that human re-reviews |
| Question / out of scope | Substantive reply only — no code churn |

Always evaluate **every** unresolved thread. Cap blocks code, not evaluation.

Never empty acknowledgements. If you fixed in code, reply **after** push with the commit SHA.

### 5. Cancelled / timed-out CI

Flag `ci_needs_attention`. Do not thrash auto-reruns unless the platform has a safe rerun path and the failure is clearly infra.

### 6. Checks pending

Wait. Still act on conflicts / known review items in the same cycle.

### 7. All green

If taste DRR already approve / approve-with-residual and no open P0/P1: floor surfaces **human-merge ready**. Babysit stays quiet unless a new event regresses it.

## CloudAgent reply contract

Every fix reply must include:

1. Goal (one sentence)
2. Constraints (ticket id, files/seams, “no drive-by”)
3. Evidence (CI log excerpt, review quote, conflict files)
4. Past issues to avoid (CRM patterns)
5. Done means: pushed commit + what to re-check

Prefer `reply` over `launch`. Use `interrupt: true` only when the user asked to stop/redirect that agent, or the in-flight turn is clearly wedged on the wrong task.

## Enrollment

On factory PR open (or floor enroll):

1. Confirm ownership gate + Linear + cloud agent association (`find_by_pr`)
2. Add to watchlist
3. Run one immediate check cycle
4. If no cloud agent is attached, tell floor — do not invent a second implement agent without Argus

## Reporting

When something changed on an ours PR: brief note to the user (PR number, what broke, what was pushed, residual). When nothing changed or not ours: stay silent.

## Anti-patterns

- Babysitting teammate / Codex / bot PRs because Cris was CC’d as reviewer
- Importing personal pr-babysit harness verbatim
- Auto-merge or “LGTM, merging”
- Second cloud agent “to go faster”
- Ignoring human review while marking human-merge ready
- Fixing nits under the cap while P0/P1 remain
- Repo-wide CI listener on `main` only pretending to cover PR checks — use event wakes + check-cycle CI query (and cron backup if needed)

## Related

- `factory-runbook` (CQ + babysit pointer)
- Taste pack + `google-code-review` / `review-conceptual-integrity`
- `plan-dispatch` (model lock)
- Stack skills when restacking
