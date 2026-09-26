#!/bin/bash
# PreToolUse hook for Bash: block `git` inside an Arcadia (arc) checkout.
#
# Agents habitually type `git status` / `git diff` in ~/arcadia, get a
# confusing error and waste turns. Inside an arc repo this hook denies any
# segment of the command whose executable is `git` or `git-<sub>` and points
# at `arc`. Outside Arcadia (git repos in ~/yandex-cloud, Home Assistant, ...)
# it does nothing. Escape hatch: prefix the command with AISUITE_ALLOW_GIT=1.
#
# Unlike the AISuite `restrict_git` hook this is fail-open: a command the
# regex does not understand is allowed, not blocked.
#
# Local, AISuite-free port of
# ai/tools/aisuite/cli/hook/handlers/common/restrict_git_hook_shell.py.

JQ=$(command -v jq 2>/dev/null || echo "ya tool jq")
INPUT=$(cat)

CMD=$(printf '%s' "$INPUT" | $JQ -r '.tool_input.command // empty')
[ -z "$CMD" ] && exit 0

# Explicit opt-out.
case "$CMD" in
  *AISUITE_ALLOW_GIT=1*) exit 0 ;;
esac

# Cheap pre-filter before spawning arc.
case "$CMD" in
  *git*) ;;
  *) exit 0 ;;
esac

# `git` (or `git-foo`) as the executable of a command segment: at the start,
# after ; & | ( ` or newline, or after $( — optionally preceded by VAR=val
# assignments. `| grep git` or "git" inside a quoted string does not match.
SEG_START='(^|[;&|(`]|\$\()[[:space:]]*'
ENV_ASSIGN='([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*'
GIT_EXE='git(-[A-Za-z][A-Za-z0-9-]*)?([[:space:]]|$)'
if ! printf '%s\n' "$CMD" | grep -qE "${SEG_START}${ENV_ASSIGN}${GIT_EXE}"; then
  exit 0
fi

CWD=$(printf '%s' "$INPUT" | $JQ -r '.cwd // empty')
[ -z "$CWD" ] && exit 0

# `cd <dir> && git ...` from outside: judge by the cd target, not the session cwd.
CD_TARGET=$(printf '%s\n' "$CMD" | sed -nE 's/^[[:space:]]*cd[[:space:]]+("([^"]+)"|'"'"'([^'"'"']+)'"'"'|([^[:space:];&|]+)).*$/\2\3\4/p' | head -n 1)
if [ -n "$CD_TARGET" ]; then
  CD_TARGET="${CD_TARGET/#\~/$HOME}"
  case "$CD_TARGET" in
    /*) CWD="$CD_TARGET" ;;
    *)  CWD="$CWD/$CD_TARGET" ;;
  esac
fi
# Only inside an arc checkout.
REPO_ROOT=$(cd "$CWD" 2>/dev/null && arc root 2>/dev/null)
[ -z "$REPO_ROOT" ] && exit 0

$JQ -n --arg reason "Это чекаут Arcadia ($REPO_ROOT), не git-репозиторий. Используй arc: arc status / arc diff / arc log / arc branch / arc commit / arc push (см. скилл arc). Если git нужен намеренно, добавь префикс AISUITE_ALLOW_GIT=1 к команде." '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: $reason
  }
}'
exit 0
