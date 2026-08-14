# handover

File-based session handover for Claude Code. `/handover:end` writes down what
happened and what's next; `/handover:start` reads it back. Context survives
between sessions.

```bash
/plugin install handover@pongsapakl-skills
```

## The Problem

Claude Code sessions are ephemeral. When one ends — context limit, credit cap,
or just closing the terminal — what you were doing, what you decided, and what
comes next is gone. The next session starts from zero.

`/compact` doesn't solve this: it's lossy and invisible. You can't read it, edit
it, or hand it to a teammate. A file-based handover is inspectable by both the
human and the agent, and it survives the session that created it.

## The Three Files

| File | Owner | Purpose |
|------|-------|---------|
| `TODO.md` | Human | Freeform scratchpad. Append-only — Claude never deletes or rewrites your entries. |
| `WORK.md` | AI | Structured multi-track state. Each track is independent; `/handover:end` only updates the active one. |
| `docs/sessions/*.md` | Both | Immutable narrative logs, one per session — the "what happened" story, not just checkboxes. |

Multi-track matters if you work on several things in one repo: parallel
workstreams keep separate state, so closing one session never clobbers another
track's context.

## Skills

| Command | When | What it does |
|---------|------|--------------|
| `/handover:init` | Once per project | Creates `docs/`, `WORK.md`, `TODO.md`, updates `.gitignore`, and writes a Session Handover block into the project's `CLAUDE.md`. |
| `/handover:start` | Opening a session | Reads `WORK.md`, `TODO.md`, and the latest session log; shows active tracks; asks which to focus on. |
| `/handover:end` | Closing a session | Scans the conversation, writes a narrative session log, merges state into the active track, appends to `TODO.md`. |

## Lifecycle

```text
  /handover:init          /handover:start           /handover:end
  (once per project)      (open)                    (close)
  ┌────────────────┐      ┌────────────────┐        ┌────────────────┐
  │ docs/ folders  │      │ read WORK.md   │        │ write session  │
  │ WORK.md        │─────▶│ + TODO.md      │───────▶│ log            │
  │ TODO.md        │      │ + latest log   │        │ merge active   │
  │ CLAUDE.md block│      │ pick a track   │        │ track only     │
  └────────────────┘      └────────────────┘        └───────┬────────┘
                                   ▲                        │
                                   └────────────────────────┘
                                        next session
```

## Design Notes

**The next-step note is the point.** The most valuable line in a session log
isn't what was finished — it's the specific thing to do next and the file it
lives in. Everything else is context; that line is the handoff. `/handover:end`
quality-tests it and refuses vague entries like "continue working on the
feature."

**Ending with no handoff is valid.** A session that was purely advisory, or that
finished everything it opened, writes `None — session closed cleanly` rather
than inventing a next action or recycling old backlog.

**`/handover:init` writes into `CLAUDE.md`.** Sessions that never run
`/handover:start` still need to know what `WORK.md` and `TODO.md` are. The block
is delimited by `<!-- handover:begin -->` / `<!-- handover:end -->` sentinels, so
re-running init updates it in place instead of appending a duplicate.
