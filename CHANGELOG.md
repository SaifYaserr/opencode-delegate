# Changelog

Every change to the shared workflow, newest last. Lessons are appended by `ocd lesson generic`.

- 2026-10-09 v0.1: extracted from the mohamy.world project: `ocd` CLI (init, run, pipeline, status, review, prompt, lesson, score, update); templates (plan, tickets, ticket, crossreview, fix, init-draft, project.env, project-rules); delegate-core (opencode) and opencode-delegate (Claude) skills; scorecard with the first five measured rows.
- 2026-10-09: Claude skill: keep an open-items checklist per batch, updated at every start/landing/deferral (loose ends were living only in the conversation).
- 2026-10-09: tests-first only for pure logic; for mocked I/O the ticket lists the cases and the cross-review checks each exists.
- 2026-10-09 lesson: 2026-10-09 step-5 cross-review, push switch: missed that a startsWith('/') && !startsWith('//') link check is bypassed by '/\evil.com' (brow
- 2026-10-09 lesson: 2026-10-09 mimo, privacy text: the Arabic retention line said the opposite of the English ('longer than the life of the device' vs 'as long 
- 2026-10-09: fix: OCD_* settings given on the command line now win over defaults and project.env.
- 2026-10-09: init: detects a Node install outside PATH (~/.local/node, nvm, volta) and records it in project.env; init --draft verified end to end.
- 2026-10-09: fix: pipeline parses findings wrapped in backticks/bullets/bold; an unparsed review now says so instead of looking clean.
- 2026-10-09: fix: run doesn't retry on the fallback model when the reviewer interrupts a run (exit 130/143). Tip: stop runs by PID, not `pkill -f` with a pattern your own shell contains.
- 2026-10-10: Claude skill: reinstall dependencies after integrating commits that touch manifests/lockfiles; read every check's result (a filtered check failed silently in the mohamy batch).
- 2026-10-10 lesson: 2026-10-09 mimo, Remotion reel: Arabic text was right-to-left but every row/grid container was left-to-right (labels, avatars, toggles and a
