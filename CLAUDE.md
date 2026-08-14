# CLAUDE.md

## Project Overview

**pongsapakl-skills** is a Claude Code plugin marketplace. It currently ships one
plugin, **handover**, which solves the problem of ephemeral Claude Code sessions
by persisting context across them via a three-file architecture: TODO.md (human
scratchpad), WORK.md (AI context), and rich narrative session logs.

## Project Structure

```
pongsapakl-skills/
├── skills/          # 3 skills: init, start, end
├── .claude-plugin/  # marketplace.json (marketplace) + plugin.json (handover)
├── LICENSE
└── README.md
```

## Key Concepts

- **Three-file architecture**: TODO.md (human), WORK.md (AI), session logs (both)
- **Multi-track WORK.md**: Parallel workstreams don't clobber each other; `/handover:end` only updates the active track
- **TODO.md**: Append-only freeform scratchpad; Claude never deletes user content
- **Rich session logs**: Narrative "What Happened" stories, not just checkboxes
- **Session lifecycle**: `/handover:init` (once) → `/handover:start` → work → `/handover:end`
- **CLAUDE.md block**: `/handover:init` writes a sentinel-delimited Session Handover block into the target project's CLAUDE.md, so sessions that never run `/handover:start` still understand the file contract

## Development Notes

- Installed via `/plugin marketplace add pongsapakl/pongsapakl-skills` then `/plugin install handover`
- Skills are defined in `skills/<name>/SKILL.md` (uppercase filename — a lowercase `skill.md` will not load reliably)
- Marketplace name and plugin name are separate: the repo/marketplace is `pongsapakl-skills`, the plugin is `handover`, and the plugin name is what prefixes commands (`/handover:start`)
- Version is tracked in `.claude-plugin/plugin.json`
- The README has a hand-written intro section above `## Quick Install` that should not be edited by Claude

## Decisions

- **v1.0.0 — removed agents, rules, and 5 skills.** Two months of session logs showed zero invocations of all 8 C-suite/review agents and of `/c-suite-meeting`, `/research`, `/plan`, `/deployment-checker`, `/infra-checker`. Native plan mode and the built-in Plan/Explore agents cover the planning and research cases. Kept only what usage data supported: init, start, end.
- **Rules directory deleted.** Rules were never a plugin capability — `/init` hand-copied them into `.claude/rules/` with a "native support expected" deprecation header that never landed. Replaced with a generated CLAUDE.md block owned by the init skill, which has no version-drift problem.
- **Repo is a marketplace, not a single plugin.** Lets future skills ship as sibling plugins with short invocation prefixes instead of one long namespace.
