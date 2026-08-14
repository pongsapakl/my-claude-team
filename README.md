# pongsapakl-skills

[Claude when you update readme please dont edit this part. This is handwritten (or handtyped) and I wanted to keep it as is. Below ## Quick Install you can do whatever you are born to do.]

It appears to me that there are so many productivity frameworks out there trying to utilize the function of agents, skills, etc. as provided by Claude. Yet I find many of them are more generic and load everything up front (which I find somewhat annoying) and not tailored to my own needs. So, I created a custom one based on those frameworks out there and made it fit my requirements a little more. It is very basic yet so powerful for my workflow.

This repo serves as my archive/backup for my workflow (integrated with Claude Code, obviously), yet I try to make it more generic by moving project-specific information to the `CLAUDE.md` file and letting agents read from there to make this tool more reusable for other projects. If you find this interesting, please feel free to test it out, fork it—comments are appreciated, yet I can't confirm I'll fix issues since it is my workflow for my needs after all. Also feel free to basically fetch this to Claude and let it generate your own version of this. Well, maybe fetching some other repo might provide more polished ideas, but whatever.

[UPDATE v.0.5.0] I also feels like handing over session for me is really important. Despite there are things like `/compact` it is still not as good as i think it can be. That is why I use a file-based system to hand over session. This way, not only agent, but also us humans can catch up on what is left, what to do next more easily. Key is what is just done, and what to do next (along with related file).

## Quick Install

```bash
/plugin marketplace add pongsapakl/pongsapakl-skills
/plugin install handover@pongsapakl-skills
```

This repo is a marketplace. Each plugin installs on its own — `handover` is the
only one so far.

## What Problem Does This Solve?

Claude Code sessions are ephemeral. When a session ends — context limit, credit
cap, or just closing the terminal — everything about what you were doing, what
you decided, and what comes next is gone. The next session starts from zero.

`handover` fixes that with a file-based handover system. `/handover:end` writes
down what was done, what's half-finished, and a specific actionable note for
next time. `/handover:start` reads it back and gets you (or Claude) up to speed
in seconds.

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

## Session Lifecycle

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

**Why files instead of `/compact`.** Compaction is lossy and invisible — you
can't read it, edit it, or hand it to a teammate. A file-based handover is
inspectable by both the human and the agent, and it survives the session that
created it.

**Why the next-step note is the point.** The most valuable line in a session log
isn't what was finished, it's the specific thing to do next and the file it
lives in. Everything else is context; that line is the handoff.

**Why `/handover:init` writes into `CLAUDE.md`.** Sessions that never run
`/handover:start` still need to know what `WORK.md` and `TODO.md` are. The block
is delimited by `<!-- handover:begin -->` / `<!-- handover:end -->` sentinels, so
re-running init updates it in place instead of appending a duplicate.

## Repo Layout

```text
pongsapakl-skills/
├── .claude-plugin/marketplace.json   ← lists every plugin
└── handover/                         ← one plugin, installed on its own
    ├── .claude-plugin/plugin.json
    └── skills/{init,start,end}/
```

Plugins are top-level directories. Each has its own version and its own
`skills` allowlist, so adding a group never touches an existing one.

## Scope

This repo is my working setup, published as-is. It used to ship a C-suite agent
team, planning, research, and deployment-check skills; usage data across two
months of sessions showed those were never invoked, so v1.0.0 removed them. What
remains is the part I actually use every day.

Fork it, adapt it, or point Claude at it and generate your own. Issues and
comments are welcome, but this tracks my workflow first.

## License

MIT — see [LICENSE](LICENSE).
