---
name: init
description: Bootstrap workspace with docs structure, WORK.md, and TODO.md. Auto-invokes on "/handover:init", "initialize workspace", "set up project structure".
allowed-tools: [Bash, Write, Read, Glob, AskUserQuestion]
---

# Init — Workspace Bootstrapper

Sets up the documentation structure, live state file (WORK.md), and human scratchpad (TODO.md) for a new project.

## When to Auto-Invoke

Trigger when user says:
- `/handover:init`
- "initialize workspace"
- "set up project structure"
- "set up docs structure"
- "bootstrap project"

## How It Works

### Step 1: Detect Existing Structure

Check what already exists in the project root:

```bash
# Check for existing docs folders
ls -d docs/sessions docs/decisions docs/research docs/plans 2>/dev/null
# Check for WORK.md and TODO.md
ls WORK.md TODO.md 2>/dev/null
# Check for legacy .claude/memory/session-logs
ls -d .claude/memory/session-logs 2>/dev/null
```

Record which items exist and which need to be created.

### Step 2: Smart Merge (if anything exists)

For **each** existing item, use AskUserQuestion:

- "docs/sessions/ already exists. What should I do?"
  - **Keep** (leave as-is)
  - **Replace** (delete and recreate empty)
  - **Skip** (don't touch)

- "WORK.md already exists. What should I do?"
  - **Keep** (leave as-is)
  - **Replace** (overwrite with fresh template)
  - **Skip** (don't touch)

- "TODO.md already exists. What should I do?"
  - **Keep** (leave as-is)
  - **Replace** (overwrite with fresh template)
  - **Skip** (don't touch)

If nothing exists, skip this step entirely — just create everything.

### Step 3: Create Folder Structure

For each folder the user approved (or that doesn't exist yet):

```bash
mkdir -p docs/sessions docs/decisions docs/research docs/plans
```

### Step 4: Create WORK.md (AI Context File)

Only if it doesn't exist or user chose "Replace".

WORK.md is the **AI-facing** structured state file. It uses a multi-track format so parallel workstreams don't clobber each other.

Use this template:

```markdown
# WORK.md

> Last updated: {YYYY-MM-DD}

## Tracks

### {Track Name}
**Status**: Active | Paused | Blocked
**Last session**: {date} — {link to session log}
**State**: {Current state of this track — what's done, what's in progress}
**Next**: {Specific next action for this track}
**Key files**: {Files actively being worked on in this track}

## Open Questions
- {Any blockers or questions that span tracks}

## Active Plan
None
```

Replace `{YYYY-MM-DD}` with today's date. Leave placeholder text for user to fill in.

Ask the user: "What are your initial work tracks? (e.g., 'frontend', 'backend', 'infra') — or just one track is fine too."

### Step 5: Create TODO.md (Human Scratchpad)

Only if it doesn't exist or user chose "Replace".

TODO.md is the **human-facing** freeform scratchpad. It is append-only — old entries are never deleted.

Use this template:

```markdown
# TODO

## Active Tracks
- {emoji} {Track name} ({brief description})

## {YYYY-MM-DD}
- {What needs to happen today/next}
```

Replace `{YYYY-MM-DD}` with today's date. Keep it minimal — the user will fill this in their own style.

### Step 6: Configure .gitignore

For **each** of the four `docs/` subfolders, ask the user:

"Which docs/ subfolders should be added to .gitignore?"

Present as multi-select:
- `docs/sessions/` — session logs (often contain verbose context)
- `docs/decisions/` — ADRs (usually worth committing)
- `docs/research/` — research spikes (usually worth committing)
- `docs/plans/` — implementation plans (usually worth committing)

Append chosen entries to `.gitignore`. If `.gitignore` doesn't exist, create it.

### Step 7: Write the Handover Block into CLAUDE.md

The project's `CLAUDE.md` is what every session loads, including sessions that
never run `/handover:start`. Without this block, a passing session sees `WORK.md` and
`TODO.md` and has no idea what they are.

Append the block below to the project's `CLAUDE.md`, creating the file if it
does not exist.

**Idempotency:** the block is delimited by sentinel comments. If
`<!-- handover:begin -->` already exists in the file, replace everything between
the sentinels in place — do not append a second copy.

```markdown
<!-- handover:begin -->
## Session Handover

This project uses three files to carry context across sessions.

| File | Owner | Purpose |
|------|-------|---------|
| `TODO.md` | Human | Freeform scratchpad. Append-only — never delete or rewrite the user's entries. |
| `WORK.md` | AI | Structured multi-track state. Each track is independent; only update the active one. |
| `docs/sessions/*.md` | Both | Immutable narrative logs, one per session. |

Run `/handover:start` to open a session and `/handover:end` to close one.
Outside those skills, treat `WORK.md` as read-mostly and never clobber a track
you are not working on.
<!-- handover:end -->
```

### Step 8: Legacy Migration (if applicable)

If `.claude/memory/session-logs/` exists and has files:

Ask: "Found existing session logs in `.claude/memory/session-logs/`. Move them to `docs/sessions/`?"

If yes:
```bash
mv .claude/memory/session-logs/*.md docs/sessions/
```

### Step 9: Confirm

Print summary:

```
Workspace initialized:

  Created:
  - docs/sessions/
  - docs/decisions/
  - docs/research/
  - docs/plans/
  - WORK.md (AI context — multi-track state)
  - TODO.md (your scratchpad — freeform, append-only)

  .gitignore:
  - docs/sessions/ (ignored)

  CLAUDE.md:
  - Added the Session Handover block

  Migration:
  - Moved 3 files from .claude/memory/session-logs/ to docs/sessions/

Ready to use /handover:start and /handover:end for session management.

File guide:
  TODO.md → Your notes. You own it. Claude appends, never deletes.
  WORK.md → AI context. /handover:end updates per-track, never overwrites other tracks.
  docs/sessions/ → Rich session logs (immutable archive).
```

## Important

- This skill is **idempotent** — running `/handover:init` twice should not break anything
- Use `{cwd}` (from `pwd`) for all paths, never hardcode
- If `.gitignore` already has an entry, don't duplicate it
- The skill creates structure only — it does not populate content beyond templates

## Tools Usage

- **Bash**: `mkdir -p`, `ls`, `mv`, `pwd`, `date`
- **Write**: Create WORK.md, TODO.md, append to .gitignore
- **Read**: Check existing .gitignore content
- **Glob**: Detect existing structure
- **AskUserQuestion**: Smart merge decisions, .gitignore choices, track names
