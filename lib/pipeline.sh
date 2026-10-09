#!/usr/bin/env bash
# Free passes after a build, before the Claude review:
#   1. cross-review by a different model (read-only) -> findings
#   2. on "needs fixes", one fix round in the builder's session
#   3. the review gate
# Usage: ocd pipeline <base> <ticket-file> <plan-file|none> <build-session> [builder] [reviewer]
set -uo pipefail
. "$OCD_HOME/lib/common.sh"; ocd_load
base=$1 ticket=$2 plan=$3 session=$4 builder=${5:-$OCD_BUILDER} reviewer=${6:-$OCD_REVIEWER}
name="$(basename "$ticket" .md)-$(date +%H%M)"

ocd_fill crossreview ticket="$ticket" plan="$plan" base="$base" > "$OCD_LOGDIR/xr-$name.txt"
"$OCD_HOME/lib/run.sh" plan "$reviewer" "cross-review $name" "$OCD_LOGDIR/xr-$name.txt" 30 > "$OCD_LOGDIR/xr-$name.log" 2>&1
findings=$(sed 's/\x1b\[[0-9;]*m//g' "$OCD_LOGDIR/xr-$name.log" | grep -E '^\[(high|medium|low)\]|^VERDICT')
echo "$findings" > "$OCD_LOGDIR/findings-$name.txt"
echo "--- cross-review ($reviewer)"; echo "$findings"

if echo "$findings" | grep -q 'VERDICT: needs fixes'; then
  { ocd_fill fix; echo; echo "$findings"; } > "$OCD_LOGDIR/fix-$name.txt"
  "$OCD_HOME/lib/run.sh" build "$builder" "fix $name" "$OCD_LOGDIR/fix-$name.txt" 30 "$session" > "$OCD_LOGDIR/fix-$name.log" 2>&1
  echo "--- fix round done: $OCD_LOGDIR/fix-$name.log"
  sed 's/\x1b\[[0-9;]*m//g' "$OCD_LOGDIR/fix-$name.log" | tail -15
fi

echo "--- gate"; "$OCD_HOME/lib/review.sh" "$base" .
