zplug b4b4r07/zplug

zplug local/listup-pathenv, from:local, nice:-5
zplug local/register-lscolors, from:local, nice:-3

zplug seebi/dircolors-solarized, do:'echo register-lscolors `pwd`/dircolors.ansi-dark > init.zsh'

zplug zsh-users/zsh-syntax-highlighting, if:"__version_requirement '$ZSH_VERSION' '4.3.17'", nice:10
zplug mollifier/anyframe
zplug zsh-users/zsh-completions, nice:5

zplug junegunn/fzf, as:command, do:"rm fzf && ./install --bin", of:"bin/{fzf,fzf-tmux}"

zplug fumiyas/home-commands, as:command, of:echo-sd

zplug local/prompt, from:local

zplug b4b4r07/enhancd, of:"zsh/enhancd.plugin.zsh"
