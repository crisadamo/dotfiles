# Fields, types, states, and documentation

## Contents

- Field naming and schema discipline
- Field behavior and presence
- Enums, quantities, time, and standardized values
- Repeated, generic, and sensitive fields
- Standard fields and states
- Documentation

## Field naming and schema discipline

Apply AIP-140 and AIP-190:

- Use simple, consistent American English and one name for one concept.
- Use `snake_case` for protobuf field names and the representation's normal equivalent elsewhere.
- Use singular nouns for scalar fields and plural nouns for repeated fields.
- Name Boolean fields as clear predicates or states rather than vague nouns.
- Avoid type names in field names when the schema already conveys the type.
- Avoid overloaded, excessively general, implementation-specific, or preposition-heavy names.
- Use familiar vocabulary shared across APIs; do not invent synonyms for standard concepts.

Preserve exact public names once released. A rename is remove-plus-add and is normally breaking.

## Field behavior and presence

For protobuf request trees, apply AIP-203 field behavior explicitly:

- Every field used in a request must declare at least `REQUIRED`, `OPTIONAL`, or `OUTPUT_ONLY`, plus any other accurate behavior.
- Use `IDENTIFIER` only on a resource's `name` field.
- Use `IMMUTABLE` only when the value cannot change after creation.
- Use `INPUT_ONLY` sparingly for resource fields accepted but not returned.
- Ignore `OUTPUT_ONLY` input instead of rejecting it.
- Do not mark conditionally required fields as `REQUIRED`; document the condition and validate it semantically.
- Use `UNORDERED_LIST` when the service does not preserve list order.

Annotations describe behavior; they do not implement validation. Review service behavior and generated client consequences.

Distinguish protobuf field presence from AIP field behavior (AIP-149). Adding presence or changing field behavior can be source- or semantic-breaking even when the wire encoding remains valid.

Apply AIP-129 to server-modified values and defaults:

- Give a field one semantic owner where possible.
- Preserve user-specified configuration separately from computed effective values when both matter.
- Document normalization and return the normalized or effective value consistently.
- Do not silently change a published static default.

## Enums, quantities, time, and standardized values

Use AIP-126 for enums:

- Reserve zero for an unspecified value unless the domain has a valid zero semantic that the AIP permits.
- Prefix enum values consistently when required to avoid generated-language collisions.
- Use enums for small, stable, closed vocabularies; use strings when the vocabulary is open or independently extensible.
- Assume new response enum values can appear and document that expectation.

Use AIP-141 and AIP-142:

- Represent a single quantity as a numeric value plus a unit suffix when the unit is fixed.
- Use a structured quantity only when units vary or carry domain semantics.
- Use `google.protobuf.Timestamp` for instants and `google.protobuf.Duration` for durations.
- Use appropriate civil date and time types when no instant or time zone is intended.
- Do not encode timestamps, durations, or units in ad hoc strings.

Use AIP-143 standardized codes for content types, countries or regions, currencies, languages, and time zones. Name the field for the concept and document the governing standard.

## Repeated, generic, and sensitive fields

Apply AIP-144 to repeated fields:

- Define whether order and duplicates matter.
- Prefer whole-list replacement unless the API deliberately supports granular update semantics.
- Model independently managed elements as resources rather than an ever-growing repeated field.

Use `oneof`, maps, `Struct`, and `Any` only under AIP-146's constraints. Prefer typed schemas; generic containers push validation and compatibility costs onto every client.

For sensitive fields (AIP-147), minimize exposure, redact logs and errors, document write-only or output behavior, and avoid returning secrets after creation unless the product contract truly requires it.

Use AIP-210 for Unicode: define length units, normalization, storage form, and uniqueness. Do not compare unnormalized identifiers or measure Unicode strings with an unspecified unit.

## Standard fields and states

Use AIP-148 names and semantics for common concepts such as `name`, `uid`, `display_name`, `create_time`, `update_time`, `delete_time`, and `etag`. Do not create near-synonyms.

Apply AIP-216 to resource states:

- Use an output-only enum when clients need lifecycle visibility.
- Keep state values mutually exclusive and tied to observable semantics.
- Use custom methods for user-triggered transitions; do not make the state field directly writable through update.
- Define the zero value and whether new states can appear.
- Avoid a state field when independent Boolean or timestamp facts describe the resource more accurately.

## Documentation

Apply AIP-192:

- Document every public service, method, message, field, enum, and enum value.
- Start a component comment with a concise third-person present-tense sentence that omits the subject.
- Explain formats, ranges, units, defaults, side effects, idempotency, errors, and conditional presence where relevant.
- Use CommonMark supported by generators; avoid raw HTML, tables, headings, and ASCII diagrams inside proto comments.
- Mark deprecations in schema and start the comment with `Deprecated:` plus a replacement or reason.
- Keep internal implementation notes out of public comments.

API documentation is part of the contract and must be reviewed with the schema.

