() {
    source $ZDOTDIR/scripts/attach-tmux.zsh

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
        (
            cd $ZDOTDIR
            git fetch
            local BRANCH=`git rev-parse --abbrev-ref HEAD`
            if git format-patch $BRANCH..origin/$BRANCH --stdout | git apply --check; then
                git merge origin/$BRANCH $BRANCH
            fi
        )
        zplug update
        echo "$DATE" > $LAST_UPDATED
    fi

    [[ -f $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local
}
