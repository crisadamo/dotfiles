# Review and Calibration Playbook

Use this reference for substantial design reviews, adversarial testing, scoring, and session-end coaching.

## Contents

1. Review output
2. Anti-pattern detection
3. Red-team attacks
4. Engineering taste rubric
5. Difficulty escalation
6. Session close

## Review output

Organize a substantial adversarial review as follows:

1. **Design in one sentence** — State what the architecture actually does.
2. **Strongest idea** — Identify the mechanism that gives the design leverage.
3. **Hidden assumptions** — List the conditions on which correctness or viability depends.
4. **Missing or weak invariants** — Identify underspecified guarantees.
5. **State ownership** — Expose ambiguous, fragmented, or duplicated authority.
6. **Failure attack** — Walk through relevant crash, retry, ordering, and concurrency cases.
7. **Accidental complexity** — Identify machinery not clearly required.
8. **Abstraction smell** — Identify concepts without a concrete reason to exist.
9. **Compression** — Propose the smallest materially equivalent design.
10. **What would change my mind** — Name the constraints that would justify the extra complexity.

Adapt the sections to the design. Do not pad a small review to fill the template.

## Anti-pattern detection

Actively flag these patterns when evidence supports them:

- **Architecture by noun:** Starting from services, workers, agents, pipelines, or other components before identifying invariants.
- **Framework-shaped thinking:** Allowing framework primitives to define the domain.
- **Premature distribution:** Adding network boundaries without a scale, ownership, isolation, deployment, or organizational reason.
- **Premature genericity:** Building interfaces or type systems for hypothetical future implementations.
- **Duplicate authority:** Allowing multiple systems to behave as canonical owners.
- **Async by default:** Adding queues or events without a concrete requirement.
- **Event soup:** Producing many events without explicit transitions or ownership.
- **Hidden temporal coupling:** Depending on operations occurring soon enough or in an undocumented order.
- **Retry blindness:** Executing external effects without an explicit idempotency and ambiguity strategy.
- **Abstract noun explosion:** Dominating the design with Manager, Service, Factory, Coordinator, or similar abstractions.
- **Diagram complexity:** Creating a sophisticated picture that cannot be explained by a small set of invariants.

## Red-team attacks

Select attacks that reveal design quality; do not introduce arbitrary chaos.

- Remove the queue, cache, or secondary datastore. State exactly what breaks.
- Collapse two services. Identify the lost property.
- Make delivery at-least-once; then duplicate and reorder every event.
- Crash immediately before and after each external effect.
- Make a dependency unavailable for 30 minutes.
- Add two concurrent writers.
- Increase or reduce scale by 100 times.
- Require a nearby feature that violates the proposed abstraction.
- Replace the framework while preserving domain behavior.
- Slow the network and make clocks disagree.
- Require an operator to inspect and repair one broken entity manually.

## Engineering taste rubric

Score each dimension from 1 to 5. Use the anchors below; interpolate only when evidence warrants it.

### 1. Problem decomposition

- **1:** Architecture precedes understanding.
- **3:** Major states and constraints are explicit.
- **5:** The problem is reduced to a small set of precise facts and transitions.

### 2. Invariant quality

- **1:** Guarantees are vague.
- **3:** Main invariants are identified.
- **5:** The architecture follows almost mechanically from explicit invariants.

### 3. State ownership

- **1:** Authority is ambiguous or duplicated.
- **3:** Ownership is mostly clear.
- **5:** Every important state has one obvious authority and mutation path.

### 4. Failure clarity

- **1:** The design covers only the happy path.
- **3:** Main failures are handled.
- **5:** Crash, retry, order, and concurrency behavior are explicit and unsurprising.

### 5. Simplicity

- **1:** The design has a large conceptual surface.
- **3:** Complexity is reasonable.
- **5:** Machinery is near-minimal for the requirements.

### 6. Abstraction quality

- **1:** Abstractions are speculative or generalized.
- **3:** Most abstractions are earned.
- **5:** Each abstraction protects a concrete invariant or concentrates unavoidable complexity.

### 7. Local reasoning

- **1:** Understanding behavior requires tracing many components.
- **3:** Some boundaries can be understood independently.
- **5:** Important behavior can usually be understood locally.

### 8. Evolvability

- **1:** New cases require cross-system surgery.
- **3:** Common extensions are contained.
- **5:** Likely changes align with existing boundaries without speculative generality.

### 9. Operability

- **1:** Failures are difficult to observe or repair.
- **3:** Basic observability and recovery exist.
- **5:** State, failures, retries, and repair paths are explicit and inspectable.

### 10. Performance model

- **1:** Performance is hand-waved.
- **3:** Main bottlenecks are understood.
- **5:** The cost model is explicit and important assumptions are measurable.

Report `Total: X / 50`, then give:

- Best property
- Biggest weakness
- One deletion
- One invariant to strengthen
- One experiment to run
- What an exceptional engineer would question next

Do not inflate scores for encouragement. A 30/50 design can be shippable; the score exists for calibration.

## Difficulty escalation

Raise the bar as the user improves:

1. Identify state.
2. Identify invariants.
3. Model transitions.
4. Reason about failure.
5. Handle concurrency.
6. Handle distribution.
7. Model performance.
8. Design operational behavior.
9. Simplify mature designs.
10. Derive novel abstractions.

Do not repeat introductory lessons after the user demonstrates mastery.

## Session close

For a substantial coaching session, close with:

- **What you did well:** The strongest reasoning move the user made.
- **Where your reasoning weakened:** The point where the user jumped levels, assumed an abstraction, or missed a shaping constraint.
- **Principle to internalize:** One compact lesson.
- **Next drill:** One specific exercise targeted at the weakness.

The objective is not only a better design; it is improved independent judgment.
