# Protobuf, gRPC, HTTP, and other representations

## Contents

- Protobuf annotations
- HTTP and gRPC transcoding
- Standard HTTP mappings
- Non-protobuf adaptation
- Automated validation

## Protobuf annotations

For exact AIP conformance, use the shared Google API annotations instead of inventing equivalents:

- `google.api.resource` for resource type, patterns, singular, and plural (AIP-123).
- `google.api.resource_reference` for fields that refer to resources.
- `google.api.field_behavior` for identifier, required, optional, immutable, input-only, output-only, and unordered-list behavior (AIP-203).
- `google.api.field_info` for standardized primitive formats (AIP-202).
- `google.api.http` for HTTP mapping (AIP-127).
- `google.api.method_signature` for generated client convenience signatures.
- `google.longrunning.operation_info` for long-running response and metadata types (AIP-151).

Use shared common components from AIP-213 and API-specific proto placement from AIP-215. Do not copy standard messages into a service package.

## HTTP and gRPC transcoding

Apply AIP-127 to each non-bidirectional-streaming RPC:

- Define one HTTP method and path.
- Bind the full resource name or parent expression in the path, not only an ID fragment.
- Use `*` for one path segment and `**` only as a final multi-segment match where required.
- Do not define a body for `GET` or `DELETE`.
- Map Create and Update bodies to their resource field.
- Map remaining request fields to query parameters.
- Keep a body binding at one top-level field or `*`; do not bind a nested or repeated field as the body.
- Keep additional bindings semantically equivalent and use the same body mapping.
- Avoid custom JSON field names except for compatibility.

Bidirectional streaming has no native HTTP/1.1 transcription; provide a nonstreaming alternative when feasible.

## Standard HTTP mappings

Use these resource-oriented shapes:

```text
GET    /v1/{name=publishers/*/books/*}          GetBook
GET    /v1/{parent=publishers/*}/books          ListBooks
POST   /v1/{parent=publishers/*}/books          CreateBook
PATCH  /v1/{book.name=publishers/*/books/*}     UpdateBook
DELETE /v1/{name=publishers/*/books/*}          DeleteBook
POST   /v1/{name=publishers/*/books/*}:archive  ArchiveBook
```

These are wire-level projections of resource and method semantics. Do not design paths first and retrofit an incoherent resource model underneath them.

## Non-protobuf adaptation

For OpenAPI, JSON Schema, or another IDL:

- Preserve canonical resource names, hierarchy, method semantics, pagination, masks, errors, compatibility, and documentation.
- Express required, read-only, write-only, immutable, format, and deprecation behavior in the representation's native schema.
- Use RFC 7807 or another project standard for structured errors while preserving AIP-193's stable machine-readable reason and actionable detail.
- Document where the target format cannot encode an AIP annotation and enforce the contract in validation or tests.
- Keep transport-specific syntax separate from domain semantics.

Do not claim exact AIP protobuf conformance for an OpenAPI surface that merely follows similar REST patterns. State whether the result is **AIP-aligned** or **AIP-conformant** and define the profile.

## Automated validation

The API Linter can catch many protobuf-level AIP rules, but it cannot prove that:

- the resource ontology matches user intent;
- canonical parents represent ownership correctly;
- a custom method is semantically necessary;
- defaults and errors preserve compatibility;
- idempotency covers external effects;
- authorization prevents information disclosure;
- documentation matches implementation.

Run the project's existing lint command. Record tool version, configuration, suppressions, and pass/fail output. Review suppressions as intentional exceptions rather than hiding them.

If the linter is absent, report that validation was not run. Do not install or upgrade it without authorization.

