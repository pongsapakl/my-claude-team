---
name: session-log
description: Saves detailed session logs based on conversation context. Auto-invokes when user asks to save/log session. (project)
allowed-tools: [Read, Write, Grep, Glob, Bash]
---

# Session Log - Automatic Session Documentation

Automatically creates detailed session logs based on conversation history.

## When to Auto-Invoke

Trigger when user says:
- "save this session" / "save the session"
- "log this session" / "log the session"
- "document this session"
- "/session-log" command

## How It Works

1. **Analyze conversation** - Review full conversation history automatically
2. **Determine type** - Implementation session (coding) or General session (planning/discussion)
3. **Extract key info** - Summary, decisions, technical details, challenges, action items
4. **Generate filename** - `YYYY-MM-DD-brief-topic.md` based on main topic
5. **Save log** - Write to `.claude/memory/session-logs/`
6. **Confirm** - Show summary to user

**No menus, no questions** - fully automatic based on context.

## Session Log Templates

### Implementation Session

Use when session involved coding, technical work, or implementation:

```markdown
# Implementation Session: {Topic} - {Date}

## Objective
{What was the goal}

## Work Completed
- {Feature/fix/task 1}
- {Feature/fix/task 2}

## Technical Decisions
1. **{Decision}**: {What was decided}
   - Rationale: {Why}
   - Alternatives: {Other options considered}
   - Trade-offs: {What we're giving up}

## Code Changes
- Files modified: {list}
- Key changes: {summary}

## Challenges Encountered
- {Challenge}: {How resolved}

## Action Items
- [ ] {Next step 1}
- [ ] {Next step 2}

## Related Documents
- {Links to related files or sessions}

## Next Session
{What to tackle next}
```

### General Session

Use when session was planning, research, configuration, or discussion:

```markdown
# Session Log: {Topic} - {Date}

## Summary
{Brief overview of what happened}

## Decisions Made
1. {Decision 1}
   - Rationale: {Why}
2. {Decision 2}
   - Rationale: {Why}

## Discussion Points
- {Point 1}
- {Point 2}

## Action Items
- [ ] {Action 1}
- [ ] {Action 2}

## Related Documents
- {Links to related files or sessions}

## Next Steps
{What to do next}
```

## Confirmation Format

After saving, show user:

```
✅ Session log saved: {filename}

Key decisions: {count}
Action items: {count}
Related sessions: {count if any}
```

## Example Workflow

```
User: "save this session"
  ↓
Skill auto-invokes
  ↓
Analyzes conversation (debugging SessionEnd hook)
  ↓
Determines: General session
  ↓
Generates filename: 2025-12-28-sessionend-hook-debugging.md
  ↓
Saves to .claude/memory/session-logs/
  ↓
Confirms: ✅ Session log saved
```

## File Naming

Format: `YYYY-MM-DD-brief-topic-description.md`

Examples:
- `2025-12-28-sessionend-hook-debugging.md`
- `2025-12-18-project-deployment.md`
- `2025-12-15-api-refactor.md`

Use lowercase with dashes. Keep brief but descriptive (3-5 words max).

## Tools Usage

- **Read**: Check existing sessions for related content
- **Write**: Save session log file
- **Bash**: Get current date for filename
- **Grep**: Search for related sessions (optional)

## Key Principles

1. **Automatic** - No user input required, analyze conversation context
2. **Comprehensive** - Capture all important decisions and technical details
3. **Searchable** - Use consistent format and clear filenames
4. **Related** - Link to other relevant session logs when applicable
5. **Actionable** - Always include next steps/action items

---

Remember: Analyze the conversation thoroughly and create a complete record. The user should be able to understand what happened just by reading the log, even months later.
