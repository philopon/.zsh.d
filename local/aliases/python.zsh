python(){
    if [[ -z "$VIRTUAL_ENV" ]] && hash python3 &> /dev/null; then
        command python3 "$@"
        return $?
    fi

    command python "$@"
    return $?
}
