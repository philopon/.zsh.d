if hash nvim &> /dev/null; then
    export EDITOR=`which nvim`
    alias vim=nvim
elif hash Vim &> /dev/null; then
    export EDITOR=`which Vim`
    alias vim=Vim
fi

alias vi=vim
