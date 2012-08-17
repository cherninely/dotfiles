# export
export LANG=ru_RU.UTF-8
export PS1="`whoami`@`hostname | sed 's/\..*//'`:\w > "
export BLOCKSIZE=K;
export EDITOR=vim;
export PAGER=more;

# aliases
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

# functions

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
            sudo chown -R $USER:www $PROJECT_PATH && svn up $PROJECT_PATH/* && gmake -B -C $PROJECT_PATH
        else
            echo $PROJECT | ssh -i ~/dotfiles/ssh/zelo-access-one kaa@$JAIL
        fi

    done
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
