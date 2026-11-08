---
name: plan-slices
description: Plan an implementation before any code is written. Splits the work into slices, and a slice into steps (one commit each) when it is too big for one. Use when the user asks for a plan, describes a new feature or a larger change, or asks how to split or structure some work.
---

# Plan in slices and steps

A plan is a list of **slices**, each cut into **steps** when needed. A slice is
something the user can try: open the app, run the command, call the endpoint.
A step is one commit. The user approves the plan, then every step on its own
(the workflow in `CLAUDE.md`). Run the four parts below in order.

## 1. Check the request against the repo

Read before you plan. The plan rests on what the code and the services
actually do, not on what the request assumes.

- Read the code the request touches and the docs `CLAUDE.md` lists for it.
  Include `ARCHITECTURE.md` and its risk list when the project has one.
- When a fact about a library or an external service decides the design, look
  it up in the source or try it: read the library code, make a real request.
  Say which facts you checked and how.
- Name every premise of the request that the code contradicts, with the code
  that shows it.

Done when you can list the findings, the open questions, and the decisions
that belong to the user. Ask those decisions together (AskUserQuestion), each
with options and a recommendation. Settle everything else from the code or a
sensible default and state the default.

## 2. Cut the work into slices

- Each slice works on its own when it is done: the user can try it.
- Order by dependency: data and storage first, pure rules before the screens
  or commands that use them, wiring last. Put the riskiest unknown early.
- Say what is out of scope, and which later slices it belongs to.

## 3. Cut a slice into steps

A slice that fits one commit is one step. Otherwise cut it so that every step:

- does one thing and leaves the project working;
- changes a stored format (schema, collection, file format) in a step of its
  own, before the step that switches the code to it. A switch that only works
  when it lands whole stays one step.

For every step, write:

- **Behaviour**: what the user or the code can do afterwards.
- **Rules**: the constraints it enforces and the edge cases it covers.

## 4. Hand over

Show the slices and steps in chat, with the recommendation for each open
question. Wait for the user to approve the cut. Record decisions that change
the plan where the project keeps plans (`.claude/plans/` unless `CLAUDE.md`
says otherwise) so a later session can find them.

## Common traps

Check the project's own docs for traps seen there, then these:

- **Old stored data.** Stored documents and files are only ever added to. When
  a step removes or changes stored data, plan how installations that already
  hold the old data get the new state.
- **Time.** Deadlines, schedules, time zones: say what the step does before
  and after the deadline.
- **Counts.** Recount every number in the plan (items, groups, files) from the
  data before stating it.
