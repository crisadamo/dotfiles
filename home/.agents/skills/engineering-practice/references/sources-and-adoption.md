# Sources, reviewed skills, and adoption

## Scope and attribution

This practice is an original synthesis informed by the sources below and the user's dotfiles. It is not a claim that Google, Meta, OpenAI, Microsoft, xAI, or SpaceX use one identical process, or that any named engineer endorses it. High quality comes from decisions and evidence, not impersonating a famous engineer.

## Primary foundations

| Source | Specific contribution |
| --- | --- |
| [Lamport: State the Problem Before Describing the Solution](https://lamport.azurewebsites.net/pubs/state-the-problem.pdf) | Establish correctness requirements independently of the proposed solution, making alternatives meaningfully comparable. |
| [Lamport: Who Builds a House without Drawing Blueprints?](https://www.microsoft.com/en-us/research/publication/builds-house-without-drawing-blueprints/) | Informal specification as a useful engineering artifact. The publication record was verified; the CACM full-text page returned 403 during this review. |
| [Lamport: Specifying Systems](https://lamport.azurewebsites.net/tla/book.html) | State, actions, invariants, and temporal properties for reasoning above implementation. The practice uses formal methods selectively. |
| [Parnas: On the Criteria To Be Used in Decomposing Systems into Modules](https://www.cs.lafayette.edu/~gexia/cs301/resources/parnas.html) | Hide design decisions rather than dividing solely by execution stages. This university-hosted text is a digitized reprint; it warns of possible transcription errors. |
| [Ousterhout: Modular Design](https://web.stanford.edu/~ouster/cgi-bin/cs190-spring16/lecture.php?topic=modularDesign) | Evaluate interface knowledge versus hidden capability; design ordinary use carefully; compare alternate designs. Do not convert illustrative size heuristics into universal limits. |
| [Dean and Ghemawat: MapReduce](https://research.google/pubs/mapreduce-simplified-data-processing-on-large-clusters/) | A restricted computation interface lets the runtime own partitioning, scheduling, communication, and failure handling. The transferable lesson is where complexity lives, not that every workload should use MapReduce. |
| [Chang et al.: Bigtable](https://research.google/pubs/bigtable-a-distributed-storage-system-for-structured-data/) | A clear data model and carefully scoped operations support implementation choices. Tablet servers are not simply stateless: they maintain memtables and participate in recovery. |
| [Dean and Barroso: The Tail at Scale](https://research.google/pubs/the-tail-at-scale/) | Tail latency and utilization matter as systems compose and scale; reason about distributions and resource cost, not only averages. |
| [Google SRE: Handling Overload](https://sre.google/sre-book/handling-overload/) | Bound work, understand resource consumption, and make overload behavior part of the service contract. |
| [Google: The Standard of Code Review](https://google.github.io/eng-practices/review/reviewer/standard.html) | Favor evidence, improve code health, distinguish optional polish, and allow progress without demanding perfection. |
| [Rust Book: Methods](https://doc.rust-lang.org/book/ch05-03-method-syntax.html) and [Test Organization](https://doc.rust-lang.org/book/ch11-03-test-organization.html) | Keep data, behavior, and verification discoverable together. The TypeScript adaptation does not inherit Rust's ownership guarantees. |

The Unix, SOLID, DRY, YAGNI, and related entries in the design reference are scoped engineering heuristics in this synthesis, not verbatim rules attributed to these authors.

## pstack and Cursor review

Reviewed snapshot: [cursor/plugins at e43c7ee26e0038c6c1fa8380dd34ce86ff94cb2a](https://github.com/cursor/plugins/tree/e43c7ee26e0038c6c1fa8380dd34ce86ff94cb2a). Inventory: 50 pstack skill entrypoints, 18 cursor-team-kit entrypoints, and 3 thermos entrypoints. The review focused on architecture/domain/boundary/principle guidance and the review/verification paths, not every automation/helper. No separate skill named `cr` was found in those three packages at this snapshot; code-review intent was covered by the actual review skills.

| Source | Keep | Adapt or avoid |
| --- | --- | --- |
| [pstack architect](https://github.com/cursor/plugins/blob/e43c7ee26e0038c6c1fa8380dd34ce86ff94cb2a/pstack/skills/architect/SKILL.md) | Ground in existing code; write caller usage/types first; compare shapes; revise a disproven sketch | Mandatory model arena and fixed model slugs are harness-specific; alternatives should be proportional to consequences |
| [pstack model-the-domain](https://github.com/cursor/plugins/blob/e43c7ee26e0038c6c1fa8380dd34ce86ff94cb2a/pstack/skills/principle-model-the-domain/SKILL.md) | Replace scattered assumptions with an appropriate domain representation and clear ownership | Do not force state machines/registries where a plain function is enough |
| [pstack boundary discipline](https://github.com/cursor/plugins/blob/e43c7ee26e0038c6c1fa8380dd34ce86ff94cb2a/pstack/skills/principle-boundary-discipline/SKILL.md) | Concentrate parsing and adaptation at boundaries | Unconditional trust in internal types ignores erased types, mutation, persisted-version drift, and temporal invariants; state the trust argument |
| [pstack shared state](https://github.com/cursor/plugins/blob/e43c7ee26e0038c6c1fa8380dd34ce86ff94cb2a/pstack/skills/principle-separate-before-serializing-shared-state/SKILL.md) | Eliminate unnecessary sharing; enforce genuine shared ownership structurally | Process-local locks do not establish distributed guarantees |
| [pstack interrogate judgment](https://github.com/cursor/plugins/blob/e43c7ee26e0038c6c1fa8380dd34ce86ff94cb2a/pstack/skills/interrogate/references/lead-judgment.md) | Lead reviewer validates, deduplicates, contextualizes, and dismisses weak findings | Consensus is not proof; neither a finding quota nor a maximum count overrides evidence |
| [Cursor thermonuclear quality review](https://github.com/cursor/plugins/blob/e43c7ee26e0038c6c1fa8380dd34ce86ff94cb2a/cursor-team-kit/skills/thermo-nuclear-code-quality-review/SKILL.md) | Seek structural simplifications and ownership fixes, not just renames | The 1,000-line crossing rule and plausible missed simplification are presumptive blockers there; this practice requires a demonstrated consequence and migration-aware remedy |
| [thermos correctness/security review](https://github.com/cursor/plugins/blob/e43c7ee26e0038c6c1fa8380dd34ce86ff94cb2a/thermos/skills/thermo-nuclear-review/SKILL.md) | Trace changed behavior across boundaries; calibrate severity; inspect other reviews after independent analysis | “Nothing can slip through” is aspiration, not an achievable guarantee; report coverage and uncertainty |
| [Cursor verify-this](https://github.com/cursor/plugins/blob/e43c7ee26e0038c6c1fa8380dd34ce86ff94cb2a/cursor-team-kit/skills/verify-this/SKILL.md) | Falsifiable claims, baseline/treatment, concrete artifacts | Some claims need invariants/contract evidence rather than a performance comparison |
| [pstack test behavior](https://github.com/cursor/plugins/blob/e43c7ee26e0038c6c1fa8380dd34ce86ff94cb2a/pstack/skills/principle-test-behavior-not-implementation/SKILL.md) | Reject vacuous/self-referential tests and exercise observable behavior | Its blanket assertion-shape rules are too broad: absence and relation tests can protect real contracts, and `toBeDefined` would fail for `undefined` |

Retain ambitious simplification as a lens. Replace harshness and mandatory orchestration with explicit obligations, counterexamples, calibrated judgment, and bounded review.

## Fit with the dotfiles

Baseline: [crisadamo/dotfiles at b01bd27a7ab03e43e304da9de25961703f85f6a2](https://github.com/crisadamo/dotfiles/tree/b01bd27a7ab03e43e304da9de25961703f85f6a2/home/.agents/skills). This skill does not delete or edit those source files.

| Existing capability | Role in a consolidated practice |
| --- | --- |
| deliver-high-quality-software | Strong existing standard; this practice supplies the artifact chain, worked example, and research-backed study set |
| design-conceptual-integrity, design-deep-modules, design-simplicity-default, simplicity-complexity-bar | Shared design lenses, not four competing mandatory workflows |
| senior-typescript-engineer | Language reference beneath the common process |
| google-code-review, code-review-as-cris | Calibrated review plus Cris's naming/domain preferences |
| implement, execute-plan, design, review, check-work | Execution adapters should consume one contract/evidence record and the actual available tools |
| plan-* | Thin entrypoints into one document/state lifecycle; keep repository-specific routing in a local profile |
| api-design-google-aip, systems-design-coach, design-ui | Preserve specialist value; load only when applicable, with coaching explicitly selected |

Adoption sequence: use this practice explicitly on one small fix, one stateful feature, and one API change; inspect actual outputs and omitted risks. Then consolidate overlapping trigger descriptions and move project-specific branches/toolchains/roles to local instructions. Remove obsolete workflows only after explicit migration of their callers and authorization to remove them. Avoid running both this practice and a second full orchestration loop on the same task.

Evaluate reproducibility by artifacts and outcomes: could another engineer explain the contract, reproduce the evidence, identify the state owner, and safely make the next change? Reassess on escaped defects or repeated caller friction. More pages, reviewers, or model calls are not success measures.
