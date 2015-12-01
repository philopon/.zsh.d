#!/usr/bin/env zsh

convert1() {
    if   [[ "$1" -eq 1 ]]; then  # red
        echo b
    elif [[ "$1" -eq 2 ]]; then  # green
        echo c
    elif [[ "$1" -eq 3 ]]; then  # orange
        echo d
    elif [[ "$1" -eq 4 ]]; then  # blue
        echo e
    elif [[ "$1" -eq 5 ]]; then  # purple
        echo f
    elif [[ "$1" -eq 6 ]]; then  # cyan
        echo g
    elif [[ "$1" -eq 7 ]]; then  # grey
        echo h
    else
        echo x
    fi
}

convert(){
    bold=0
    foreground=x
    background=x

    for color in ${(s/;/)1}; do
        if [[ "$color" -eq 1 ]]; then
            bold=1
            continue
        fi

        ten=$((color / 10))
        one=$((color % 10))

        if   [[ "$ten" -eq 3 ]] || [[ "$ten" -eq 9 ]]; then
            foreground=$(convert1 $one)
        elif [[ "$ten" -eq 4 ]] || [[ "$ten" -eq 10 ]]; then
            background=$(convert1 $one)
        fi
    done

    if [[ "$bold" -eq 1 ]]; then
        foreground=${foreground:u}
    fi

    echo $foreground$background
}

di=ex
ln=fx
so=cx
pi=dx
ex=bx
bd=eg
cd=ed
su=ab
sg=ag
tw=ac
ow=ad

if ! (($+1)); then
    echo "USAGE: LSCOLORS=\$($0 \$LS_COLORS)" >&2
    exit 1
fi

for coldef in ${(s/:/)1}; do
    kv=(${(s/=/)coldef})
    target=$kv[1]
    colors=$kv[2]
    if   [[ "$target" = di ]]; then
        di=$(convert $colors)
    elif [[ "$target" = ln ]]; then
        ln=$(convert $colors)
    elif [[ "$target" = so ]]; then
        so=$(convert $colors)
    elif [[ "$target" = pi ]]; then
        pi=$(convert $colors)
    elif [[ "$target" = ex ]]; then
        ex=$(convert $colors)
    elif [[ "$target" = bd ]]; then
        bd=$(convert $colors)
    elif [[ "$target" = cd ]]; then
        cd=$(convert $colors)
    elif [[ "$target" = su ]]; then
        su=$(convert $colors)
    elif [[ "$target" = sg ]]; then
        sg=$(convert $colors)
    elif [[ "$target" = tw ]]; then
        tw=$(convert $colors)
    elif [[ "$target" = ow ]]; then
        ow=$(convert $colors)
    fi
done

echo $di$ln$so$pi$ex$bd$cd$su$sg$tw$ow
