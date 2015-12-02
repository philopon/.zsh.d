ZSHD=$HOME/${$(readlink ~/.zshrc):h} 
fpath=($ZSHD/fpath(N-/) $fpath)

#{{{ zplug
export ZPLUG_HOME=$ZSHD/zplug

if [[ ! -f $ZPLUG_HOME/zplug ]] &> /dev/null; then
    curl -fLo $ZPLUG_HOME/zplug --create-dirs git.io/zplug
fi

source $ZPLUG_HOME/zplug
source $ZSHD/plugins.zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
#}}}

#{{{ misc config
export HISTFILE=$ZSHD/history
export HISTSIZE=100000
export SAVEHIST=100000

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^p' history-beginning-search-backward-end
bindkey '^n' history-beginning-search-forward-end

autoload -Uz listup-pathenv
eval $(listup-pathenv ~/.paths)

setopt PROMPT_SUBST

autoload -Uz compaudit; compaudit
autoload -Uz compinit; compinit
unsetopt automenu
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
zstyle ":anyframe:selector:" use fzf

bindkey '^r' anyframe-widget-put-history
bindkey '^x^k' anyframe-widget-kill
bindkey '^x^f' anyframe-widget-insert-filename
bindkey '^x^j' anyframe-widget-zshmark-jump
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

# vim:set ft=zsh foldmethod=marker foldmarker={{{,}}} :
