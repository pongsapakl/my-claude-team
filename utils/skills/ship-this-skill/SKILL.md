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

The marketplace repo's `CLAUDE.md` is the authority on conventions, versioning,
docs ownership, and plugin membership. Read it once `$REPO` is resolved and
follow it — this skill does not restate its rules.

## Step 0: Resolve the marketplace repo

Before anything else. Confirm the remote before writing to it:

```bash
REPO=~/Documents/Projects/pongsapakl-skills
git -C "$REPO" remote get-url origin      # expect .../pongsapakl-skills
cat "$REPO/CLAUDE.md"
```

If that path doesn't exist or the remote is wrong, ask where the marketplace repo
is checked out. Never write into a repo you haven't confirmed.

## Step 1: Confirm what and where, in one round

Never guess. Ask once, with everything you need, quoting back what you think it
is. If it emerged from this conversation, summarize it in two or three sentences
so the confirmation is meaningful.

- **New skill, or a change to an existing one?** If a published skill already
  covers this ground, say so — modifying beats adding a near-duplicate. For a
  change, identify the exact published skill and read it before proposing edits.
- **For a new skill: its `name` and plugin.** List what exists first so the
  choice is informed, and apply the membership rules in `CLAUDE.md`:

```bash
ls -d "$REPO"/*/ | grep -v '^\.'
```

If it fits no existing plugin, propose a new one *and its membership rule* — a
group with no rule becomes a junk drawer.

## Step 2: Sanitize before porting

This repo is public. The ported content must work on a machine that isn't this
one. Rewrite, don't copy:

- **No absolute personal paths.** A `/Users/<name>/...` string anywhere is a bug.
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

Filename must be `SKILL.md`, uppercase. Frontmatter needs `name`, `description`,
and `allowed-tools`. Write the `description` with the phrases the user actually
says, so it auto-invokes.

## Step 3: Allowlist, docs, version

- Add the skill directory to that plugin's `skills` array in `plugin.json` —
  unlisted skills do not ship.
- Update `<plugin>/README.md`. Follow the docs-ownership table in `CLAUDE.md` for
  anything above the plugin directory; for an ordinary skill change, nothing
  above it should be touched.
- Bump the version per the table in `CLAUDE.md`. **Say which bump and why** —
  never bump silently, never bury it in a commit message. PATCH and MINOR are
  yours to call; **stop and confirm a MAJOR**, since it is the one that breaks an
  install or invalidates files already on disk. Stopping on every PATCH just
  trains the user to say "yes" without reading.

## Step 4: Ship

```bash
cd "$REPO"
claude plugin validate .                 # must pass
git add -A && git commit && git push     # version gate runs on push
```

Write the commit message about *why* the skill exists, not just that it was
added.

## Step 5: Install back into the working repo

```bash
claude plugin marketplace update pongsapakl-skills
claude plugin install <plugin>@pongsapakl-skills   # or `update` if already installed
```

`update` requires the fully-qualified `<plugin>@pongsapakl-skills` id; the bare
name fails.

Then tell the user to **restart the session** — the running session keeps the old
copy, so the new skill will not be available until then.

## Do not

- Copy the skill into the current working repo — it installs from the marketplace
- Bump the version without saying which and why, or ship a MAJOR without confirming
- Ship content that names a real path, host, or dataset from this machine
- Add a skill to a plugin whose membership rule it doesn't fit, because it's
  convenient
