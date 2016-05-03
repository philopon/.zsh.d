attach-tmux () {
    local result=`tmux list-session 2> /dev/null`
    if [[ -z "$result" ]]; then
        tmux new-session
        return $?
    fi

    local list=`
    cat <(echo "$result" | grep -v '(attached)$') <(echo :: NEW SESSION)
    `

    result=`echo "$list" | fzf --exit-0`
    if [[ $? != 0 ]]; then
        tmux new-session
        return $?
    fi

    result=`echo $result | cut -d: -f1`
    echo $result

    if [[ -z "$result" ]]; then
        tmux new-session
        return $?
    fi

    tmux attach-session -t $result
}
