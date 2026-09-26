#!/bin/bash
# Claude Code hook: publish the session's state into its own tmux pane, so that
# prefix+s (choose-tree) and the status line can show what each session needs
# from the user.
#
# @cc_state on the pane:
#   working  - UserPromptSubmit, PreToolUse;
#              also Stop while a background shell command (Bash with
#              run_in_background) is still running: the turn is over only
#              formally, claude wakes up on the task notification and there is
#              no result to read yet
#   blocked  - PermissionRequest, Notification (permission_prompt|elicitation_dialog):
#              claude cannot continue without an answer
#   done     - Stop, StopFailure: the turn is over, a result is waiting;
#              also toggled by prefix+m in tmux (~/bin/cc-tmux-park)
#   waiting  - never written here: set by prefix+w in tmux (~/bin/cc-tmux-wait) when the
#              conversation waits for something outside; any event below replaces it
#   (unset)  - SessionStart (startup, clear), SessionEnd: nothing has happened yet / nothing left;
#              also toggled off by prefix+m: the user read the result
# The pane is taken from $TMUX_PANE, which claude inherits from the shell, so
# no pid lookup is needed. Unlike the BEL/@unread flash in .tmux.conf this is a
# persistent state: it survives looking at the session and only changes when
# the session actually moves on.
#
# Outside tmux it exits immediately. Fail-open: tmux errors are ignored.

[ -n "$TMUX_PANE" ] || exit 0

# Background Bash commands are the only background work visible from outside:
# each one is a shell sourcing ~/.claude/shell-snapshots/… somewhere under the
# pane's process tree. Claude Code sends no hook event for them. The hook's own
# ancestors are skipped in case hooks get spawned the same way. Background
# subagents (Agent tool) have no process of their own and are not detected.
bg_shell_running() {
    local pane_pid own p a
    pane_pid=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_pid}' 2>/dev/null)
    [ -n "$pane_pid" ] || return 1
    own=" "
    p=$$
    while [ -n "$p" ] && [ "$p" -gt 1 ]; do
        own="$own$p "
        p=$(ps -o ppid= -p "$p" 2>/dev/null | tr -d ' ')
    done
    for p in $(pgrep -f '\.claude/shell-snapshots/' 2>/dev/null); do
        case "$own" in *" $p "*) continue ;; esac
        a=$p
        while [ -n "$a" ] && [ "$a" -gt 1 ]; do
            [ "$a" = "$pane_pid" ] && return 0
            a=$(ps -o ppid= -p "$a" 2>/dev/null | tr -d ' ')
        done
    done
    return 1
}

input=$(cat)

# claude wipes the pane title ("✳ name") on exit, and a sleeping pane would lose its
# name in the tabs and in prefix+s; `cs` puts this copy back after claude returns.
title=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_title}' 2>/dev/null)
case "$title" in *✳*) tmux set-option -p -t "$TMUX_PANE" @cc_title "$title" 2>/dev/null ;; esac

event=$(jq -r '.hook_event_name // empty' <<<"$input" 2>/dev/null)
src=$(jq -r '.source // empty' <<<"$input" 2>/dev/null)
case "$event" in
    UserPromptSubmit|PreToolUse)       state=working ;;
    PermissionRequest|Notification)    state=blocked ;;
    Stop)   if bg_shell_running; then state=working; else state=done; fi ;;
    StopFailure)                       state=done ;;
    # A resume or compact keeps the state: after a reboot it was put back by
    # ~/bin/cc-tmux-state-persist from the resurrect save.
    # cc-sleep ends the session on purpose (@cc_sleeping): the tab keeps its ✅/💤.
    SessionStart|SessionEnd)
        [ "$event" = SessionStart ] && [ "$src" = resume -o "$src" = compact ] && exit 0
        [ "$event" = SessionEnd ] && [ -n "$(tmux show-options -pqv -t "$TMUX_PANE" @cc_sleeping 2>/dev/null)" ] && exit 0
        tmux set-option -pu -t "$TMUX_PANE" @cc_state 2>/dev/null
        exit 0 ;;
    *) exit 0 ;;
esac

tmux set-option -p -t "$TMUX_PANE" @cc_state "$state" 2>/dev/null
# Age of the state for cc-sleep --auto.
tmux set-option -p -t "$TMUX_PANE" @cc_state_at "$(date +%s)" 2>/dev/null
exit 0
