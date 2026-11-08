# harness-template

A Claude Code marketplace with one plugin, `harness`. The plugin bundles the
standard skills, subagents and hooks that every project uses. Claude Code loads
it from its plugin cache, so nothing is copied into a project's `.claude/`.

## Layout

- `.claude-plugin/marketplace.json`: the catalog. It lists the plugins in this repo.
- `plugins/harness/`: the plugin.
  - `skills/prepare-commit`: explanation, how to check it, approved message, then the commit.
  - `skills/plan-slices`: plan work as slices and steps before any code.
  - `skills/ping`: test skill, proves the plugin is loaded.
  - `hooks/hooks.json` and `scripts/commit-gate.sh`: block `git commit` until
    `prepare-commit` ran for exactly the staged changes.

Files that must live inside each project (`CLAUDE.md`, `docs/`, settings,
git hooks) and the managed settings for client machines come in later steps.

## Commit gate (opt-in)

The gate does nothing by default. A project turns it on with
`.claude/harness.json`:

```json
{ "commitGate": true }
```

It catches a forgotten procedure, not a deliberate bypass: Claude writes the
fingerprint itself. Commits made outside Claude Code are not affected.

## Install

```bash
claude plugin marketplace add <path to this repo or owner/repo>
claude plugin install harness@redeploy-harness
```

Check it with `/harness:ping` in a new session.

## Check changes

```bash
claude plugin validate .
claude plugin validate ./plugins/harness
```
