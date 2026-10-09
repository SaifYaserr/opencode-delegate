#!/usr/bin/env bash
# Record a lesson after a review.
#   ocd lesson generic "<text>"   -> shared core skill + CHANGELOG, committed and pushed
#   ocd lesson project "<text>"   -> this project's rules skill (commit it with your work)
# Write it as: what happened (model, ticket) + **Rule:** the rule. Only call it for
# a lesson you have checked; a generic lesson must hold in any project/language.
set -uo pipefail
. "$OCD_HOME/lib/common.sh"; ocd_load
scope=$1 text=$2 day=$(date +%F)
case "$scope" in
  generic)
    f="$OCD_HOME/skills/opencode/delegate-core/SKILL.md"
    printf -- '- %s: %s\n' "$day" "$text" >> "$f"
    printf -- '- %s lesson: %s\n' "$day" "$(echo "$text" | cut -c1-140)" >> "$OCD_HOME/CHANGELOG.md"
    git -C "$OCD_HOME" add skills CHANGELOG.md
    git -C "$OCD_HOME" commit -qm "lesson: $(echo "$text" | cut -c1-60)" && echo "committed to $OCD_HOME"
    git -C "$OCD_HOME" remote | grep -q . && git -C "$OCD_HOME" push -q && echo pushed ;;
  project)
    f="$ROOT/.opencode/skills/$OCD_PROJECT_SKILL/SKILL.md"
    printf -- '- %s: %s\n' "$day" "$text" >> "$f" && echo "appended to $f" ;;
  *) echo "usage: ocd lesson <generic|project> \"<text>\""; exit 2 ;;
esac
