mkdir -p ~/.cache

JOBLIST_FILE=${JOBLIST_FILE:-~/.cache/k_jobs}

K::joblist::reset(){
    [[ -f "$JOBLIST_FILE" ]] && rm $JOBLIST_FILE
}

K::joblist::get(){
    pjstat --data | awk 'function unquate(s) {return substr(s, 2, length(s) - 2)} BEGIN{FS=","; OFS="\t"} NR>5{print unquate($2), unquate($3), unquate($5), unquate($8), unquate($9)}'
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

K::joblist::pretty_joblist() {
    ruby -F"\t" -nae 'BEGIN{$col = 0; $fs = []}; $col = [$col, $F[1].length].max; $fs.push($F); END{$fs.each {|f|printf("%8s %-"+$col.to_s+"s %s %s %s", *f)}}'
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
    if [[ -z "$1" ]]; then
        K::joblist\
            | K::joblist::pretty_joblist\
            | anyframe-selector-auto\
            | awk '{print $1}'\
            | anyframe-action-execute pjdel
    else
        pjdel "$@"
    fi
}

jg(){
    (
        cd ~/.cache;
        K::joblist\
            | awk '$3 == "RUN" {print $0}'\
            | K::joblist::pretty_joblist\
            | anyframe-selector-auto\
            | awk '{print $1}'\
            | anyframe-action-execute K::joblist::get_log "${1:-stdout}"
    )

    if [[ "$?" == 0 ]]; then
        less +G ~/.cache/pjget_output
    fi
}

JOBTEST_PY=$0:h/scripts/jobtest.py

jt(){
    python2.7 $JOBTEST_PY "$@"
}
