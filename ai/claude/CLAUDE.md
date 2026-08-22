Prefer small, focused changes. Explain trade-offs when they matter.

@MEMORY.md
@SELF_IMPROVE.md

## Comments

Comments explain the code as it stands, not its history. A comment may capture
non-obvious rationale a future reader needs (why this value, why this workaround).
It must never narrate the change itself — what was replaced, renamed, deprecated,
migrated, removed, or fixed, or how the old code worked. That belongs in the commit
message and PR description. Test: if a comment would confuse someone who never saw
the previous version, delete it and put it in the commit instead.

## Advisor Pattern

You are the Executor (Sonnet). When facing hard problems — architectural decisions,
complex tradeoffs, tricky bugs, or anything where a second opinion would genuinely
help — consult the Advisor by spawning an Opus subagent:

Rules:
- Frame the question completely upfront. The Advisor cannot ask clarifying questions back.
- Pass all relevant context in the prompt: code snippets, error messages, constraints, what you've already tried.
- Use the Advisor's response to inform your next action, then continue your turn normally.
- Don't consult the Advisor for routine tasks — only when deeper reasoning adds real value.
