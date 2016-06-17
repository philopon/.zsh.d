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

pip(){
    if [[ -z "$VIRTUAL_ENV" ]] && hash pip3 &> /dev/null; then
        pip_wrapper pip3 "$@"
        return $?
    fi

    pip_wrapper pip "$@"
    return $?
}

alias pip2="pip_wrapper pip2"
alias pip3="pip_wrapper pip3"
