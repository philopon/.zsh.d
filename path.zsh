fpath=(/usr/local/etc/bash_completion.d ~/.zsh.d/zsh-completions/src $fpath)

[ -d ~/.paths ] && for file in ~/.paths/*; do
  lvar=`basename $file`; lvar=${(L)lvar}
  uvar=${(U)lvar}

  if [ "$lvar" != "path" ]; then
    typeset -xT $uvar $lvar
  fi
  typeset -U $lvar

  while read line; do
    dir=`eval echo $line`
    if [ -d "$dir" ]; then
      eval `echo ${lvar}=\(\"$dir\" $(eval echo \\$$lvar)\)`
    else
      echo $lvar Warging: $line is not directry.
    fi
  done < $file
done

base="$HOME/cabal-sandbox"
[ -d $base ] && for file in `ls $base`; do
  bin=$base/$file/.cabal-sandbox/bin
  [ -e $bin ] && path=($bin $path)
done
export path
