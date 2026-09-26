#!/usr/bin/env bash
# Состояние дочерней сессии по имени окна tmux: что делает панель и что дочка
# сказала последним. Ничего не запускает и не меняет.
set -euo pipefail

usage() {
  cat <<'U'
usage: status.sh NAME [--tmux-session S] [--socket PATH] [--lines N]
  NAME     имя окна, которое открыл subtask.sh
  --lines  сколько последних строк ответа дочки показать (по умолчанию 40)
U
}

NAME=""; TSESSION=""; SOCKET=""; LINES=40
while [ $# -gt 0 ]; do
  case "$1" in
    --tmux-session) TSESSION=$2; shift 2 ;;
    --socket) SOCKET=$2; shift 2 ;;
    --lines) LINES=$2; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "неизвестный аргумент: $1" >&2; usage; exit 2 ;;
    *) NAME=$1; shift ;;
  esac
done
[ -n "$NAME" ] || { usage; exit 2; }

if [ -n "$SOCKET" ]; then SOCK=$SOCKET
elif [ -n "${TMUX:-}" ]; then SOCK=${TMUX%%,*}
else SOCK=/tmp/tm-$(whoami); fi
TM=(tmux -S "$SOCK")

# Окно ищем по всем сессиям сокета, если сессия не задана: имя окна и так уникально
# в рамках subtask.sh, а родитель может сидеть вне tmux.
# Разделитель — байт 0x1f: однобайтовый (read с многобайтовым IFS не работает) и не
# пробельный (пустые поля вроде незаданного @cc_state не схлопываются).
US=$'\x1f'
FMT="#S${US}#I${US}#{pane_id}${US}#{pane_current_command}${US}#{pane_current_path}${US}#{@cc_state}${US}#{@cc_uuid}${US}#{@cc_ticket}"
if [ -n "$TSESSION" ]; then
  ROW=$("${TM[@]}" list-panes -t "=$TSESSION:$NAME" -F "$FMT" 2>/dev/null | head -1 || true)
else
  ROW=$("${TM[@]}" list-panes -a -F "#W${US}${FMT}" 2>/dev/null \
        | awk -F "$US" -v n="$NAME" '$1 == n { print substr($0, length($1) + 2); exit }' || true)
fi
[ -n "$ROW" ] || { echo "окна «${NAME}» нет на $SOCK" >&2; exit 1; }
IFS="$US" read -r SESS IDX PANE CMD CWD STATE UUID TICKET <<< "$ROW"

case "$STATE" in
  working) HUMAN="⏳ работает" ;;
  blocked) HUMAN="❓ ждёт ответа в своём окне" ;;
  done)    HUMAN="✅ остановилась, результат ждёт прочтения" ;;
  waiting) HUMAN="⌛ ждёт чего-то снаружи (помечено вручную)" ;;
  *) case "$CMD" in
       [0-9]*.[0-9]*) HUMAN="· запущена, состояние ещё не опубликовано" ;;
       *) HUMAN="✗ claude не запущен (в панели $CMD)" ;;
     esac ;;
esac
echo "окно $IDX «${NAME}» в сессии $SESS: $HUMAN${TICKET:+ · тикет https://st.yandex-team.ru/$TICKET}"

[ -n "$UUID" ] || { echo "в панели нет @cc_uuid: транскрипт не найти" >&2; exit 0; }
PROJ=~/.claude/projects/$(printf '%s' "$CWD" | sed 's/[^A-Za-z0-9-]/-/g')
F="$PROJ/$UUID.jsonl"
[ -f "$F" ] || F=$(find ~/.claude/projects -maxdepth 2 -name "$UUID.jsonl" 2>/dev/null | head -1 || true)
[ -n "$F" ] && [ -f "$F" ] || { echo "транскрипт $UUID.jsonl не найден" >&2; exit 0; }

LAST_TS=$(jq -r 'select(.timestamp) | .timestamp' "$F" | tail -1)
# Записи type=user с tool_result — это ответы инструментов, не сообщения человека.
N_USER=$(jq -r 'select(.type=="user") | select((.message.content | type) == "string" or ([.message.content[]? | select(.type == "tool_result")] | length) == 0) | .uuid' "$F" | wc -l | tr -d ' ')
echo "session_id $UUID · последняя запись $LAST_TS · сообщений пользователя $N_USER"
echo "--- последний ответ дочки:"
# Текст одного ответа может лежать в нескольких записях с одним message.id; берём все
# записи последнего id.
jq -r --arg lines "$LINES" '
  select(.type=="assistant") | {id: .message.id, text: ([.message.content[]? | select(.type=="text") | .text] | join("\n"))} | select(.text != "")' "$F" \
  | jq -rs 'if length == 0 then "(текстовых ответов ещё нет)" else (.[-1].id) as $last | [.[] | select(.id == $last) | .text] | join("\n") end' \
  | tail -n "$LINES"
