# PROFILING=1
[[ -n "$PROFILING" ]] && zmodload zsh/zprof && zprof

ZSH_DIR=$HOME/.zsh.d
ZDOTDIR=$ZSH_DIR

export ENHANCD_DIR=$ZSH_DIR/.enhancd

# {{{ tmux
__attach-tmux(){
    local result

    result=`set -o pipefail\
        ; cat <(tmux list-session 2> /dev/null | grep -v '(attached)$') <(echo ":: new session")\
        | fzf --select-1 --exit-0\
        | cut -d: -f1`

    [[ "$?" -ne 0 ]] && return 1

    if [[ -z "$result" ]]; then
        exec tmux new-session
    else
        exec tmux attach-session -t $result
    fi
}

[[ -f "$ZSH_DIR/.tmux_loader" && -n "$SSH_CONNECTION" ]] && source "$ZSH_DIR/.tmux_loader"
# }}}

#{{{ zplug
ZPLUG_HOME=$ZSH_DIR

[[ -d "$ZPLUG_HOME/zplug" ]] && rm -rf "$ZPLUG_HOME/zplug"
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

# {{{ check updates
[[ ! -f $ZSH_DIR/.last_updated ]] && echo 0 > $ZSH_DIR/.last_updated
if [[ `date +%s` -gt $((`cat $ZSH_DIR/.last_updated` + 24 * 3600)) ]]; then
    zplug status
    date +%s > $ZSH_DIR/.last_updated
fi
# }}}

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

# {{{ haskell alias
alias ghc="stack ghc --"; compdef ghc=ghc
alias ghci="stack ghci"; compdef ghci=ghc
alias runghc="stack runghc --"; compdef ghci=ghc
alias runhaskell="stack runghc --"; compdef ghci=ghc
# }}}

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

# {{{ save tmux config
if [[ ! -f "$ZSH_DIR/.tmux_loader" ]]; then
    cat <<EOF > $ZSH_DIR/.tmux_loader
PATH=$PATH
if command -v tmux > /dev/null; then
    [[ -z "\$TMUX" ]] && __attach-tmux
fi
EOF
    source $ZSH_DIR/.tmux_loader
fi
# }}}

pip_wrapper(){
    local pip="$1"

    local -a args
    args=("${@[2,-1]}")

    local is_install=""
    for arg in $args; do
        if [[ "$arg" == install ]]; then
            is_install="1"
            break
        fi
    done

    if [[ -n "$is_install" && -z "$VIRTUAL_ENV" ]]; then
        args=("${args[@]}" --user)
    fi

    command $pip "${args[@]}"
}

alias pip="pip_wrapper pip"
alias pip2="pip_wrapper pip2"
alias pip3="pip_wrapper pip3"

[[ -f ~/.zsh.d/zshrc.local ]] && source ~/.zsh.d/zshrc.local

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# vim:set ft=zsh foldmethod=marker foldmarker={{{,}}} :
