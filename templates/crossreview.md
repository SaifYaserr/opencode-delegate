Load skills delegate-core and {{project_skill}}. REVIEW ONLY: do not edit any file.
You are reviewing another model's work. Ticket: {{ticket}}. Plan: {{plan}}.
Run `git diff {{base}}..HEAD` (and `git diff {{base}}..HEAD --stat`) and review every changed source file.

Check, in this order:
1. Does it do what the ticket and plan ask? List anything missing.
2. Bugs: wrong logic, unhandled errors, `fetch` without a `response.ok` check, a promise not awaited, a race, an off-by-one, a wrong status code.
3. Security and privacy: access rules, secrets in client code (`NEXT_PUBLIC_` on a secret), personal data leaking (logs, push text, URLs), missing auth or permission checks.
4. The house rules in the {{project_skill}} skill (style, i18n, logging, module boundaries) and the delegate-core rules.
5. Tests: do they test behaviour (not implementation)? Was any test weakened or a reviewer-owned test changed?

Reply with ONLY a findings list, most severe first, each one line:
`[high|medium|low] path:line — what is wrong — the fix`
Then `VERDICT: clean` or `VERDICT: needs fixes`. No praise, no summary. If you are unsure, say "unsure" in the line rather than leaving it out.
