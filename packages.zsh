get_os() {
    __zplug::base::base::get_os
}

zsh_version() {
    __zplug::base::base::version_requirement $ZSH_VERSION $1
}

zsh_version 4.3.17 && zplug zsh-users/zsh-syntax-highlighting, defer:2
zplug zsh-users/zsh-completions

zplug $ZDOTDIR/local/prompt, from:local

zplug $ZDOTDIR/local/register-lscolors, from:local

local DIRCOLORS_FILE=seebi/dircolors-solarized/dircolors.256dark
zplug ${DIRCOLORS_FILE:h}, hook-load:"register-lscolors $ZPLUG_HOME/repos/$DIRCOLORS_FILE $ZDOTDIR/dircolors", on:register-lscolors

zplug junegunn/fzf-bin, as:command, from:gh-r, rename-to:fzf
zplug mollifier/anyframe, hook-load:"source $ZDOTDIR/scripts/hook-anyframe.zsh"

zplug $ZDOTDIR/local/listup-pathenv, from:local

zplug $ZDOTDIR/local/config, from:local
zplug $ZDOTDIR/local/aliases, from:local
zplug $ZDOTDIR/local/gist, from:local, as:command
zplug $ZDOTDIR/local/rust, from:local

if [[ `hostname` =~ "^fe01p[0-9]{2}$" ]]; then
    zplug philopon/k.zsh, hook-build:make
fi

zplug motemen/ghq, as:command, from:gh-r, rename-to:ghq
