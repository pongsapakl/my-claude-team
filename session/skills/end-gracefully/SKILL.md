---
name: end-gracefully
description: Check whether the current session can be closed cleanly — surfaces half-done work, unresolved questions, decisions made but never written down, unverified claims, and uncommitted changes. Read-only; reports and routes, never acts. Auto-invokes on "end gracefully", "can I close this", "anything I missed", "did we miss anything", "is this session done", "safe to close", "anything more then".
allowed-tools: [Read, Grep, Glob, Bash]
---

# End Gracefully — Pre-Close Sweep

Long, multitasking sessions lose threads. Something gets started and buried under
the next thing; a question gets asked and never answered; a decision gets made in
conversation and never written anywhere. This skill looks back over the session
and says whether it's safe to close.

**This skill is read-only.** It never commits, never writes files, never edits
docs. It reports what's outstanding and points at the thing that handles it.
That's what makes it safe to run at any moment.

## Scope

Works in any session, with or without a handover setup. If `WORK.md` or
`docs/sessions/` exist, use them as extra signal — but never require them, and
never create them.

## Step 1: Re-read the session

Scan the whole conversation, not just the recent part — the buried items are the
point. For each, note the specific file, command, or question involved.

Look for:

1. **Half-done work** — something started whose completion was never confirmed.
   A file edited but never run, a test written but never executed, a migration
   half-applied.
2. **Unresolved questions** — a question raised (by either side) that got
   overtaken by later work and never answered.
3. **Decisions made but unrecorded** — a choice settled in conversation with
   nothing written to disk. These are the most expensive to lose: the reasoning
   evaporates and gets re-litigated later.
4. **Unverified claims** — anything asserted to work that was never actually
   run. Distinguish "I ran it and it passed" from "this should work now."
5. **Deferred items** — things explicitly punted ("let's do that later") that
   were never captured anywhere.

## Step 2: Check the working tree

Only if this is a git repo:

```bash
git status --short
git log --oneline @{upstream}..HEAD 2>/dev/null
```

Report uncommitted changes and unpushed commits. **Do not commit or push** — say
what's there and let the user decide.

## Step 3: Check whether it's already closed

If `docs/sessions/` exists, check for a log dated today. Answers "did we already
end this?" without the user having to look.

## Step 4: Report

Lead with the verdict.

**If nothing is outstanding:**

```
Safe to close. [One line on what this session did.]
```

Say this plainly when it's true. A clean session is a normal outcome.

**If something is outstanding**, list only real items, most consequential first:

```
Not clean yet — N things:

1. [Half-done] `src/auth/webhook.ts` — constructEvent is stubbed; signature
   verification never written.
2. [Unanswered] You asked whether the Pi should own the watcher; we moved on
   without deciding.
3. [Unrecorded] Decided to drop the retry layer because of the rate limit —
   nothing on disk.
4. [Uncommitted] 3 modified files, 2 unpushed commits.
```

Then route, don't act:

- Unrecorded decisions or a session worth logging → suggest `/handover:end` if
  handover is set up here; otherwise say what's worth writing down and where
- Uncommitted work → ask whether to commit; committing is a separate step
- Half-done work → offer to finish it now, or to note it as the next step

## Do not manufacture work

The failure mode is inventing loose ends to look thorough. Apply this bar:

- Pre-existing backlog is **not** a loose end from this session
- A file you read but didn't change is not unfinished work
- "Could be improved" is not outstanding — only things *this session* opened
- If the session was advisory, or answered its own question, it's clean

**Reporting "safe to close" on a clean session is a correct answer, not a lazy
one.** An item is only outstanding if a future session would be worse off for
not knowing it.
