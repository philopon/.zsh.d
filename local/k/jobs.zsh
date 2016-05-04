mkdir -p ~/.cache

JOBLIST_FILE=${JOBLIST_FILE:-~/.cache/k_jobs}

K::joblist::reset(){
    [[ -f "$JOBLIST_FILE" ]] && rm $JOBLIST_FILE
}

K::joblist::get(){
    pjstat --data | awk 'function unquate(s) {return substr(s, 2, length(s) - 2)} BEGIN{FS=","; OFS="\t"} NR>5{print unquate($2), unquate($3), unquate($8), unquate($9)}'
}

K::joblist(){
    local now=`date +%s`
    local last=0

    if [[ -f "$JOBLIST_FILE" ]]; then
        last=`stat -c %Z $JOBLIST_FILE`
    fi

    if (($now - $last > 300)); then
        K::joblist::get > $JOBLIST_FILE
    fi
    cat $JOBLIST_FILE
}

K::joblist::get_log(){
    pjget $2 0:$1 pjget_output
}

pjsub(){
    K::joblist::reset
    command pjsub "$@"
}

alias jl=pjstat
alias jla="pjstat -A --filter grp=${HOME:h:t}"

alias js=pjsub

jd(){
    K::joblist\
        | anyframe-selector-auto\
        | cut -f1\
        | anyframe-action-execute pjdel
}

jg(){
    (
        cd ~/.cache;
        K::joblist\
            | anyframe-selector-auto\
            | cut -f1\
            | anyframe-action-execute K::joblist::get_log "${1:-stdout}"
    )

    if [[ "$?" == 0 ]]; then
        $PAGER ~/.cache/pjget_output
    fi
}
