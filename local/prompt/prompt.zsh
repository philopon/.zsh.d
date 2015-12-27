export VIRTUAL_ENV_DISABLE_PROMPT=1

setopt PROMPT_SUBST
autoload -Uz add-zsh-hook

autoload -Uz vcs_info
add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats " (%F{cyan}%b%f%u%c)"
zstyle ':vcs_info:*' actionformats " (%F{cyan}%b%f%u%c|%F{red}%a%f)"
zstyle ':vcs_info:*' unstagedstr "%F{yellow}●%f"
zstyle ':vcs_info:*' stagedstr "%F{green}●%f"

sandbox_info(){
    [[ -n "$VIRTUAL_ENV" ]] && echo "(${VIRTUAL_ENV#$PWD/})"
}

local cwd='%F{yellow}%~%f'

local user="%(#,%F{red},%F{magenta})%n%f"

cmachine() {
    local color
    [[ -n "$SSH_CONNECTION" ]] && color=red || color=green
    echo "%F{$color}%m%f"
}

local cmark="%B%(?,%F{green},%F{red})%#%f%b"

PROMPT="$user@\$(cmachine) in $cwd\${vcs_info_msg_0_} \$(sandbox_info)
$cmark "
