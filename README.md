# harness-template

A Claude Code marketplace with one plugin, `harness`. The plugin bundles the
standard skills, subagents and hooks that every project uses. Claude Code loads
it from its plugin cache, so nothing is copied into a project's `.claude/`.

## Layout

- `.claude-plugin/marketplace.json`: the catalog. It lists the plugins in this repo.
- `plugins/harness/`: the plugin (manifest, skills, later agents and hooks).

Files that must live inside each project (`CLAUDE.md`, `docs/`, settings,
git hooks) and the managed settings for client machines come in later steps.

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
