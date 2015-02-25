function _wcnew() {

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    PROJECTS_LIST='video3 video_touch_phone video_touch_pad images3 images_touch_phone images_touch_pad images_smart video2 images2'
    OPTS_LIST='--make'
    cd ~

    if [[ ${COMP_CWORD} == 1  ]] ; then # при вводе подкоманды первого уровня: существующие WC
        COMPREPLY=( $(compgen -d -- ${cur})  )
        return 0
    fi

    if [[ ${COMP_CWORD} == 2  ]] ; then # при вводе подкоманды 2-го уровня: известные проекты
        COMPREPLY=( $(compgen -W "$PROJECTS_LIST" -- "$cur") )
        return 0
    fi

    if [[ ${COMP_CWORD} == 3  ]] ; then # Подсказки по опциям
        COMPREPLY=( $(compgen -W "$OPTS_LIST" -- "$cur") )
        return 0
    fi

    return 0

}

complete -F _wcnew_complition.bash wcnew
