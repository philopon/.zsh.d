local ZPLUG_INIT=$ZPLUG_HOME/init.zsh
[[ ! -f $ZPLUG_HOME/init.zsh ]] && git clone https://github.com/b4b4r07/zplug $ZPLUG_HOME
source $ZPLUG_HOME/init.zsh

source $ZDOTDIR/packages.zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load --verbose 2> /dev/null

export PATH=$ZPLUG_HOME/bin:$PATH

[[ -z "$TMUX" && -n "$SSH_CONNECTION" ]] && exec attach-tmux
