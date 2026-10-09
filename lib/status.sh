#!/usr/bin/env bash
# One line per opencode run (logs in $OCD_LOGDIR) + changed files per worktree.
. "$OCD_HOME/lib/common.sh"; ocd_load
logdir="${1:-$OCD_LOGDIR}"
for log in "$logdir"/run*.log "$logdir"/xr-*.log "$logdir"/fix-*.log; do
  [ -e "$log" ] || continue
  age=$(( ($(date +%s) - $(stat -c %Y "$log")) / 60 ))
  last=$(grep -aE '^\S*(→|←|\$|✱)' "$log" | tail -1 | sed 's/\x1b\[[0-9;]*m//g' | cut -c1-90)
  state=running; [ "$age" -ge 3 ] && state="idle ${age}m"
  grep -aq TIMEOUT "$log" && state=TIMEOUT
  grep -aq "NEEDS REVIEWER" "$log" && state="NEEDS REVIEWER"
  printf '%-28s %-16s %s\n' "$(basename "$log" .log)" "$state" "$last"
done
echo "--- worktrees"
git worktree list 2>/dev/null | while read -r dir _ branch; do
  printf '%-50s %s  changed:%s\n' "$dir" "$branch" "$(git -C "$dir" status -s | grep -vc '\.opencode/')"
done
