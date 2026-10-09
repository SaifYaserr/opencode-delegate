#!/usr/bin/env bash
# Time-boxed opencode run; retries once on $OCD_FALLBACK if the model fails fast.
# Usage: ocd run <plan|build> <model|-> <title> <prompt-file> [minutes=15] [session]
# A model of "-" uses the project default (planner for plan, builder for build).
set -uo pipefail
. "$OCD_HOME/lib/common.sh"; ocd_load
mode=$1 model=$2 title=$3 prompt=$4 minutes=${5:-15} session=${6:-}
agent=build; [ "$mode" = plan ] && agent=plan
if [ "$model" = "-" ]; then [ "$agent" = plan ] && model=$OCD_PLANNER || model=$OCD_BUILDER; fi
args=(run --agent "$agent" -m "opencode/$model" --title "$title")
[ "$agent" = build ] && args+=(--auto)
[ -n "$session" ] && args+=(-s "$session")
timeout --signal=INT "${minutes}m" "$OPENCODE" "${args[@]}" "$(cat "$prompt")"
code=$?
# Not on a timeout (124) or an interrupt by the reviewer (130 SIGINT, 143 SIGTERM).
if [ $code -ne 0 ] && [ $code -ne 124 ] && [ $code -ne 130 ] && [ $code -ne 143 ] && [ -n "$OCD_FALLBACK" ] && [ "$OCD_FALLBACK" != "$model" ]; then
  echo "FAILED on $model (exit $code), retrying on $OCD_FALLBACK"
  args[4]="opencode/$OCD_FALLBACK"
  timeout --signal=INT "${minutes}m" "$OPENCODE" "${args[@]}" "$(cat "$prompt")"
  code=$?
fi
[ $code -eq 124 ] && echo "TIMEOUT after ${minutes}m: resume with -s and a narrower prompt"
"$OPENCODE" session list 2>/dev/null | head -3
exit $code
