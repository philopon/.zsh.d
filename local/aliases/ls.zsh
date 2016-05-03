if which gls > /dev/null; then
    alias ls="gls --color"
elif [[ $OSTYPE == *darwin* ]]; then
    alias ls="ls -G"
fi

alias ll="ls -l"
alias llh="ls -lh"
alias la="ls -a"
