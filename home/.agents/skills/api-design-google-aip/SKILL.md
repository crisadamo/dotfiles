---
name: api-design-google-aip
description: Design, evolve, document, or review resource-oriented APIs using the General Google API Improvement Proposals (AIPs). Use for protobuf or gRPC APIs, REST and JSON transcodings, OpenAPI surfaces adopting Google-style resource patterns, API design proposals, resource and method modeling, schema reviews, compatibility analysis, versioning, pagination, filtering, field masks, long-running operations, errors, retries, authorization, idempotency, or AIP conformance audits.
---

# Design APIs with General Google AIPs

Use the General AIPs as a coherent API contract, not as a bag of naming tips. Optimize for simple, intuitive, consistent consumer behavior while protecting published compatibility.

## Establish authority and applicability

Before applying a rule, determine:

- whether the task targets exact Google AIP conformance or uses AIPs as design guidance;
- the API audience, stability level, and existing client commitments;
- whether the API is greenfield or already published;
- the primary representation: protobuf/gRPC, REST/JSON, OpenAPI, GraphQL, or another protocol;
- whether the operation belongs to the management plane, data plane, or both;
- project-specific standards and domain-specific AIPs that override or extend the General collection.

Treat approved AIPs as best current practice. Treat draft, reviewing, replaced, deferred, or rejected AIPs as context, not binding requirements. Check live state before relying on a non-approved proposal.

Do not impose Google-internal review procedures or Google-only infrastructure on an external project. Adapt the wire-level and semantic rules while naming any protobuf-specific requirement that does not translate.

Read [authority-and-review.md](references/authority-and-review.md) whenever deciding precedence, compliance severity, exceptions, or review output.

## Choose the working mode

- **Greenfield design:** Produce the resource model, methods, schemas, HTTP mapping, cross-cutting behavior, and compatibility policy before implementation details.
- **Change design:** Compare the proposed change with the published contract across source, wire, and semantic compatibility before recommending it.
- **Review:** Report high-impact contract failures first, cite the exact AIP and section, and propose a compatible repair.
- **Implementation:** Encode an already-decided design in protobuf, OpenAPI, or code without silently inventing domain semantics.
- **Focused question:** Answer with the applicable AIP state, normative strength, decision, rationale, and a small example.

Scale the workflow to the request. A field-name question does not require a full API audit; a new service does.

## Load the relevant design references

- Read [resource-model.md](references/resource-model.md) for planes, resources, hierarchy, names, types, associations, declarative behavior, and singleton resources.
- Read [methods.md](references/methods.md) for standard, custom, batch, aggregate, and long-running methods.
- Read [fields-and-types.md](references/fields-and-types.md) for field naming, behaviors, presence, enums, quantities, time, standard fields, states, sensitivity, and documentation.
- Read [design-patterns.md](references/design-patterns.md) for idempotency, request IDs, pagination, filtering, masks, concurrency, authorization, errors, retries, soft deletion, expiration, validation, and partial success.
- Read [compatibility-and-versioning.md](references/compatibility-and-versioning.md) for source, wire, and semantic compatibility, stability, deprecation, versioning, and migration.
- Read [protobuf-and-http.md](references/protobuf-and-http.md) for protobuf annotations, gRPC/HTTP transcoding, REST mappings, and non-protobuf adaptation.
- Read [source-map.md](references/source-map.md) to locate every General AIP and verify current status or newly revised guidance.

## Design the API from the domain outward

### 1. Define the consumer contract

Capture the consumer goals, actors, authorization boundaries, latency expectations, consistency guarantees, failure model, scale, lifecycle, and compatibility budget. Identify what users must store, retry, poll, compare, or automate.

Separate API semantics from storage schema. Do not expose tables, internal jobs, transport mechanics, or implementation state as first-order API concepts unless they are genuine user-facing resources.

### 2. Model resources and relationships

Identify stable nouns, their canonical parents, ownership, lifecycle, resource names, types, references, and mutable configuration. Give each resource a canonical read path. Prefer one canonical parent and represent other associations through resource-reference fields or association resources.

