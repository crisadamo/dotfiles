# Design for low cost of understanding and change

## Evaluate from outside

Write ordinary and failure-path usage before internals. Identify what the caller must know: ordering, representation, retry, cleanup, defaults, and exceptional states. Count concepts and coordination obligations, not only methods or lines.

A useful module completes a coherent capability and hides a meaningful decision: storage layout, protocol, scheduling, lifetime, validation, or algorithm. Name it. If several modules know the same private rule, repair ownership or the interface. Load/validate/transform/save modules can scatter one body's knowledge; organize by what must remain consistent.

Use stable vocabulary, sensible defaults, explicit units, predictable errors, and composable inputs/outputs. Keep advanced behavior discoverable without forcing ordinary callers to configure it. Define an escape hatch's guarantee boundary. A short wrapper can still leak a complicated protocol.

Use classes for owned state/lifetime, data/functions for values and transformations. Dependency injection can be one function argument. Add a container, repository interface, builder, plugin system, event bus, or policy framework only when a concrete need repays the concepts.

## Compare economically

For consequential choices compare the simplest viable baseline with a structurally different alternative. Rehearse ordinary use, failure recovery, a likely next change, slow/unavailable dependency, mixed versions, unfamiliar-operator diagnosis, and expected load. Compare invariant enforcement, caller knowledge, change amplification, operations, latency/cost, migration, and reversibility.

“Extensible” needs a named expected extension and the simpler alternative's actual cost. Estimate request mix, fan-out, growth, concurrency, hot keys, peak/steady utilization, and relevant latency percentiles before adding distribution. Identify the first bottleneck and a measured trigger for changing architecture. Label assumptions and validate them. High engineering quality does not require a hyperscale topology.

## Resolve heuristics

| Heuristic | Useful interpretation | Limit |
| --- | --- | --- |
| KISS | Reduce concepts and coordination | Preserve necessary failure/domain distinctions |
| DRY | One authority for duplicated knowledge | Similar syntax can represent different policies |
| YAGNI | Avoid unsupported features/extension points | Current invariants and migrations still need mechanisms |
| Single responsibility/cohesion | Keep knowledge that changes together together | Avoid micro-layers repeating the same rules |
| Open/closed | Stabilize a boundary with real variation | Do not build a plugin framework to avoid editing one function |
| Liskov/substitution | Preserve behavior, errors, timing, and lifetime promises | No stronger preconditions or weaker guarantees |
| Interface segregation | Expose the needed capability | Do not force callers to assemble one operation |
| Dependency inversion | Own capability contracts in application language | A rename-only interface hides nothing |
| Tell, don't ask | Let the owner enforce mutations/invariants | Queries on immutable data are legitimate |
| Unix composition | Cohesive capabilities with explicit contracts | Plumbing must not export recovery/coordination complexity |

Encapsulation controls knowledge and valid operations, not merely field visibility. Conceptual integrity means consistent meanings and ownership, not one pattern everywhere.

## Demonstrate simplification

Name what disappears, who benefits, and how behavior remains intact. Compare caller examples or concrete change scenarios. Preserve concurrency guarantees, trust checks, and compatibility. A one-use abstraction can earn its place by owning an invariant; a many-use helper can still be wrong. Reduced LOC alone does not establish improvement.
