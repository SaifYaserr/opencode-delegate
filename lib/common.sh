# Shared by every ocd command. Loads the project's .opencode/project.env.
# shellcheck disable=SC2034
ocd_load() {
  ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  OCD_PROJECT_SKILL="project-rules"
  OCD_PATH_PREFIX=""
  OCD_CHECKS="npm run -s lint|npm run -s typecheck|npm test --silent"
  OCD_RISKY_PATHS='migrations/|\.sql$|/auth/|security|/api/|\.env|config\.'
  OCD_REDFLAGS='security definer|grant |service_role|dangerouslySetInnerHTML|eval\(|console\.log|TODO|: any\b|as any\b'
  OCD_EXTRA_CHECKS=""
  OCD_PLANNER="step-5-preview-free"
  OCD_BUILDER="mimo-v2.6-flash-free"
  OCD_REVIEWER="step-5-preview-free"
  OCD_FALLBACK="nemotron-3-ultra-free"
  OCD_LOGDIR="${TMPDIR:-/tmp}/ocd-$(basename "$ROOT")"
  OCD_SPEC_DIR=""
  # shellcheck source=/dev/null
  [ -f "$ROOT/.opencode/project.env" ] && . "$ROOT/.opencode/project.env"
  [ -n "$OCD_PATH_PREFIX" ] && export PATH="$OCD_PATH_PREFIX:$PATH"
  mkdir -p "$OCD_LOGDIR"
  OPENCODE="${OPENCODE:-$(command -v opencode || echo "$HOME/.opencode/bin/opencode")}"
}

# fill <template-name> key=value ... -> stdout. {{project_skill}} is always set.
ocd_fill() {
  local tpl="$OCD_HOME/templates/$1.md"; shift
  local text; text="$(cat "$tpl")"
  text="${text//\{\{project_skill\}\}/$OCD_PROJECT_SKILL}"
  text="${text//\{\{ocd_home\}\}/$OCD_HOME}"
  for kv in "$@"; do text="${text//\{\{${kv%%=*}\}\}/${kv#*=}}"; done
  printf '%s\n' "$text"
}
