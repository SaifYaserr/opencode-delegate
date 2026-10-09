# opencode-delegate

Claude plans, decides and reviews; [opencode](https://opencode.ai) on **free models** builds. The goal is the lowest Claude usage per ticket at high accuracy: every step a free model can do (drafting tickets, building, cross-reviewing, fixing) is done by one, and Claude reads only what the gates flag.

## Install (once per machine)
```bash
git clone git@github.com:SaifYaserr/opencode-delegate.git ~/Documents/Work/Projects/opencode-delegate
~/Documents/Work/Projects/opencode-delegate/install.sh
```
This links the `ocd` CLI, the Claude Code skill `opencode-delegate` (so Claude knows the workflow in every project) and the opencode skill `delegate-core` (shared builder rules). `ocd update` pulls improvements; the links make them live everywhere.

## Use in a project
```bash
ocd init --draft      # .opencode/project.env + a drafted project-rules skill; review, then commit .opencode/
```
Then ask Claude to "use the opencode workflow" for a feature. The flow:

1. **Claude** writes a detailed ADR (decision, rules, rejected alternatives, owner steps, task list).
2. **Free run** drafts tickets from the ADR (`ocd prompt tickets …`); **Claude** corrects them and writes reviewer-owned tests.
3. **Free run** builds each ticket in its own git worktree (`ocd run build …`).
4. **Free pipeline**: cross-review by a second model, one fix round, the gate (`ocd pipeline …`).
5. **Claude** reviews the findings and flagged files, integrates, and records lessons (`ocd lesson`) and scores (`ocd score`).

Security-sensitive parts (access rules, auth, secrets, personal data) go to a Claude subagent instead.

## Layout
| Path | What |
|---|---|
| `bin/ocd`, `lib/*.sh` | CLI: init, run, pipeline, status, review, prompt, lesson, score, update |
| `templates/` | prompts (plan, tickets, crossreview, fix, init-draft), ticket template, project.env, project-rules skeleton |
| `skills/claude/opencode-delegate/` | Claude-side workflow (global Claude Code skill) |
| `skills/opencode/delegate-core/` | Builder-side shared rules + generic lessons (global opencode skill) |
| `scorecard.md` | measured model performance across projects |
| `CHANGELOG.md` | every change to the workflow |

## How it improves
- After each ticket Claude records checked lessons: generic ones in `delegate-core` (shared by all projects, committed here), project-only ones in that project's rules skill.
- Gaps found in runs or reviews become script/template fixes here, with a CHANGELOG line.
- Nothing changes the shared core without a reviewed commit, and nothing project-specific (code, env, tickets, client data) is ever stored here.
