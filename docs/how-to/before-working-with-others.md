# Before working with others or with client data

The template is built and tested for one person on one machine. Work through
this list when either of these starts:

- a second person uses the template or a project made from it
- a project holds client data or touches client systems

Each item names the risk it removes and what is still unchecked.

## When a second person joins

- [ ] **Move the repo to the RedeployAB organization.** A private repo under a
  personal account disappears with its owner and cannot use team permissions.
  After moving, change `marketplace_repo` in `copier.yml` and the URL in every
  project's `.claude/settings.json`.
- [ ] **Check that a teammate can install the plugin from the private repo.**
  Claude Code clones it with the teammate's own git credentials. Never tried:
  have a teammate run `claude plugin marketplace add RedeployAB/harness-template`.
- [ ] **Test the deny rules in a real session.** The rules for `.env`, `secrets/`
  and the guardrail files were written but never run. Also check that the
  `./` path form works when Claude runs from a subfolder.
- [ ] **Run the same checks in CI.** Hooks fail open: a crash or timeout lets the
  action through. CI is the check that cannot be skipped. Add gitleaks for
  secrets.
- [ ] **Pin a version per project.** Tag a release, and let projects point at the
  tag, so a change here cannot alter a running project unnoticed.
- [ ] **Decide who reviews changes to the template.** It holds the guardrails of
  every project made from it.

## When a project holds client data

- [ ] **Run the client intake first.** Not built yet. It must record the client's
  systems, data classes and what Claude may read, write and call, and block tool
  use until a person approved it.
- [ ] **Choose the data path.** A provider in the client's tenant (Bedrock,
  Vertex or Foundry, locked with `allowedProviders`) or zero data retention.
  Standard retention is 30 days, and local transcripts are plaintext.
- [ ] **Write managed settings per risk level.** Only managed settings cannot be
  changed by the project or by Claude: bypass mode off, hooks and permission
  rules managed, provider lock, sandbox with `failIfUnavailable`, telemetry off.
- [ ] **Make the client's IT force-enable the plugin.** With
  `allowManagedHooksOnly`, hooks from a plugin that users enable themselves do
  not run. The plugin must be listed in the managed `enabledPlugins`, with the
  marketplace in `extraKnownMarketplaces`.
- [ ] **Take away write access, not only permission.** Hooks cannot stop a script
  that holds credentials. Use read-only database users, short-lived tokens and
  an egress allowlist.
- [ ] **Add the sandbox.** A read deny rule stops Claude's file tools and common
  shell commands, not a script that opens the file. The sandbox does not run on
  native Windows: use WSL2 or a devcontainer there.
