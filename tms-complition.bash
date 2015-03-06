function _tms_complition() {

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ ${COMP_CWORD} == 1  ]] ; then # при вводе подкоманды первого уровня:
        COMPREPLY=( $(compgen -W "$(tm ls | sed -r 's/:.+$//g' | xargs)" -- ${cur})  )
        return 0
    fi

    return 0

}

complete -F _tms_complition tms
