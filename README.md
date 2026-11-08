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

- `copier.yml` and `scaffold/template/`: the project files that must live in
  each repo, generated with copier (see "New project"). They are `CLAUDE.md`,
  `docs/` in the four Diátaxis folders, `.claude/settings.json`,
  `.claude/harness.json`, `.githooks/commit-msg`, `.gitignore`, a pull request
  template and CODEOWNERS.

Managed settings for client machines come in a later step.

## New project

Run in the project folder (needs `uv`; copier is fetched on demand):

```bash
uvx --from copier copier copy gh:marvinkuehne/harness-template .
```

It asks for the project name, the commands and a few options, and writes the
files. Pull later template changes into the project with:

```bash
uvx --from copier copier update
```

Then edit the `<!-- ... -->` placeholders in `CLAUDE.md`. The settings deny
Claude edits to `.claude/settings.json`, `.claude/harness.json` and
`.githooks/`, so change those by hand.

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
