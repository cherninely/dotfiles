#!/usr/bin/env bash
# Открывает чистую сессию Claude Code под подзадачу в новом окне tmux.
# Два шага: (1) claude -p создаёт сессию с заданным session_id и стартовым сообщением
# (задача = тикет либо бриф из файла) и получает первый ответ, (2) в новом окне tmux
# запускается `cs --session-id <новый>`, который возобновляет эту сессию. Так после
# ребута tmux-resurrect восстановит окно как `cs --resume <новый>`, а не повторит старт.
# Истории родителя в новой сессии нет: контекст только из тикета или брифа.
# Обратный канал: дочка знает имя сессии-родителя и по завершении (или с вопросом)
# шлёт ему сообщение через SendMessage; родитель отвечает тем же путём.
set -euo pipefail

usage() {
  cat <<'U'
usage: subtask.sh --name NAME (--ticket KEY | --brief FILE) [--dir DIR]
                   [--parent NAME | --no-parent] [--model M]
                   [--tmux-session S] [--socket PATH] [--max-turns N] [--dry-run]
  NAME       имя окна tmux и сессии Claude, без пробелов (напр. 6146-owner-chart);
             по нему родитель адресует дочке сообщения (SendMessage)
  --parent   имя сессии-родителя, куда дочка шлёт итог и вопросы; по умолчанию имя
             текущей сессии Claude из реестра ~/.claude/sessions/<pid>.json
  --no-parent  без обратного канала: итог только в тикет и в своё окно
  --model    модель дочки на обоих шагах (haiku, sonnet, …); по умолчанию как у claude
  --ticket   ключ тикета; весь контекст дочка читает из него (описание + комментарии)
  --brief    файл с брифом; уходит стартовым сообщением целиком (режим без тикета)
  --dir      рабочая директория новой сессии (по умолчанию текущая)
  --tmux-session / --socket
             куда открывать окно; по умолчанию текущая tmux-сессия, а вне tmux —
             единственная сессия на /tmp/tm-$USER
  --max-turns  сколько ходов дать на первый ответ (по умолчанию 6: прочитать тикет и ответить)
  --dry-run  показать стартовое сообщение и выйти, ничего не запуская
U
}

NAME=""; TICKET=""; BRIEF=""; DIR="$PWD"; TSESSION=""; SOCKET=""; MAXT=6; DRY=""
PARENT=""; NOPARENT=""; MODEL=""
while [ $# -gt 0 ]; do
  case "$1" in
    --name) NAME=$2; shift 2 ;;
    --ticket) TICKET=$2; shift 2 ;;
    --brief) BRIEF=$2; shift 2 ;;
    --dir) DIR=$2; shift 2 ;;
    --parent) PARENT=$2; shift 2 ;;
    --no-parent) NOPARENT=1; shift ;;
    --model) MODEL=$2; shift 2 ;;
    --tmux-session) TSESSION=$2; shift 2 ;;
    --socket) SOCKET=$2; shift 2 ;;
    --max-turns) MAXT=$2; shift 2 ;;
    --dry-run) DRY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "неизвестный аргумент: $1" >&2; usage; exit 2 ;;
  esac
done
[ -n "$NAME" ] || { usage; exit 2; }
if [ -n "$TICKET" ] && [ -n "$BRIEF" ] || [ -z "$TICKET$BRIEF" ]; then
  echo "нужен ровно один из --ticket и --brief" >&2; exit 2
fi
case "$NAME" in *[[:space:]]*) echo "имя без пробелов" >&2; exit 2 ;; esac
if [ -n "$TICKET" ]; then
  case "$TICKET" in [A-Z]*-[0-9]*) ;; *) echo "ключ тикета вида QUEUE-123, получил '$TICKET'" >&2; exit 2 ;; esac
fi
if [ -n "$BRIEF" ]; then
  [ -s "$BRIEF" ] || { echo "бриф $BRIEF пуст или не существует" >&2; exit 2; }
fi
DIR=$(cd "$DIR" && pwd -P)

