# Mechanics and formatting

## Contents

- Visual formatting
- Capitalization and punctuation
- Links and cross-references
- Dates, times, numbers, and units
- Spelling, names, and terminology decisions

## Visual formatting

Use semantic formatting consistently:

- **Bold** for UI labels and occasional run-in headings.
- `Code font` for machine-facing text, identifiers, input, output, filenames, and paths.
- *Italics* sparingly for emphasis, terms being introduced, or titles where the publication style calls for them.

Do not underline for emphasis or override the site's font family, size, or color. Do not use an ampersand as shorthand for **and** except in an exact name, UI label, code token, or severe space constraint.

Use sentence case for titles, headings, navigation, table headings, and captions unless an exact proper name or UI label uses other capitalization. Use all caps for placeholders, not for ordinary emphasis.

## Capitalization and punctuation

Use US English spelling and punctuation unless project style overrides it. Use the serial comma.

Keep punctuation outside link text unless it belongs to the linked title. In US prose, punctuation placement around quotation marks follows US convention, but never move punctuation inside an exact code string or literal.

Use punctuation to clarify, not decorate:

- Use a colon after a complete sentence that directly introduces a list, table, code block, or explanation.
- Use em dashes sparingly; simpler sentences are easier to scan and translate.
- Use hyphens for compound modifiers where they prevent ambiguity, and follow the live word list for established compounds.
- Avoid semicolons when two short sentences or a list is clearer.
- Avoid slashes for alternatives such as "and/or"; name the relationship explicitly.
- Avoid ellipses except for an intentional omission or an exact UI label. In code, use a language comment to mark omitted content.
- Avoid exclamation marks in ordinary documentation.

## Links and cross-references

Every link creates a choice and a possible exit. Link selectively to the best destination.

Write descriptive link text that makes sense out of context. Do not use **click here**, **this link**, or a raw URL when a descriptive label is available. Make the surrounding sentence explain why the destination helps.

Use a consistent cross-reference form such as "For more information about authentication, see [Configure authentication](...)." Use **about**, not **on**, in that construction. Do not repeat the destination title immediately outside identical link text.

Prefer in-page context for a short definition or a few essential steps. Link to authoritative external documentation instead of reproducing another product's complete standard. Use HTTPS when the destination supports it.

Open links in the same tab by default. If the platform must open a new tab or invoke another application, tell the reader in accessible text when the behavior would be surprising.

Use repository-appropriate relative links for internal content and stable canonical links for external content. Check anchors, redirects, and fragment case. Do not use an icon alone to indicate that a link is external.

## Dates, times, numbers, and units

Write dates so month and day cannot be reversed. Spell out the month in prose when practical, or use the project's unambiguous machine format. Include the year when readers could otherwise misinterpret it.

Use numerals for times and include a time zone when readers span zones. Distinguish a named regional time zone from a numeric UTC offset when daylight-saving changes matter. Use a 24-hour clock only when project or domain convention calls for it.

Use numerals for measurements and technical quantities. Put a space between a number and a unit symbol unless the unit's standard convention omits it. Keep units consistent within a comparison and identify whether storage units are decimal or binary when ambiguity matters.

Follow domain conventions for percentages, ranges, phone numbers, version numbers, and mathematical notation. Never localize or reformat a literal that code, an API, or a UI expects exactly.

## Spelling, names, and terminology decisions

Follow this hierarchy:

1. Project-specific terminology and the authoritative product UI or API.
2. The live Google developer documentation word list and product-name guidance.
3. Merriam-Webster for general US spelling.
4. The project's chosen general or technical style reference.

Use the full, correct product name on first relevant mention. Shorten it only when the abbreviation is established and cannot be confused. Do not invent possessive, plural, or abbreviated product forms.

Differentiate a product name from a generic concept through exact capitalization, not gratuitous formatting. Respect trademarks, but do not add trademark symbols unless legal or project guidance requires them.

When evidence conflicts, choose the form that is clearest for the audience, record a project-level exception if it will recur, and use the chosen form consistently.

