function _wcnew_complition() {

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    PROJECTS_LIST='fiji video3 video_touch_phone video_touch_pad images3 images_touch_phone video2 images2 web4 granny'
    OPTS_LIST='--make --tmux'
    cd ~

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

    if [ ${COMP_CWORD} -ge 3  ] ; then # Подсказки по опциям
        COMPREPLY=( $(compgen -W "$OPTS_LIST" -- "$cur") )
        return 0
    fi

    return 0

}

complete -F _wcnew_complition wcnew
