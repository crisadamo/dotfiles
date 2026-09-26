# Authority, conformance, and review

## Contents

- AIP authority and state
- Requirement strength
- Precedence and exceptions
- Review method
- Decision records

## AIP authority and state

General AIPs are concise API design standards intended to help producers and reviewers create consistent interfaces. Apply their state deliberately:

- **Approved:** Best current practice. Use as the normative baseline.
- **Reviewing:** The proposal has broad direction but is not accepted. Use as advisory context and verify current discussion.
- **Draft:** Actively changing. Do not block a design solely on it.
- **Replaced:** Follow the replacement.
- **Deferred, withdrawn, or rejected:** Historical context, not current guidance.

The live AIP page is authoritative over this bundled summary. Check the live page when the status is not approved, the question is compatibility-sensitive, or the local snapshot is older than the design decision.

## Requirement strength

Interpret the bold lowercase keywords using RFC 2119 semantics:

- **must / must not:** A conformance requirement in an approved AIP.
- **should / should not:** The default; an exception requires a valid competing concern and a clear rationale.
- **may:** An allowed option. Do not require it without another source of authority.

Guidance lives in the AIP's guidance section. Rationale explains why; it does not create additional requirements. Examples illustrate a rule but do not necessarily exhaust valid designs.

## Precedence and exceptions

Use this decision order:

1. Preserve explicit user requirements, external specifications, legal obligations, and already-published client contracts.
2. Follow approved project- or domain-specific AIPs where their scope applies.
3. Follow approved General AIPs.
4. Use reviewing and draft AIPs as advisory future direction.
5. Use precedent only when it is current, intentional, and relevant.

For a greenfield API, do not copy a standards violation merely because another API shipped it. For an existing API, local consistency and backwards compatibility can outweigh changing one new field or method to the global standard.

When an exception is necessary:

- identify the violated AIP and exact requirement;
- explain the external specification, established local pattern, technical constraint, or user need;
- bound the exception to the smallest surface;
- prevent it from becoming precedent for unrelated APIs;
- record how future additions should behave.

Do not use expediency as a silent exception. If a deadline wins, state the debt, compatibility consequence, and follow-up boundary.

## Review method

Review from the consumer's perspective in this order:

1. Resource ontology and ownership.
2. Resource identity and canonical names.
3. Standard versus custom method semantics.
4. Request and response schemas.
5. Cross-cutting behavior and failure handling.
6. Compatibility and lifecycle.
7. Documentation and naming polish.

For each issue, cite a stable URL such as `https://google.aip.dev/134#request-message`. Include the AIP state and distinguish a **must** violation from a **should** deviation.

Use severity based on consumer impact:

- **Blocking:** Breaking compatibility, ambiguous identity or ownership, security leakage, irreversible destructive ambiguity, or violation of an approved **must**.
- **High:** Semantics that make safe automation, retries, or client generation unreliable.
- **Medium:** Approved **should** deviations or inconsistencies that raise recurring client cost.
- **Low:** Local clarity or polish with no material contract risk.

Do not count findings. One broken resource model can matter more than twenty naming issues.

## Decision records

For a contested design, capture:

```text
Decision:
Consumer goal:
Applicable AIPs and states:
Selected design:
Alternatives rejected:
Compatibility impact:
Intentional exceptions:
Validation evidence:
```

Never claim Google approval, AIP editor approval, or formal conformance unless that review actually occurred.

