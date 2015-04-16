
# tanker-kit completion. Use in conjunction with tanker-cli or global tanker-kit
_tanker_completion() {
    TANKERCOMP="$(tanker comp -c "${COMP_LINE}" -p "${COMP_CWORD}" 2> /dev/null)"
    COMPREPLY=($(IFS=$'\n' compgen -W "${TANKERCOMP}" -- "${COMP_WORDS[COMP_CWORD]}"))
}

complete -o default -F _tanker_completion tanker
# ------------------------------------------------------------------------------
