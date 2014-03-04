fpath=(~/.zsh.d/zsh-completions/src $fpath)

for file in ~/.paths/*; do
  lvar=`basename $file`; lvar=${(L)lvar}
  uvar=${(U)lvar}

  if [ "$lvar" != "path" ]; then
    typeset -xT $uvar $lvar
  fi
  typeset -U $lvar

  while read line; do
    eval `echo ${lvar}=\(\"$(eval echo $line)\" $(eval echo \\$$lvar)\)`
  done < $file
done
