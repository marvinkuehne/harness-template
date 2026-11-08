# Design of the harness template

## Three parts, because they have different lifecycles

| Part | Holds | Why separate |
|---|---|---|
| Plugin (`plugins/harness/`) | Skills, subagents, generic hooks | One source, updated centrally, versioned. Claude Code loads it from its plugin cache, so nothing is copied into a project. |
| Scaffold (`copier.yml`, `scaffold/template/`) | `CLAUDE.md`, `docs/`, settings, git hooks, PR template | These files must live in each repo and are edited there. Copier can merge later template changes with `copier update`. |
| Managed settings (not built yet) | Rules for client machines | Only managed settings cannot be changed by the project or by Claude. A copy inside a repo can be edited by anyone with write access. |

## What goes where

- Guidance that is always needed and short: `CLAUDE.md`.
- Reference knowledge read when touching an area: a doc.
- A procedure with steps and a "done when": a skill.
- Something that must happen every time: a hook.
- Something that must never happen: a deny rule, the sandbox or a managed setting.

Skills that name no project belong in the plugin. A skill that is about one
project stays in that project's `.claude/skills/`.

## Docs follow Diátaxis

All four quadrants are first-class: never skip one because it seems unneeded
for a small team or because the content feels implicit. Layout under `docs/`:

- `tutorial/`: learning-oriented walkthroughs
- `how-to/`: task-oriented recipes
- `reference/`: information-oriented lookups
- `explanation/`: understanding-oriented design rationale

The scaffold creates all four, each with a README and one starter doc. This
repo's own `docs/` has only the two files that exist so far.

## Decisions

- The commit gate is opt-in (`.claude/harness.json`), so the plugin never
  interferes with a project that does not use the procedure.
- The gate parses the command instead of matching a pattern, so
  `git -c k=v commit` is caught and `echo git commit` is not.
- Claude cannot edit its own guardrail files (deny rules in the scaffold).
  They are changed by hand.
- The plugin is private for now. See `how-to/before-working-with-others.md`
  for what to check when that changes.
