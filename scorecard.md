# Model scorecard

Measured rows only (append with `ocd score`). Use it to pick `OCD_PLANNER`, `OCD_BUILDER`, `OCD_REVIEWER` per project. Defects = real issues found after the run (by cross-review or Claude).

## Current read (update every ~10 rows)
- **step-5-preview-free**: best planner and cross-reviewer: thorough code survey, names existing patterns, flags its own risks; 8 real findings on one review where a quick Claude review found 2. Weak: dates; prefers hand-rolling to libraries.
- **mimo-v2.6-flash-free**: reliable builder: fixes its own tests, writes docs unasked, handles a reviewer's false positive with a reason. Weak: slow, misses `response.ok` / fail-safe details.
- **nemotron-3-ultra-free**: fast and terse; correct SQL/logic, checks real schemas. Weak: UI conventions (raw colors, physical CSS directions).
- **Claude Sonnet agent (baseline)**: ~80–100k tokens per part, 0 defects on access rules work; use for security-sensitive parts.

| date | project | task type | mode | model | min | fix rounds | defects found | notes |
|---|---|---|---|---|---|---|---|---|
| 2026-10-09 | mohamy | outside API ping + route | build | mimo-v2.6-flash-free | ~50 | 0 | 1 minor | no response.ok check |
| 2026-10-09 | mohamy | SQL fn + admin card | build | nemotron-3-ultra-free | ~55 | 0 | 2 | raw colors, ml-2 in RTL; SQL correct |
| 2026-10-09 | mohamy | feature plan | plan | step-5-preview-free | ~25 | – | 3 | wrong migration date, hand-rolled crypto; found every hook point |
| 2026-10-09 | mohamy | table + RLS + API | build | Claude Sonnet agent | 4 | 0 | 0 | 83k tokens |
| 2026-10-09 | mohamy | sending logic | build+xr | mimo build, step-5 review | ~50 | 1 | 8 by xr (4 med), 2 by Claude | xr beat a quick Claude review |
| 2026-10-09 | mohamy | client card + service worker | build+xr | mimo build, step-5 review | ~60+30 | 1 | 8 by xr (3 med), 2 by Claude (URL bypass, Arabic legal meaning) | xr and Claude caught disjoint sets |
| 2026-10-10 | mohamy-reel | Remotion video + kit | build | mimo-v2.6-flash-free | ~90 | 0 (Claude fixed 3 small items) | 3 | strong at motion code; review stills as contact sheets |
| 2026-10-20 | cafepos | cross-review Go backup/restore + React (T018, 52 files) | review | deepseek-v4.1-flash-free | 14 | – | 7 real of 9, 0 false | broadest: post-swap error path, request-ctx cancel during restore, missing i18n key, tmp left on USB |
| 2026-10-20 | cafepos | same T018 review | review | minimax-m3.1-flash-free | 30 | – | 5 real of 6, 0 false | only one to catch same-second backup deleting the earlier good file (data loss); missed post-swap path |
| 2026-10-20 | cafepos | same T018 review | review | glm-5.3-flash-free | 11 | – | 5 real of 10, 1 false | several vague 'unsure' lines |
| 2026-10-20 | cafepos | same T018 review | review | nemotron-3.5-super-vl-free | 7 | – | 2-3 real of 5, 2 false | a false [high] (mutation errors do toast) |
| 2026-10-20 | cafepos | same T018 review | review | longcat-2.5-preview-free | hung | – | 0 | no output after 28 min, stopped |
| 2026-10-20 | cafepos | Go backup file safety + tests (T019-a1, 4 files) | build+xr | minimax build, deepseek review | 17+15 | 1 | 3 low by xr (dead guard, tie-break order, ignored remove errors), 0 by Claude | fixed all 3 in one round; correct data-loss fix |
