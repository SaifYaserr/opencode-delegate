---
name: opencode-delegate
description: Claude plans and reviews while opencode (free models) builds — the owner's delegation workflow for any project. Use when the owner asks to delegate, build tickets with opencode, "use the workflow", plan a feature into tickets, or set the workflow up in a new project (`ocd init`). Also use at the end of each delegated ticket to record lessons and scores.
---

# opencode-delegate (Claude side)

Goal (owner's priorities): **lowest Claude tokens per ticket with high accuracy**. Speed and one-off tooling cost don't matter. Every free-model pass that saves a Claude read is worth adding. Push back on the owner (with reasons and an alternative) when an instruction works against this.

The CLI is `ocd` (repo: this skill's repo, `ocd update` pulls it). The builder-side rules are the opencode skill `delegate-core` (global) + the project's `.opencode/skills/<project-rules>` skill.

## Set up a project (once)
1. `ocd init --draft` in the repo root: writes `.opencode/project.env` (checks, risky paths, models) and drafts `.opencode/skills/project-rules/SKILL.md` with a free run.
2. Review both (fix the checks, trim the pattern library to real paths), build the graph (`graphify update .`), commit `.opencode/`.

## Per feature
1. **Decide** with the owner (one question at a time). **Claude writes a detailed ADR**: context, decision, rules (privacy, access, failure handling), alternatives rejected and why, consequences, owner steps, and a short task list.
2. **Free ticket drafting**: `ocd prompt tickets adr=<adr> tasks="<which>" parent=<n> dir=<issues dir> > p.txt; ocd run build - "tickets <n>" p.txt 45`. It writes one ticket file per run-sized piece (template `templates/ticket.md`).
3. **Claude reviews the tickets** (a few lines of corrections; fix dates, routing, library choices) and **writes reviewer-owned tests** for pure logic (20–30 lines, first line a `reviewer-owned` comment). Keep pristine copies in a spec dir; put only the current ticket's specs in its worktree.
4. **Route**: opencode for UI, copy, pure logic, tests, docs, pattern-copy server code. A Claude subagent (Sonnet, high effort) for new access rules/RLS, privileged DB functions, auth, secrets, personal data — for accuracy, not speed.
5. **Build**: parallel tickets in `git worktree`s off the batch branch; `ocd run build - "<title>" <ticket-prompt> 90`. Prompt = "Load skills delegate-core and <project skill>" + ticket path + only task-specific facts. Never repeat house rules in prompts.
6. **Pipeline (free)**: `SPEC_DIR=<specs> ocd pipeline <base> <ticket> <plan|none> <build-session>` → cross-review by a different model, one fix round, the gate.
7. **Claude review**: read the findings, the gate output and only the files it lists under "read these in full"; spot-check the riskiest change. Fix tiny things yourself (with `set -o pipefail`); send bigger ones back with `-s <session>`.
8. **Integrate**: cherry-pick into the batch branch in ticket order; resolve shared-file duplicates (env examples, message files); remove the worktree and branch. Shared status files (HANDOFF etc.) are updated once, in a final bookkeeping commit.
9. **Learn** (every ticket):
   - `ocd lesson generic "<model, ticket: what happened. **Rule:** …>"` only for lessons that hold in any project/language; otherwise `ocd lesson project "…"`.
   - Add any pattern the run had to discover to the project's pattern library.
   - `ocd score "| date | project | task type | mode | model | min | fix rounds | defects found | notes |"`.
   - `graphify update . && graphify save-result --question "where is X" --answer "<files>" --outcome useful`.
   - Every ~10 tickets: `graphify reflect`, re-read the scorecard, adjust default models in `project.env`, prune lessons that no longer fire.

## Keep an open-items checklist (always)
Parallel runs, worktrees and deferred cleanups create loose ends that otherwise live only in the conversation. Keep one checklist file per batch (the project's memory or handoff file): Done / Open per ticket / batch wrap-up / workflow / owner decisions. Update it **every time** something starts, lands or is deferred, not at the end. Before telling the owner a batch is ready, every Open item is either done or explicitly handed over.

## Polling
`ocd status` (one line per run). Never sit in a loop reading logs; wait for background notifications. Don't spawn agents just to wait on CI.

## Improving the workflow itself
When a run, review or gate shows a gap, fix it in the shared repo (scripts, templates, delegate-core), add a CHANGELOG line, commit and push. Never let a lesson modify the shared core silently: only checked lessons, through `ocd lesson` or a reviewed commit. Project-specific rules stay in the project.
