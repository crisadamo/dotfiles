# Accessible, global, and inclusive documentation

## Contents

- Accessible language and structure
- Nonvisual and keyboard use
- Images, media, forms, and tables
- Global readability and localization
- Inclusive language and examples

## Accessible language and structure

Accessibility is part of editorial quality, not a final cosmetic pass.

- Use short, direct sentences and single-idea paragraphs.
- Put distinguishing information early.
- Use descriptive titles, ordered heading levels, and semantic lists.
- Define unfamiliar abbreviations and preserve parallel structure.
- Avoid double negatives, nested exceptions, and instructions that depend on punctuation being spoken.
- Use native semantic elements instead of visual styling that only resembles them.

Do not force line breaks inside prose. Do not center or fully justify body text. Avoid unnecessary all-caps and camel-case prose because some screen readers pronounce it poorly.

## Nonvisual and keyboard use

Ensure the document remains understandable:

- without images, animation, sound, color, or punctuation;
- with enlarged text or screen magnification;
- by keyboard alone;
- in a screen reader's linear reading order.

Do not use **above**, **below**, **on the right**, **the green button**, or similar visual-only orientation. Refer to a section, table, diagram, or control by its label or name. Use **preceding** or **following** only when the reading order makes the reference stable.

Introduce interactive elements before they appear. Make focus order follow document order and provide visible focus. Avoid flashing, flickering, hover-only behavior, and content that requires a mouse.

## Images, media, forms, and tables

Write alt text that communicates the image's purpose in context, not every visual detail. Use empty alt text for a decorative image whose adjacent text already conveys the same information. Put essential explanation in body text when alt text would become a miniature article.

Provide captions or transcripts for meaningful audio and video. Do not communicate a state through color, icon, size, or location alone; add a text label or another independent cue.

Label every form control with a semantic label outside the field. Error messages must say what went wrong and how to fix it.

Introduce tables because a screen reader might not announce their purpose. Use semantic headers and scope, avoid merged cells, and prefer a list when a table is not clearly the best representation.

Treat WCAG and the publishing platform's accessibility requirements as authoritative when they are stricter or more specific than this summary.

## Global readability and localization

Write in US English unless the project specifies another locale, but assume many readers use English as an additional language or read a translation.

- Use literal, concise, unambiguous wording.
- Keep terminology, capitalization, and formatting consistent.
- Include normal articles and standard sentence structure.
- Avoid colloquialisms, idioms, wordplay, humor, and culture-specific references.
- Use unambiguous dates and identify time zones.
- Avoid seasons as date references; seasons differ by hemisphere.
- State units and use locale-appropriate or convertible formats when the audience requires them.
- Avoid noun stacks; expand the relationship between nouns when a phrase is hard to parse.

Do not concatenate sentence fragments or embed variables in grammar-dependent prose if the content is also a translatable UI string.

## Inclusive language and examples

Use literal and precise terms in their primary sense. Avoid unnecessarily gendered, ableist, violent, stigmatizing, or dehumanizing language. Do not use a person's identity as a metaphor for system state or failure.

When discussing disability, follow the preferences of the people or community being described and the project's current terminology guidance. Focus on access needs and product behavior, not assumptions about limitations.

Use diverse example names and scenarios without stereotyping. Avoid assigning identities to negative behavior or placing only one group in subordinate roles. Use singular **they** for a person whose gender is unknown or irrelevant.

If a discouraged term appears in an API, command, or configuration key:

1. Preserve the exact token in code font where readers must use it.
2. Use preferred language in surrounding prose.
3. Explain the mapping only when needed to prevent confusion.
4. Recommend migration only if the product actually supports it.

Consult the live Google word list and the project's inclusion guidance for terms that evolve over time.

