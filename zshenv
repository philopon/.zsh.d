typeset -U path PATH

ZDOTDIR=~/.zsh.d
ZCACHEDIR=~/.cache/zsh
ZPLUG_HOME=$ZCACHEDIR/zplug
EDITOR=vi
PAGER=less

PATH=~/.local/bin:/usr/local/bin:$PATH

[[ ! -d $ZCACHEDIR ]] && mkdir -p $ZCACHEDIR
