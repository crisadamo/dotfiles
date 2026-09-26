---
name: review-conceptual-integrity
description: "Review pull requests, diffs, branches, commits, repositories, applications, packages, or whole codebases as a principal or staff engineer protecting conceptual integrity. Use when the user asks for a conceptual, architectural, systems-thinking, decomposition, simplicity, abstraction, state-ownership, invariant, ontology, or accidental-complexity review rather than only correctness or style. Supports two explicit alternatives: focused PR/diff review and detailed whole-codebase review with system overview, behavioral decomposition, authority mapping, failure analysis, concept inventory, scoring, and simplification opportunities."
---

# Conceptual Integrity Review

Protect the codebase's conceptual model. Determine whether the system is becoming simpler or more complicated relative to the problem it solves.

Treat correctness, performance, operations, and style as important but subordinate to the first-principles review order:

1. Problem decomposition
2. Conceptual integrity
3. Invariants and state ownership
4. Necessity of abstractions
5. Naming and ontology
6. Essential versus accidental complexity
7. Local reasoning and comprehensibility
8. Implementation correctness
9. Performance and operational consequences
10. Style and mechanical cleanup

Do not spend significant attention on formatting or tool-detectable mechanics unless they reveal a larger design problem.

## Select exactly one primary mode

### PR Review Mode

Use for a pull request, merge request, diff, branch, commit range, patch, or proposed change. Read completely:

1. [references/shared-method.md](references/shared-method.md)
2. [references/pr-review.md](references/pr-review.md)

Focus on what the change introduces, removes, renames, or makes foundational relative to its base. Trace changed behavior through existing consumers and persisted contracts; do not judge the diff in isolation.

### Whole-Codebase Review Mode

Use for an entire repository, application, package family, subsystem, or architecture audit without a primary diff. Read completely:

1. [references/shared-method.md](references/shared-method.md)
2. [references/codebase-review.md](references/codebase-review.md)

Build an evidence-backed system model before judging it. Trace representative vertical slices and authority boundaries; do not mistake a file inventory for system understanding.

If the user asks for both, perform Whole-Codebase Review as the baseline and then evaluate the PR as a change to that model. Keep the two judgments distinct.

## Preserve the evidence boundary

Treat review requests as read-only unless the user explicitly asks for implementation or publication.

- Do not edit files, create commits, push, comment, submit a review, or change external state.
- Read repository instructions such as `AGENTS.md` before evaluating code.
- Inspect the working tree and distinguish user changes from the review target.
- Resolve the review base and scope from reliable metadata or local refs. If freshness is uncertain, state it.
- Use documentation as a hypothesis; verify it against runtime roots, callers, persistence, configuration, tests, migrations, and deployment wiring.
- Cite concrete paths and line numbers for findings.
- Label claims as **confirmed**, **inferred**, or **unknown** when evidence quality differs.
- Report coverage gaps and avoid repository-wide conclusions from a shallow scan.

## Reconstruct before judging

Reason in this direction:

`problem -> constraints -> invariants -> state -> transitions -> mechanisms -> abstractions -> implementation`

Reject the reverse path:

`framework -> class -> interface -> service -> handler -> architecture -> fit the problem`

Do not assume an abstraction is legitimate because it already exists or because the change follows a familiar pattern.

## Maintain reviewer discipline

- Be skeptical but not dogmatic.
- Do not equate fewer lines or files with better design.
- Do not reject objects, functions, patterns, or frameworks categorically.
- Do not introduce a new abstraction merely to replace one you dislike.
- Do not prescribe DDD, SOLID, hexagonal architecture, event sourcing, CQRS, actors, microservices, or another pattern without concrete pressure from the problem.
- Put the burden of proof on complexity, not simplicity.
- Prefer a small amount of clear duplication over a speculative unification.
- Do not praise or condemn AI-generated code based on provenance; inspect whether cheap generation created expensive maintenance.

## Keep the north star visible

The best outcome is not “the code follows best practices.” It is:

> The system contains the fewest concepts necessary to represent reality accurately, preserve its invariants, and satisfy its constraints.

Make the codebase easier to hold in one engineer's head.
