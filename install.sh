#!/usr/bin/env bash
# Links this repo into the places Claude Code, opencode and your shell look:
#   ~/.local/bin/ocd                          the CLI
#   ~/.claude/skills/opencode-delegate        Claude-side workflow skill (all projects)
#   ~/.config/opencode/skills/delegate-core   opencode-side shared rules (all projects)
# Symlinks, so `ocd update` (git pull) reaches every project at once. Safe to re-run.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
link() { mkdir -p "$(dirname "$2")"; [ -L "$2" ] && rm "$2"; [ -e "$2" ] && { echo "skip $2 (exists, not a link)"; return; }; ln -s "$1" "$2"; echo "linked $2"; }
chmod +x "$here"/bin/ocd "$here"/lib/*.sh
link "$here/bin/ocd" "$HOME/.local/bin/ocd"
link "$here/skills/claude/opencode-delegate" "$HOME/.claude/skills/opencode-delegate"
link "$here/skills/opencode/delegate-core" "$HOME/.config/opencode/skills/delegate-core"
command -v opencode >/dev/null || [ -x "$HOME/.opencode/bin/opencode" ] || echo "note: install opencode (https://opencode.ai)"
command -v graphify >/dev/null || echo "note: graphify is optional but recommended (code graph for cheap lookups)"
echo "done. In a project: ocd init --draft"
