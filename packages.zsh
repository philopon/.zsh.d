zplug zsh-users/zsh-syntax-highlighting, nice:10, if:"__zplug::core::core::version_requirement $ZSH_VERSION 4.3.17"
zplug zsh-users/zsh-completions

zplug $ZDOTDIR/local/prompt, from:local

zplug $ZDOTDIR/local/register-lscolors, from:local
zplug seebi/dircolors-solarized, hook-load:"register-lscolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.ansi-dark", nice:5

zplug junegunn/fzf-bin, as:command, from:gh-r, rename-to:fzf
zplug mollifier/anyframe, hook-load:"source $ZDOTDIR/hook/anyframe.zsh"

zplug $ZDOTDIR/local/config, from:local
zplug $ZDOTDIR/local/aliases, from:local
zplug $ZDOTDIR/local/auto-tmux, from:local, if:"which tmux", nice:-10

zplug $ZDOTDIR/local/direnv, from:local, if:"which direnv"

zplug $ZDOTDIR/local/pip-wrapper, from:local
