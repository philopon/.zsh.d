#!/usr/bin/env zsh

listup_paths(){
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

if ! (($+1)) || [[ ! -d $1 ]]; then
    echo "USAGE: eval \$($0 \$DIR)" >&2
    exit 1
fi

for file in $1/*; do
    echo "export ${file:t}=$(listup_paths $file):\$${file:t}"
done
