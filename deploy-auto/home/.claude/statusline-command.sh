#!/usr/bin/env bash
# Claude Code status line script

input=$(cat)

# --- Colors ---
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

FG_WHITE="\033[97m"
FG_CYAN="\033[36m"
FG_YELLOW="\033[33m"
FG_GREEN="\033[32m"
FG_MAGENTA="\033[35m"
FG_BLUE="\033[34m"
FG_RED="\033[31m"

# --- Model ---
model=$(echo "$input" | jq -r '.model.display_name // "Unknown model"')

# --- Billing mode ---
# work: launched via `c` alias → ANTHROPIC_AUTH_TOKEN is set (paid API)
# sub:  launched via `cs` alias → token unset (Anthropic subscription)
if [ -n "$ANTHROPIC_AUTH_TOKEN" ]; then
  BILLING_LABEL="work"
  BILLING_COLOR="$FG_YELLOW"
else
  BILLING_LABEL="sub"
  BILLING_COLOR="$FG_GREEN"
fi

# --- Context window ---
# Real occupied context = input_tokens + cache_creation + cache_read.
# `current_usage.input_tokens` alone is only the new tokens sent this turn.
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
current_input=$(echo "$input" | jq -r '
  (.context_window.current_usage.input_tokens // 0) +
  (.context_window.current_usage.cache_creation_input_tokens // 0) +
  (.context_window.current_usage.cache_read_input_tokens // 0)
')

if [ -n "$used_pct" ]; then
  used_int=$(echo "$used_pct" | awk '{printf "%d", int($1 + 0.5)}')
else
  used_int=0
fi

# Pick ctx color based on usage
if [ "$used_int" -ge 85 ]; then
  CTX_COLOR="$FG_RED"
elif [ "$used_int" -ge 60 ]; then
  CTX_COLOR="$FG_YELLOW"
else
  CTX_COLOR="$FG_MAGENTA"
fi

# Format context size as "200k"
ctx_k=$(echo "$ctx_size" | awk '{printf "%dk", $1/1000}')
ctx_used_k=$(echo "$current_input" | awk '{printf "%dk", $1/1000}')

# --- Subscription quota (only in `sub` mode and only when rate_limits present) ---
# Claude.ai Pro/Max exposes rate_limits.five_hour and rate_limits.seven_day with
# `used_percentage` (0-100) and `resets_at` (unix seconds). Show remaining %.
quota_segment=""
if [ "$BILLING_LABEL" = "sub" ]; then
  five_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
  seven_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
  # resets_at: unix seconds when the window resets
  five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
  seven_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

  # Time left until a reset timestamp: 3d4h / 12h / 2h13m / 45m / 30s. Empty if unknown.
  fmt_reset() {
    local target="$1"
    case "$target" in ''|*[!0-9]*) return 0 ;; esac
    local now remaining h m d hr
    now=$(date +%s)
    remaining=$(( target - now ))
    [ "$remaining" -le 0 ] && { printf "0s"; return 0; }
    h=$(( remaining / 3600 ))
    m=$(( (remaining % 3600) / 60 ))
    d=$(( h / 24 ))
    hr=$(( h % 24 ))
    if [ "$d" -gt 0 ]; then
      printf "%dd%dh" "$d" "$hr"
    elif [ "$h" -gt 9 ]; then
      printf "%dh" "$h"
    elif [ "$h" -gt 0 ]; then
      printf "%dh%dm" "$h" "$m"
    elif [ "$m" -gt 0 ]; then
      printf "%dm" "$m"
    else
      printf "%ds" "$remaining"
    fi
  }

  format_quota() {
    local used="$1"
    local label="$2"
    local resets_at="$3"
    local remaining
    remaining=$(awk -v u="$used" 'BEGIN{r=100-u; if(r<0)r=0; printf "%d", r+0.5}')
    local color="$FG_GREEN"
    if [ "$remaining" -le 15 ]; then
      color="$FG_RED"
    elif [ "$remaining" -le 40 ]; then
      color="$FG_YELLOW"
    fi
    printf "  ${DIM}${FG_WHITE}%s${RESET} ${color}%s%%${RESET}" "$label" "$remaining"
    local left
    left=$(fmt_reset "$resets_at")
    if [ -n "$left" ]; then
      printf " ${DIM}(%s)${RESET}" "$left"
    fi
  }

  if [ -n "$five_used" ]; then
    quota_segment+=$(format_quota "$five_used" "5h" "$five_reset")
  fi
  if [ -n "$seven_used" ]; then
    quota_segment+=$(format_quota "$seven_used" "7d" "$seven_reset")
  fi
fi

# --- Assemble output ---
printf "${DIM}${FG_CYAN}⬡ ${BOLD}%s${RESET}" "$model"
printf "  ${BOLD}${BILLING_COLOR}[%s]${RESET}" "$BILLING_LABEL"
printf "  ${DIM}${CTX_COLOR}ctx ${ctx_used_k}/${ctx_k} (%s%%)${RESET}" "$used_int"
printf "%b" "$quota_segment"
printf "\n"
