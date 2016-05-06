if which nvim &> /dev/null; then
    export EDITOR=`which nvim`
    alias vim=nvim
elif which Vim &> /dev/null; then
    export EDITOR=`which Vim`
    alias vim=Vim
fi

alias vi=vim
