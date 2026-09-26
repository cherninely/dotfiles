#!/bin/bash
# PreToolUse hook for the built-in Grep and Glob tools.
#
# Denies a search whose root is "wide": `/`, an ancestor-or-equal of $HOME,
# an ancestor-or-equal of the current arc repo root, or any arc repo root
# (e.g. ~/arcadia, ~/arcadia-worktrees/*). Traversing the FUSE-mounted
# monorepo never finishes and draws the attention of security.
#
# A search scoped to a project subdirectory (hyperenv/, ai/artifacts/, ...)
# is allowed. Companion of ai/artifacts/hooks/block-find-arcadia-root.sh,
# which applies the same policy to shell commands (find/grep -r/rg/...).
#
# Local, AISuite-free port of the policy behind the AISuite `restrict_search`
# hook (ai/tools/aisuite/cli/hook/handlers/common/restrict_search_hook_grep.py).

JQ=$(command -v jq 2>/dev/null || echo "ya tool jq")
INPUT=$(cat | tr '[:cntrl:]' ' ')

TOOL=$(printf '%s' "$INPUT" | $JQ -r '.tool_name // empty')
case "$TOOL" in
  Grep|Glob) ;;
  *) exit 0 ;;
esac

CWD=$(printf '%s' "$INPUT" | $JQ -r '.cwd // empty')
RAW=$(printf '%s' "$INPUT" | $JQ -r '.tool_input.path // empty')

# Search root: explicit path operand, else the cwd.
[ -z "$RAW" ] && RAW="$CWD"
[ -z "$RAW" ] && exit 0

P="${RAW/#\~/$HOME}"
case "$P" in
  /*) ;;
  *) P="${CWD:-.}/$P" ;;
esac

# A single file as the search root is never wide.
if [ -f "$P" ]; then
  exit 0
fi
# Normalize (resolve symlinks, strip trailing slash). Missing dir -> let the tool fail itself.
P=$(cd "$P" 2>/dev/null && pwd -P) || exit 0

REPO_ROOT=""
[ -n "$CWD" ] && REPO_ROOT=$(cd "$CWD" 2>/dev/null && arc root 2>/dev/null)
REPO_ROOT="${REPO_ROOT%/}"

is_dangerous() {
  local p="$1" r
  [ "$p" = "/" ] && return 0
  # ancestor-or-equal of $HOME (covers /Users, $HOME itself)
  if [ "$HOME" = "$p" ] || [ "${HOME#"$p"/}" != "$HOME" ]; then
    return 0
  fi
  # ancestor-or-equal of the current repo root
  if [ -n "$REPO_ROOT" ] && { [ "$REPO_ROOT" = "$p" ] || [ "${REPO_ROOT#"$p"/}" != "$REPO_ROOT" ]; }; then
    return 0
  fi
  # the path itself is an arc repo root (any checkout / worktree)
  r=$(cd "$p" 2>/dev/null && arc root 2>/dev/null)
  [ -n "$r" ] && [ "${r%/}" = "$p" ] && return 0
  return 1
}

if is_dangerous "$P"; then
  $JQ -n --arg reason "Слишком широкий поиск ($TOOL от $P): корень Аркадии, \$HOME или /. Это обход FUSE-монорепозитория, он не завершится. Сузь path до поддиректории проекта (например ~/arcadia/hyperenv) или используй ya grep --remote / ast-index / ya tool cs." '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
fi
exit 0
