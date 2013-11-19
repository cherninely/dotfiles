# add ~/bin to PATH
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

source ~/dotfiles/git-completion.bash

# export
export LANG=ru_RU.UTF-8
export PS1="`whoami`@`hostname | sed 's/\..*//'`:\w > "
export BLOCKSIZE=K;
export EDITOR=vim;
export PAGER=less;
export CLICOLOR=yes; # git colors
export TERM=xterm-256color

# aliases
alias ll='ls -laFo'
alias l='ls -l'
alias la='ls -la'
alias ltr='ls -ltr'

alias vim='vim -O'

alias apache-restart='sudo /usr/local/etc/rc.d/apache.sh restart'
alias apache-stop='sudo /usr/local/etc/rc.d/apache.sh stop'
alias apache-start='sudo /usr/local/etc/rc.d/apache.sh start'

alias mine='sudo chown -R $USER:www .'

if [ -f ~/bin/svn ]; then
    alias svn='~/bin/svn';
fi
alias svn-conflict='svn st | awk ''$1 ~ "C" { print $2 }'''
alias mo='mergeone'

# functions

# посмотреть логи рабочей копии
wclog()
{
    tail -f /var/tmp/$USER-d-*
}

# цветной diff svn
svndiff()
{
    svn diff "${@}" | colordiff
}

# цветной diff git
gitdiff()
{
    git diff "${@}" | colordiff
}

alias gitlog="git log --graph --oneline --all --date=short"

# показать svn коммиты пользователя за сегодня
# или за диапазон, указанный вторым параметром (ex: -7d)
userlogs()
{
    DATE=${2:-+0d}
    svn log -r {`date -v+1d +"%Y-%m-%d"`}:{`date -v$DATE +"%Y-%m-%d"`} | sed -n "/| $1 |/,/-----$/ p"
}

# Work Copy Update
# wcup - update default project in local jail
# wcup project [server] - update project on specified jail
# wcup project1+project2[+projectN] [server] - update multiple projects on specified jail
wcup()
{
    DEFAULT_PROJECT="images2"
    DEFAULT_JAIL=$(hostname)

    JAIL=${2:-$DEFAULT_JAIL}
    PROJECTS=${1:-$DEFAULT_PROJECT}

    export IFS="+"
    for PROJECT in $PROJECTS; do

        echo -e "\033[33m=== UPDATE === \nPROJECT: \033[31m$PROJECT \033[33m\nJAIL   : \033[31m$JAIL \033[0m"

        if [[ $DEFAULT_JAIL == $JAIL* ]]; then
            PROJECT_PATH="/hol/arkanavt/report/templates/YxWeb/"$PROJECT;
            TEMP_PRJ_PATH=$PROJECT_PATH;
            export TEMP_PRJ_PATH;
            sudo chown -R $USER:www $PROJECT_PATH && bash -c 'cd $TEMP_PRJ_PATH/;  git pull --rebase' && gmake -B -C $PROJECT_PATH
        else
            echo $PROJECT | ssh -i ~/dotfiles/ssh/zelo-access-one kaa@$JAIL
        fi

    done
}

# обновить данные джейла с zelo
dataup()
{
    sudo rsync -av --exclude '*.000' zelo::arkanavt/data.runtime/ /hol/arkanavt/data.runtime
    sudo rsync -av --exclude '*.000' zelo::arkanavt/passport/ /hol/arkanavt/passport
}

# рисует горизонтальную линию и очищает экран
drawline()
{
    SEPARATOR="-"
    WIDTH=$(tput cols);
    echo -e "\033[$(($RANDOM % 7 + 31))m"
    for ((i=0; i<$WIDTH; i++)); do echo -n $SEPARATOR ; done
    echo -e "\033[0m"
    clear
}

# редактировать commit-message указанного коммита
svnedit()
{
    svn propedit -r${1} --revprop svn:log
}

# подмаунтить jail
# используется http://osxfuse.github.com/
jailmount()
{
    JAIL=${1:-"leon42.yandex.ru"}
    echo -e "\033[33m===> MOUNT JAIL: \033[31m$JAIL \033[0m"
    mkdir -p /mount/$JAIL
    jailunmount $JAIL
    sshfs $USER@$JAIL:/ /mount/$JAIL -oauto_cache,reconnect,volname=$1
}

# размаунтить джейл
jailunmount()
{
    JAIL=${1:-"leon42.yandex.ru"}
    umount /mount/$1 >/dev/null
}

# replace git read-only protocol to pushable ssh in current git repo
alias gitssh='sed -ie "s/git:\/\/\([^\/]*\)\/\(.*\)/git@\1:\2/g" .git/config'

# Tmux stuff

# Save ssh agent socket for using in tmux sessions
if [[ $SSH_AUTH_SOCK && $SSH_AUTH_SOCK != $HOME/.ssh/ssh_auth_sock ]]; then
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi

# wrapper for tmux, using socket assigned to user
function tm { tmux -2 -S /tmp/tm-`whoami` "$@"; }

# Tmux session alias for pair-programming
# Syntax:
#    Server:
#        tm-pair <feature>
#    Client:
#        tm-pair <user> <feature>
function tm-pair
{
    if [ ${2} ]; then
        tmux -2 -S /tmp/tm-${1} attach -t ${2}
    else
        tmux -2 -S /tmp/tm-`whoami` new -s ${1}
    fi
}
