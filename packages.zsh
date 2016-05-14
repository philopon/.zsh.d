get_os() {
    __zplug::core::core::get_os
}

zsh_version() {
    __zplug::core::core::version_requirement $ZSH_VERSION $1
}

zplug zplug/zplug

zplug zsh-users/zsh-syntax-highlighting, nice:10, if:"zsh_version $1"
zplug zsh-users/zsh-completions

zplug $ZDOTDIR/local/prompt, from:local

zplug $ZDOTDIR/local/register-lscolors, from:local
zplug seebi/dircolors-solarized, hook-load:"register-lscolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.ansi-dark", nice:5

zplug junegunn/fzf-bin, as:command, from:gh-r, rename-to:fzf
zplug mollifier/anyframe, hook-load:"source $ZDOTDIR/scripts/hook-anyframe.zsh"

zplug $ZDOTDIR/local/listup-pathenv, from:local, nice:-10

zplug $ZDOTDIR/local/config, from:local
zplug $ZDOTDIR/local/aliases, from:local, nice:5

zplug philopon/k.zsh, if:'[[ `hostname` =~ "^fe01p[0-9]{2}$" ]]'

zplug direnv/direnv, as:command, from:gh-r, hook-build:"chmod 755 *", use:"*$(get_os)*", rename-to:direnv, hook-load:'eval "$(direnv hook zsh)"'

zplug $ZDOTDIR/local/pip-wrapper, from:local
