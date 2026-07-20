#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Tool registry: name -> "source_relative_to_script|destination_path"
# Add new tools here.
TOOL_CLAUDE_SRC="$SCRIPT_DIR/claude/settings-ollama.json"
TOOL_CLAUDE_DST="$HOME/.claude/settings.json"
TOOL_OPENCODE_SRC="$SCRIPT_DIR/opencode/opencode.jsonc"
TOOL_OPENCODE_DST="$HOME/.config/opencode/opencode.jsonc"

MODELS=(
  "deepseek-v4-flash:cloud"
  "deepseek-v4-pro:cloud"
  "glm-5.1:cloud"
)

usage() {
  cat <<EOF
claude-worker setup — initialize ollama models and tool settings

Usage: $(basename "$0") [options] <command>

Commands:
  pull              Pull all required ollama models (claude)
  link [TOOLS]      Symlink tool settings to the right paths.
                    TOOLS is a comma-separated list to link
                    (default: claude). Available: claude, opencode
                    Example: link opencode
  all [TOOLS]       Run pull + link (default if no command given)
  help              Show this help message

Options:
  --dry-run         Show what would be done without executing

Examples:
  $(basename "$0") link
  $(basename "$0") link opencode
  $(basename "$0") link claude,opencode
  $(basename "$0") all claude,opencode
  $(basename "$0") all claude --dry-run
EOF
}

info()  { echo "[INFO]  $*"; }
warn()  { echo "[WARN]  $*" >&2; }
err()   { echo "[ERROR] $*" >&2; }

# Resolve a tool name to "src|dst". Returns 1 if unknown.
resolve_tool() {
  local name="$1"
  case "$name" in
    claude)   echo "$TOOL_CLAUDE_SRC|$TOOL_CLAUDE_DST" ;;
    opencode) echo "$TOOL_OPENCODE_SRC|$TOOL_OPENCODE_DST" ;;
    *) err "Unknown tool: $name (available: claude, opencode)"; return 1 ;;
  esac
}

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

# Link one tool. Args: <tool_name> [--dry-run]
link_one() {
  local tool="$1"
  local dry_run="${2:-}"

  local pair src dst
  if ! pair="$(resolve_tool "$tool")"; then
    return 1
  fi
  src="${pair%|*}"
  dst="${pair#*|}"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    err "Source not found for $tool: $src"
    return 1
  fi

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    info "Already linked ($tool): $dst -> $src"
    return 0
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    if [[ -L "$dst" ]]; then
      warn "Existing symlink at $dst (not pointing to $src). Replacing."
      if [[ "$dry_run" == "--dry-run" ]]; then
        info "Would remove symlink: $dst"
      else
        rm "$dst"
      fi
    else
      warn "Existing file at $dst (not a symlink). Backing up to ${dst}.bak"
      if [[ "$dry_run" == "--dry-run" ]]; then
        info "Would back up: $dst -> ${dst}.bak"
        return 0
      fi
      mv "$dst" "${dst}.bak"
    fi
  fi

  if [[ "$dry_run" == "--dry-run" ]]; then
    info "Would link ($tool): $dst -> $src"
  else
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    info "Linked ($tool): $dst -> $src"
  fi
}

# Parse a comma-separated tool list into an array.
parse_tools() {
  local spec="$1"
  TOOLS=()
  IFS=',' read -r -a parts <<< "$spec"
  for t in "${parts[@]}"; do
    t="${t// /}"  # trim spaces
    [[ -z "$t" ]] && continue
    TOOLS+=("$t")
  done
  if [[ ${#TOOLS[@]} -eq 0 ]]; then
    err "No tools specified."
    return 1
  fi
}

cmd_link() {
  local dry_run="${1:-}"
  local tool_spec="${LINK_TOOLS:-claude}"

  parse_tools "$tool_spec" || return 1

  local failed=0
  for tool in "${TOOLS[@]}"; do
    if ! link_one "$tool" "$dry_run"; then
      failed=$((failed+1))
    fi
  done
  return $failed
}

cmd_all() {
  local dry_run="${1:-}"

  cmd_pull "$dry_run"
  cmd_link "$dry_run"
}

# --- arg parsing ---
DRY_RUN=false
COMMAND=""
LINK_TOOLS=""

ARGS=("$@")
i=0
while [[ $i -lt ${#ARGS[@]} ]]; do
  arg="${ARGS[$i]}"
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    help|pull|link|all) COMMAND="$arg" ;;
    *)
      # First non-command, non-flag arg is the optional tool list for link/all
      if [[ -z "$COMMAND" ]]; then
        err "Unknown argument: $arg"
        usage; exit 1
      fi
      if [[ "$COMMAND" == "link" || "$COMMAND" == "all" ]]; then
        if [[ -n "$LINK_TOOLS" ]]; then
          err "Unexpected extra argument: $arg"
          usage; exit 1
        fi
        LINK_TOOLS="$arg"
      else
        err "Unknown argument: $arg"
        usage; exit 1
      fi
      ;;
  esac
  i=$((i+1))
done

: "${COMMAND:=all}"

DRY_FLAG=""
$DRY_RUN && DRY_FLAG="--dry-run"

case "$COMMAND" in
  help)  usage ;;
  pull)  cmd_pull "$DRY_FLAG" ;;
  link)  cmd_link "$DRY_FLAG" ;;
  all)   cmd_all "$DRY_FLAG" ;;
esac
