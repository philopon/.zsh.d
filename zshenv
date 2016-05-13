typeset -U path PATH

ZDOTDIR=~/.zsh.d
ZCACHEDIR=~/.cache/zsh
ZPLUG_HOME=$ZCACHEDIR/zplug

export EDITOR=`which vim`
export PAGER=`which less`

PATH=~/.local/bin:/usr/local/bin:$PATH

[[ ! -d $ZCACHEDIR ]] && mkdir -p $ZCACHEDIR
