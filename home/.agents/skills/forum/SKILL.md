---
name: forum
description: Convene a structured three-model discussion using OpenAI GPT-5.6 Sol xhigh through Codex, Anthropic Fable 5 High through Claude Code, and xAI Grok 4.5 High through the Grok CLI, then have GPT-5.6 Sol xhigh synthesize the strongest final answer. Use when a user invokes Forum or asks for a multi-model panel, debate, second opinions, comparative reasoning, cross-review, or a consensus answer from these three models.
---

# Forum

Run a two-round panel and return one chair-written answer:

1. Ask all three models for independent answers in parallel.
2. Give every answer to all three models for parallel comparative review.
3. Give the original prompt, answers, and reviews to GPT-5.6 Sol xhigh for final synthesis.

## Run the forum

Pass the user's substantive prompt verbatim through stdin. Do not include the request to invoke Forum itself.

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/forum/scripts/forum.py" --cwd "$PWD" <<'FORUM_PROMPT'
<prompt>
FORUM_PROMPT
```

Return the script's stdout as the answer. Progress and errors go to stderr.

Use `--artifacts-dir <directory>` only when the user requests transcripts or an audit trail. The directory receives the original prompt, three drafts, three reviews, and final answer. Otherwise, keep intermediate material temporary and return only the synthesis.

Use `--timeout <seconds>` to change the per-model-call timeout from 900 seconds. Set `FORUM_CODEX_BIN`, `FORUM_CLAUDE_BIN`, or `FORUM_GROK_BIN` only when a CLI is installed at a nonstandard path. Model IDs can be updated with `FORUM_CODEX_MODEL`, `FORUM_CLAUDE_MODEL`, and `FORUM_GROK_MODEL` if providers rename them.

## Preserve the boundary

- Treat Forum as an answer-generation workflow, not an implementation agent. The child CLIs receive no write-capable tools and must not modify the workspace.
- Inline all facts, file excerpts, images transcribed as text, or other context the panel needs into the prompt. Do not assume child models share the current conversation context.
- Do not silently substitute a model. If any required call fails, report the failure instead of presenting a partial panel as complete.
- Do not expose drafts or reviews unless requested. The final synthesis must answer the original prompt directly and mention the panel only when that context is useful or requested.
