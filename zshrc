# PROFILING=1
[[ -n "$PROFILING" ]] && zmodload zsh/zprof && zprof

ZSH_DIR=$HOME/.zsh.d
ZDOTDIR=$ZSH_DIR

#{{{ zplug
ZPLUG_HOME=$ZSH_DIR

if [ ! -f "$ZPLUG_HOME/zplug" ]; then
    curl -fLo $ZPLUG_HOME/zplug --create-dirs https://git.io/zplug
    source $ZPLUG_HOME/zplug
    zplug update --self
else
    source $ZPLUG_HOME/zplug
fi

source $ZSH_DIR/plugins.zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
#}}}

#{{{ misc config
export HISTFILE=$ZSH_DIR/.history
export HISTSIZE=100000
export SAVEHIST=100000
setopt append_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_save_by_copy
setopt share_history
setopt auto_pushd

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^p' history-beginning-search-backward-end
bindkey '^n' history-beginning-search-forward-end

setopt PROMPT_SUBST
setopt complete_aliases

unsetopt automenu
#}}}

alias ghc="stack ghc --"; compdef ghc=ghc
alias ghci="stack ghci"; compdef ghci=ghc
alias runghc="stack runghc --"; compdef ghci=ghc
alias runhaskell="stack runghc --"; compdef ghci=ghc

#{{{ vim alias, EDITOR
if command -v Vim > /dev/null; then
    alias vim=Vim
fi

if command -v vim > /dev/null; then
    alias vi=vim; compdef vi=vim
    alias v=vim; compdef v=vim

    export EDITOR=vim
fi
#}}}

#{{{ anyframe
if zplug check mollifier/anyframe; then
    command -v fzf > /dev/null && zstyle ":anyframe:selector:" use fzf

    bindkey '^r' anyframe-widget-put-history
    bindkey '^x^k' anyframe-widget-kill
    bindkey '^x^f' anyframe-widget-insert-filename
fi
#}}}

#{{{ ls aliases
alias ll="ls -l"; compdef ll=ls
alias llh="ll -h"; compdef llh=ls
alias la="ls -a"; compdef la=ls
#}}}

#{{{ direnv
command -v direnv > /dev/null && eval "$(direnv hook zsh)"
#}}}

#{{{ OS specific
case "$OSTYPE" in
    darwin*)
        command -v gls > /dev/null && alias ls="gls --color=auto"
        export HOMEBREW_CASK_OPTS="--appdir=/Applications"
    ;;
    linux*)
        alias ls='ls --color=auto'
    ;;
esac
#}}}

#{{{ profile result
if (command -v zprof > /dev/null) ;then
  zprof | less
fi
#}}}

if zplug check b4b4r07/enhancd; then
    export ENHANCD_DIR=$ZSH_DIR/.enhancd
    export ENHANCD_LOG=$ENHANCD_DIR/enhancd.log

    _enhancd-cd(){
        cd
        local f
        for f in $precmd_functions; do
            $f
        done
        zle reset-prompt
    }
    zle -N _enhancd-cd
    bindkey '^x^j' _enhancd-cd
fi

# vim:set ft=zsh foldmethod=marker foldmarker={{{,}}} :
