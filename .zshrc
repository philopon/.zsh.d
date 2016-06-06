() {
    local ZPLUG_INIT=$ZPLUG_HOME/init.zsh
    local LAST_UPDATED=$ZCACHEDIR/last_updated

    source $ZDOTDIR/scripts/attach-tmux.zsh

    [[ ! -f $ZPLUG_INIT ]] && git clone https://github.com/zplug/zplug $ZPLUG_HOME
    source $ZPLUG_INIT

    source $ZDOTDIR/packages.zsh

    zplug check --verbose || rm $LAST_UPDATED

    zplug load --verbose 2> /dev/null

    export PATH=$ZPLUG_HOME/bin:$PATH

    [[ ! -f $LAST_UPDATED ]] && echo 0 > $LAST_UPDATED

    local DATE=`date +%s`
    if (( $DATE > `cat $LAST_UPDATED` + 24 * 3600 )); then
        (
            cd $ZDOTDIR
            git fetch
            local BRANCH=`git rev-parse --abbrev-ref HEAD`
            if git format-patch $BRANCH..origin/$BRANCH --stdout | git apply --check 2> /dev/null; then
                git merge origin/$BRANCH $BRANCH
            fi
        )
        zplug check --verbose || zplug install
        zplug update
        zplug clean --force
        zplug clear
        echo "$DATE" > $LAST_UPDATED
        exec zsh
    fi

    [[ -f $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local
}
