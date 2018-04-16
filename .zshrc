local ZPLUG_INIT=$ZPLUG_HOME/init.zsh
local LAST_UPDATED=$ZCACHEDIR/last_updated

bindkey -e

source $ZDOTDIR/scripts/attach-tmux.zsh

[[ ! -f $ZPLUG_INIT ]] && git clone https://github.com/zplug/zplug $ZPLUG_HOME
source $ZPLUG_INIT

source $ZDOTDIR/packages.zsh

zplug check --verbose || zplug install

[[ ! -f $LAST_UPDATED ]] && echo 0 > $LAST_UPDATED

local DATE=`date +%s`
if (( $DATE > `cat $LAST_UPDATED` + 7 * 24 * 3600 )); then
    (
        cd $ZDOTDIR
        git fetch
        local BRANCH=`git rev-parse --abbrev-ref HEAD`
        if git format-patch $BRANCH..origin/$BRANCH --stdout | git apply --check 2> /dev/null; then
            git merge origin/$BRANCH $BRANCH
        fi
    )

    (
        cd $ZPLUG_HOME
        git pull
    )

    zplug check --verbose || zplug install
    zplug update
    echo "$DATE" > $LAST_UPDATED
fi

zplug load

[[ -f $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local

update-zshrc() {
    rm $ZCACHEDIR/last_updated
    exec zsh
}

hash direnv 2> /dev/null && eval "$(direnv hook zsh)"
