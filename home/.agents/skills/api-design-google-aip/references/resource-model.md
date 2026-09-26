# Resource model

## Contents

- Planes
- Resource-oriented invariants
- Names and types
- Hierarchy and association
- Declarative-friendly and singleton resources
- Resource modeling checklist

## Planes

Classify each surface using AIP-111:

- **Management plane:** Users configure durable resources. Favor user-specified IDs, strong post-mutation consistency, declarative reconciliation, etags, and long-running operations where provisioning is slow.
- **Data plane:** Users move or process data, often at higher volume. Resource orientation still applies when it clarifies identity and ownership, but control-plane automation requirements can be relaxed where the AIPs allow it.

Do not let a management API expose transient implementation jobs as the primary model when users care about durable desired state. Do not wrap a naturally stateless data operation in a fake persistent resource without a lifecycle benefit.

## Resource-oriented invariants

Apply AIP-121:

- Model stable nouns as individually named resources.
- Express ownership and hierarchy explicitly.
- Use a small standard method vocabulary before custom methods.
- Keep requests stateless: each request is independently understandable and resources are directly addressable.
- Use the same resource schema in every method in the same service when the request or response contains that resource.
- Provide `Get`; provide `List` except for singleton resources.
- For management-plane mutations, completion means the resource's existence and user-settable values have reached a readable steady state.
- Keep parent-child and user-specified resource-reference graphs acyclic.

The API model must not mirror the database merely because the data is stored that way. Storage is an implementation; the API is a long-lived consumer contract.

## Names and types

Apply AIP-122 and AIP-123:

- Give every resource a stable relative name such as `publishers/123/books/les-miserables`.
- Alternate plural collection identifiers and resource ID segments.
- Separate segments with `/`; avoid characters that require URL escaping.
- Use lowercase, documented user-specified IDs where possible.
- Put the canonical name in a string field named `name`; do not use self-links or identifying tuples as the primary identity.
- Keep resource names stable across API versions. Do not embed a version in the resource name.
- Use a full resource name only when the owning API is otherwise ambiguous.
- Define a globally unique resource type as `{service-name}/{PascalCaseType}`.
- Keep the resource type name aligned with its message or schema name.
- Keep resource patterns ordered and backwards compatible.

For protobuf, declare `google.api.resource` with `type`, `pattern`, `singular`, and `plural`. Name pattern variables with the singular resource term in `snake_case`, without an `_id` suffix.

## Hierarchy and association

Apply AIP-124:

- Give a resource at most one canonical parent.
- Do not make `List` require two parent fields.
- Express additional many-to-one relationships as resource-reference fields.
- Express a simple many-to-many relationship as a repeated set of resource names.
- Introduce an association resource only when the relationship has its own metadata, lifecycle, or update constraints.
- Filter a canonical collection by secondary associations instead of inventing another required parent.

Choose the parent based on ownership and lifecycle, not merely query convenience. A child name should remain meaningful and stable for as long as the contract promises.

## Declarative-friendly and singleton resources

For declarative-friendly management resources (AIP-128):

- support create, get, update, and delete with stable names;
- support reconciliation toward desired state;
- expose etags and compatible no-op or missing-resource behavior where required by the applicable AIPs;
- use long-running operations for slow mutations;
- avoid custom imperative methods except for genuinely imperative operations such as move or rename.

For singleton resources (AIP-156):

- derive identity from the parent rather than a user-chosen collection member;
- provide `Get` and normally `Update`;
- do not provide a meaningless `List`;
- tie lifecycle to the parent and document creation or existence semantics.

## Resource modeling checklist

For each resource, record:

```text
Consumer noun:
Canonical parent:
Relative name pattern:
Resource type:
User-specified ID policy:
Mutable configuration:
Output-only observations:
References to other resources:
Lifecycle and states:
Get/List support:
Consistency after mutation:
Declarative-client expectations:
```

If these answers are unclear, method and field design is premature.

