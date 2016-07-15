typeset -U path PATH

ZDOTDIR=~/.zsh.d
ZCACHEDIR=~/.cache/zsh
ZPLUG_HOME=$ZCACHEDIR/zplug

export EDITOR=`which vim`
export PAGER=`which less`

export GOPATH=$HOME/.go

PATH=$GOPATH/bin:~/.local/bin:/usr/local/bin:$PATH

[[ ! -d $ZCACHEDIR ]] && mkdir -p $ZCACHEDIR
