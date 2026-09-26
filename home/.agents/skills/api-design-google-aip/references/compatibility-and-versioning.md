# Compatibility, stability, and versioning

## Contents

- Three compatibility dimensions
- Safe and unsafe evolution
- Stability and deprecation
- Versioning strategies
- Change-review workflow

## Three compatibility dimensions

Apply AIP-180 across three independent contracts:

1. **Source compatibility:** Existing client code still compiles and runs with regenerated or upgraded libraries.
2. **Wire compatibility:** Old clients and new servers still serialize, deserialize, and communicate correctly.
3. **Semantic compatibility:** Existing code continues to observe behavior a reasonable consumer would expect.

A wire-compatible protobuf change can still break generated source or semantics. Review all three explicitly.

## Safe and unsafe evolution

New components can often be added within a major version only when unaware clients keep their previous behavior.

Do not, within a stable major version:

- add a required field to an existing request or resource input;
- remove or rename a service, method, message, field, enum, or enum value;
- move a component between proto files when generated imports can change;
- move a field into or out of a `oneof`;
- change a field type, even when wire-compatible;
- change a static default, serialization presence, value format, or construction algorithm;
- change canonical resource names or their documented valid format;
- add pagination in a way that truncates results previously returned in full;
- change LRO response or metadata types;
- make an optional field required or a mutable field immutable;
- alter visible semantics likely to break reasonable client code.

Treat rename as remove-plus-add. If a better name is necessary, add it alongside the old element, define conflict behavior, deprecate deliberately, and keep the old contract for the promised period.

Be cautious even with normally additive changes:

- response enums may break exhaustive consumers;
- new fields may conflict in generated languages;
- new default-populated output can change equality, hashing, or serialization behavior;
- larger string values can overflow consumer storage;
- a new filter, ordering, or optional behavior becomes a future compatibility obligation.

## Stability and deprecation

Apply AIP-181:

- **Alpha or experimental:** Breaking change is expected, but communicate with the curated users.
- **Beta or preview:** Treat the surface as nearly complete. Minimize incompatibility, define the deprecation or expiration policy up front, and give consumers a migration window.
- **Stable or GA:** No breaking change within the supported major version except extreme security, regulatory, or formally governed cases.

Mark deprecation in machine-readable schema and documentation. Name the replacement and migration action. Do not launch new functionality already deprecated into a more stable channel.

Compatibility expectations come from the product contract, not only the label. Record the support and turndown policy before launch.

## Versioning strategies

Apply AIP-185 for Google-style versioning:

- Expose a major version in the protobuf package and first REST path segment.
- Do not expose minor or patch numbers in the public version identifier.
- Update a stable major version in place only with backwards-compatible changes.
- Let old and new major versions coexist for a reasonable migration period.
- Do not make a new major version depend on the old major version.
- Keep the same resource names across versions that address the same underlying resources.

AIP-185 describes channel-, interface-, release-, and visibility-based strategies. Choose one intentionally; do not combine conventions ad hoc.

AIP-184 defines date-based version identifiers for interface-based versioning and was introduced in the source snapshot dated 2026-08-17. Because this area is new and fast-moving, load the live AIP-184 and AIP-185 before designing interface-based versioning.

For non-Google APIs, adapt these principles to the project's established versioning scheme. Do not introduce Google headers, visibility annotations, or protobuf package conventions merely for cosmetic compliance.

## Change-review workflow

For every proposed change:

1. Inventory current released shapes, generated clients, documentation, and observed behavior.
2. Classify the affected stability level.
3. Evaluate source, wire, and semantic compatibility separately.
4. Test old client against new server and new client against old server where supported.
5. Identify stored identifiers, resource names, enum handling, defaults, pagination, and error parsing.
6. Select in-place addition, coexistence and deprecation, new major version, or rejection.
7. Document migration, rollback, support period, and observability.

Do not recommend a new major version merely to avoid thinking through coexistence; do not recommend in-place mutation merely to avoid migration work.

