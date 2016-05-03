local ZPLUG_INIT=$ZPLUG_HOME/init.zsh
[[ ! -f $ZPLUG_HOME/init.zsh ]] && curl -sL git.io/zplug | zsh
source $ZPLUG_HOME/init.zsh

source $ZDOTDIR/packages.zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
