Load skills delegate-core and {{project_skill}}. TICKET DRAFTING: write ticket files only; change no code, run no checks, make no commit.

Source of truth: {{adr}}. Task(s) to split: {{tasks}}. Parent ticket: {{parent}}.
Template: {{ocd_home}}/templates/ticket.md (fill every section).

1. Read the ADR fully, then find the code with graphify and targeted reads (at most ~15 files): the exact functions to change, the existing pattern to copy for each new piece, and the tests that already cover the area.
2. Split each task into tickets small enough for one run of a small model: one concern, at most ~5 source files, clear done-criteria. Order them; state dependencies.
3. Route each ticket: "opencode" (UI, copy, pure logic, tests, docs, pattern-copy server code) or "Sonnet agent" (new RLS policy, security definer function, auth/session, secrets, personal data). Say why in a few words.
4. For pure logic, list the test cases the reviewer should write first (reviewer-owned), as one line each.
5. Write each ticket to {{dir}}/{{parent}}-<part>-<slug>.md. Then print a table: file | title | route | depends on | est. files.

Rules: follow the ADR exactly; if the ADR and the code disagree, or something is undecided, add it under "Open questions" in the ticket instead of deciding. Migrations are dated today with the next free sequence number. Prefer an existing helper over a new one.
