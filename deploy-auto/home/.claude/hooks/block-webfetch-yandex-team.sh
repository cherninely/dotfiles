#!/bin/bash
# PreToolUse hook for WebFetch: block internal yandex-team.ru URLs.
#
# WebFetch has no corporate auth, so such requests end with 401/redirect and
# waste a turn. Deny by hostname (yandex-team.ru and any subdomain; scheme,
# port, path and query are ignored) and point the agent at the right tool.
#
# Local, AISuite-free port of the AISuite Go-native `restrict_web_fetch` hook
# (ai/tools/aisuite/hooks/core).

JQ=$(command -v jq 2>/dev/null || echo "ya tool jq")
INPUT=$(cat)

URL=$(printf '%s' "$INPUT" | $JQ -r '.tool_input.url // empty')
[ -z "$URL" ] && exit 0

# scheme:// -> user@ -> path/query/fragment -> :port ; lowercase
HOST=$(printf '%s' "$URL" \
  | sed -E 's#^[A-Za-z][A-Za-z0-9+.-]*://##; s#^[^/?\#]*@##; s#[/?\#].*$##; s#:[0-9]+$##' \
  | tr '[:upper:]' '[:lower:]')

case "$HOST" in
  yandex-team.ru|*.yandex-team.ru) ;;
  *) exit 0 ;;
esac

case "$HOST" in
  st.yandex-team.ru|st-api.yandex-team.ru) HINT="Tracker MCP (mcp__tracker_mcp__GetIssue и др.) или скилл startrek-client" ;;
  wiki.yandex-team.ru)                    HINT="скилл wiki-client (ya tool gena-wiki-cli pages get)" ;;
  docs.yandex-team.ru)                    HINT="скилл docs" ;;
  a.yandex-team.ru|arcanum.yandex-team.ru) HINT="локальный чекаут ~/arcadia, arc / ya grep --remote; для PR — Arcanum MCP или скилл arcanum" ;;
  paste.yandex-team.ru)                   HINT="ya curl -s <url>/text (авторизованный curl) или ya paste" ;;
  *)                                      HINT="профильный MCP/скилл, intrasearch, либо авторизованный ya curl -s <url>" ;;
esac

$JQ -n --arg reason "WebFetch не умеет корпоративную авторизацию, запрос к $HOST вернёт 401. Вместо него: $HINT." '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: $reason
  }
}'
exit 0
