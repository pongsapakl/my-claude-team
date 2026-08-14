---
name: ship-this-skill
description: Port a skill or workflow that proved useful in this session into the pongsapakl-skills marketplace, or modify an existing published skill — then ship it and install it back. Handles placement, sanitization, versioning, and release. Auto-invokes on "ship this skill", "add this to my plugins", "publish this skill", "make this a real skill", "update my plugin".
allowed-tools: [Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion]
---

# Ship This Skill

Takes something that worked *here* — in the current working repo — and lands it
in the `pongsapakl-skills` marketplace as a published plugin skill.

**Separation of concerns is the whole point.** The work happens in the
marketplace repo, never in the working repo. The working repo only ever
*installs* the result. Do not copy skill files into the current project.

## Step 1: Confirm what we're shipping

Never guess. Ask, and quote back what you think it is:

- **Which skill or workflow?** If it emerged from this conversation, summarize it
  in two or three sentences and get confirmation that's the right thing.
- **New skill, or a change to an existing one?** If a published skill already
  covers this ground, say so — modifying is usually better than adding a
  near-duplicate.

If the answer is "a change", identify the exact published skill and read it
before proposing edits.

## Step 2: Confirm placement (new skills only)

Ask for the skill `name` and which plugin it belongs to. List what exists first,
so the choice is informed:

```bash
ls -d "$REPO"/*/ | grep -v '^\.'
```

Current groups and their membership rules:

| Plugin | Holds |
|--------|-------|
| `handover` | Skills that read/write the project file contract — `WORK.md`, `TODO.md`, `docs/sessions/` |
| `session` | Skills that operate on the conversation rather than project files |
| `utils` | Maintainer tools for this marketplace itself |

If it fits none of them, propose a new plugin and its membership rule — a group
with no rule becomes a junk drawer. Creating one means a new directory, its own
`plugin.json` starting at `0.1.0`, a `README.md`, and one entry in
`marketplace.json`.

Skill names must be unique within a plugin, not across the repo.

## Step 3: Sanitize before porting

This repo is public. The ported content must work on a machine that isn't this
one. Rewrite, don't copy:

- **No absolute personal paths.** A `/Users/<name>/...` string anywhere is a bug.
  A previously published skill shipped a hardcoded project path and it went
  unnoticed for months.
- **No project-specific names** — repos, tickets, datasets, hostnames, internal
  URLs — unless they're clearly generic examples.
- **No incident history.** "This caught our currency bug in the Q3 model" is
  meaningless to anyone else; state the class of problem instead.
- **No secrets, credentials, tokens, or personal data.** Never inline a config
  value read from an environment file; refer to the variable name only.
- **No dependencies on local files** outside the target project — no shelling out
  to scripts that live in another repo.

Then check the result:

```bash
grep -rIn "/Users/\|/Volumes/\|192\.168\|localhost:[0-9]" "$REPO/<plugin>/skills/<name>/"
```

Filename must be `SKILL.md`, uppercase — a lowercase `skill.md` will not load
reliably. Frontmatter needs `name`, `description`, and `allowed-tools`. Write the
`description` with the phrases the user actually says, so it auto-invokes.

## Step 4: Update that plugin's docs

Per this repo's docs-ownership rule, **nothing outside a plugin's directory names
its skills**:

- Update `<plugin>/README.md` — the skills table and any workflow that changed
- Update the root `README.md` **only** when adding a whole new plugin (one row in
  the Plugins table)
- Do not touch the root `README.md` or `CLAUDE.md` for an ordinary skill change
- Add a `## Decisions` entry in root `CLAUDE.md` only for a structural choice,
  such as creating a new plugin or changing a membership rule

## Step 5: Allowlist and version

Add the skill directory to that plugin's `skills` array in `plugin.json` —
unlisted skills do not ship.

Then set the version. Pick it yourself, but **say which and why** — never bump
silently, and never bury it in a commit message the user won't read:

| Bump | When | Who decides |
|------|------|-------------|
| PATCH | Fix or wording; no behaviour change | You. State it and proceed. |
| MINOR | New skill, or new behaviour in an existing one | You. State it and proceed. |
| MAJOR | Renamed or removed a skill, or changed a file contract | **Stop and confirm with the user.** |

MAJOR is the one that breaks someone's install or invalidates files already on
disk, so it is the only bump worth interrupting for. Stopping on every PATCH just
trains the user to say "yes" without reading.

A new plugin starts at `0.1.0`. A push without a bump is blocked by
`scripts/check-version-bump.sh`, so this step is not optional.

## Step 6: Ship

```bash
cd "$REPO"
claude plugin validate .                 # must pass
git add -A && git commit && git push     # gate runs on push
```

Write the commit message about *why* the skill exists, not just that it was
added.

## Step 7: Install back into the working repo

```bash
claude plugin marketplace update pongsapakl-skills
claude plugin install <plugin>@pongsapakl-skills   # or `update` if already installed
```

`update` requires the fully-qualified `<plugin>@pongsapakl-skills` id; the bare
name fails.

Then tell the user to **restart the session** — the running session keeps the old
copy, so the new skill will not be available until then.

## Finding the marketplace repo

Resolve `$REPO` before doing anything else. Try the conventional checkout
location, and confirm the remote is correct before writing to it:

```bash
REPO=~/Documents/Projects/pongsapakl-skills
git -C "$REPO" remote get-url origin      # expect .../pongsapakl-skills
```

If that path doesn't exist or the remote is wrong, ask the user where the
marketplace repo is checked out. Never write into a repo you haven't confirmed.

## Do not

- Copy the skill into the current working repo — it installs from the marketplace
- Bump the version without saying which and why, or ship a MAJOR without confirming
- Ship content that names a real path, host, or dataset from this machine
- Add a skill to a plugin whose membership rule it doesn't fit, because it's
  convenient
