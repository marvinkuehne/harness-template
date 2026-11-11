#!/usr/bin/env bash
# SessionStart hook: points git at the project's committed hooks folder, so the
# commit-msg check in .githooks/ runs without a manual setup step.
#
# Git reads hooks from .git/hooks, which is never shared, so a project keeps its
# hooks in .githooks/ and each clone has to set core.hooksPath once. This does it
# when Claude Code opens the project.
#
# Does nothing unless the project has .githooks/commit-msg, is a git repo, and has
# no core.hooksPath yet, so it never overrides a path someone chose themselves.
set -u

dir="${CLAUDE_PROJECT_DIR:-$PWD}"

[ -f "$dir/.githooks/commit-msg" ] || exit 0
git -C "$dir" rev-parse --git-dir >/dev/null 2>&1 || exit 0
[ -z "$(git -C "$dir" config --local --get core.hooksPath)" ] || exit 0

git -C "$dir" config --local core.hooksPath .githooks
