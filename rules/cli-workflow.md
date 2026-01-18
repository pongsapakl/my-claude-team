# CLI-Based Workflow (No MCP Servers)

## Philosophy

This project uses **natural language instructions + CLI tools** instead of MCP servers to minimize context overhead while maintaining full functionality.

## Token Savings

**Before (with MCP servers):**
- Notion MCP: ~32.5k tokens per session
- GitHub MCP: ~15-20k tokens per session
- **Total overhead: ~50k tokens** (25% of 200k budget)

**After (CLI-based):**
- Zero token overhead
- All functionality via standard CLI tools
- Instructions in `.claude/rules/` and skills

## How It Works

### Git Operations
Instead of GitHub MCP server, use standard `git` and `gh` CLI:

```bash
# Create commits
git add . && git commit -m "message"

# Create PRs
gh pr create --title "..." --body "..."

# Check status
git status
git log --oneline -5
```

### Knowledge Management
Instead of Notion MCP server, use local markdown files:

```bash
# Save session log
echo "content" > .claude/memory/session-logs/2025-12-18-decision.md

# Search past decisions
grep -r "authentication" .claude/memory/

# Read past sessions
cat .claude/memory/session-logs/2025-12-17-*.md
```

### Benefits

1. **Zero Token Overhead**: MCP servers consume tokens just by existing
2. **More Transparent**: You see the actual commands being run
3. **Standard Tools**: No extra dependencies to maintain
4. **More Flexible**: Can chain any CLI commands
5. **Better Control**: Define patterns in rules/skills for consistency

### When You Might Want MCP

MCP servers make sense when:
- Complex API operations need type-safe structured responses
- Working in a team that standardizes on MCP tools
- Need real-time data from third-party services (Slack, Jira, etc.)

For a solo developer building MVPs, CLI is almost always better.

## Implementation

All git operations should:
1. Use standard `git` commands via Bash tool
2. Follow patterns in `.claude/rules/` if defined
3. Be transparent - user sees what commands are run
4. Use `gh` CLI for GitHub-specific operations when needed

All knowledge management should:
1. Save to `.claude/memory/` as markdown files
2. Use descriptive filenames with dates
3. Be searchable via grep/file tools
4. Follow templates defined in skills if applicable
