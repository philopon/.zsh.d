ask-pip() {
    local install
    for a in "$@"; do
        if [[ "$a" == "--user" ]]; then
            "$@"
            return $?
        fi

        if [[ "$a" == "install" ]]; then
            install=true
        fi
    done
    if [[ "$install" != true ]]; then
        "$@"
        return $?
    fi

    if [[ -n "$VIRTUAL_ENV" ]]; then
        "$@"
        return $?
    fi

    read -q "REPLY?there is no --user option. continue? (y/N)"
    echo

    if [[ "$REPLY" == "y" ]]; then
        "$@"
        return $?
    fi

    echo "abort"
    return 1
}

alias pip=pip3
alias pip2="ask-pip pip2"
alias pip3="ask-pip pip3"