For a management-plane resource, define steady-state behavior after mutations and design for declarative clients. For data-plane operations, preserve resource orientation where useful without forcing control-plane semantics onto high-throughput calls.

### 3. Select method categories in order

Try, in order:

1. Standard methods.
2. Batch or aggregate variants.
3. Resource-, collection-, or service-scoped custom methods.
4. Streaming only when the preceding forms cannot represent the interaction.

Do not make a standard method "almost" fit. Use a custom method when semantics include side effects or state transitions that an update must not hide.

### 4. Specify the schema

For every field, decide name, type, presence, field behavior, default, mutability, sensitivity, normalization, validation, and compatibility implications. Use one term per concept and the same resource schema across methods in the same service.

Make request and response semantics explicit: required inputs, ignored fields, output-only values, partial updates, concurrency guards, state transitions, error codes, and retry behavior.

### 5. Add cross-cutting behavior at the outset

Decide pagination before releasing collection methods. Decide request identification before promising retry safety. Define filters, ordering, field masks, etags, long-running operations, authorization ordering, partial success, soft delete, expiration, and validation only where the use case requires them.

Avoid speculative options. Adding an optional feature later is often compatible; removing or changing observable behavior is not.

### 6. Test evolution, not only the initial shape

Walk through adding a field, enum value, resource pattern, method, and new API version. Test old-client/new-server behavior, serialized data, generated clients, default behavior, pagination, errors, and resource names. If the design cannot evolve without surprising existing consumers, revise it before launch.

### 7. Validate the artifact

When protobuf sources and the API Linter are available, run the repository's configured linter and preserve its configuration. Treat lint success as necessary evidence, not proof that domain modeling, semantics, or compatibility are correct.

For OpenAPI or another representation, validate the schema with the project's toolchain and manually apply the AIPs that the tool cannot encode.

Do not install new tooling, change lint suppressions, or modify a published API merely to silence findings unless the user authorizes it.

## Produce evidence-backed output

For a design proposal, include:

1. Consumer goals and constraints.
2. Resource graph and canonical names.
3. Method inventory and HTTP mapping.
4. Core schemas and field behavior.
5. Cross-cutting contracts.
6. Errors, retries, consistency, and authorization.
7. Compatibility and versioning policy.
8. Open questions, intentional exceptions, and validation plan.

For a review, report each finding as:

1. **Severity and contract impact.** Explain the consumer failure mode.
2. **Location.** Identify the method, field, path, or schema fragment.
3. **Authority.** Cite `AIP-NUMBER`, its current state, section, and requirement strength.
4. **Repair.** Provide a concrete compatible design.
5. **Migration risk.** State whether the repair is safe in place or requires deprecation, coexistence, or a new version.

Prioritize broken resource identity, incompatibility, ambiguous ownership, unsafe retries, authorization leaks, destructive semantics, and inconsistent standard methods over cosmetic naming.

## Apply normative language correctly

- Treat **must** and **must not** in an approved AIP as conformance requirements.
- Treat **should** and **should not** as defaults that permit a documented, user-serving exception.
- Treat **may** as permission, not a recommendation or requirement.
- Do not strengthen a recommendation into a requirement.
- Do not cite rationale, examples, changelog entries, or a draft proposal as if they were approved normative guidance.

## Run the final design gate

Confirm that:

- every first-order concept is a user-facing resource or a justified stateless operation;
- resource names are canonical, stable, unique, and version-independent;
- each resource has at most one canonical parent and a reliable read path;
- standard methods use standard semantics, shapes, and HTTP mappings;
- update does not hide side effects or writable state transitions;
- collection methods are paginated from launch;
- fields have explicit behavior, durable defaults, and documented formats;
- mutations define concurrency, idempotency, consistency, and retry contracts;
- authorization runs before validation where existence could leak;
- errors are canonical, machine-readable, actionable, and stable where clients depend on them;
- source, wire, and semantic compatibility are evaluated separately;
- non-approved AIPs and project exceptions are labeled explicitly;
- automated validation and manual contract review both have evidence.

