# CLAUDE.md

## What This Repo Is

**pongsapakl-skills** is a Claude Code plugin marketplace holding the skills the
owner actively uses. It is a live backup of a working setup, not a product —
skills get added when they earn their place and removed when usage data says
they didn't. Expect churn in `<plugin>/`, not in the repo's shape.

## Structure

```
pongsapakl-skills/
├── .claude-plugin/marketplace.json   # lists every plugin
└── <plugin>/
    ├── .claude-plugin/plugin.json    # own name, version, skills allowlist
    ├── README.md                     # that plugin's docs
    └── skills/<skill>/SKILL.md
```

One repo, one marketplace, N plugins. Each plugin versions and installs
independently.

## Conventions

- Skills live at `<plugin>/skills/<name>/SKILL.md` — **uppercase** filename; a lowercase `skill.md` will not load reliably
- Each `plugin.json` carries an explicit `skills` allowlist. A skill directory not listed does not ship — use it to stage work-in-progress skills on `main`
- Skill names must be unique **within** a plugin, not across the repo, so two plugins may each define an `end`
- The marketplace name, plugin name, and skill name are three separate things. The **plugin** name is what prefixes commands (`/handover:start`)
- Validate before pushing: `claude plugin validate .`
- `claude plugin update` needs the fully-qualified id (`handover@pongsapakl-skills`), not the bare plugin name
- Bump the version in the plugin's own `plugin.json` when its skills change; other plugins are unaffected

## Docs Ownership

Keep skill-specific content out of repo-level docs so routine skill changes
don't ripple:

| File | Scope | Changes when |
|------|-------|--------------|
| `README.md` | Repo, install, conventions | Layout or workflow changes — rarely |
| `CLAUDE.md` | Conventions and decisions | A structural decision is made |
| `<plugin>/README.md` | That plugin's skills and workflow | That plugin changes |
| `<plugin>/.claude-plugin/plugin.json` | Plugin identity and allowlist | Skills are added or removed |

Rule: **nothing outside a plugin's directory names its skills.** The root README
lists plugins, never skills. Adding, renaming, or deleting a skill must be a
one-directory change.

`README.md` has a hand-written intro above `## What This Is` that must not be
edited by Claude.

## Decisions

- **v1.0.0 — removed agents, rules, and 5 skills.** Two months of session logs showed zero invocations of all 8 C-suite/review agents and of `c-suite-meeting`, `research`, `plan`, `deployment-checker`, `infra-checker`. Native plan mode and the built-in Plan/Explore agents cover the planning and research cases. Kept only what usage data supported.
- **Rules directory deleted.** Rules were never a plugin capability — `init` hand-copied them into `.claude/rules/` behind a "native support expected" deprecation header that never landed. Replaced with a generated CLAUDE.md block owned by the init skill, which has no version-drift problem.
- **Marketplace of sibling plugins, not one plugin.** Considered the single-plugin layout (mattpocock/skills uses it: one plugin at `./`, group folders under `skills/`, explicit allowlist). Rejected because a single plugin means one flat skill namespace — every skill name unique repo-wide, forcing long compound names and blocking a second `end`-style skill. Sibling plugins give short prefixes, independent versions, and atomic per-group installs, at the cost of one `plugin.json` per group.
- **Adopted the `skills` allowlist from mattpocock/skills.** Lets unfinished skills live in the repo without shipping.
- **Docs split by ownership.** Repo-level docs describe the system; plugin-level docs describe contents. Avoids re-editing the root README on every skill change.
