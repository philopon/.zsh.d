zplug b4b4r07/zplug

zplug seebi/dircolors-solarized
zplug zsh-users/zsh-syntax-highlighting, if:"__version_requirement '$ZSH_VERSION' '4.3.17'", nice:10
zplug mollifier/anyframe
zplug zsh-users/zsh-completions, nice:5
zplug jocelynmallon/zshmarks

zplug junegunn/fzf, as:command, do:"rm fzf && ./install --bin", of:"bin/{fzf,fzf-tmux}"

zplug fumiyas/home-commands, as:command, of:echo-sd

zplug themes/steeef, from:oh-my-zsh

zplug local/listup-pathenv, from:local
zplug local/convert-lscolors, from:local
zplug local/anyframe-widget-zshmark-jump, from:local
