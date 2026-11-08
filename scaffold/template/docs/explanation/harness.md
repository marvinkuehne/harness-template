# The harness

The harness is the set of files and plugin parts that keep Claude's work in
this project reviewable and safe. Each part exists to remove one specific risk.

## Why not just write rules in CLAUDE.md

`CLAUDE.md` is guidance. Claude usually follows it, but nothing makes it. A rule
that must hold every time needs something that runs every time: a hook, a deny
rule, or a managed setting. `CLAUDE.md` keeps the short list of what Claude
cannot read from the code, and points to the docs.

## The parts

| Part | Risk it removes |
|---|---|
| `CLAUDE.md` workflow (state, list files, wait for approval) | Large changes nobody agreed to |
| `/harness:plan-slices` | Plans that rest on wrong assumptions about the code |
| `/harness:prepare-commit` and the commit gate | Commits the user has not understood or checked |
| `.githooks/commit-msg` | Commit messages that break the repo's conventions, from people and from Claude |
| `ask` for `git commit` and `git push` | Unreviewed history or pushes |
| `deny` for `.env` files and `secrets/` | Secrets entering Claude's context and the local transcript |
| `deny` for editing `.claude/settings.json`, `.claude/harness.json`, `.githooks/` | Claude loosening its own guardrails |
| Diátaxis docs | Docs that mix teaching, recipes, lookups and rationale and so serve none of them |

## What the guardrails do not do

- The commit gate catches a forgotten procedure, not a deliberate bypass:
  Claude writes the fingerprint itself.
- Hooks fail open: if a hook crashes or times out, the action usually goes ahead.
  Checks that matter also run in CI.
- A deny rule on reading a file stops Claude's file tools and common shell
  commands, not a script that opens the file itself. Keep real secrets out of
  the working folder.
- Settings in this repository can be edited by anyone with write access.
  Controls that must hold against the user belong in managed settings.
