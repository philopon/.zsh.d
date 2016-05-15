#!/usr/bin/env zsh

register-lscolors(){
    local THEME=$1 DIRCOLORS_CMD

    hash gdircolors > /dev/null && DIRCOLORS_CMD=gdircolors
    hash dircolors > /dev/null && DIRCOLORS_CMD=dircolors

    [[ -z "$DIRCOLORS_CMD" ]] && return 1

    eval $($DIRCOLORS_CMD $THEME)
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
}
