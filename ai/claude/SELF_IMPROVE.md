## Self-improving skill loop

After finishing any task that involved real problem-solving (not: trivial
edits, one-line fixes, or pure Q&A) — before ending the turn, run this
reflection silently:

1. **Would this exact procedure recur?** If a similar task came up again,
   would replaying these steps save real time or avoid a mistake just
   made? If no, stop here — not everything is skill-worthy.

2. **Check for an existing skill first.** Look in `.agent/skills/` (or
   `.claude/skills/` if this is Claude Code — same directory the Skill
   tool already reads). If one already covers this territory, *update*
   it instead of creating a near-duplicate.

3. **If genuinely new, write `.agent/skills/<short-name>.md`:**
   ```
   ---
   name: <short-name>
   trigger: <when this applies — be specific, not "sometimes">
   ---

   ## Procedure
   <the actual steps, as terse as still-correct>

   ## Gotchas
   <specific mistakes made while solving it, and the fix>
   ```

4. **Save what's durable to global memory** (see MEMORY.md) — anything
   learned that's true beyond this one task/repo, not just the reusable
   procedure itself.

5. **At the start of a new task**, check `.agent/skills/` for a matching
   trigger and global memory for relevant precedent before solving from
   scratch. Prefer reusing over rederiving.

Keep skills honest: a wrong skill is worse than no skill, since it gets
trusted and replayed. If a skill fails when reused, fix it in the same
reflective step rather than silently working around it.
