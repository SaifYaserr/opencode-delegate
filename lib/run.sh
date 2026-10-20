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

# One attempt, streamed to stdout. opencode sometimes never starts a session and prints nothing until the
# timeout (seen three times with v2.0.26), so a run with no tool call after $OCD_STALL seconds is stopped: 125.
attempt() {
  local out started=0 start=$SECONDS pid tailpid c
  out=$(mktemp)
  timeout --signal=INT "${minutes}m" "$OPENCODE" "${args[@]}" "$(cat "$prompt")" > "$out" 2>&1 &
  pid=$!
  tail -n +1 -f --pid=$pid "$out" & tailpid=$!
  while kill -0 $pid 2>/dev/null; do
    if [ $started -eq 0 ]; then
      if grep -aqE '→|←|✱|\$ ' "$out"; then started=1
      elif (( SECONDS - start > ${OCD_STALL:-600} )); then
        kill -INT $pid; wait $pid; wait $tailpid; rm -f "$out"; return 125
      fi
    fi
    sleep 5
  done
  wait $pid; c=$?; wait $tailpid; rm -f "$out"; return $c
}

attempt; code=$?
if [ $code -eq 125 ]; then
  echo "STALLED: no tool call in ${OCD_STALL:-600}s, starting again"
  attempt; code=$?
fi
# Not on a timeout (124) or an interrupt by the reviewer (130 SIGINT, 143 SIGTERM).
if [ $code -ne 0 ] && [ $code -ne 124 ] && [ $code -ne 130 ] && [ $code -ne 143 ] && [ -n "$OCD_FALLBACK" ] && [ "$OCD_FALLBACK" != "$model" ]; then
  echo "FAILED on $model (exit $code), retrying on $OCD_FALLBACK"
  args[4]="opencode/$OCD_FALLBACK"
  attempt; code=$?
fi
[ $code -eq 124 ] && echo "TIMEOUT after ${minutes}m: resume with -s and a narrower prompt"
"$OPENCODE" session list 2>/dev/null | head -3
exit $code
