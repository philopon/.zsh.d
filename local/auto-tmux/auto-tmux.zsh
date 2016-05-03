__attach-tmux () {
    local result=`tmux list-session 2> /dev/null`
    if [[ $? == 0 ]]; then
        result=`
            set -o pipefail;
            cat <(echo $result | grep -v '(attached)$') <(echo ":: new session")\
                | fzf --select-1 --exit-0\
                | cut -d: -f1
            `

        [[ $? != 0 ]] && result=

        if [[ -z "$result" ]]; then
            exec tmux new-session
        else
            exec tmux attach-session -t $result
        fi
    fi
}

[[ -z "$TMUX" && -n "$SSH_CONNECTION" ]] && __attach-tmux
