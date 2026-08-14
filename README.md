# pongsapakl-skills

<!-- [Claude when you update readme please dont edit this part. This is handwritten (or handtyped) and I wanted to keep it as is. Below ## Quick Install you can do whatever you are born to do.] -->

Everyone is having their own marketplace and plugins, so let me have one.

This repo serves as my mirror/backup of skills I used as I continuously working with coding agent.

Since AI itself is continuously changing and getting more intelligence in a very fast pace, most of the skills will likely stale over a very short period of time. So, will try to maintain and actively update it to make it lean, relevant, and up-to-date.

<!-- end of handwritten section -->

## What This Is

A living record of how I work with Claude Code, published as a plugin
marketplace. These are the skills I actually use and maintain.

It grows and gets pruned over time. Skills get added when they earn their place
and removed when they stop being used — v1.0.0 dropped eight agents and five
skills that two months of session logs showed I never invoked once.

Treat it as a live mirror of my own setup that happens to be installable. Fork
it, copy a skill out of it, or point Claude at it and generate your own.

## Quick Install

```bash
/plugin marketplace add pongsapakl/pongsapakl-skills
/plugin install <plugin>@pongsapakl-skills
```

Each plugin installs on its own. Browse them below or run `/plugin` to see
what's available.

## Plugins

| Plugin | What it's for |
|--------|---------------|
| [`handover`](handover/) | File-based session handover — carry context across Claude Code sessions |

Each plugin's own README has its skills, workflow, and design notes.

## Repo Layout

```text
pongsapakl-skills/
├── .claude-plugin/marketplace.json   ← lists every plugin
└── <plugin>/                         ← one directory per plugin
    ├── .claude-plugin/plugin.json    ← own name, version, skills allowlist
    ├── README.md                     ← that plugin's docs
    └── skills/<skill>/SKILL.md
```

One repo, one marketplace, N plugins. Plugins version and install
independently, so adding or changing one never touches another.

## Adding a Plugin

1. `mkdir -p <plugin>/.claude-plugin <plugin>/skills/<skill>`
2. Write `<plugin>/.claude-plugin/plugin.json` — its own `name`, `version`, and
   a `skills` array listing the skill directories that should ship
3. Add one entry to `.claude-plugin/marketplace.json`:
   `{ "name": "<plugin>", "source": "./<plugin>" }`
4. `claude plugin validate .`

A skill directory that isn't in the `skills` allowlist doesn't ship — so
unfinished skills can live on `main` without reaching anyone.

Skill names only need to be unique *within* a plugin, so two plugins can both
define a skill called `end`.

## Docs

Kept deliberately split so docs don't need touching every time a skill changes:

| File | Scope | Changes when |
|------|-------|--------------|
| This README | The repo and its conventions | Layout or workflow changes — rarely |
| `CLAUDE.md` | Conventions and decisions for working in this repo | A structural decision is made |
| `<plugin>/README.md` | That plugin's skills and workflow | That plugin changes |
| `<plugin>/.claude-plugin/plugin.json` | That plugin's identity and allowlist | Skills are added or removed |

Nothing outside a plugin's own directory names its skills, so adding, renaming,
or deleting a skill is a one-directory change.

## License

MIT — see [LICENSE](LICENSE).
