function _tanker_complition() {

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ ${COMP_CWORD} == 1  ]] ; then # при вводе подкоманды первого уровня:
        COMPREPLY=( $(compgen -W "sync" -- ${cur})  )
        return 0
    fi

    return 0

}

complete -F _tanker_complition tanker
