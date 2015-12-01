ZSHD=$HOME/${$(readlink ~/.zshrc):h} 

#{{{ zplug
export ZPLUG_HOME=$ZSHD/zplug

if [[ ! -f $ZPLUG_HOME/zplug ]] &> /dev/null; then
    curl -fLo $ZPLUG_HOME/zplug --create-dirs git.io/zplug
fi

source $ZPLUG_HOME/zplug

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
#}}}

#{{{ misc config
autoload -Uz colors
colors

export HISTFILE=$ZSHD/history
export HISTSIZE=100000
export SAVEHIST=100000

setopt PROMPT_SUBST

eval $($ZSHD/bin/paths.zsh ~/.paths)
#}}}

#{{{ vim alias, EDITOR
if type Vim &> /dev/null; then 
    alias vim=Vim
fi

alias vi=vim
alias v=vim

export EDITOR=vim
#}}}

#{{{ anyframe
autoload -Uz anyframe-init 
anyframe-init

zstyle ":anyframe:selector:" use fzf

bindkey '^r' anyframe-widget-execute-history
#}}}

#{{{ LS_COLORS
DIRCOLORS_THEME=$ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.ansi-dark
type gdircolors &> /dev/null && DIRCOLORS=gdircolors
type dircolors &> /dev/null && DIRCOLORS=dircolors

if [[ -n "$DIRCOLORS" ]] && [[ -f "$DIRCOLORS_THEME" ]]; then
    eval $(gdircolors $DIRCOLORS_THEME)
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

type gls &> /dev/null && alias ls="gls --color=auto"
#}}}

#{{{ ls aliases
alias ll="ls -l"
alias llh="ll -h"
alias la="ls -a"
#}}}

#{{{ direnv
command -v direnv > /dev/null && eval "$(direnv hook zsh)"
#}}}

# vim:set foldmethod=marker foldmarker={{{,}}} :
