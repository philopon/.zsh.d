typeset -U path PATH

ZDOTDIR=~/.zsh.d
ZCACHEDIR=~/.cache/zsh
ZPLUG_HOME=$ZCACHEDIR/zplug

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

export EDITOR=`which vim`
export PAGER=`which less`

export GOPATH=$HOME/.go:$HOME/.ghq

PATH=$HOME/.go/bin:~/.local/bin:/usr/local/bin:$PATH

[[ ! -d $ZCACHEDIR ]] && mkdir -p $ZCACHEDIR
