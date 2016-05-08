() {
    local ZPLUG_INIT=$ZPLUG_HOME/init.zsh
    [[ ! -f $ZPLUG_INIT ]] && git clone https://github.com/zplug/zplug $ZPLUG_HOME
    source $ZPLUG_INIT

    source $ZDOTDIR/packages.zsh

    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi

    zplug load --verbose 2> /dev/null

    export PATH=$ZPLUG_HOME/bin:$PATH

    local LAST_UPDATED=$ZCACHEDIR/last_updated
    [[ ! -f $LAST_UPDATED ]] && echo 0 > $LAST_UPDATED

    local DATE=`date +%s`
    if (( $DATE > `cat $LAST_UPDATED` + 24 * 3600 )); then
        zplug update
        echo "$DATE" > $LAST_UPDATED
    fi

    if zplug check $ZDOTDIR/local/attach-tmux; then
        [[ -z "$TMUX" && -n "$SSH_CONNECTION" ]] && exec attach-tmux
    fi

    [[ -f $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local
}
