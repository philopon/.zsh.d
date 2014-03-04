#!/bin/zsh

autoload -Uz zmv
alias zmv='noglob zmv -W '

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

## complete ##################################################

autoload -Uz compaudit
autoload -Uz compinit; compinit -u

unsetopt automenu
unsetopt list_ambiguous

## Keybind ##################################################

setopt emacs

bindkey '^p' history-beginning-search-backward-end
bindkey '^n' history-beginning-search-forward-end

bindkey '^R' zaw-history

## MISC ##########################################################    #######

disable r

setopt clobber
setopt correct
setopt mail_warning

setopt auto_continue
setopt noflowcontrol

zmodload zsh/mathfunc

# BSD DIR, SYMLINK, SOCKET, PIPE, EXE, BLOCK_SP, CHAR_SP, EXE_SUID, EXE_GUID, DIR_STICKY, DIR_WO_STICKY
# GNU  di,      ln,     so,   pi,  ex,       bd,      cd,       su,       sg,         tw,            ow

# source $HOME/.zsh.d/lscolor.zsh
# LSCOLORSCONF="di=Brown:default ln=magenta:default so=green:default pi=blue:default ex=red:default bd=blue:cyan cd=green:cyan su=cyan:red sg=blue:red tw=cyan:brown ow=blue:brown"

export CLICOLOR=1
export LSCOLORS='Dxfxcxexbxegcggbebgded' # lsColorsBSD $LSCOLORSCONF
export LS_COLORS='di=01;33:ln=35:so=32:pi=34:ex=31:bd=34;46:cd=32;46:su=36;41:sg=34;41:tw=36;43:ow=34;43' # lsColorsGNU $LSCOLORSCONF
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

source ~/.zsh.d/zaw/zaw.zsh

## Aliases #########################################################

alias la="ls -a "
alias ll="ls -l "
alias osxsleep="osascript -e 'tell application \"Finder\" to sleep'"

alias vi=vim
alias v=vim

case $OSTYPE in
    linux-gnu)
        alias ls='ls --color ';;
esac

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
