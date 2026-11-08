---
name: prepare-commit
description: Run before every git commit in a project that uses the harness commit gate. Updates the architecture doc if there is one, explains the change and how to check it by hand, and gets the commit message approved.
---

# Prepare a commit

The user approves every commit after seeing three things: the architecture doc
brought up to date (when the project has one), a plain-language explanation
they can verify by hand, and the message. When the project turned the commit
gate on (`.claude/harness.json` with `"commitGate": true`), a hook blocks
`git commit` until step 5 has recorded the fingerprint of the staged changes.

Read the project's `CLAUDE.md` first. It names the commands, the docs and the
commit rules that the steps below refer to.

## 1. Update the architecture doc

Skip this step when the project has no `ARCHITECTURE.md`.

Otherwise bring it up to date for this change. Use the `update-architecture`
skill when it is available, and follow the heading style the doc already uses.

Done when the sections you changed are shown to the user, even if the answer
is that nothing changed.

## 2. Stage exactly this change

Stage the files of this commit by path, `ARCHITECTURE.md` included when step 1
changed it. Done when `git diff --cached --stat` lists those files and nothing
else.

## 3. Explain what was done and how to check it

Write two sections for a teammate who has not seen the code. Plain language,
short sentences; a needed technical term gets one explanation in brackets.

**What I did**: a few bullets, one per change the user would notice or rely on.

**How to check it yourself**: numbered steps. Every step names one action
and the result the user should see. Pick the method that shows the behavior
most directly. The project's verification doc (usually `docs/verifying.md`)
and `CLAUDE.md` name the commands to use.

| Change | Check |
|---|---|
| Something visible | The command that starts the project, what to click or call, what appears |
| Stored data | Where the data lives and how to read it, or one command that prints it |
| Logic covered by tests | The test command and the test names to look for, plus one edit that turns a named test red, so the user sees the test can fail |
| Tooling, hooks, scripts | A command that triggers it and the output to expect, for both the pass and the block case |
| Docs only | Which file and section to read, and what it should now say |

Run every command you list here yourself first and take the expected result
from its real output. A command that was never run does not go in the list.

Done when every changed behavior has at least one step, and each step has an
expected result the user can compare against.

## 4. Draft the message

Follow the project's commit rules (usually `docs/repo-conventions.md`, else
`CLAUDE.md`). Write the draft to a temporary file outside the repo. When the
project has a `commit-msg` git hook, run it on the draft until it passes.
Show the message to the user and wait for approval. A requested change to the
message or the files means going back to the step it affects.

## 5. Record the fingerprint and commit

Only after the user approved, as two separate commands. The gate checks before
a command starts, so one command that records the fingerprint and then commits
is blocked.

```bash
git write-tree > "$(git rev-parse --git-dir)/claude-commit-ready"
```

```bash
git commit -F <approved message file>
```

Stage nothing in between. If anything is staged after this point, the
fingerprint no longer matches and the gate blocks again: return to step 3 for
the new state.
