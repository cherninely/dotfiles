function _wcnew_complition() {

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    PROJECTS_LIST="$(cat ~/dotfiles/extra/fiji-projects | xargs) video2 images2 web4 granny"
    OPTS_LIST='--make --tmux --branch --feature'
    [ $WC_BIN ] && cd $WC_BIN || cd ~

    if [[ ${COMP_CWORD} == 1  ]] ; then # при вводе подкоманды первого уровня: существующие WC
        COMPREPLY=( $(compgen -d -- ${cur} | grep '^[^\.]')  )
        return 0
    fi

    if [[ ${COMP_CWORD} == 2  ]] ; then # при вводе подкоманды 2-го уровня: известные проекты
        COMPREPLY=( $(\
            compgen -W "$PROJECTS_LIST" -- "$(echo "$cur" | sed -E 's/^.+\+//')" \
            | while IFS= read -r line; do \
                if [[ `echo "$cur" | grep "+"` ]]; then
                    echo "$(echo "$cur" | sed -E 's/\+.+$/+/')$line"
                else
                    echo "$line"
                fi
            done \
        ) )
        return 0
    fi

    if [[ "$COMP_CWORD" -ge 3 ]]; then # Подсказки по опциям
        echo "$prev" > debug
        if [[ $prev = '-b' || $prev = '--branch' ]]; then
            PREV_DIR=$(pwd -L)
            create_tmp_git_repo
            cd $TMP_REPO_DIR
            COMPREPLY=( $(compgen -W "$(git br -r | sed 's|origin/||')" -- "$cur") )
            cd $PREV_DIR
        else
            COMPREPLY=( $(compgen -W "$OPTS_LIST" -- "$cur") )
        fi
        return 0
    fi

    return 0

}

function create_tmp_git_repo() {
    TMP_REPO_DIR=/tmp/tmp-fiji-for-wcnew-complition
    if [ ! -d $TMP_REPO_DIR ]; then
        git clone git@github.yandex-team.ru:mm-interfaces/fiji.git $TMP_REPO_DIR > /dev/null 2>&1
    else
        PREV_DIR=$(pwd -L)
        cd $TMP_REPO_DIR
        git pull > /dev/null 2>&1
        cd $PREV_DIR
    fi
}

complete -F _wcnew_complition wcnew
