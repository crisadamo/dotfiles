# Cross-cutting design patterns

## Contents

- Idempotency and request identification
- Pagination, filtering, and partial responses
- Field masks and concurrency
- Authorization and errors
- Retry policy
- Lifecycle, validation, and partial success

## Idempotency and request identification

Apply AIP-155 when clients need retry-safe mutation, deduplication, or audit correlation:

- Put optional `request_id` on the request, never on the resource.
- Prefer documented UUIDv4 values and annotate their format in protobuf.
- If a request ID is accepted, duplicate use must provide an idempotency guarantee for the documented retention period.
- Prefer returning the original successful response; a current resource state is acceptable only where the AIP permits it.
- Define what constitutes the same request and what happens when a request ID is reused with different input.

Do not claim exactly-once business effects merely because a request ID exists. The contract depends on deduplication scope, retention, transaction boundaries, external effects, and response replay.

## Pagination, filtering, and partial responses

Apply AIP-158 at initial release for every potentially unbounded collection:

- Use optional `page_size` and `page_token`; return `next_page_token`.
- Empty `next_page_token` is the only end-of-collection signal.
- Keep page tokens opaque, URL-safe, non-authorizing, and non-parseable.
- Keep all pagination arguments except page size consistent across requests.
- Document defaults and maxima; reject negative sizes and normally coerce oversized values.
- Do not add finite pagination later without treating it as a breaking semantic change.

Apply AIP-160 when filtering is needed. Use one documented expression language consistently, validate unsupported fields and operators, and avoid one-off filter parameters that fragment the surface.

For list ordering, use the AIP-132 `order_by` convention and define a stable tie-breaker when deterministic pagination requires one.

Apply AIP-157 for partial responses. Prefer the current query-parameter or view pattern from the live AIP; do not introduce deprecated request-level read masks.

## Field masks and concurrency

Apply AIP-161 and AIP-134:

- Use `google.protobuf.FieldMask` for update masks.
- Define paths relative to the resource, not the request wrapper.
- Support nested fields and the standard `*` meaning where required.
- Ignore output-only fields in update input and masks.
- Reject invalid write paths with `INVALID_ARGUMENT` unless a documented deletion rule applies.
- Preserve read-write consistency for the same mask.

Use etags under AIP-154 when clients must detect stale mutations. Treat the etag as opaque. On mismatch, use `ABORTED` where the applicable standard method requires it. Define whether etags are strong or weak and which mutations change them.

Do not replace an etag with a client timestamp or undocumented hash.

## Authorization and errors

Apply AIP-211:

- Check authorization before request validation when validation or existence checks could leak information.
- Return `PERMISSION_DENIED` for an unauthorized operation without confirming whether the target exists.
- Check only the permissions relevant to the operation; do not probe related permissions in ways that create inconsistent disclosure.

Apply AIP-193:

- Use canonical error codes and the standard structured status model for AIP-conformant protobuf APIs.
- Make the developer-facing message brief, plain, actionable, and independent of internal implementation.
- Include machine-readable `ErrorInfo` with a stable domain and reason.
- Put dynamic values represented in messages into structured metadata so clients do not parse text.
- Use standard detail payloads for bad requests, preconditions, localized messages, and help links.
- Preserve legacy message text when existing clients had no machine-readable alternative and may depend on it.

Map these semantics deliberately when the representation is RFC 7807, OpenAPI, or another error format.

## Retry policy

Apply AIP-194 as a starting point, then verify method semantics:

- Automatically retry only unary requests whose repetition does not cause unintended state change.
- Treat `UNAVAILABLE` as the standard transient retry signal.
- Do not blindly retry invalid input, permission failures, missing resources, failed preconditions, or unknown outcomes.
- Retry an aborted transaction at the transaction boundary, not as an isolated request.
- Honor cancellation and deadlines.
- Consider billing, quotas, backoff, jitter, maximum attempts, and total deadline.
- Pair mutation retries with AIP-155 request identification or another operation-owned idempotency contract.

An HTTP verb alone does not prove that an operation is safe to retry.

## Lifecycle, validation, and partial success

Use these patterns only when the product needs them:

- **Validation (AIP-163):** Add `validate_only` with identical validation semantics and no committed effects. Define the response for synchronous and long-running methods.
- **Soft delete (AIP-164):** Model deleted visibility, undelete, expunge, retention, states, and errors consistently.
- **Expiration (AIP-214):** Use standard expiration or TTL semantics and distinguish input-only TTL from output expiration time.
- **States (AIP-216):** Expose lifecycle and use custom methods for transitions.
- **Unreachable resources (AIP-217):** Use the standard partial-success pattern for cross-scope list operations; define authorization and pagination behavior.
- **Jobs, import/export, revisions, policy preview, and criteria-based delete:** Load AIP-152, 153, 162, 236, or 165 directly before designing the pattern. AIP-162 is draft in the verified snapshot and must remain advisory.

Do not hide per-item failures inside a successful batch or import response without a stable machine-readable contract.

