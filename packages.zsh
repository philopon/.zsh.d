version_requirement() {
    __zplug::core::core::version_requirement "$@"
}

zplug zsh-users/zsh-syntax-highlighting, nice:10, if:"version_requirement $ZSH_VERSION 4.3.17"
zplug zsh-users/zsh-completions

zplug $ZDOTDIR/local/prompt, from:local

zplug $ZDOTDIR/local/register-lscolors, from:local
zplug seebi/dircolors-solarized, hook-load:"register-lscolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.ansi-dark", nice:5

zplug junegunn/fzf-bin, as:command, from:gh-r, rename-to:fzf
zplug mollifier/anyframe, hook-load:"source $ZDOTDIR/hook/anyframe.zsh"

zplug $ZDOTDIR/local/listup-pathenv, from:local, nice:-10

zplug $ZDOTDIR/local/config, from:local
zplug $ZDOTDIR/local/aliases, from:local, nice:5
zplug $ZDOTDIR/local/auto-tmux, from:local, if:"which tmux > /dev/null", nice:-5

zplug $ZDOTDIR/local/direnv, from:local, if:"which direnv > /dev/null"

zplug $ZDOTDIR/local/pip-wrapper, from:local
