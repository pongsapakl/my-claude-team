# CLAUDE.md

## What This Repo Is

**pongsapakl-skills** is a Claude Code plugin marketplace holding the skills the
owner actively uses — a living record of a working setup. It grows and gets
pruned over time: skills are added when they earn their place and removed when
usage data says they stopped being used. Expect churn inside `<plugin>/`, not in
the repo's shape.

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
- Bump the version in the plugin's own `plugin.json` when its files change; other plugins are unaffected

## Versioning

Strict semver per plugin, enforced at push time by `.githooks/pre-push` →
`scripts/check-version-bump.sh`. If any file under `<plugin>/` changed since the
upstream ref and that plugin's `version` did not, the push is **blocked**.
Downgrades and non-semver strings are rejected too.

| Bump | When |
|------|------|
| PATCH | Fix or wording; no behaviour change for the user |
| MINOR | New skill, or new behaviour in an existing one |
| MAJOR | Renamed or removed a skill, or changed a file contract (`WORK.md`, `TODO.md`, session-log format) |

**The gate never bumps for you.** It fails and tells you the options; choosing
the number is a deliberate decision. A version maps to a *group* of commits, not
to each commit — which is why the check runs on push, not on commit.

`<plugin>/README.md` is excluded from the check: doc-only edits don't need a
version. Changes outside any plugin directory (root README, CLAUDE.md, scripts)
need no bump at all.

Enable the hook once per clone:

```bash
git config core.hooksPath .githooks
```

## Working on Skills

- **The dogfooding loop is not live.** The installed plugin is a clone of the GitHub repo, so editing files here changes nothing in a running session until: push → `claude plugin marketplace update pongsapakl-skills` → `claude plugin update <plugin>@pongsapakl-skills` → restart the session
- **Editing manifests programmatically: always `ensure_ascii=False`.** Python's `json.dumps` defaults to escaping non-ASCII, which silently turns every em-dash into `—`. It still validates and still looks broken
- **Verify plugin mechanics before designing around them.** Scaffold the layout in a scratch directory and run `claude plugin validate` on it. Cheaper than reversing a structural decision after the fact
- **Never duplicate metadata across manifests.** `marketplace.json` entries stay `name` + `source`; description and keywords live in `plugin.json` only
- **Hand-written sections: fix mechanics, never voice.** Spelling, capitalization, and punctuation may be corrected silently. Grammar, wording, and phrasing get flagged for the owner, not changed

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

## Maintenance Notes

If `.claude/MAINTAINING.md` exists, read it — it holds the owner's maintenance
workflow (how to add skills and plugins, which docs to update, how to decide
what's worth keeping). It is gitignored and machine-local, so it won't be
present in a fresh clone; nothing in this file depends on it.

## Decisions

- **v1.0.0 — removed agents, rules, and 5 skills.** Two months of session logs showed zero invocations of all 8 C-suite/review agents and of `c-suite-meeting`, `research`, `plan`, `deployment-checker`, `infra-checker`. Native plan mode and the built-in Plan/Explore agents cover the planning and research cases. Kept only what usage data supported.
- **Rules directory deleted.** Rules were never a plugin capability — `init` hand-copied them into `.claude/rules/` behind a "native support expected" deprecation header that never landed. Replaced with a generated CLAUDE.md block owned by the init skill, which has no version-drift problem.
- **Marketplace of sibling plugins, not one plugin.** Considered the single-plugin layout (mattpocock/skills uses it: one plugin at `./`, group folders under `skills/`, explicit allowlist). Rejected because a single plugin means one flat skill namespace — every skill name unique repo-wide, forcing long compound names and blocking a second `end`-style skill. Sibling plugins give short prefixes, independent versions, and atomic per-group installs, at the cost of one `plugin.json` per group.
- **Adopted the `skills` allowlist from mattpocock/skills.** Lets unfinished skills live in the repo without shipping.
- **Docs split by ownership.** Repo-level docs describe the system; plugin-level docs describe contents. Avoids re-editing the root README on every skill change.
