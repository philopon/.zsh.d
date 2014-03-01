#!/bin/zsh

autoload -Uz colors; colors
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

setopt prompt_subst
setopt transient_rprompt

zstyle ':vcs_info:*' formats '%c%u[%b](%s)'
zstyle ':vcs_info:*' actionformats '%c%u[%b|%F{red}%a%f](%s)'
zstyle ':vcs_info:*' get-revision true

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*'   stagedstr "%F{green}+%f"
zstyle ':vcs_info:*' unstagedstr "%F{red}-%f"

function _vcs_info_precmd () {LANG=en_US.UTF-8 vcs_info}
add-zsh-hook precmd _vcs_info_precmd

function zsh_prompt_jobs(){
    local running=0
    local suspended=0
    local line
    jobs | while read line; do
        case ${${(z)line}[3]} in
            running)   ((running   = running + 1));;
            suspended) ((suspended = suspended + 1));;
        esac
    done
    local result=""
    [[ $running   > 0 || $suspended > 0 ]] && result+='|'
    [[ $running   > 0 ]]                   && result+=${fg[green]}$running${reset_color}
    [[ $running   > 0 && $suspended > 0 ]] && result+='|'
    [[ $suspended > 0 ]]                   && result+=${fg[red]}$suspended${reset_color}
    echo $result
}

zsh_prompt_exitcode="%(?.%F{green}%?%f.%F{red}%?%f)"
zsh_prompt_username="%(#.%F{red}%n%f.%n)"

function zsh_prompt_remotehost(){
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        echo %F{red}@%m%f
    fi
}

function zsh_prompt_cabal_sandbox() {
  local glob
  if [ -d ./.cabal-sandbox/ ]; then
    glob=(./.cabal-sandbox/*/*.conf)
    echo "%B%F{green}${#glob}%k%b "
  fi
}

zsh_prompt_directory="%F{yellow}%~%f"
zsh_prompt_mark="%(#.%F{red}#%f.%%)"

case $TERM in
    dumb | emacs )
        RPROMPT=""
        PROMPT="%m:%~> "
        unsetopt zle ;;
    *)
        RPROMPT='${vcs_info_msg_0_}[%!]'
        PROMPT="[${zsh_prompt_exitcode}\$(zsh_prompt_jobs)]${zsh_prompt_username}\$(zsh_prompt_remotehost):${zsh_prompt_directory}
\$(zsh_prompt_cabal_sandbox)${zsh_prompt_mark} ";;

esac
