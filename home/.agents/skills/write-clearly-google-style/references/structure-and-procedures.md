# Structure and procedures

## Contents

- Page architecture
- Headings and titles
- Lists and tables
- Procedures
- Notes, examples, and images

## Page architecture

Give a page one clear purpose and make the title reflect it. Near the beginning, establish what the reader can accomplish, who the page is for, and any prerequisite that affects whether the task applies.

Order material by the reader's path:

1. Goal and scope.
2. Prerequisites or constraints.
3. Primary procedure or explanation.
4. Expected result and verification.
5. Troubleshooting, alternatives, or deeper reference material.

Do not preannounce undocumented features or fill introductions with marketing. Put essential context on the page; use links for relevant supporting information, not as a substitute for the explanation a reader needs to continue.

## Headings and titles

Use sentence case for page titles and headings. Make them specific, unique, and useful in a table of contents or screen-reader heading list.

- Use a bare infinitive for a task: "Create an API key."
- Use a noun phrase for a concept or reference section: "Authentication methods."
- Avoid vague headings such as "Overview," "Details," or "More" when a descriptive phrase is available.
- Avoid gerunds when a direct task or noun phrase is clearer.
- Do not number headings merely to represent hierarchy.
- Use one page-level heading, nest levels in order, and never choose a level for visual size.
- Do not put links in headings unless the publishing system has a compelling established pattern.
- Define an unfamiliar abbreviation in the first paragraph after the heading rather than expanding the heading into an unwieldy title.

Use heading text and explicit anchors as stable link targets. Follow the repository's anchor convention, and avoid changing published targets without a redirect or compatibility plan.

## Lists and tables

Use a numbered list for an ordered sequence or priority. Use a bulleted list for unordered items. Use a description list for term-description pairs. Use a table when each item has three or more comparable fields.

Introduce a list or table with a complete sentence when the heading alone does not provide enough context. Use parallel grammar across items.

For list punctuation:

- Start ordinary items with a capital letter unless case is meaningful.
- End complete sentences with punctuation.
- Omit end punctuation for single words, short noun phrases without verbs, code-only items, link-only items, or titles.
- If punctuation becomes inconsistent, rewrite for parallel structure or punctuate every item consistently.

Do not create a list containing only one item.

For tables:

- Use tables only for genuinely two-dimensional information, never for page layout or code layout.
- Prefer a list for one-dimensional data or a single-column table.
- Introduce the table in surrounding prose.
- Use concise sentence-case headers marked semantically as headers.
- Add appropriate header scope; do not communicate meaning through styling alone.
- Avoid merged cells, large multi-axis tables, and tables inside numbered procedures.
- Split complex tables and make them responsive when possible.

## Procedures

Prepare the reader before the first step. State required permissions, tools, configuration, costs, destructive effects, and information they must gather.

Write steps as follows:

1. Start the first sentence of each step with an imperative verb.
2. Use complete sentences and parallel verb forms.
3. Put the environment or UI context before the action when it can change.
4. Keep one reader decision or meaningful action per step. Combine tightly coupled actions only when separating them would interrupt the flow.
5. Mark a nonrequired step with **Optional:** as the first word.
6. Keep the successful path short and place exceptions or alternatives after it.
7. State an expected result when it helps the reader verify progress.

Focus command introductions on outcomes:

- Prefer: "Deploy the service:"
- Avoid: "Run the following command:"

Do not add **please** to each instruction. Avoid keyboard shortcuts because they vary by platform and configuration. If pressing Enter is part of entering a value, include it in the same step.

When multiple methods exist, document the recommended method in the main path. Include alternatives only when readers have a real constraint or the task explicitly compares approaches.

For nested procedures, minimize depth. Use substeps for a small, inseparable sequence inside a parent step; otherwise, create a separate procedure with its own descriptive heading.

## Notes, examples, and images

Use notices sparingly and choose the lowest severity that communicates the risk. Do not place essential steps only in a note. State the consequence and the prevention or recovery action.

Label examples clearly and make them realistic, internally consistent, and safe to copy. Explain what an example demonstrates. Never let an illustrative sample appear to be a supported production default when it is not.

Use diagrams or screenshots only when they materially reduce cognitive load. Provide useful alt text and a prose explanation of any information needed to complete the task. Do not rely on color, position, animation, or an icon alone. Keep screenshots current, focused, high resolution, and consistent in platform and theme across a document set.

