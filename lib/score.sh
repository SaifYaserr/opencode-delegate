#!/usr/bin/env bash
# Append a measured row to the shared scorecard (committed and pushed).
# ocd score "| date | project | task type | mode | model | minutes | fix rounds | defects found in review | notes |"
set -uo pipefail
. "$OCD_HOME/lib/common.sh"
echo "$1" >> "$OCD_HOME/scorecard.md"
git -C "$OCD_HOME" add scorecard.md && git -C "$OCD_HOME" commit -qm "score: $(echo "$1" | cut -c1-60)"
git -C "$OCD_HOME" remote | grep -q . && git -C "$OCD_HOME" push -q
tail -1 "$OCD_HOME/scorecard.md"
