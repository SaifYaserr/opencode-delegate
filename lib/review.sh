#!/usr/bin/env bash
# Reviewer gate: project checks, diff summary, risky files, red flags, spec guard.
# Usage: ocd review [base=main] [dir=.]   (SPEC_DIR=<pristine reviewer-owned tests>)
set -uo pipefail
. "$OCD_HOME/lib/common.sh"
base="${1:-main}"; cd "${2:-.}" && ocd_load

IFS='|' read -ra checks <<< "$OCD_CHECKS"
for c in "${checks[@]}"; do
  if out=$(bash -o pipefail -c "$c" 2>&1); then echo "PASS $c"; else echo "FAIL $c"; echo "$out" | tail -25; fi
done

echo "--- commits since $base"; git log --oneline "$base"..HEAD
echo "--- diff"; git diff --stat "$base"; git status -s | grep '^??' | grep -v '\.opencode/' || true
echo "--- read these in full"
git diff --name-only "$base" | grep -E "$OCD_RISKY_PATHS" || echo "(none)"

spec="${SPEC_DIR:-$OCD_SPEC_DIR}"
if [ -n "$spec" ] && [ -d "$spec" ]; then
  (cd "$spec" && find . -type f -printf '%P\n') | while read -r f; do
    if cmp -s "$spec/$f" "$f"; then echo "PASS spec unchanged: $f"; else echo "FAIL reviewer-owned test changed: $f"; fi
  done
fi

echo "--- red flags"
src=(-- . ':!*.md' ':!*.test.*' ':!*.spec.*' ':!*lock*' ':!*.json')
git diff "$base" "${src[@]}" | grep -nE "^\+.*($OCD_REDFLAGS)" | head -30 || true
if git diff "$base" "${src[@]}" | grep -q '^+.*await fetch(' && ! git diff "$base" "${src[@]}" | grep -qE '^\+.*\.(ok|status)\b'; then
  echo "fetch added without checking response.ok/status"
fi
[ -n "$OCD_EXTRA_CHECKS" ] && [ -x "$OCD_EXTRA_CHECKS" ] && "$OCD_EXTRA_CHECKS" "$base"
exit 0
