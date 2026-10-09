# Changelog

Every change to the shared workflow, newest last. Lessons are appended by `ocd lesson generic`.

- 2026-10-09 v0.1: extracted from the mohamy.world project: `ocd` CLI (init, run, pipeline, status, review, prompt, lesson, score, update); templates (plan, tickets, ticket, crossreview, fix, init-draft, project.env, project-rules); delegate-core (opencode) and opencode-delegate (Claude) skills; scorecard with the first five measured rows.
- 2026-10-09: Claude skill: keep an open-items checklist per batch, updated at every start/landing/deferral (loose ends were living only in the conversation).
- 2026-10-09: tests-first only for pure logic; for mocked I/O the ticket lists the cases and the cross-review checks each exists.
- 2026-10-09 lesson: 2026-10-09 step-5 cross-review, push switch: missed that a startsWith('/') && !startsWith('//') link check is bypassed by '/\evil.com' (brow
