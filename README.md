# pongsapakl-skills

[Claude when you update readme please dont edit this part. This is handwritten (or handtyped) and I wanted to keep it as is. Below ## Quick Install you can do whatever you are born to do.]

It appears to me that there are so many productivity frameworks out there trying to utilize the function of agents, skills, etc. as provided by Claude. Yet I find many of them are more generic and load everything up front (which I find somewhat annoying) and not tailored to my own needs. So, I created a custom one based on those frameworks out there and made it fit my requirements a little more. It is very basic yet so powerful for my workflow.

This repo serves as my archive/backup for my workflow (integrated with Claude Code, obviously), yet I try to make it more generic by moving project-specific information to the `CLAUDE.md` file and letting agents read from there to make this tool more reusable for other projects. If you find this interesting, please feel free to test it out, fork it—comments are appreciated, yet I can't confirm I'll fix issues since it is my workflow for my needs after all. Also feel free to basically fetch this to Claude and let it generate your own version of this. Well, maybe fetching some other repo might provide more polished ideas, but whatever.

[UPDATE v.0.5.0] I also feels like handing over session for me is really important. Despite there are things like `/compact` it is still not as good as i think it can be. That is why I use a file-based system to hand over session. This way, not only agent, but also us humans can catch up on what is left, what to do next more easily. Key is what is just done, and what to do next (along with related file).

## What This Is

My working Claude Code setup, published as a plugin marketplace. These are the
skills I actually use and maintain — not a polished framework, and not trying to
be one. Things get added when they earn their place and deleted when the usage
data says they never did.

Treat it as a live backup of my own setup that happens to be installable. Fork
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
