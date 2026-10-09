#!/usr/bin/env bash
# Set up the workflow in the current project:
#   .opencode/project.env                 checks, risky paths, models (edit it)
#   .opencode/skills/project-rules/       house rules + pattern library (drafted by a free run with --draft)
# Usage: ocd init [--draft]
set -uo pipefail
. "$OCD_HOME/lib/common.sh"; ocd_load
cd "$ROOT"
mkdir -p .opencode/skills/project-rules
if [ ! -f .opencode/project.env ]; then
  pm=npm; [ -f pnpm-lock.yaml ] && pm=pnpm; [ -f yarn.lock ] && pm=yarn; [ -f bun.lockb ] && pm=bun
  checks=""
  if [ -f package.json ]; then
    for s in lint typecheck test; do
      grep -q "\"$s\"" package.json && checks="${checks:+$checks|}$pm run -s $s"
    done
  fi
  [ -f pyproject.toml ] && checks="${checks:+$checks|}ruff check .|pytest -q"
  [ -f go.mod ] && checks="${checks:+$checks|}go vet ./...|go test ./..."
  [ -f Cargo.toml ] && checks="${checks:+$checks|}cargo clippy -q|cargo test -q"
  sed "s#{{checks}}#${checks:-echo no checks configured}#" "$OCD_HOME/templates/project.env" > .opencode/project.env
  echo "created .opencode/project.env (checks: ${checks:-none found})"
fi
[ -f .opencode/skills/project-rules/SKILL.md ] || cp "$OCD_HOME/templates/project-rules.SKILL.md" .opencode/skills/project-rules/SKILL.md
command -v graphify >/dev/null && [ ! -f graphify-out/graph.json ] && echo "tip: build the code graph once: graphify update ."
if [ "${1:-}" = "--draft" ]; then
  ocd_fill init-draft > "$OCD_LOGDIR/init-draft.txt"
  "$OCD_HOME/lib/run.sh" build - "draft project rules" "$OCD_LOGDIR/init-draft.txt" 40 > "$OCD_LOGDIR/run-init.log" 2>&1
  echo "drafted .opencode/skills/project-rules/SKILL.md: review it before the first ticket"
fi
echo "next: review .opencode/project.env and the project-rules skill, then commit .opencode/"
