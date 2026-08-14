# utils

Maintainer tools for this marketplace itself. Membership rule: **skills only the
repo owner uses, to work on this repo.** Everything else belongs in a plugin
named for what it does.

```bash
/plugin install utils@pongsapakl-skills
```

## Skills

| Command | What it does |
|---------|--------------|
| `/utils:ship-this-skill` | Ports a skill or workflow that proved useful in a working session into a published plugin here — placement, sanitization, versioning, release, then installs it back. |

## Why it's a separate plugin

These have no value to anyone who isn't maintaining this repo, so they shouldn't
be bundled with skills that do. Keeping them apart means installing `handover` or
`session` never drags maintainer tooling along.

`utils` earns its vague name by having a real membership rule. Without one, a
"utils" group becomes the drawer everything falls into, and installing it means
taking a pile of unrelated things at once — the exact problem separate plugins
exist to avoid.

## Separation of concerns

`ship-this-skill` runs *from* whatever repo you're working in, but does all its
work *in* this repo, then installs the result back. Skill files never get copied
into the working project — that project only ever consumes the published plugin.
