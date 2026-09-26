# Methods and operations

## Contents

- Method selection
- Standard methods
- Custom methods
- Long-running operations
- Batch and aggregate methods
- Cross-method invariants

## Method selection

Apply AIP-130 in this order:

1. Standard collection or resource method.
2. Standard batch or aggregate method.
3. Custom method attached to a resource, collection, or service scope.
4. Streaming method.

The order matters because standard shapes are recognizable to SDKs, CLIs, UIs, declarative clients, and automation. Do not contort nonstandard semantics into a standard method.

## Standard methods

Use the following baseline:

| Method | HTTP | Request identity | Body | Response |
|---|---|---|---|---|
| Get (AIP-131) | `GET` resource URI | `name` | None | Resource |
| List (AIP-132) | `GET` collection URI | `parent` when nested | None | Repeated resources plus page token |
| Create (AIP-133) | `POST` collection URI | `parent`, resource, optional or required resource ID | Resource field | Created resource or LRO |
| Update (AIP-134) | `PATCH` resource URI | Resource `name` plus `update_mask` | Resource field | Updated resource or LRO |
| Delete (AIP-135) | `DELETE` resource URI | `name` | None | Empty, resource for soft delete, or LRO |

Apply these semantic constraints:

- **Get:** Return a single resource, normally fully populated. Add only AIP-defined optional fields.
- **List:** Paginate from launch. Use `parent`, `page_size`, `page_token`, repeated results, and `next_page_token`. Add filtering or ordering only with a real use case.
- **Create:** Create inside an existing collection. For management-plane resources, accept a user-specified `{resource}_id`. Ignore a client-supplied resource `name` on create. Return `ALREADY_EXISTS`, or `PERMISSION_DENIED` when existence cannot be disclosed.
- **Update:** Prefer partial updates with `PATCH` and `google.protobuf.FieldMask`. Treat an omitted mask according to AIP-134. Do not put state transitions or unrelated side effects in update.
- **Delete:** Refuse deletion with children using `FAILED_PRECONDITION` unless the caller explicitly opts into a supported cascade. Use `force`, `etag`, or `allow_missing` only with their standard semantics.

For management-plane create, update, and delete, successful completion must align with the strong-consistency contract from AIP-121.

## Custom methods

Use AIP-136 only when standard methods cannot express the behavior cleanly.

- Name the RPC `VerbNoun` without prepositions or standard-method verbs.
- Do not include `Async`; long-running behavior is expressed by the response type.
- Attach the method to the narrowest relevant resource or collection.
- Use `GET` for side-effect-free retrieval when request size permits.
- Use `POST` for mutation, side effects, billed stateless work, or retrieval requiring a body.
- Append `:lowerCamelVerb` to the HTTP path.
- Use `name` for a resource-scoped method and `parent` for a collection-scoped method.
- Use a stateless service-scoped method only when no durable resource owns the action.

If a proposed method name includes `By`, `For`, `With`, or another preposition, check whether a filter, an optional field, or a better domain verb avoids a hyper-specific method.

## Long-running operations

Use AIP-151 when blocking would be a poor experience; roughly ten seconds is a useful signal, not a hard threshold.

- Return the shared `google.longrunning.Operation`; do not invent another promise type for AIP-conformant protobuf APIs.
- Declare stable response and metadata types.
- Implement the standard Operations service.
- Put start-time failures in the immediate RPC error; put execution failures in `Operation.error`.
- Make in-progress resources visible through `Get` and `List` when useful, with a meaningful state.
- Define parallel-operation behavior and use `ABORTED` when a conflicting operation is rejected.
- Treat changes to LRO response or metadata types as breaking.

## Batch and aggregate methods

Use AIP-231, AIP-233, AIP-234, and AIP-235 for operations over named resources in one collection. Keep per-item semantics aligned with the corresponding standard method. Define limits, ordering, partial failure behavior, atomicity, and idempotency explicitly.

Use AIP-159 for reading the same resource type across multiple parent collections. Do not overload ordinary `List` with multiple required parents.

Use criteria-based deletion (AIP-165) only when deleting by filter is a genuine product need and the safety, validation, response, and long-running behavior are explicit.

## Cross-method invariants

Confirm that:

- method names, request names, response names, and HTTP paths agree;
- the same resource schema appears across methods;
- required fields do not proliferate beyond the standard shape;
- read results can verify mutation results;
- custom methods do not duplicate or undermine standard methods;
- synchronous, long-running, and batch variants have compatible semantics;
- errors and authorization do not reveal resource existence inconsistently.

