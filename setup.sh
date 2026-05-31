#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SETTINGS_SRC="$SCRIPT_DIR/claude/settings-ollama.json"
SETTINGS_DST="$HOME/.claude/settings.json"

MODELS=(
  "deepseek-v4-flash:cloud"
  "deepseek-v4-pro:cloud"
  "glm-5.1:cloud"
)

usage() {
  cat <<EOF
claude-worker setup — initialize ollama models and claude code settings

Usage: $(basename "$0") <command>

Commands:
  pull    Pull all required ollama models
  link    Symlink settings-ollama.json to ~/.claude/settings.json
  all     Run pull + link (default if no command given)
  help    Show this help message

Options:
  --dry-run   Show what would be done without executing
EOF
}

info()  { echo "[INFO]  $*"; }
warn()  { echo "[WARN]  $*" >&2; }
err()   { echo "[ERROR] $*" >&2; }

cmd_pull() {
  local dry_run=false
  [[ "${1:-}" == "--dry-run" ]] && dry_run=true

  info "Pulling Ollama models from settings-ollama.json..."
  for model in "${MODELS[@]}"; do
    if $dry_run; then
      info "Would pull: $model"
    else
      info "Pulling: $model"
      ollama pull "$model"
    fi
  done
  $dry_run || info "All models pulled."
}

cmd_link() {
  local dry_run=false
  [[ "${1:-}" == "--dry-run" ]] && dry_run=true

  if [[ ! -f "$SETTINGS_SRC" ]]; then
    err "Source not found: $SETTINGS_SRC"
    return 1
  fi

  if [[ -L "$SETTINGS_DST" && "$(readlink "$SETTINGS_DST")" == "$SETTINGS_SRC" ]]; then
    info "Already linked: $SETTINGS_DST -> $SETTINGS_SRC"
    return 0
  fi

  if [[ -e "$SETTINGS_DST" && ! -L "$SETTINGS_DST" ]]; then
    warn "Existing file at $SETTINGS_DST (not a symlink). Backing up to ${SETTINGS_DST}.bak"
    $dry_run && info "Would back up: $SETTINGS_DST -> ${SETTINGS_DST}.bak" && return 0
    mv "$SETTINGS_DST" "${SETTINGS_DST}.bak"
  fi

  if $dry_run; then
    info "Would link: $SETTINGS_DST -> $SETTINGS_SRC"
  else
    mkdir -p "$(dirname "$SETTINGS_DST")"
    ln -sf "$SETTINGS_SRC" "$SETTINGS_DST"
    info "Linked: $SETTINGS_DST -> $SETTINGS_SRC"
  fi
}

cmd_all() {
  local dry_run=false
  [[ "${1:-}" == "--dry-run" ]] && dry_run=true

  cmd_pull "${dry_run:+--dry-run}"
  cmd_link "${dry_run:+--dry-run}"
}

# --- main ---
DRY_RUN=false
COMMAND=""

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    help|pull|link|all) COMMAND="$arg" ;;
    *) err "Unknown argument: $arg"; usage; exit 1 ;;
  esac
done

: "${COMMAND:=all}"

case "$COMMAND" in
  help)  usage ;;
  pull)  cmd_pull $($DRY_RUN && echo "--dry-run") ;;
  link)  cmd_link $(! $DRY_RUN || echo "--dry-run") ;;
  all)   cmd_all $(! $DRY_RUN || echo "--dry-run") ;;
esac