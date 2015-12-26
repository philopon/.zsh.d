zplug b4b4r07/zplug

zplug local/listup-pathenv, from:local, nice:-5, of:"init.zsh"
zplug local/register-lscolors, from:local, nice:-3, of:"init.zsh"

zplug seebi/dircolors-solarized, do:'echo register-lscolors `pwd`/dircolors.ansi-dark > init.zsh', of:"init.zsh"

zplug zsh-users/zsh-syntax-highlighting, if:"__version_requirement '$ZSH_VERSION' '4.3.17'", nice:10, of:"zsh-syntax-highlighting.plugin.zsh"
zplug mollifier/anyframe, of:"anyframe.plugin.zsh"
zplug zsh-users/zsh-completions, nice:5, of:"zsh-completions.plugin.zsh"

zplug junegunn/fzf, as:command, do:"rm fzf && ./install --bin", of:"bin/{fzf,fzf-tmux}"

zplug fumiyas/home-commands, as:command, of:echo-sd

zplug local/prompt, from:local, of:"init.zsh"

zplug b4b4r07/enhancd, of:"zsh/enhancd.plugin.zsh"
