export PATH=$HOME/node_modules/.bin:$HOME/bin:$PATH:/sbin:/bin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/Berkanavt/bin:/Berkanavt/bin/scripts:$HOME/bin

export BLOCKSIZE=K;
export EDITOR=vim;
export PAGER=more;

alias ll='ls -laFo'
alias l='ls -l'
alias la='ls -la'
alias ltr='ls -ltr'

alias vim='vim -O'

alias restart-apache='/hol/arkanavt/report/scripts/dev/restart-upperapache'
alias stop-apache='sudo sudo /usr/local/etc/rc.d/apache.sh stop'
alias start-apache='sudo /usr/local/etc/rc.d/apache.sh start'

alias svn='~/bin/svn'
alias svn-conflict='svn st | awk ''$1 ~ "C" { print $2 }'''
alias mo='mergeone'

wclog()
{
    if [ -z "$1" -o ! -d "/home/$USER/$1/" ]; then
        tail -f "/var/tmp/$USER-d-trunk.log"
    else
        tail -f "/var/tmp/$USER-d-${1}.log"
    fi
}

svndiff()
{
    svn diff "${@}" | colordiff
}

gitdiff()
{
    git diff "${@}" | colordiff
}

# показать svn коммиты пользователя за сегодня
userlogs()
{
    svn log ${@:2} -r {`date -v+1d +"%Y-%m-%d"`}:{`date +"%Y-%m-%d"`} | sed -n "/| $1 |/,/-----$/ p"
}

export LANG=ru_RU.UTF-8

export PS1="`whoami`@`hostname | sed 's/\..*//'`:\w > "

if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    alias ack=ack-grep
else
    alias ls='ls -G'
    export LSCOLORS="Exfxcxdxbxegedabagacad"
fi

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

_expand()
{
    return 0;
}
