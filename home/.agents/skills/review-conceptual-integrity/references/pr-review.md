# PR Conceptual Integrity Review

Use this mode for a pull request, diff, branch, commit range, or patch.

## Contents

1. Establish scope and evidence
2. Reconstruct the change
3. Compare against the minimal design
4. Review the change in context
5. Classify findings
6. Produce the review

## 1. Establish scope and evidence

Determine:

- base and head revisions;
- changed, added, deleted, generated, and migrated files;
- PR description, issue, or acceptance criteria when available;
- relevant repository instructions;
- focused tests and baseline validation evidence;
- existing working-tree changes that are outside review scope.

Inspect the diff, then open complete changed files and the smallest set of consumers, callers, tests, schemas, migrations, configuration, and runtime wiring needed to understand behavior. Use history when it clarifies why a boundary exists.

Do not assume unchanged code is correct, but keep findings attributable to the PR. Distinguish:

- **Introduced:** created by the change.
- **Exposed:** pre-existing but made reachable, relied upon, or materially worsened by the change.
- **Unrelated:** outside the review target; mention only when necessary to bound confidence.

## 2. Reconstruct the change

State what observable behavior the PR is actually adding or changing without copying its implementation terminology.

Reconstruct:

- goal;
- hard constraints and inferred assumptions;
- canonical and derived state;
- state owner and mutation paths;
- meaningful transitions;
- transactional and external-effect boundaries;
- invariants required for correctness.

Call out any item that cannot be established from evidence.

## 3. Compare against the minimal design

Construct the simplest plausible design that satisfies the known requirements. Use it as a control, not an automatic recommendation.

For every major concept added by the PR ask which concrete requirement pays for it. Estimate the net conceptual delta:

- concepts added;
- concepts removed;
- concepts renamed or split;
- new authorities, states, lifecycles, events, configuration, or failure modes.

Pay particular attention when a small behavioral change adds many nouns.

## 4. Review the change in context

Trace at least one complete changed path from ingress or caller through the domain transition, persistence, and external effects. For each important step, test:

- ownership and invariant enforcement;
- duplicate or concurrent execution;
- crash before and after persistence;
- ambiguous external success;
- backward compatibility and migration behavior;
- whether local reasoning improves or degrades;
- whether likely changes land in the logical owner.

Pressure-test new abstractions, names, indirection, and generalization using the shared method. Do not accept an abstraction solely because it mirrors existing ceremony.

## 5. Classify findings

Use exactly these severities:

### BLOCKING

Use when the PR introduces a fundamentally wrong boundary, confused authority, correctness or invariant violation, false domain concept, foundational unnecessary framework, unmodeled failure semantics, or substantial accidental complexity that will materially damage the codebase.

### STRONG SUGGESTION

Use when the change works but has an important opportunity to simplify the conceptual model: an unnecessary layer, vague abstraction, premature interface, duplicated concept, or naming problem that obscures ownership.

### NIT

Use only for small improvements that do not materially affect architecture or comprehension. Avoid flooding the review with nits.

Tie every finding to concrete evidence and a consequence. Do not invent blocking severity merely because an alternative is aesthetically preferable.

## 6. Produce the review

Use this structure. Omit no mandatory section; keep empty sections explicit.

### 1. What I Think This PR Is Actually Doing

Explain the behavioral change in plain language. Do not copy the PR description blindly.

### 2. Reconstructed Model

State concisely:

- Goal
- Constraints
- State
- State owner or owners
- Transitions
- Important invariants

Mark unclear items.

### 3. Complexity Assessment

Score from 1 to 5:

- Problem decomposition
- Conceptual integrity
- Naming precision
- State ownership clarity
- Abstraction necessity
- Local reasoning
- Overall simplicity

Use:

- **5:** exceptionally clear and minimal;
- **4:** strong;
- **3:** acceptable but improvable;
- **2:** problematic;
- **1:** fundamentally confused.

Do not inflate scores. Explain each score in one concise sentence when it is not self-evident.

### 4. Findings

Order findings by architectural importance. For each meaningful finding use:

#### `[Severity] Short finding title`

- **Evidence:** Exact paths and lines.
- **Observed:** What the PR does.
- **Why this matters:** The architectural or correctness consequence.
- **Pressure test:** The question the author must answer.
- **Simpler model:** A materially simpler alternative when one exists.

Do not prescribe a large rewrite unless it materially improves the system.

### 5. Concepts Added

List important concepts introduced by the PR and classify each:

- **ESSENTIAL:** forced by the problem.
- **JUSTIFIED:** not strictly essential but earns its cost.
- **QUESTIONABLE:** evidence of pressure is insufficient.
- **REMOVE:** materially unnecessary or misleading.

Give one sentence of reasoning per concept.

### 6. What I Would Delete

Identify code, concepts, layers, configuration, or abstractions that appear unnecessary. This section is mandatory. If nothing should be deleted, say so and explain why the added surface is earned.

### 7. Missing Invariants

Identify guarantees the implementation relies on but does not clearly encode, enforce, test, or document. If none are missing, say so.

### 8. The Minimal Alternative

Describe the simplest architecture that could satisfy the same requirements. Make clear that it is a comparison baseline, not automatically the recommended implementation. State which constraints justify deviations from it.

### 9. Final Judgment

Choose exactly one:

- **MERGE — conceptually strong**
- **MERGE — minor simplification opportunities**
- **REQUEST CHANGES — unnecessary complexity**
- **REQUEST CHANGES — conceptual model needs rework**
- **REQUEST CHANGES — correctness/invariant violation**

Give a concise explanation tied to the highest-impact evidence.
