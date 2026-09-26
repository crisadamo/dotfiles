# Technical elements

## Contents

- Exact text and code font
- Code samples
- Commands and output
- Placeholders
- UI elements
- API reference comments
- Filenames and source markup

## Exact text and code font

Use code font for text that a reader enters, code identifiers, method and class names, attributes, data types, database elements, filenames, paths, flags, HTTP status codes, literal values, console output, and similar machine-facing tokens.

Do not use code font merely because a term is technical. Product names, organization names, domains, and ordinary prose stay in normal font unless the specific occurrence is input, output, or an identifier.

Preserve exact case and spelling. Integrate code tokens grammatically without changing the token; add a noun when pluralization would otherwise alter a class or method name.

If a UI label is also a code token, apply the project's established combined formatting. Avoid inventing custom styling when semantic Markdown or HTML can express the distinction.

## Code samples

Make samples correct, minimal, and relevant to the surrounding task. Follow the project's language-specific code style before applying general documentation conventions.

- Introduce every sample and state what it demonstrates.
- End an introduction with a colon only when the sample immediately follows it.
- Keep lines readable; treat 80 characters as the Google guide's general target unless the codebase uses another convention.
- Use spaces, indentation, and fences appropriate to the language and publishing system.
- Mark omitted code with a valid comment in that language, not with unexplained ellipses.
- Avoid fake credentials, unsafe defaults, destructive commands without warnings, and samples that cannot plausibly run.
- When execution is in scope, test the sample. Otherwise, say that it was not executed if the distinction matters.

## Commands and output

Describe what a command accomplishes and link to its authoritative reference when useful. In tutorials, show the arguments needed for the recommended task and leave the exhaustive option list to reference documentation.

Prefer click-to-copy commands that run after readers replace clearly identified placeholders. Do not put syntax notation such as optional brackets or mutually exclusive braces into a copyable command unless the interface strips or explains it.

For long commands, use the shell's valid continuation character and align continuation lines consistently. Keep commands and their output in separate blocks. State whether output is exact, abbreviated, or representative.

Show prompts only when they clarify a multi-line session or a change of execution context. Do not include a changing working-directory path in the prompt. Do not rely on `$` or another prompt character if readers might copy it as part of the command.

For syntax references:

- Use `[OPTION]` for an optional element.
- Use `{ONE|OTHER}` for exactly one required choice.
- Explain repetition explicitly and avoid syntax notation in runnable examples.

## Placeholders

Use descriptive uppercase names separated by underscores, such as `PROJECT_ID` or `SERVICE_ACCOUNT_EMAIL`. Avoid `X`, repeated `x` characters, `MY_`, and `YOUR_` unless a domain convention requires them.

Normalize an obvious sample-only placeholder to this form when doing so cannot change execution semantics. Do not rename a real environment variable, template token, positional parameter, or other executable identifier merely to satisfy editorial style. If the distinction is uncertain, preserve the token and flag it for verification.

Distinguish placeholders visually from literal code using the publishing system's supported semantic markup. Explain each placeholder immediately after the sample or before it when the reader needs the value in advance. Do not wrap brackets, braces, or ellipses in placeholder markup.

Use realistic example values when the value itself teaches the expected format. Use reserved example domains, IP addresses, and phone-number ranges instead of real third-party data.

## UI elements

Focus an instruction on the reader's goal, not on widget mechanics. When a UI reference is necessary:

- Use the visible label exactly and format it in bold.
- Refer to controls by label instead of color, shape, relative position, or icon appearance.
- Add a generic control noun only when it clarifies the instruction.
- Write menu paths in order and use the publishing system's accessible menu-path markup.
- Use semantic keyboard markup for keys and write letter keys in uppercase.
- Avoid gestures and keyboard shortcuts when a stable label-based instruction is available.
- Provide context when mentioning a UI element outside a numbered procedure.

Do not update a quoted label to match house capitalization; the product UI is the source of truth. If the label appears wrong or stale, flag it for verification.

If the source identifies a control only by color, shape, icon, or position and the exact label is unknown, do not invent a label. Use an unambiguous functional description only when the interface makes it unique; otherwise, insert a clearly marked label placeholder or report the missing product fact.

## API reference comments

Document every public type, field, constant, method, parameter, return value, and thrown exception that the reference surface exposes.

Put the most useful summary in the first sentence because generators often use it in indexes. Start with what the element does, returns, represents, or controls; do not merely repeat the identifier in prose.

Use present tense and specific reference verbs. State parameter meaning, accepted values, units, defaults, nullability, side effects, and constraints when relevant. Describe Boolean return semantics explicitly. Describe when exceptions occur.

For deprecations, start with **Deprecated.**, name the replacement, and explain the migration action. Include the deprecation version when the API tracks versions.

Follow language-specific documentation syntax and the API's design standard; this editorial guide does not replace them.

## Filenames and source markup

Refer to a filename in code font with its exact spelling; add the word **file** when it prevents ambiguity. Refer to a file type by its conventional name, such as "a PNG file," rather than by extension alone.

For new documentation filenames, prefer lowercase ASCII words separated by hyphens, but follow an existing directory convention when consistency or generated tooling requires it.

Use semantic Markdown or HTML rather than manual font, size, or color styling. Follow the project's source-format rules. In HTML, prefer native semantic elements, lowercase elements and attributes, two-space indentation when no project rule overrides it, and explicit optional elements when the documentation standard requires them.
