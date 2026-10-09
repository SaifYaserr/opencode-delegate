# <n>-<part>: <title>

**ADR:** docs/adr/<NNNN>-<slug>.md (read the sections named below only)
**Task:** <the task this ticket belongs to>   **Depends on:** <tickets, or none>
**Route:** opencode <model> | Sonnet agent (why)   **Cross-review:** <model>

## Goal
One or two sentences: what changes for the user or the system.

## Read first (only these)
- `path` — why
- Pattern to copy: `path` (`function`)

## Change
1. `path` — what exactly (signatures, names, behaviour)
2. …

## Rules for this ticket
- Decisions from the ADR the code must follow (privacy, access, failure handling).
- Out of scope: … (do not touch)

## Tests
- Reviewer-owned (don't edit): `path` (if any)
- Add: `path` — cases …
- e2e/DB: only `<spec>` (or none)

## Done when
- `pnpm lint`, `pnpm typecheck`, `pnpm test` pass (with `set -o pipefail`); the named spec passes.
- Commit title: "<title>"; Status section appended to this ticket; owner steps under `### Owner steps`.
