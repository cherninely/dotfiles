#!/usr/bin/env zsh

# ---------- PATH & env ----------
# Homebrew first (Apple Silicon). Sets PATH/MANPATH/INFOPATH.
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/.bin:$PATH"

# ---------- Shared dotfiles ----------
# .exports (env), .aliases, .functions, .extra (local-only), .path (optional)
for file in ~/.{path,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# ---------- keybindings ----------
# Force emacs-mode: zsh would otherwise pick vi-mode from $EDITOR=nvim
bindkey -e

# ---------- zsh options ----------
setopt AUTO_CD                # `dirname` jumps without `cd`
setopt AUTO_PUSHD             # cd pushes to dir stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt EXTENDED_GLOB          # **/*, qualifiers, negation (^)
setopt INTERACTIVE_COMMENTS   # allow # in interactive shells
setopt NO_BEEP
setopt CORRECT                # suggest corrections for mistyped commands

# ---------- History ----------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=32768
SAVEHIST=32768
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# ---------- Completion ----------
# Add brew site-functions to fpath BEFORE compinit
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit
compinit -i

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

# git completion for `g` alias (replaces `complete -F _git g`)
compdef g=git

# SSH host completion from ~/.ssh/config (replaces bash `complete -W`)
if [ -r "$HOME/.ssh/config" ]; then
    _ssh_hosts=(${(f)"$(awk '/^Host / && !/[?*]/{for(i=2;i<=NF;i++)print $i}' ~/.ssh/config)"})
    zstyle ':completion:*:(ssh|scp|sftp):*' hosts $_ssh_hosts
fi

# ---------- Plugins ----------
# Order: fzf-tab -> zsh-syntax-highlighting -> zsh-autosuggestions

# fzf-tab: fuzzy completion with preview (cloned by bootstrap.sh, not in brew)
[ -f "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh" ] && source "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh"

# fzf-tab tweaks
zstyle ':fzf-tab:*' fzf-flags --height=60% --layout=reverse --border
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null || ls -1 $realpath'
zstyle ':fzf-tab:complete:(git|arc)-*:*' fzf-preview 'git log --oneline --color=always -20 $word 2>/dev/null'

# zsh-syntax-highlighting (must be near end)
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions (last)
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# fzf keybindings (Ctrl-R history, Ctrl-T files, Alt-C cd)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Ctrl-R: при отмене (Esc/Ctrl-C/Ctrl-G) вернуть набранный в fzf query в строку,
# чтобы можно было дописать команду, а не начинать заново.
export FZF_CTRL_R_OPTS='--bind=esc:print-query+abort,ctrl-c:print-query+abort,ctrl-g:print-query+abort'

# ---------- SSH agent socket for tmux ----------
if [[ $SSH_AUTH_SOCK && $SSH_AUTH_SOCK != $HOME/.ssh/ssh_auth_sock ]]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi

# ---------- YDB CLI ----------
[ -f "$HOME/ydb/path.bash.inc" ] && source "$HOME/ydb/path.bash.inc"

# ---------- Prompt ----------
command -v starship >/dev/null && eval "$(starship init zsh)"
