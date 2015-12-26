#!/usr/bin/env zsh

__convert-lscolors::convert1() {
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

__convert-lscolors::convert(){
    local bold=0 foreground=x background=x color ten one

    for color in ${(s/;/)1}; do
        if [[ "$color" -eq 1 ]]; then
            bold=1
            continue
        fi

        ten=$((color / 10))
        one=$((color % 10))

        if   [[ "$ten" -eq 3 ]] || [[ "$ten" -eq 9 ]]; then
            foreground=$(__convert-lscolors::convert1 $one)
        elif [[ "$ten" -eq 4 ]] || [[ "$ten" -eq 10 ]]; then
            background=$(__convert-lscolors::convert1 $one)
        fi
    done

    if [[ "$bold" -eq 1 ]]; then
        foreground=${foreground:u}
    fi

    echo $foreground$background
}

convert-lscolors(){
    local di=ex ln=fx so=cx pi=dx ex=bx bd=eg\
        cd=ed su=ab sg=ag tw=ac ow=ad\
        coldef kv target colors

    if [[ -z "$1" ]]; then
        echo "USAGE: LSCOLORS=\$($0 \$LS_COLORS)" >&2
        return 1
    fi

    for coldef in ${(s/:/)1}; do
        kv=(${(s/=/)coldef})
        target=$kv[1]
        colors=$kv[2]
        if   [[ "$target" = di ]]; then
            di=$(__convert-lscolors::convert $colors)
        elif [[ "$target" = ln ]]; then
            ln=$(__convert-lscolors::convert $colors)
        elif [[ "$target" = so ]]; then
            so=$(__convert-lscolors::convert $colors)
        elif [[ "$target" = pi ]]; then
            pi=$(__convert-lscolors::convert $colors)
        elif [[ "$target" = ex ]]; then
            ex=$(__convert-lscolors::convert $colors)
        elif [[ "$target" = bd ]]; then
            bd=$(__convert-lscolors::convert $colors)
        elif [[ "$target" = cd ]]; then
            cd=$(__convert-lscolors::convert $colors)
        elif [[ "$target" = su ]]; then
            su=$(__convert-lscolors::convert $colors)
        elif [[ "$target" = sg ]]; then
            sg=$(__convert-lscolors::convert $colors)
        elif [[ "$target" = tw ]]; then
            tw=$(__convert-lscolors::convert $colors)
        elif [[ "$target" = ow ]]; then
            ow=$(__convert-lscolors::convert $colors)
        fi
    done

    echo $di$ln$so$pi$ex$bd$cd$su$sg$tw$ow
}
