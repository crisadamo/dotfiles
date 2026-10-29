# TypeScript: values, operations, effects, evidence

Transfer Rust's visibility of data and behavior, not its syntax or ownership guarantees. TypeScript types are erased; `readonly` does not freeze objects or prevent every alias mutation.

## Arrange a cohesive module

Prefer public domain types/outcomes → parsers or constructors → operations → private helpers/effect adapters → adjacent tests. Keep private types near use. Do not force separate types/impl/tests packages or fake `impl` namespaces. Classes/factories can own lifecycle; stateless operations can be exported functions.

Derive signatures from consumer examples. Keep framework/serialization types at their boundary unless the library's actual domain is that protocol. Derive repeated contracts from a schema or generated source when possible instead of maintaining parallel field lists.

## Make promises honest

- Decode `unknown` at trust boundaries with schemas or explicit parsers; `as T` is not validation. Pass established domain values inward.
- Use discriminated unions for distinct states/outcomes and validated brands when ID/unit confusion is a real risk. Make cases exhaustive.
- Use the existing expected-error/result convention; preserve cause and stable codes without leaking secrets.
- Keep generic machinery private unless it improves caller inference/safety. Test public types and built-package consumers.
- Keep strict checks. Adopt disruptive compiler flags deliberately; never weaken checks merely to make a patch compile.
- Treat assertions, mutable aliases, reflection, and generated decoders as local proof obligations: where is the invariant established, and what can invalidate it?

## Own asynchronous work

Every promise, stream reader, subscription, timer, and temporary resource needs a lifetime owner. Await, return, or supervise it. Propagate deadlines/cancellation through effects. Release resources on success, failure, and early consumer exit.

Prefer one retry owner. Specify attempts, total deadline, retryability, backoff/jitter, Retry-After, and duplicate-effect semantics. Stopping observation does not undo an accepted remote effect. Represent uncertainty when the effect may have happened.

Bound concurrency and buffered data where resources are consumed. Define overload behavior. Unbounded queues or `Promise.all` over user-controlled input are not a scalability strategy.

Adopt Effect when scopes, typed errors, cancellation, and dependency composition recur enough to repay team learning and interoperability cost. Do not add a new effect/result framework for style.

## Verify the promise

Use examples/properties for domain laws, malformed data for parsing, controlled faults for lifetimes, the real engine for transactions, and built consumers for exports. Mock only what the scenario must control; mocks do not establish an external system's guarantee.

Keep comments explaining rationale, invariants, and tempting incorrect simplifications. Delete syntax narration. Use the commit-pinned pattern catalog selectively. The lease-job asset demonstrates types → transitions → tests; its worked example names remaining durable guarantees.