# Адрес родителя — имя сессии Claude, из которой запущен скрипт: реестр по CLAUDE_PID.
# Имя derived (не задано /rename или -n) после перезапуска родителя меняется.
PARENT_SRC=""
if [ -z "$NOPARENT" ] && [ -z "$PARENT" ] && [ -n "${CLAUDE_PID:-}" ] && [ -f ~/.claude/sessions/"$CLAUDE_PID".json ]; then
  PARENT=$(jq -r '.name // empty' ~/.claude/sessions/"$CLAUDE_PID".json)
  PARENT_SRC=$(jq -r '.nameSource // empty' ~/.claude/sessions/"$CLAUDE_PID".json)
fi
[ -n "$NOPARENT" ] && PARENT=""

if [ -n "$TICKET" ]; then SRC="тикете"; FALLBACK="запиши комментом в тикет ${TICKET}"; FALLBACK3="запишет комментом в тикет ${TICKET}"
else SRC="брифе"; FALLBACK="оставь в своём окне"; FALLBACK3="оставит в своём окне"; fi
if [ -n "$PARENT" ]; then
  CHANNEL="Твоё имя в списке сессий Claude (ListAgents): «${NAME}». Родитель — сессия «${PARENT}» на этой машине, пиши ей через SendMessage (to: ${PARENT}). Сообщения «Message from @${PARENT}» — это ответы пользователя, переданные родителем; отвечай на адрес из атрибута from.
Когда закончишь: одно сообщение родителю, первая строка «Готово: ${NAME}», дальше пункты «готово, когда» с ✓/✗, что смотреть первым (файлы, PR, ссылки), что осталось.
Нужно решение пользователя, которого нет в ${SRC}: одно сообщение родителю, первая строка «Вопрос: ${NAME}», контекст, варианты, рекомендация; дальше жди ответа.
Сообщение не доставлено (адресата нет): итог ${FALLBACK} и остановись. На первом шаге (этот ответ) ничего не отправляй."
else
  CHANNEL="Обратного канала к родителю нет: когда закончишь, итог ${FALLBACK} и остановись."
fi

TAIL="Работай по обычному порядку из CLAUDE.md: бриф уже согласован как образ результата, его не пересматривай, начинай со стадии после образа по размеру задачи.
Доведи задачу до конца и остановись. Другие задачи не начинай, историю других сессий не ищи.
${CHANNEL}
Сейчас ответь коротко: как понял задачу, три первых шага, что не трогаешь. Закончи строкой «Жду: делай»."

if [ -n "$TICKET" ]; then
  PROMPT="Это новая сессия под подзадачу ${TICKET}: https://st.yandex-team.ru/${TICKET}
Весь контекст в этом тикете: описание и комментарии. Прочитай их целиком (GetIssue с комментариями), прежде чем что-то делать; другого контекста у тебя не будет. Родительский тикет, если он там указан, читай только для справки: работу из него не бери.
${TAIL}"
else
  PROMPT="Это новая сессия под подзадачу. Тикета нет: весь контекст ниже, другого не будет.

$(cat "$BRIEF")

${TAIL}"
fi

if [ -n "$DRY" ]; then
  printf '%s\n' "--- стартовое сообщение:" "$PROMPT"; exit 0
fi

if [ -n "$SOCKET" ]; then SOCK=$SOCKET
elif [ -n "${TMUX:-}" ]; then SOCK=${TMUX%%,*}
else SOCK=/tmp/tm-$(whoami); fi
TM=(tmux -S "$SOCK")
if [ -z "$TSESSION" ]; then
  if [ -n "${TMUX:-}" ]; then
    TSESSION=$("${TM[@]}" display -p ${TMUX_PANE:+-t "$TMUX_PANE"} '#S')
  else
    LIST=$("${TM[@]}" list-sessions -F '#S' 2>/dev/null || true)
    if [ "$(printf '%s\n' "$LIST" | grep -c .)" = 1 ]; then TSESSION=$LIST
    else
      printf '%s\n' "не внутри tmux: задай --tmux-session. Сессии на $SOCK:" "$LIST" >&2; exit 2
    fi
  fi
