---
name: Factory runbook
description: >-
  Use when running eng work through Athena → Daedalus → Argus factory (intake
  through human merge and ours-only retro writeback), or refusing a weak spec /
  skipping a gate.
---
# Factory runbook

Closed loop for eng work. Atlas (or the floor manager) orchestrates; Athena frames; Daedalus designs; Argus implements. Agents never merge.

## The line

Intake (Slack / Sentry / Linear / media) → **risk tier** → **Athena** (problem + acceptance + contract seeds) → **Daedalus** (ADR/spec, illegal states, PR Plan when multi-PR) → **Argus** (implement via cloud agent, Grok 4.7 xhigh) → taste pack + Greptile + Codex CQ (+ security pass when High) → Daedalus/Argus DRR → **babysit until human-merge** → **human merge** → deploy evidence → **retro** → write back into skills / ADRs / Linear / Code Review Memory.

## Gates (non-negotiable)

1. No code without a Linear issue and acceptance criteria.
2. No PR without a stacked/correct base and Dev Review Ready.
3. No “LGTM” without the four taste skills — `design-deep-modules`, `simplicity-complexity-bar`, `design-conceptual-integrity`, `design-simplicity-default` — plus `google-code-review` / `review-conceptual-integrity`, and Greptile/Codex when those loops are in play.
4. Before any eng PR taste/DRR on `PatagonAI/platform`, read repo **Code Review Memory**: `.agents/docs/CODE-REVIEW-MEMORY.md` (exact name — never `REVIEW-AREAS.md`, never `CORE-REVIEW-MEMORY.md`). STANDARDS.md is the bar; Code Review Memory is where defects keep showing up.
5. Agents never merge. Human gate stays human.
6. One cloud agent per workstream. Cancel duplicates; do not thrash in parallel on the same PR/issue.
7. Asterion/David (or any external) PRs get the same bar — no skip lane.
8. Risk tier is set at intake and drives which stages fire. Do not lower the tier because the diff looks small.
9. Orchestrators (Atlas / Argus) must not narrate “launched X” without the matching tool call in the same turn.
10. Taste/DRR endorsements must match **files at HEAD**, not the PR summary. If the body claims a procedure/guards/snap-restore and the migration file is a naive DDL sequence, say so and do not APPROVE the missing mechanism (#1777).
11. No spec goes to build without both mandatory spec passes: Pass 1 codebase grounding before writing, Pass 2 grounding re-check + adversarial review after writing.

## One owner per stage

| Stage | Owner |
| --- | --- |
| Problem framing + acceptance + risk tier | Athena (Atlas may set tier when intake is clear) |
| Design integrity (ADR/spec, contract, illegal states, PR Plan) | Daedalus |
| Branch, fix loop, CQ | Argus |
| Babysit (CI / conflicts / review → CloudAgent reply) | Argus runs fixes; Atlas owns watchlist + human-merge surface |
| Queue, sequencing from PR Plan DAG, “not ready” | Atlas (floor manager) |
| Merge | Human only |

## Risk tier (set at intake)

Choose **before** dispatch. Do not drop the tier merely because the patch is small.

| Tier | When | Stages that fire |
| --- | --- | --- |
| **Low** | Local, reversible, one module; no durable/public contract change | Athena acceptance (short) → Argus implement → CQ + taste → human merge. Skip ADR unless something surprises. |
| **Medium** | New capability, cross-module seam, internal API, meaningful state transition, moderate migration | Athena acceptance + contract seeds → Daedalus short brief (illegal states + ≥1 alternative) → Argus → CQ + taste → human merge. |
| **High** | Public API, durable schema, auth/security/PII, money, distributed coordination, new service, foundational abstraction, irreversible migration | Full Athena + Daedalus ADR (contract + failure rehearsal) → mandatory PR Plan if >1 PR → Argus → CQ + taste + **security pass** → human merge. |

Floor manager refuses work that has no tier, or that claims Low while touching auth, PII, money, or schema.

## Stage checklist

### 1. Intake

- Capture signal (bug report, Sentry, Slack, product ask).
- Athena writes problem statement + acceptance criteria on a Linear issue (or epic + children).
- Set **risk tier** (Low / Medium / High) on the ticket.
- Refuse work that has no ticket or fuzzy acceptance.

### 2. Spec

- Daedalus owns ADR/spec under `docs/` when the tier requires it (Medium short brief; High full ADR); use `plan-add` / `plan-write` / `plan-spec` as appropriate.
- **Pass 1: codebase grounding (mandatory, before any spec text).** Explore the repo first and record a Codebase Grounding section with file:line evidence: ID/reference fields as the repo names them (e.g. `organizationPublicId`, not `org_id`; `newId()` public IDs vs internal bigint), table/column naming, timestamps, JSON/enum style, where schemas/migrations live, type/namespace names, worker/job structure (queue helpers, signature verification, dedup ids, retries), route naming, feature-config and tool naming, and the closest existing pattern. Every name in the spec comes from that list or is marked NEW with the convention it follows.
- **Pass 2: grounding re-check + adversarial review (mandatory, after the spec is written, before build).** One pass, two jobs: (a) re-compare every name, type, table, and pattern in the spec against the repo and fix drift; (b) actively try to break the spec: question assumptions, find missing edge cases and failure modes, flag over-specification (logic/tables/endpoints not needed for the outcome) and under-specification (ambiguous contracts), and challenge whether what's specified is what should be built. Record findings and resolutions in the spec (a short 'Pass 2 review' section). Prefer a different reviewer than the writer (e.g. Daedalus writes, Argus or Athena challenges). No dispatch until Pass 2 is recorded and its blockers are resolved or escalated to Cris.
- **Contract** (state as much as the tier warrants — expand illegal states):
  - **Trust** — untrusted inputs, authz, validation boundary
  - **Effects** — I/O, time, concurrency, vendor calls made explicit
  - **Failure** — partial success, retry, idempotency, cancellation, overload
  - **Change** — compatibility with old clients, deployments, stored data; rollback
- Illegal states and seams named before code.
- **PR Plan required when the design needs more than one PR**: ordered DAG (title, files/components, dependencies, brief). Atlas sequences human-merge and rebases from that DAG — do not invent landing order in chat.
- Writer↔reviewer disagreement twice on a design point → escalate to the human (stalemate). Do not spin.
- Atlas refuses weak specs: send back, do not dispatch. A spec without a recorded Pass 1 (Codebase Grounding) and Pass 2 (grounding re-check + adversarial review) is weak by definition.
- Do not ship an invariant in code without the matching spec/constraint, update (see WhatsApp inbound media playbook).
- Lock single-valued contract knobs (thresholds, authority functions, scope grains, **and final UI control shapes** — select vs editable picker, amount caps, custom-value preserve) in the first ADR/ticket cut before opening the impl PR — ranges and “TBD ownership” force incompatible invent-on-implement (see #2056 Greptile pass → later canary/`retryAfterMs`/portfolio locks; #2180 ENG-948 dropdown lock → shipped ±1 pickers).

### 3. Implement

- Argus dispatches **one** cloud agent per workstream.
- Model lock: `grok-4.7`, `reasoning_effort: xhigh`, `fast: false` (see `plan-dispatch`).
- Scope stays inside the ticket/plan. No drive-by refactors.
- Exact identifiers in the prompt (paths, filenames, ticket ids). Near-homophones (`CORE-*` vs `CODE-*`) are bugs — put the literal string in the dispatch, not a paraphrase.
- **Inject Code Review Memory into the cloud-agent prompt**: read `.agents/docs/CODE-REVIEW-MEMORY.md` and paste the top recurring defect patterns (and any subsystem landmines) as “Past issues to avoid” — do not paraphrase the path; quote it literally. Prefer this over a second shadow memory file.
- Browser-facing timing/conversion helpers belong in a Core browser-safe facade (e.g. `@patagon-ai/core/agent-v2/follow-up-delay`), not `packages/common`, when portals must import them (#2180).
- Prefer the smallest read-path remint for expired conversation media links over sprawling shared upload/storage abstractions unless the ticket demands them (#2193 → #2195).

### 4. CQ + taste DRR

- Greptile + Codex (or standing CQ loop) until clean of P0/P1.
- Read `.agents/docs/CODE-REVIEW-MEMORY.md` before taste DRR.
- **High-risk (or Sensitive Data / Auth findings from Greptile/Codex)**: run an explicit **security pass** before marking human-merge ready (PII masking, authz, secret leakage, injection). Not required on every Low ticket.
- Taste DRR: request changes with a **concrete seam**, fix, re-verify, then mark human-merge ready.
- Template: #2109-style pass (request changes → fix → re-verify → human merge). That is the only path.
- **Code-judo tone** on taste DRR: when the PR preserves incidental complexity and a simpler reframing would delete whole branches/helpers/layers, push that as a presumptive blocker — not a nit. Prefer deleting complexity over rearranging it. File crossing ~1k lines from the PR, ad-hoc special-case branches into busy flows, and thin wrappers are the same class of smell. Keep approve-with-residual for true non-blocking nits; do not demand zero nits.
- Implementer↔reviewer stalemate (same issue reopened after wontfix twice) → escalate to the human.
- **Babysit after open**: factory PRs stay on [Factory PR babysit](sand-workflow:factory-pr-babysit) until human-merge or closed. Event routine + weekday cron backup drive CI/conflict/review wakes; Argus replies the existing cloud agent (`find_by_pr` → `reply`); Atlas surfaces human-merge ready. Caps, never-merge, and CRM injection live in that skill — do not duplicate a second babysit harness. **Ours only** (same gate as merge retro): crisadamo / factory cloud agent / floor-enrolled — not teammate/Codex/bot PRs.
- After a multi-week restack of Medium/High work, stale human APPROVED on an old SHA does not count — get a fresh human look (or explicit Core Team merge note) before self-merge (#1777).
- Harness-only component screenshots are not authenticated persistence proof — call that residual out before human-merge when the PR claims portal UX (#2180).
- When Bugbot/Codex are usage-capped on a security-sensitive media/URL path, get at least one human look (or explicit Core Team note) before self-merge (#2195).

### 5. Human merge

- Floor manager surfaces mergeable PRs in PR Plan / risk order; does not merge.
- After merge: deploy evidence when relevant (Sentry quiet, smoke, env purge notes).
- A gh-stack / Graphite dry-run “merge” is not a landed merge — verify the tip is on the intended base before closing Linear (see #2105 dry-run vs live #2119).
- After an ADR base merges, restack the stacked impl PR onto `main` in the same cycle.
- Close superseded factory PRs and attach the landing PR on the Linear ticket in the same retro cycle (#2193 left open until #2195 retro).

### 6. Retro + writeback (required for “done”)

**Ours only.** Factory eng merge retro fires on `pr-merged` for `PatagonAI/platform` with author allowlist `crisadamo`, plus the same ownership gate as babysit (`find_by_pr` / floor enroll / factory Linear cut). Teammate and bot merges stay silent — no note, no writeback thrash.

Three bullets max, then **one** writeback. No retro → not done.

Bullets:

1. Outcome (what shipped / what failed)
2. What broke or surprised
3. What we’d do differently next time

Writeback (pick at least one):

- Patch a standing skill (subsystem playbook or factory runbook)
- Append a recurring defect class to repo Code Review Memory when it is platform-wide (this is the implement-style memory flush — keep one corpus)
- Durable memory fact (invariant only)
- ADR residual or amend
- Follow-up Linear ticket (class of bug → next seed)
- `plan-retro` when a docs/specs plan moved to done/discarded

## Subsystem playbooks

Before starting work in a known subsystem, read that playbook’s landmines (WhatsApp inbound media / R2, WhatsApp outbound send-path, MCP tools, meetings / calendar / visit booking, qualification extraction, web embed, agent model routing / Responses cutoff, LeadSource / attribution UTM, follow-up delay UI, conversation media renewal/rendering, etc.). After a retro that finds a new landmine, append it there. Platform-wide recurring review defects also go into Code Review Memory.

## Anti-patterns

- More bots instead of a tighter loop
- Auto-merge
- Retros as dashboards
- Retro thrash on every human/teammate merge in the repo
- Parallel cloud agents on the same workstream
- “LGTM” without taste skills or without Code Review Memory
- Shipping without Linear acceptance criteria
- Treating chat as source of truth over Linear / ADR / plan files
- Inventing near-homophone filenames (`CORE-REVIEW-MEMORY` for `CODE-REVIEW-MEMORY`) — quote the exact path in the agent prompt
- Claiming Low risk on auth / PII / money / durable schema
- Over-speccing Low work with a full ADR, or under-speccing High work with “just ship it”
- Standing up a second review-memory file instead of writing back to `.agents/docs/CODE-REVIEW-MEMORY.md`
- Blocking merge on nits when approve-with-residual is enough
- Narrating subagent / cloud-agent launches without the tool call
- Six parallel reviewers / “effort 5” by default — reserve specialists for High (or Sensitive Data hits)
- Leaving factory PRs unwatched after open (babysit is mandatory until human-merge or closed)
- Closing Linear on a stack dry-run merge while the real impl PR is still open
- Endorsing a migration mechanism from the PR summary without opening the SQL at HEAD (#1777 procedure vs naive ADD/copy/CHANGE/DROP)
- Self-merging a restacked Medium/High PR on a stale human APPROVE from weeks earlier
- Putting portal-imported timing/conversion helpers in `packages/common` instead of a Core browser-safe facade (#2180)
- Shipping a sprawling remint/upload rewrite when the smallest dual-app read-path remint would do (#2193 → #2195)
- Leaving superseded factory PRs open and Linear still on the dead branch after the slim PR merges (#2193 / ENG-966)

## Related skills

- Plans: `plan-init`, `plan-add`, `plan-write`, `plan-sync`, `plan-status`, `plan-dispatch`, `plan-retro`
- Taste: `design-deep-modules`, `simplicity-complexity-bar`, `design-conceptual-integrity`, `design-simplicity-default`
- Review: `google-code-review`, `review-conceptual-integrity`
- Loop: `factory-pr-babysit`
- Subsystems: `mcp-tools-playbook`, `meetings-playbook`, `qualification-extraction-playbook`, `whatsapp-outbound-send-path-playbook`, `agent-model-routing-playbook`, `attribution-lead-source-playbook`, `follow-up-delay-ui-playbook`, `conversation-media-playbook`

## Provenance (ideas, not imports)

Ideas drawn from AI-native SDLC writeups and OpenAI factory public notes; the live loop above is authoritative for Patagon.
