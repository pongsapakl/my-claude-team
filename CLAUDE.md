# CLAUDE.md

## Project Overview

**pongsapakl-skills** is a Claude Code plugin marketplace. It currently ships one
plugin, **handover**, which solves the problem of ephemeral Claude Code sessions
by persisting context across them via a three-file architecture: TODO.md (human
scratchpad), WORK.md (AI context), and rich narrative session logs.

## Project Structure

```
pongsapakl-skills/
├── .claude-plugin/
│   └── marketplace.json          # marketplace: lists every plugin
├── handover/                     # plugin: handover
│   ├── .claude-plugin/plugin.json
│   └── skills/{init,start,end}/SKILL.md
├── LICENSE
└── README.md
```

One repo, one marketplace, N plugins. Each plugin is a top-level directory with
its own `.claude-plugin/plugin.json` and `skills/`, and gets its own entry in
`marketplace.json`. Plugins version and install independently.

## Key Concepts

- **Three-file architecture**: TODO.md (human), WORK.md (AI), session logs (both)
- **Multi-track WORK.md**: Parallel workstreams don't clobber each other; `/handover:end` only updates the active track
- **TODO.md**: Append-only freeform scratchpad; Claude never deletes user content
- **Rich session logs**: Narrative "What Happened" stories, not just checkboxes
- **Session lifecycle**: `/handover:init` (once) → `/handover:start` → work → `/handover:end`
- **CLAUDE.md block**: `/handover:init` writes a sentinel-delimited Session Handover block into the target project's CLAUDE.md, so sessions that never run `/handover:start` still understand the file contract

## Development Notes

- Installed via `/plugin marketplace add pongsapakl/pongsapakl-skills` then `/plugin install handover`
- Skills are defined in `<plugin>/skills/<name>/SKILL.md` (uppercase filename — a lowercase `skill.md` will not load reliably)
- Each `plugin.json` carries an explicit `skills` allowlist. A skill directory that is not listed does not ship — use this to stage work-in-progress skills in the open
- Skill names only need to be unique **within** a plugin, so `handover:end` and a future `x:end` can coexist
- Validate before pushing: `claude plugin validate .`
- Marketplace name and plugin name are separate: the repo/marketplace is `pongsapakl-skills`, the plugin is `handover`, and the plugin name is what prefixes commands (`/handover:start`)
- Version is tracked in `.claude-plugin/plugin.json`
- The README has a hand-written intro section above `## Quick Install` that should not be edited by Claude

## Decisions

- **v1.0.0 — removed agents, rules, and 5 skills.** Two months of session logs showed zero invocations of all 8 C-suite/review agents and of `/c-suite-meeting`, `/research`, `/plan`, `/deployment-checker`, `/infra-checker`. Native plan mode and the built-in Plan/Explore agents cover the planning and research cases. Kept only what usage data supported: init, start, end.
- **Rules directory deleted.** Rules were never a plugin capability — `/init` hand-copied them into `.claude/rules/` with a "native support expected" deprecation header that never landed. Replaced with a generated CLAUDE.md block owned by the init skill, which has no version-drift problem.
- **Repo is a marketplace of sibling plugins, not one plugin.** Considered the single-plugin layout (mattpocock/skills uses it: one plugin at `./`, group folders under `skills/`, explicit `skills` allowlist). Rejected because a single plugin means one flat skill namespace — every skill name must be unique repo-wide, which forces long compound names and blocks a future `end`-style skill from coexisting with `handover:end`. Sibling plugins give short prefixes (`/handover:end`), independent versions, and atomic per-group installs, at the cost of one `plugin.json` per group.
- **Adopted the `skills` allowlist from mattpocock/skills.** Lets unfinished skills live in the repo without shipping.
