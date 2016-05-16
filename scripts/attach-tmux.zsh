() {
    if hash tmux &> /dev/null; then

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

        [[ -z "$SSH_CONNECTION" ]] && return

        if [[ -z "$TMUX" ]]; then
            [[ ! -f ~/.tmux.conf ]] && ln -sf $ZDOTDIR/tmux.conf ~/.tmux.conf
            [[ ! -d ~/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
            exec attach-tmux

        elif ((`grep @plugin $ZDOTDIR/tmux.conf | wc -l` - `ls ~/.tmux/plugins|wc -l` > 0)); then
            tmux run-shell ~/.tmux/plugins/tpm/bindings/install_plugins
        fi
    fi
}
