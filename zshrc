#!/bin/zsh

source ~/.zsh.d/haskell.zsh
source ~/.zsh.d/path.zsh
source ~/.zsh.d/prompt.zsh

HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
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

## complete #################################################

autoload -Uz compaudit
autoload -Uz compinit; compinit -u
autoload -Uz bashcompinit; bashcompinit

unsetopt automenu
unsetopt list_ambiguous

## Keybind ##################################################

setopt emacs

bindkey '^p' history-beginning-search-backward-end
bindkey '^n' history-beginning-search-forward-end

bindkey '^R' zaw-history

## MISC #####################################################

disable r

setopt clobber
setopt correct
setopt mail_warning

setopt auto_continue
setopt noflowcontrol

zmodload zsh/mathfunc

source $HOME/.zsh.d/lscolor.zsh
LSCOLORSCONF="\
  di=Brown:default\
  ln=magenta:default\
  so=green:default\
  pi=blue:default\
  ex=red:default\
  bd=blue:cyan\
  cd=green:cyan\
  su=cyan:red\
  sg=blue:red\
  tw=cyan:brown\
  ow=blue:brown"

export CLICOLOR=1
export LSCOLORS=`lsColorsBSD $LSCOLORSCONF`
export LS_COLORS=`lsColorsGNU $LSCOLORSCONF`
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

source ~/.zsh.d/zaw/zaw.zsh

## Aliases ##################################################

export EDITOR=vim

alias la="ls -a "
alias ll="ls -l "

command -v Vim > /dev/null && alias vim=Vim
alias mvi=mvim

alias vi=vim

case $OSTYPE in
    linux-gnu)
        alias ls='ls --color ';;
esac

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

command -v direnv > /dev/null && eval "$(direnv hook zsh)"

## MKL #######################################################

case "${OSTYPE}" in
  darwin*)
    MKL_NUM_THREADS=$(sysctl machdep.cpu.core_count)
    MKL_NUM_THREADS=${MKL_NUM_THREADS#*: }
    ;;
  linux*)
    MKL_NUM_THREADS=`~/.zsh.d/physical-cores.py`
    ;;
esac

export MKL_NUM_THREADS
