---
name: write-clearly-google-style
description: Draft, rewrite, edit, or review developer documentation by applying the Google developer documentation style guide. Use for READMEs, tutorials, how-to guides, concepts, API references, CLI docs, UI procedures, release-independent product docs, code comments, and documentation style audits where clear structure, conversational tone, active voice, second person, accessibility, global readability, inclusive language, technical formatting, links, tables, or terminology matter.
---

# Write clearly in Google style

Apply Google's reader-centered documentation style without changing technical meaning. Treat this skill as an operational editing workflow, not as a license to make unverified product claims.

## Resolve authority before editing

Apply guidance in this order:

1. Follow explicit user instructions and project- or product-specific style.
2. Follow this skill's summary of the Google developer documentation style guide.
3. For unresolved questions, consult the live Google guide and then its recommended third-party references.

Prefer clarity for the actual audience over mechanical compliance. If a deliberate exception helps readers, use it consistently and mention it only when the user needs an audit trail. Do not imply that content is Google-authored, Google-approved, or official merely because it follows this style.

## Choose the working mode

- **Draft:** Build a new document from verified facts, audience needs, and a concrete reader goal.
- **Rewrite:** Preserve meaning, identifiers, and required constraints while improving structure and language.
- **Review:** Report consequential findings first, then propose precise revisions. Do not bury correctness or accessibility issues under punctuation nits.
- **Answer a style question:** Give the decision, a short reason, and an example. Consult the live guide for obscure, product-specific, or recently changing terminology.

Scale the work to the request. A sentence needs a focused edit; a documentation set needs an inventory, information architecture, terminology pass, and cross-page consistency check.

## Load only the references needed

- Read [core-writing.md](references/core-writing.md) for voice, person, agency, sentences, paragraphs, tense, timelessness, claims, jargon, and prescriptive language.
- Read [structure-and-procedures.md](references/structure-and-procedures.md) for page design, headings, lists, tables, procedures, notices, examples, and images.
- Read [technical-elements.md](references/technical-elements.md) for code in text, code samples, commands, placeholders, UI instructions, API reference comments, filenames, Markdown, and HTML.
- Read [accessible-global-inclusive.md](references/accessible-global-inclusive.md) whenever writing or reviewing user-facing documentation, and especially for accessibility, localization, examples involving people, or potentially exclusionary terms.
- Read [mechanics-and-formatting.md](references/mechanics-and-formatting.md) for links, capitalization, emphasis, punctuation, dates, times, numbers, units, spelling, product names, and word choice.
- Read [source-map.md](references/source-map.md) to locate the canonical Google page for an edge case or to refresh guidance that might have changed.

## Work through the document

### 1. Establish the contract

Identify or infer:

- the intended reader and what they are trying to accomplish;
- the document type and publication format;
- prerequisites, scope, supported versions, and non-goals;
- project terminology, source-of-truth facts, and existing house style;
- whether code, commands, UI labels, error messages, legal wording, or API names must remain exact;
- accessibility, localization, and maintenance requirements.

Ask only when a missing fact would materially change the result. Otherwise, state a narrow assumption and proceed.

### 2. Protect technical truth

Do not silently alter commands, paths, identifiers, version numbers, defaults, API behavior, security requirements, or quoted UI labels. Verify code and commands when the task authorizes execution. If verification is unavailable, preserve the source and flag the uncertainty.

Separate editorial defects from suspected technical defects. Style cannot repair an incorrect procedure.

### 3. Design for the reader's path

Give each page one primary purpose. Put the reader's goal, critical constraints, and prerequisites before detail. Use descriptive sentence-case headings, short single-idea paragraphs, and lists only when they improve scanning. For tasks, recommend the clearest successful path rather than presenting avoidable choices.

### 4. Draft or revise in passes

Use these passes in order:

1. **Purpose and structure:** Remove irrelevant material, order content by reader need, and make headings form a useful outline.
2. **Accuracy and agency:** Make actors, conditions, required actions, outcomes, and failure states explicit.
3. **Procedure quality:** Put conditions before actions, use imperative steps, supply prerequisites and context, and keep one reader decision per step.
4. **Language:** Use conversational US English, second person, active voice, present tense, literal wording, consistent terms, and concise sentences.
5. **Technical presentation:** Format code, commands, placeholders, UI labels, filenames, tables, links, and examples consistently.
6. **Access and reach:** Check semantic structure, keyboard and screen-reader implications, alt text, nonvisual meaning, global readability, and inclusive language.
7. **Maintenance:** Remove avoidable time anchors, unsupported promises, excessive claims, and duplicated explanations that will drift.

### 5. Deliver in the requested form

For a draft or rewrite, lead with the finished copy. Add a short assumptions or change note only when it helps the user review material decisions.

For a review, organize each actionable finding as:

1. Location or quoted fragment.
2. Reader or production impact.
3. Applicable principle.
4. Concrete replacement or repair.

Distinguish blocking accuracy/accessibility problems from consistency improvements. If the document is already sound, say so directly rather than inventing findings.

## Run the final audit

Confirm that:

- the page serves a named reader goal and exposes prerequisites early;
- facts, code, commands, and labels remain technically accurate;
- headings are descriptive and sentence case;
- paragraphs are scannable and lead with their point;
- instructions use direct, imperative language and explicit conditions;
- terminology, capitalization, and formatting are consistent;
- links are descriptive and selective;
- images, tables, and UI directions work without relying only on position, color, or appearance;
- potentially changing terminology was checked against the live word list;
- the copy avoids avoidable jargon, figurative language, cultural assumptions, unsupported claims, and unnecessary time anchors;
- any exception to the guide is intentional, audience-serving, and consistent.
