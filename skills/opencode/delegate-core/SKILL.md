---
name: delegate-core
description: Shared rules for any build, plan or review task delegated by Claude, in any project. Load it together with the project's rules skill (usually project-rules) before starting.
---

# Working as Claude's delegate

Claude plans and reviews; you build (or plan, or review, as the prompt says). Your work is checked by a gate, by a second model and by Claude, so precision beats speed.

## Find code cheaply
- If `graphify-out/` exists, query the graph before reading files: `graphify query "<question>"`, `graphify explain "<symbol>"`, `graphify path "A" "B"`, `graphify affected "<symbol>"`. Keep queries narrow (a symbol or a file), not broad topics.
- Read only the files the prompt names plus what the graph points to. Prefer the project's pattern library over exploring.
- Before writing SQL or calling an API, check the real schema/signature in the code; don't trust the prompt's guess.

## Stay in your lane
- Do exactly the ticket. Out-of-scope improvements go in your final message as suggestions, not in the diff.
- Stop and say "NEEDS REVIEWER: <reason>" (don't guess) if a step needs: a new access rule/RLS policy or privileged DB function not copied from a named example, auth/session changes, secrets handling, payments, or storing personal data.
- When the ticket and the code disagree, or something is undecided, say so in your final message and choose the safer option.

## Tests
- A test file the prompt lists as reviewer-owned, or that starts with a `reviewer-owned` comment, is the spec: make the code pass it; never edit, skip or weaken it. If you think it's wrong: "NEEDS REVIEWER: <test> because <reason>".
- Changing any test's expected value needs a one-line reason in the commit body.
- Test behaviour, not implementation. No network in unit tests.
- Only one worktree at a time may run DB or end-to-end tests if they share a local database.

## Shell
- Start every check command with `set -o pipefail` (`test | tail` otherwise hides failures).
- Run the project's checks (in its rules skill) and fix until all pass. Run only the e2e/DB spec the prompt names.

## Git
- Stay on the current branch. Never push, never open a PR, never rebase or reset others' commits.
- `git add <explicit paths>` only (never `-A` or `.`). Never commit files you didn't create or change for this ticket.
- Commit message: the title the prompt gives; blank line; the trailer lines the prompt gives, verbatim.
- Don't edit shared status files (HANDOFF, CHANGELOG, root docs) unless the prompt says so: runs happen in parallel worktrees and they conflict. Put owner steps under `### Owner steps` in the ticket's Status section.

## Code habits that reviewers keep catching
- After every outside `fetch`/HTTP call, check the status (`response.ok`) and log failures with the project's logger; network errors alone aren't enough.
- When an outcome is unknown, fail safe: count it as failed and log it; never assume success.
- Never log a library's error or response object whole (it can hold endpoints, tokens, identifiers): log a new Error(message) plus a status or internal id.
- Secrets never go in client-exposed config (e.g. NEXT_PUBLIC_, VITE_); trim env values.
- Background work after a response never throws to the caller; each independent step gets its own try/catch.
- Prefer a well-known library over hand-written crypto, parsing or protocols.
- Migrations: dated today, next free sequence number.

## Finish
Print `git show --stat HEAD`, the one-line test summary, and any assumption you made. Then stop.

## Lessons (appended by `ocd lesson generic`; each was checked by Claude in review)
- 2026-10-09: mimo, IndexNow ticket: a `fetch` only caught network errors, so 403/422 failed silently. **Rule:** check `response.ok` after every outside call.
- 2026-10-09: mimo, push ticket: `statusOf(result) ?? 201` treated an unknown result as success. **Rule:** unknown = failed.
- 2026-10-09: mimo, push ticket: logged web-push's error object whole, which carries the device endpoint. **Rule:** log message + status only.
- 2026-10-09: reviewer's own pipe `test | tail` hid a failing test and a broken commit went through. **Rule:** `set -o pipefail`.
- 2026-10-09: step-5, plan: planned hand-written VAPID/aes128gcm and a wrong migration date. **Rules:** library over hand-rolled crypto; migrations dated today.
- 2026-10-09: nemotron, usage ticket: good: checked the real table columns before writing SQL instead of trusting the prompt. Keep doing this.
- 2026-10-09: 2026-10-09 step-5 cross-review, push switch: missed that a startsWith('/') && !startsWith('//') link check is bypassed by '/\evil.com' (browsers read backslash as slash); Claude caught it. **Rule:** to keep a URL on-site, resolve it with new URL(raw, origin) and compare origins; never check prefixes.
- 2026-10-09: 2026-10-09 mimo, privacy text: the Arabic retention line said the opposite of the English ('longer than the life of the device' vs 'as long as the device exists'); the cross-review didn't catch it. **Rule:** for any bilingual legal or user-facing text, the reviewer compares meaning line by line across languages, not just key parity.
