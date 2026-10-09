Load skill delegate-core. Draft this project's rules skill: edit ONLY .opencode/skills/project-rules/SKILL.md (it holds a template with headings). Change no other file, make no commit.

Use graphify (if graphify-out/ exists) and targeted reads of at most ~25 files: README, the package/build files, lint/format config, 2-3 representative source files per layer (UI, server/API, data access, tests), the CI workflow.

Fill each heading with facts, not advice:
- Stack and versions, and anything newer than common knowledge (with where its docs live in the repo, e.g. node_modules/<pkg>/docs).
- How to run the checks (exact commands), tool locations if not on PATH.
- Code conventions actually used: naming, module boundaries, error handling and logging helper, i18n, styling system and tokens, comments style, test framework and where tests live.
- Pattern library: a table "Need | Copy from" with 8-15 rows of real paths for the recurring needs (data read, data write, auth/permission check, API route, background work, UI card/form, config/env, tests).
- Risky areas a small model must not change without review (access rules, auth, payments, migrations).
Keep it under 120 lines.
