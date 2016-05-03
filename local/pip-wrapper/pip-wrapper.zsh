pip_wrapper(){
    local pip="$1"

    local -a args
    args=("${@[2,-1]}")

    local is_install=""
    for arg in $args; do
        if [[ "$arg" == install ]]; then
            is_install="1"
            break
        fi
    done

    if [[ -n "$is_install" && -z "$VIRTUAL_ENV" ]]; then
        args=("${args[@]}" --user)
    fi

    command $pip "${args[@]}"
}

alias pip="pip_wrapper pip"
alias pip2="pip_wrapper pip2"
alias pip3="pip_wrapper pip3"
