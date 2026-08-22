## Global memory (~/.gh/global-memory/)

A single index file, `~/.gh/global-memory/MEMORY.md`, plus topic
subdirectories that don't exist until the first memory needs one — no
pre-seeded topics. `MEMORY.md` stays a pure index: one line per memory
(`- [Title](topic/file.md) — hook`), never memory content itself.

### Topic selection

When saving a memory, decide which topic subdirectory it belongs in:

1. List existing topics first (the subdirectory names under
   `~/.gh/global-memory/`) — reuse beats creation.
2. Match by domain (what is this fundamentally about), not by keyword
   overlap with the memory's content.
3. Prefer the closest existing topic even on an imperfect fit — a
   slightly-broad topic beats ten narrow ones.
4. Create a new topic only if no existing topic is a reasonable home,
   *and* this domain will plausibly accumulate more than one memory over
   time. A fact that will likely always be alone doesn't earn its own
   directory.
5. A new topic must match the scope/altitude of whatever topics already
   exist — a life-domain, not a narrow slice or a project name. If the
   natural name is narrower than that, it's a memory within an existing
   topic, not a new topic.
6. Name new topics as short, generic, lowercase nouns naming the domain
   itself, not the fact that triggered creating it.
7. On genuine ties, pick the closer fit and move on — findable later
   matters more than theoretically perfect categorization.
8. Mention it in your response when a session creates a new top-level
   topic, so the growth is visible, not discovered later.

### Atomicity

Each memory file captures exactly one discrete, self-contained fact or
learning:

- One file = one fact. Two independent things → two files.
- Must be understandable alone, without reading siblings. Link related
  memories with `[[name]]` rather than merging them.
- Filename must name exactly the one thing inside — specific enough that
  the index line (and the filename itself) tells you what's inside
  without opening it.
- New info that corrects/extends an existing memory edits that file in
  place. Never create a near-duplicate for the same fact restated.
- If a memory-in-progress turns out to be two facts, split it into two
  files, filed under whichever topic each independently belongs in.
- If an existing file has drifted into covering more than one fact, split
  it the next time it's touched.

Each memory file keeps the same frontmatter shape as a project's
per-project memory system (`name`, `description`, `metadata.type` —
`user`/`feedback`/`reference`; `project`-type facts stay in per-project
memory, they don't belong globally by definition).
