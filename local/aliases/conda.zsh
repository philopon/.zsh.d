if [[ -d ~/miniconda3 ]]; then
    CONDABASE=~/miniconda3
elif [[ -d ~/miniconda2 ]]; then
    CONDABASE=~/miniconda2
fi

if [[ -n "$CONDABASE" ]]; then
    alias conda=$CONDABASE/bin/conda
    alias activate="source $CONDABASE/bin/activate"
fi
