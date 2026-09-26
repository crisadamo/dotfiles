# Google engineering-practice basis

Use this reference to explain or reconcile the skill's review rules. It is a concise synthesis, not a substitute for repository-local policy.

## Source map

- [Code review overview](https://google.github.io/eng-practices/review/)
- [The standard of code review](https://google.github.io/eng-practices/review/reviewer/standard.html)
- [What to look for](https://google.github.io/eng-practices/review/reviewer/looking-for.html)
- [Navigating a CL](https://google.github.io/eng-practices/review/reviewer/navigate.html)
- [Speed of reviews](https://google.github.io/eng-practices/review/reviewer/speed.html)
- [Writing review comments](https://google.github.io/eng-practices/review/reviewer/comments.html)
- [Handling pushback](https://google.github.io/eng-practices/review/reviewer/pushback.html)
- [CL author's guide](https://google.github.io/eng-practices/review/developer/)
- [Writing good CL descriptions](https://google.github.io/eng-practices/review/developer/cl-descriptions.html)
- [Small CLs](https://google.github.io/eng-practices/review/developer/small-cls.html)
- [Handling reviewer comments](https://google.github.io/eng-practices/review/developer/handling-comments.html)
- [Emergencies](https://google.github.io/eng-practices/review/emergencies.html)

## Review standard

The governing objective is long-term code health while preserving team progress. Approval does not mean perfection; it means the change is a definite improvement to the affected system and meets its standards.

Apply these conflict rules:

1. Prefer technical evidence and engineering principles over opinion.
2. Let an authoritative style guide settle style. Otherwise follow healthy local consistency and do not block on taste.
3. Treat design as an engineering question, not mere style.
4. When several options are equally valid, accept the author's preference.
5. Seek consensus. If discussion stalls, talk synchronously, record the decision in the review, then escalate to the appropriate technical owner rather than letting the change languish.

## Review coverage

Start broad, then narrow:

1. Does the change make sense and belong in the product or codebase?
2. Is the major design sound? Send major design feedback early.
3. Does behavior work for end users and developer users, including edge cases?
4. Is concurrency safe and UI behavior sensible where applicable?
5. Is complexity necessary? Reject speculative functionality.
6. Are tests present, correct, useful, and maintainable?
7. Are names, comments, documentation, and style clear?
8. Has every changed line been reviewed in enough context?

Comments should normally explain why a construct exists, while API or module documentation should explain purpose, behavior, and use. If a reviewer cannot understand code, prefer clarifying the code; an explanation that exists only in the review tool does not help future readers.

Request a qualified reviewer for areas such as security, privacy, concurrency, accessibility, or internationalization when the current reviewer lacks the needed expertise.

## Change size

The ideal CL is one self-contained conceptual change, including its tests, that leaves the system working. Small changes generally review faster, attract deeper attention, fail less often, merge and roll back more easily, and waste less work when the direction is rejected.

Separate material refactoring or formatting from behavior changes. Do not split so far that an API lands without a representative use or that the implications become harder to understand. Treat line counts as weak signals; conceptual surface and reviewer effort matter more.

## Review navigation and speed

Read the description, inspect the most important or highest-risk part, then cover the rest in a sequence that prevents omissions. Tests may be the best starting point when they clarify intended behavior.

Optimize for team throughput and fast responses, not constant interruption. Respond at a natural break point; when a full review must wait, provide early design feedback or route to another qualified reviewer. Approve with comments when remaining items are explicitly non-blocking or the author can safely complete them without another round.

For a change too large to review promptly, request a decomposition. If it truly cannot be split, return broad design feedback first so the author can make progress.

## Comment quality

- Be courteous and discuss the code rather than the person.
- Explain the reasoning and code-health consequence.
- Balance explicit fixes with problem statements that leave implementation ownership to the author.
- Label non-blocking intent with `Nit`, `Optional` or `Consider`, and `FYI`.
- Reinforce genuinely good engineering when it teaches a reusable practice; avoid empty praise.

On pushback, first reconsider the author's evidence. If it changes the assessment, say so and drop the point. If not, acknowledge the argument and explain the remaining code-health concern. Do not accept newly introduced complexity on an unsupported promise to clean it up later.

## Author responsibilities

A description is durable history. Its first line should stand alone, be short and focused, and use an imperative construction. The body should communicate what changed, why, key context, the chosen approach, and material shortcomings or evidence.

Authors should keep changes self-contained, include related tests, respond professionally, and clarify code rather than relying on review-thread explanations. Update the description after review if the change evolved.

## Emergency exception

Relax normal review depth only for a genuine production, legal, launch-blocking, or major security emergency. Prioritize whether the small change resolves the incident safely, then review it thoroughly after stabilization. Convenience, Friday timing, reviewer time zones, or a soft schedule are not emergencies.
