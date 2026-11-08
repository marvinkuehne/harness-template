#!/usr/bin/env bash
# PreToolUse hook on Bash: blocks a git commit by Claude unless the
# prepare-commit skill ran for exactly the staged content. The skill writes the
# staged tree hash to <git dir>/claude-commit-ready after the user approves; any
# later staging changes the hash and blocks again.
#
# Opt-in: does nothing unless the project has .claude/harness.json with
# "commitGate": true, so the plugin never interferes with projects that do not
# use this procedure.
#
# Claude writes the fingerprint itself, so this catches a forgotten procedure,
# not a deliberate bypass. Commits made outside Claude Code are not affected.
set -u

input=$(cat)

# True when any command in the line is `git commit`, also with git's global
# options in between (`git -c k=v commit`, `git -C dir commit`, `git --no-pager commit`).
is_commit=$(printf '%s' "$input" | python3 -c '
import json, re, shlex, sys

TAKES_VALUE = {"-c", "-C", "--git-dir", "--work-tree", "--namespace", "--exec-path", "--super-prefix", "--config-env"}

WRAPPERS = {"env", "sudo", "command", "time", "nohup", "exec", "nice"}

def is_git_commit(tokens):
    i = 0
    # skip VAR=value prefixes and wrappers so only the command itself counts
    while i < len(tokens) and (re.match(r"^\w+=", tokens[i]) or tokens[i] in WRAPPERS):
        i += 1
    if i >= len(tokens) or tokens[i].rsplit("/", 1)[-1] != "git":
        return False
    j = i + 1
    while j < len(tokens) and tokens[j].startswith("-"):
        j += 2 if tokens[j] in TAKES_VALUE else 1
    return j < len(tokens) and tokens[j] == "commit"

command = json.load(sys.stdin).get("tool_input", {}).get("command", "")
found = False
for part in re.split(r"[;&|\n()]+", command):
    try:
        tokens = shlex.split(part)
    except ValueError:
        tokens = part.split()
    if is_git_commit(tokens):
        found = True
print(found)
')
[ "$is_commit" = "True" ] || exit 0

project="${CLAUDE_PROJECT_DIR:-$PWD}"
config="$project/.claude/harness.json"
[ -f "$config" ] || exit 0
enabled=$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1])).get("commitGate") is True)' "$config" 2>/dev/null) || exit 0
[ "$enabled" = "True" ] || exit 0

cd "$project" || exit 0
marker="$(git rev-parse --git-dir)/claude-commit-ready"
staged=$(git write-tree 2>/dev/null) || exit 0

if [ ! -f "$marker" ] || [ "$(cat "$marker")" != "$staged" ]; then
  cat >&2 <<'EOF'
Commit blocked: the prepare-commit skill has not run for the staged changes.
Run /harness:prepare-commit (explanation with how to check it, approved message).
Its last step records the fingerprint that lets this commit through.
EOF
  exit 2
fi
