# Core writing guidance

## Contents

- Voice and tone
- Reader, actor, and voice
- Sentences and paragraphs
- Prescriptive language
- Tense, time, and claims
- Terminology, jargon, and abbreviations

## Voice and tone

Write like a knowledgeable colleague who respects the reader's time. Be conversational, friendly, direct, and calm. Keep personality subordinate to usefulness.

Avoid slang, cuteness, pop-culture references, hype, repeated pleas, exclamation marks, and formal bureaucratic phrasing. Do not call a task easy, simple, quick, or obvious; those judgments can frustrate readers who encounter difficulty. Replace filler such as "please note" with the fact itself.

Use contractions when they make prose sound natural and remain unambiguous. Prefer literal language over idioms, metaphors, clichés, or jokes.

## Reader, actor, and voice

Address the document's reader as **you**. Use the imperative for instructions; the implied subject is the reader.

Use third person for software behavior or for an end user of software that the reader is developing. Make the distinction explicit:

- Reader action: "Call the method to refresh the token."
- Software behavior: "The client refreshes the token before it expires."
- End-user action: "The user approves access in the consent screen."

Use **we**, **our**, or **us** only when the pronoun clearly refers to the organization authoring the document. Do not use **we** to blur who performs an action.

Prefer active voice because it names the actor. Passive voice is acceptable when the actor is unknown, irrelevant, or intentionally de-emphasized, but the sentence must remain unambiguous.

Avoid anthropomorphism when it hides mechanics or agency. A service can return, store, reject, or calculate data; it usually does not want, know, decide, or believe. Established technical shorthand is acceptable when readers understand it and no ambiguity results.

## Sentences and paragraphs

Put a condition, circumstance, or goal before its instruction so readers can skip actions that do not apply:

- Prefer: "To delete the workspace, click **Delete**."
- Avoid: "Click **Delete** if you want to delete the workspace."

Use standard English word order. Keep the subject and verb close together. Prefer affirmative statements over double negatives. Include articles such as **a**, **an**, and **the**; do not drop them merely to make a heading shorter.

Aim for short, complete sentences. Treat 26 words as a warning sign, not an absolute limit. Split sentences when they contain multiple conditions, actions, or ideas.

Give each paragraph one main idea and put the important point first. Break up walls of text, but do not fragment a coherent idea solely to meet a numeric limit. Paragraphs longer than roughly five or six sentences deserve a second look.

## Prescriptive language

For task-oriented documentation, recommend a path instead of shifting avoidable design decisions to the reader.

Use modality precisely:

- Use an imperative for a required reader action: "Create a service account."
- Use **must** for a mandatory requirement or unavoidable condition.
- Use **can** for capability or an available option.
- Use **might** for possibility.
- Use "We recommend" or name the recommending organization for a nonmandatory recommendation.
- Avoid ambiguous **should** in prescriptive passages when one of the preceding forms states the intent more precisely.

Do not inflate a preference into a requirement. Preserve standards language such as RFC keywords when the source assigns them defined meanings.

## Tense, time, and claims

Use present tense for current product behavior. Avoid unnecessary future tense; describe what happens after an action in the present tense.

Write durable product documentation. Avoid **currently**, **now**, **new**, **latest**, **soon**, **eventually**, and similar time anchors unless the document is explicitly versioned, dated, or announcing a release. When a comparison with an earlier state matters, give a concrete version or date.

Do not document unannounced future features or speculate about roadmaps. Keep release notes, announcements, and migration guides clearly time-scoped.

Avoid unsupported superlatives, universal claims, and promises. Replace "always," "never," "best," "fastest," or "guarantees" with a scoped, supportable statement. Do not promise that a future state will occur unless the product contract actually guarantees it.

## Terminology, jargon, and abbreviations

Use one term for one concept and preserve capitalization. Prefer the product's authoritative name and define domain-specific terms near first use.

Avoid jargon when plain language is more precise. If readers search for or rely on a necessary term:

1. Introduce it with a plain-language explanation.
2. Use the exact term consistently afterward.
3. Link to a trusted definition if a short explanation is insufficient.

When a legacy or noninclusive term is embedded in code, format the exact code token as code and write the surrounding prose with the preferred term. Do not silently rewrite executable identifiers.

Spell out an abbreviation on first use when readers might not know it, followed by the abbreviation in parentheses. Do not define universally understood units or identifiers unnecessarily. Avoid using an abbreviation only once unless it improves recognition. Apply articles according to pronunciation, not spelling.

Consult the live Google word list for disputed or changing terms. Treat product-specific annotations as scoped guidance, not universal rules.

