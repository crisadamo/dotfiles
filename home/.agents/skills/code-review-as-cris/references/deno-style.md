# Deno Style Reference

Source: https://docs.deno.com/runtime/contributing/style_guide/

Last checked: 2026-07-29. The page itself listed `last_modified: 2026-03-12`.

Use this as a secondary reference after Patagon repo-local instructions. Deno states this guide is for Deno runtime internals and the Deno Standard Library, so do not apply its rules mechanically where Patagon conventions differ.

## Transferable Review Points

- Treat public TypeScript APIs as long-lived contracts. Prefer 0-2 required parameters, then an options object when more shape is needed.
- Put optional parameters into an options object when the API may grow.
- Avoid plain object positional parameters that can be confused with options objects.
- Export interfaces that appear in exported function parameters or return types.
- Minimize dependencies and avoid circular imports.
- Prefer explicit code over metaprogramming, especially `Proxy`, unless there is a concrete reason.
- Require tests for new public behavior. Test names should state the behavior being proven.
- Use JSDoc for exported symbols when they are part of a public surface.
- Keep top-level exported functions as `function` declarations unless repo conventions say otherwise.
- Keep user-facing error messages clear, active, concise, sentence case, and free of trailing periods.
- Quote string values in error messages when the value matters.
- State the failed action in the error message, not only that an input was invalid.
- Use `camelCase` for functions, methods, fields, and locals.
- Use `PascalCase` for classes, types, interfaces, and enums.
- Use `UPPER_SNAKE_CASE` for static top-level constants.
- Treat acronyms as ordinary words in `camelCase` or `PascalCase` unless the repo or a web/API standard requires otherwise: prefer `HttpClient` over `HTTPClient`, `parseUrl` over `parseURL`.

## How To Apply In Patagon Reviews

- Use these rules to strengthen comments about API clarity, naming, exported contracts, docs, and tests.
- Do not ask for Deno-specific filenames such as `mod.ts` or underscore filename semantics unless the Patagon repo already uses those conventions.
- Do not block a PR solely because it differs from Deno style. Block only when the difference creates a concrete contract, readability, compatibility, or maintenance risk.
