# TypeScript Implementation Standard

Use this reference for TypeScript/TSX implementation, libraries, SDKs, framework applications, public generic APIs, and runtime-schema boundaries.

## Contents

1. Runtime truth and strictness
2. Boundary parsing
3. Domain modeling
4. Failures, effects, and resources
5. Modules and packages
6. Testing
7. Safety evidence and discoverability

## 1. Runtime Truth and Strictness

Treat TypeScript as an erased, intentionally unsound analysis layer over JavaScript. Maintain separate static, runtime, and operational models.

For new code, prefer at least:

```jsonc
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "useUnknownInCatchVariables": true,
    "forceConsistentCasingInFileNames": true,
  },
}
```

Use typed lint rules for floating and misused promises. For libraries or multi-runtime packages, evaluate `verbatimModuleSyntax`, `isolatedModules`, declaration checks, explicit export maps, and package-consumer verification.

Adopt disruptive flags such as `exactOptionalPropertyTypes` deliberately. Never weaken project strictness merely to make a change compile.

## 2. Boundary Parsing

Accept `unknown` for values crossing a trust boundary:

- HTTP/query/header/cookie/webhook input;
- environment and configuration;
- parsed JSON and cached blobs;
- database rows when schema/runtime may drift;
- queue/workflow/event payloads;
- third-party responses;
- AI model output and tool arguments;
- caught arbitrary values.

Parse once with a runtime schema or explicit decoder. Return a trusted domain value or a typed failure. Do not cast input to the desired type.

Keep parsing, normalization, and error context at the boundary. Do not spread repeated defensive checks through the domain.

## 3. Domain Modeling

Use types to encode real decisions and invariants:

- discriminated unions for finite states and expected outcomes;
- branded/opaque primitives for IDs, money, units, validated strings, or confusing primitive domains;
- constructors/parsers that establish the brand;
- exhaustive switches with a `never` check;
- readonly data where immutability carries meaning;
- domain operations instead of setters that permit invalid intermediate states.

Use an economic test: make illegal states unrepresentable when doing so removes a meaningful defect class without overwhelming ordinary change.

Keep type-level programming behind small named exports. Require readable errors, bounded compiler cost, useful caller inference, and type tests. Prefer a runtime function over a complex conditional type when callers gain no safety.

Infer implementation details. Add explicit types at exported, serialized, callback, factory, and architectural boundaries when they stabilize the API.

## 4. Failures, Effects, and Resources

Represent expected domain outcomes as discriminated values or the project's established result model. Use named `Error` subclasses where library/framework conventions expect throwing. Preserve `cause` and stable codes either way.

Do not introduce Effect, a custom Result, or a new error framework for style alone. Adopt a coherent effect model only when typed failures, structured concurrency, resource scopes, dependency composition, schedules, and schema transformations recur enough to repay whole-team cost.

Propagate `AbortSignal` or an equivalent deadline through remote capabilities. Intentionally await, return, or explicitly own every promise. Release resources on success, failure, timeout, and cancellation.

Keep retryability, idempotency, concurrency limits, and partial success explicit in the public contract where callers must react.

## 5. Modules and Packages

- Use named exports by default; follow framework-required defaults as scoped exceptions.
- Keep public exports minimal and intentional.
- Avoid broad barrels that expose internals or create cycles.
- Keep framework entrypoints thin.
- Own capability ports in domain/application language.
- Keep transport, persistence, provider, and presentation types from leaking into the domain.
- Test built declarations and actual package exports.
- Treat generated code as generated; extend through supported handwritten layers.
- Use `satisfies` to validate shapes without losing literal inference.
- Prefer `unknown`, narrowing, and schema parsing over `any`, non-null assertions, double casts, and unchecked assertions.

## 6. Testing

Map risk to evidence:

| Risk                           | First evidence                                 |
| ------------------------------ | ---------------------------------------------- |
| Domain invariant/transition    | unit table or property test                    |
| Public generic inference       | type test and declaration fixture              |
| Parsing/serialization          | valid, invalid, boundary, and round-trip tests |
| Adapter contract               | shared contract suite                          |
| Database/transaction/migration | integration against the real engine            |
| Package/runtime support        | built-package consumer tests                   |
| Retry/cancel/replay            | deterministic clock and fault injection        |
| Critical user flow             | focused end-to-end test                        |

Use a local or SQLite-compatible substitute only when its constraints, transactions, isolation, query behavior, and concurrency faithfully represent the production contract. Otherwise, use the real engine.

Avoid broad module mocks and spy-driven tests. Fake only external or nondeterministic capabilities needed to control the scenario.

## 7. Safety Evidence and Discoverability

Treat every assertion, non-null claim, reflection boundary, generated decoder, dynamic registry, concurrency assumption, and unsafe adapter as an evidence obligation:

- state the invariant;
- show where it is established;
- minimize the unsafe surface;
- document what could invalidate it;
- add a focused test or runtime check where practical.

Write comments for invariants, tradeoffs, reasons, safety arguments, compatibility constraints, and non-obvious failure behavior. Do not restate syntax.

Make the system discoverable to humans and coding agents:

- maintain local contributor/agent instructions;
- identify canonical entrypoints and sources of truth;
- document focused verification commands;
- use greppable names and explicit interfaces;
- provide architecture/package maps for non-obvious graphs;
- keep examples aligned with the supported path;
- record migrations, compatibility behavior, and known constraints near the owned module.
