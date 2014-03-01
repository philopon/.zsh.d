#!/bin/zsh

# a 0 - black   k
# b 1 - red     r
# c 2 - green   g
# d 3 - yellow  y
# e 4 - blue    b
# f 5 - magenta m
# g 6 - cyan    c
# h 7 - white   w

# x 00 - default

# upperCase 01 - bold

# BSD (fg)(bg)
# GNU 30+: fg, 40+: bg

# BSD DIR, SYMLINK, SOCKET, PIPE, EXE, BLOCK_SP, CHAR_SP, EXE_SUID, EXE_GUID, DIR_STICKY, DIR_WO_STICKY
# GNU  di,      ln,     so,   pi,  ex,       bd,      cd,       su,       sg,         tw,            ow

function lsColorsBSD () {
    local -A param
    for str in ${(s: :)1}; do
        kv=(${(s:=:)str})
        param[$kv[1]]=$kv[2]
    done
    local result
    result+=`parseColorToBSD $param[di]`
    result+=`parseColorToBSD $param[ln]`
    result+=`parseColorToBSD $param[so]`
    result+=`parseColorToBSD $param[pi]`
    result+=`parseColorToBSD $param[ex]`
    result+=`parseColorToBSD $param[bd]`
    result+=`parseColorToBSD $param[cd]`
    result+=`parseColorToBSD $param[su]`
    result+=`parseColorToBSD $param[sg]`
    result+=`parseColorToBSD $param[tw]`
    result+=`parseColorToBSD $param[ow]`
    echo $result
}

function lsColorsGNU () {
    local -A param
    for str in ${(s: :)1}; do
        kv=(${(s:=:)str})
        param[$kv[1]]=$kv[2]
    done
    local result
    result+="di=`parseColorToGNU $param[di]`:"
    result+="ln=`parseColorToGNU $param[ln]`:" 
    result+="so=`parseColorToGNU $param[so]`:" 
    result+="pi=`parseColorToGNU $param[pi]`:" 
    result+="ex=`parseColorToGNU $param[ex]`:" 
    result+="bd=`parseColorToGNU $param[bd]`:" 
    result+="cd=`parseColorToGNU $param[cd]`:" 
    result+="su=`parseColorToGNU $param[su]`:" 
    result+="sg=`parseColorToGNU $param[sg]`:" 
    result+="tw=`parseColorToGNU $param[tw]`:" 
    result+="ow=`parseColorToGNU $param[ow]`"
    echo $result
}



function parseColorToBSD () {
    local -a param
    local result=""

    if [[ ${1:+ok} != "ok" ]];then echo xx; return 0; fi
    param=(${(s#:#)1})

    case $param[1] in
        black)                                       result+=a;;
        red)                                         result+=b;;
        green)                                       result+=c;;
        yellow|brown)                                result+=d;;
        blue)                                        result+=e;;
        purple|violet|magenta)                       result+=f;;
        cyan)                                        result+=g;;
        white)                                       result+=h;;
        default|x)                                   result+=x;;
        Black|BLACK)                                 result+=A;;
        Red|RED)                                     result+=B;;
        Green|GREEN)                                 result+=C;;
        Yellow|YELLOW|Brown|BROWN)                   result+=D;;
        Blue|BLUE)                                   result+=E;;
        Purple|PURPLE|Violet|VIOLET|Magenta|MAGENTA) result+=F;;
        Cyan|CYAN)                                   result+=G;;
        White|WHITE)                                 result+=H;;
        *) echo "cannot read front ground color: $1" ; return 1;;
    esac
    case $param[2] in
        black)                                       result+=a;;
        red)                                         result+=b;;
        green)                                       result+=c;;
        yellow|brown)                                result+=d;;
        blue)                                        result+=e;;
        purple|violet|magenta)                       result+=f;;
        cyan)                                        result+=g;;
        white)                                       result+=h;;
        default|x)                                   result+=x;;
        *) echo "cannot read back ground color: $1" ; return 2;;
    esac
    echo $result;
}


function parseColorToGNU () {
    local -a  param
    local -Ua result

    if [[ ${1:+ok} != "ok" ]];then echo 00; return 0; fi
    param=(${(s#:#)1})

    case $param[1] in
        black)                                       result=($result 30);;
        red)                                         result=($result 31);;
        green)                                       result=($result 32);;
        yellow|brown)                                result=($result 33);;
        blue)                                        result=($result 34);;
        purple|violet|magenta)                       result=($result 35);;
        cyan)                                        result=($result 36);;
        white)                                       result=($result 37);;
        default|x)                                   ;;
        Black|BLACK)                                 result=($result 01 30);;
        Red|RED)                                     result=($result 01 31);;
        Green|GREEN)                                 result=($result 01 32);;
        Yellow|YELLOW|Brown|BROWN)                   result=($result 01 33);;
        Blue|BLUE)                                   result=($result 01 34);;
        Purple|PURPLE|Violet|VIOLET|Magenta|MAGENTA) result=($result 01 35);;
        Cyan|CYAN)                                   result=($result 01 36);;
        White|WHITE)                                 result=($result 01 37);;
        *) echo "cannot read front ground color: $1" ; return 1;;
    esac
    case $param[2] in
        black)                                       result=($result 40);;
        red)                                         result=($result 41);;
        green)                                       result=($result 42);;
        yellow|brown)                                result=($result 43);;
        blue)                                        result=($result 44);;
        purple|violet|magenta)                       result=($result 45);;
        cyan)                                        result=($result 46);;
        white)                                       result=($result 47);;
        default|x)                                   ;;
        *) echo "cannot read back  ground color: $1" ; return 2;;
    esac
    [[ ${#result[*]} == 0 ]] && result=(00);
    echo ${(pj:;:)result};
}
