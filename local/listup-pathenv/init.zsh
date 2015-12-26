#!/usr/bin/env zsh

__listup-pathenv::listup-paths(){
    local file list line path
    file=$1

    list=()
    while read line; do
        path=${line/\~/$HOME}
        if [[ -d "$path" ]]; then
            list+=($path)
        else
            echo "$line is not exists" >&2
        fi
    done < $file

    echo ${(j/:/)list}
}

listup-pathenv(){
    if [[ -z "$1" ]]; then
        echo "USAGE: eval \$($0 \$DIR)" >&2
        return 1
    fi

    if [[ -f "$1" ]]; then
        echo "$0 error: DIR should be directory, but it's file." >&2
        return 1
    fi

    if [[ -d "$1" ]]; then
        local file
        for file in $1/*; do
            echo "typeset -U ${file:t}"
            echo "export ${file:t}=$(__listup-pathenv::listup-paths $file):\$${file:t}"
        done
    fi
}
