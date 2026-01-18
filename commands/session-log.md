Save detailed session log based on conversation context.

Use the session-log skill to automatically create comprehensive session logs:

**The skill will**:
1. Analyze full conversation history automatically
2. Determine type (Implementation session or General session)
3. Extract key info (summary, decisions, technical details, challenges, action items)
4. Generate filename: `YYYY-MM-DD-brief-topic.md`
5. Save to `.claude/memory/session-logs/`
6. Confirm with summary

**No menus, no questions** - fully automatic based on context.

**Output**: `.claude/memory/session-logs/YYYY-MM-DD-{topic}.md`

**Log includes**:
- Implementation session: Objective, work completed, technical decisions, code changes, challenges, action items
- General session: Summary, decisions made, discussion points, action items

**Confirmation**:
```
✅ Session log saved: {filename}

Key decisions: {count}
Action items: {count}
Related sessions: {count if any}
```

**Note**: Creates detailed, searchable records so you can understand what happened months later.
