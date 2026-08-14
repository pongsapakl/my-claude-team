#!/usr/bin/env bash
# Fails if a plugin's files changed without its version being bumped.
# Runs at push time, not commit time: a version maps to a group of commits.
set -uo pipefail

BASE="${1:-}"
if [ -z "$BASE" ]; then
  BASE=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || echo "")
fi
if [ -z "$BASE" ] || ! git rev-parse --verify -q "$BASE" >/dev/null; then
  echo "check-version-bump: no upstream to compare against — skipping."
  exit 0
fi

SEMVER='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'
fail=0

ver_at() { # ver_at <ref> <path>  -> version or empty
  git show "$1:$2" 2>/dev/null | python3 -c \
    'import json,sys;print(json.load(sys.stdin).get("version",""))' 2>/dev/null || true
}

while IFS= read -r manifest; do
  dir=$(dirname "$(dirname "$manifest")")
  plugin=$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["name"])' "$manifest")

  changed=$(git diff --name-only "$BASE"..HEAD -- "$dir/" | grep -v '/README\.md$' || true)
  [ -z "$changed" ] && continue

  new=$(ver_at HEAD "$manifest")
  old=$(ver_at "$BASE" "$manifest")

  if ! [[ "$new" =~ $SEMVER ]]; then
    echo "✘ $plugin: version '$new' is not valid semver (MAJOR.MINOR.PATCH)."
    fail=1; continue
  fi

  if [ -z "$old" ]; then
    echo "✔ $plugin: new plugin at $new"
    continue
  fi

  if [ "$old" = "$new" ]; then
    echo "✘ $plugin: files changed but version is still $old."
    echo "  Changed:"; echo "$changed" | sed 's/^/    /'
    echo "  Decide the bump yourself, then edit $manifest:"
    echo "    PATCH — fix or wording, no behaviour change for the user"
    echo "    MINOR — new skill, or new behaviour in an existing one"
    echo "    MAJOR — renamed/removed a skill, or changed a file contract"
    fail=1; continue
  fi

  # Reject downgrades
  if [ "$(printf '%s\n%s\n' "$old" "$new" | sort -t. -k1,1n -k2,2n -k3,3n | head -1)" = "$new" ]; then
    echo "✘ $plugin: version went backwards ($old → $new)."
    fail=1; continue
  fi

  echo "✔ $plugin: $old → $new"
done < <(find . -path ./.git -prune -o -name plugin.json -path '*/.claude-plugin/*' -print)

if [ "$fail" -ne 0 ]; then
  echo
  echo "Push blocked. Bump the version deliberately — do not auto-bump."
  exit 1
fi
exit 0
