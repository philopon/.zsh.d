#!/usr/bin/env zsh

cd-ghq() {
    command ghq list |
    anyframe-selector-auto |
    xargs -I{} echo "`command ghq root`/{}" |
    anyframe-action-execute cd
}

zle -N cd-ghq
bindkey '^g' cd-ghq
