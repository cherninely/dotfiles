#!/bin/bash
# PreToolUse hook for Bash: PRs are created as drafts, never published and
# never get reviewers unless the user explicitly asks in the current request.
#
# Denies, in any segment of the command:
#   arc pr create / arc pr c / arc submit  without --publish=disabled,
#                                          or with --publish[=upload|ci-success],
#                                          -A/--auto, -r/--reviewer
#   arc pr publish
#   arc push -p/--publish
#   gh pr create                           without -d/--draft, or with -r/--reviewer
#   gh pr ready
#   gh pr edit --add-reviewer
#
# Escape hatch for an explicit "опубликуй" from the user: prefix the command
# with ALLOW_PR_PUBLISH=1. Fail-open: anything the regexes do not understand
# is allowed. Same shape as block-git-in-arcadia.sh.

JQ=$(command -v jq 2>/dev/null || echo "ya tool jq")
INPUT=$(cat)

CMD=$(printf '%s' "$INPUT" | $JQ -r '.tool_input.command // empty')
[ -z "$CMD" ] && exit 0

case "$CMD" in
  *ALLOW_PR_PUBLISH=1*) exit 0 ;;
esac

# Cheap pre-filter.
case "$CMD" in
  *arc*|*gh*) ;;
  *) exit 0 ;;
esac

SP='[[:space:]]'
W="(^|$SP)"      # token start
E="($SP|$)"      # token end

deny() {
  $JQ -n --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

HINT_ARC="PR создаётся только черновиком и без ревьюеров, пользователь сначала смотрит его сам (CLAUDE.md, «Атомарные PR»). Используй: arc pr create --publish=disabled --no-commits -m \"...\". Без --publish, -A/--auto, -r/--reviewer, arc pr publish, arc push --publish. Если пользователь в текущем запросе явно попросил опубликовать — добавь префикс ALLOW_PR_PUBLISH=1."
HINT_GH="PR создаётся только черновиком и без ревьюеров, пользователь сначала смотрит его сам (CLAUDE.md, «Атомарные PR»). Используй: gh pr create --draft ... без --reviewer; gh pr ready / --add-reviewer не вызывать. Если пользователь в текущем запросе явно попросил опубликовать — добавь префикс ALLOW_PR_PUBLISH=1."

has() { printf '%s\n' "$SEG" | grep -qE -- "$1"; }

# Split into command segments on ; && || | and newlines; quoting is ignored (fail-open).
printf '%s\n' "$CMD" | sed -E 's/(&&|\|\||;|\|)/\n/g' | while IFS= read -r SEG; do
  [ -z "$SEG" ] && continue

  if has "${W}arc${SP}+(pr${SP}+(create|c)|submit)${E}"; then
    has "${W}(-A|--auto)${E}" && deny "$HINT_ARC"
    has "${W}(-r|--reviewer)(${SP}|=|$)" && deny "$HINT_ARC"
    # every --publish token must be exactly --publish=disabled, and one must be present
    if printf '%s\n' "$SEG" | grep -oE -- "--publish[^[:space:]]*" | grep -vqx -- "--publish=disabled"; then
      deny "$HINT_ARC"
    fi
    has "--publish=disabled${E}" || deny "$HINT_ARC"
  fi

  has "${W}arc${SP}+pr${SP}+publish${E}" && deny "$HINT_ARC"

  if has "${W}arc${SP}+push${E}"; then
    has "${W}(-p|--publish)${E}" && deny "$HINT_ARC"
  fi

  if has "${W}gh${SP}+pr${SP}+create${E}"; then
    has "${W}(-r|--reviewer)(${SP}|=|$)" && deny "$HINT_GH"
    has "${W}(-d|--draft)${E}" || deny "$HINT_GH"
  fi

  has "${W}gh${SP}+pr${SP}+ready${E}" && deny "$HINT_GH"

  if has "${W}gh${SP}+pr${SP}+edit${E}"; then
    has "--add-reviewer" && deny "$HINT_GH"
  fi
done
exit 0
