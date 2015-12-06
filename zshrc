# PROFILING=1
[[ -n "$PROFILING" ]] && zmodload zsh/zprof && zprof

ZSH_DIR=$HOME/.zsh.d
fpath=($ZSH_DIR/fpath(N-/) $fpath)

#{{{ zgen
ZGEN_DIR=$ZSH_DIR/.zgen
ZGEN_RESET_ON_CHANGE=($ZSH_DIR/plugins.zsh)

if [ ! -f "$ZSH_DIR/zgen/zgen.zsh" ]; then
    git clone https://github.com/tarjoilija/zgen.git $ZSH_DIR/zgen
fi

source $ZSH_DIR/zgen/zgen.zsh

if ! zgen saved; then
    source $ZSH_DIR/plugins.zsh
    zgen save
fi
#}}}

#{{{ misc config
export HISTFILE=$ZSH_DIR/history
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

autoload -Uz listup-pathenv
eval $(listup-pathenv ~/.paths)

setopt PROMPT_SUBST

unsetopt automenu
#}}}

#{{{fzf
FZF_DIR=$ZGEN_DIR/junegunn/fzf-master
$FZF_DIR/install --bin > /dev/null
export PATH=$FZF_DIR/bin:$PATH
source $FZF_DIR/shell/completion.zsh
source $FZF_DIR/shell/key-bindings.zsh
#}}}

#{{{ vim alias, EDITOR
if command -v Vim > /dev/null; then
    alias vim=Vim
fi

alias vi=vim
alias v=vim

export EDITOR=vim
#}}}

#{{{ anyframe
command -v fzf > /dev/null && zstyle ":anyframe:selector:" use fzf

bindkey '^r' anyframe-widget-put-history
bindkey '^x^k' anyframe-widget-kill
bindkey '^x^f' anyframe-widget-insert-filename
bindkey '^x^j' anyframe-widget-zshmark-jump
#}}}

#{{{ LS_COLORS
DIRCOLORS_THEME=$ZGEN_DIR/seebi/dircolors-solarized-master/dircolors.ansi-dark
command -v gdircolors > /dev/null && DIRCOLORS=gdircolors
command -v dircolors > /dev/null && DIRCOLORS=dircolors

if [[ -n "$DIRCOLORS" ]] && [[ -f "$DIRCOLORS_THEME" ]]; then
    eval $($DIRCOLORS $DIRCOLORS_THEME)
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

#}}}

#{{{ ls aliases
alias ll="ls -l"
alias llh="ll -h"
alias la="ls -a"
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

# vim:set ft=zsh foldmethod=marker foldmarker={{{,}}} :

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
