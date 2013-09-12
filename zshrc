#!/bin/zsh

autoload -Uz zmv
alias zmv='noglob zmv -W '

## PATH ##################################################

typeset -U path cdpath fpath manpath
function setenv() { export $1="$2" }

case $OSTYPE in
    darwin*)
        [ -f ~/.launchd.conf ] && source ~/.launchd.conf;;
    linux-gnu)
        alias ls='ls --color ';;
esac

fpath=(~/.zsh.d/zsh-completions/src $fpath)

## PROMPT ##################################################

source ~/.zsh.d/prompt

## History ##################################################

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

source $HOME/.zsh.d/lscolor.zsh
LSCOLORSCONF="di=Brown:default ln=magenta:default so=green:default pi=blue:default ex=red:default bd=blue:cyan cd=green:cyan su=cyan:red sg=blue:red tw=cyan:brown ow=blue:brown"

export CLICOLOR=1
export LSCOLORS=`lsColorsBSD $LSCOLORSCONF`
export LS_COLORS=`lsColorsGNU $LSCOLORSCONF`
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

source ~/.zsh.d/zaw/zaw.zsh

## Aliases #########################################################

function e () {
    if ! `emacsclient -n $@ 2> /dev/null`; then
        case $OSTYPE in
            darwin*)
                open -a Emacs
                while ! `emacsclient -e 'nil' &> /dev/null`; do
                    sleep 1
                done
                emacsclient -n $@
        esac
    fi
}

alias la="ls -a "
alias ll="ls -l "

