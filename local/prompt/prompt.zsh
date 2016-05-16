export VIRTUAL_ENV_DISABLE_PROMPT=1

setopt PROMPT_SUBST
autoload -Uz add-zsh-hook

autoload -Uz vcs_info
add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats " (%b%u%c)"
zstyle ':vcs_info:*' actionformats " (%b%u%c|%F{red}%a%f)"
zstyle ':vcs_info:*' unstagedstr "%F{226}● %f"
zstyle ':vcs_info:*' stagedstr "%F{82}● %f"

sandbox_info(){
    [[ -n "$VIRTUAL_ENV" ]] && echo "(`basename $VIRTUAL_ENV`)"
}

local cwd='%F{172}%~%f'

local user="%(#,%F{red},%F{240})%n%f"

cmachine() {
    local color
    [[ -n "$SSH_CONNECTION" ]] && color=red || color=240
    echo "%F{$color}%m%f"
}

local cmark="%B%(?,%F{green},%F{red})%#%f%b"

PROMPT="$user%F{240}@%f\$(cmachine)%F{240}:%f $cwd\${vcs_info_msg_0_} \$(sandbox_info)
$cmark "