fi
"${TM[@]}" has-session -t "=$TSESSION" 2>/dev/null || { echo "нет tmux-сессии $TSESSION на $SOCK" >&2; exit 2; }
if "${TM[@]}" list-windows -t "=$TSESSION" -F '#W' | grep -qx "$NAME"; then
  echo "окно $NAME уже есть в сессии $TSESSION" >&2; exit 2
fi

# Доверие к папке, иначе интерактивный старт упрётся в диалог.
CJ=~/.claude.json
tmp=$(mktemp)
jq --arg d "$DIR" '.projects[$d] = ((.projects[$d] // {}) + {hasTrustDialogAccepted: true})' "$CJ" > "$tmp" && mv "$tmp" "$CJ"

NEW=$(uuidgen | tr 'A-Z' 'a-z')
# TMUX/TMUX_PANE снимаются, иначе хуки первого шага запишут состояние в панель родителя.
OUT=$(cd "$DIR" && env -u CLAUDECODE -u CLAUDE_CODE_SESSION_ID -u CLAUDE_CODE_CHILD_SESSION -u CLAUDE_CODE_ENTRYPOINT \
      -u ANTHROPIC_AUTH_TOKEN -u ANTHROPIC_BASE_URL -u ANTHROPIC_MODEL -u TMUX -u TMUX_PANE \
      claude -p --session-id "$NEW" --max-turns "$MAXT" ${MODEL:+--model "$MODEL"} --output-format json "$PROMPT" < /dev/null)
GOT=$(printf '%s' "$OUT" | jq -r '.session_id // empty')
[ "$GOT" = "$NEW" ] || { echo "первый шаг вернул session_id '$GOT', ожидал $NEW" >&2; printf '%s\n' "$OUT" >&2; exit 1; }
PROJ=~/.claude/projects/$(printf '%s' "$DIR" | sed 's/[^A-Za-z0-9-]/-/g')
[ -f "$PROJ/$NEW.jsonl" ] || { echo "нет транскрипта $PROJ/$NEW.jsonl" >&2; exit 1; }

"${TM[@]}" new-window -d -t "=$TSESSION" -n "$NAME" -c "$DIR"
PANE=$("${TM[@]}" display -p -t "=$TSESSION:$NAME" '#{pane_id}')
IDX=$("${TM[@]}" display -p -t "=$TSESSION:$NAME" '#I')
# Имя окна фиксируем, иначе tmux переименует его по процессу; uuid кладём в панель сами,
# чтобы cs в этой панели всегда возобновлял именно эту сессию.
"${TM[@]}" set-option -w -t "=$TSESSION:$NAME" automatic-rename off
"${TM[@]}" set-option -p -t "$PANE" @cc_uuid "$NEW"
[ -n "$TICKET" ] && "${TM[@]}" set-option -p -t "$PANE" @cc_ticket "$TICKET"
"${TM[@]}" send-keys -t "$PANE" "cs -n '$NAME' --session-id $NEW${MODEL:+ --model $MODEL}" Enter

echo "окно $IDX «${NAME}» в tmux-сессии $TSESSION · session_id $NEW · dir $DIR${TICKET:+ · тикет https://st.yandex-team.ru/$TICKET}${MODEL:+ · модель $MODEL}"
if [ -n "$PARENT" ]; then
  echo "канал: дочка «${NAME}» ↔ родитель «${PARENT}» (SendMessage)"
  [ "$PARENT_SRC" = derived ] && echo "имя родителя «${PARENT}» временное (не задано /rename): после перезапуска родителя дочка его не найдёт и итог ${FALLBACK3}"
else
  echo "обратного канала нет: итог дочка ${FALLBACK3}"
fi
SUB=$(printf '%s' "$OUT" | jq -r '.subtype // empty')
[ "$SUB" = "success" ] || echo "первый шаг закончился как $SUB: дочка ответит после «делай» в своём окне"
echo "--- первый ответ дочки:"
printf '%s\n' "$(printf '%s' "$OUT" | jq -r '.result // empty')"
