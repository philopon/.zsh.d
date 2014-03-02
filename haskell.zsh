function cabal_sandbox_package_db () {
  local glob
  local line

  if [ -f cabal.sandbox.config ]; then
    while read line; do
      if [[ "$line" =~ "^package-db:" ]]; then
        echo ${${line//package-db:/}## }
        return 0
      fi
    done < cabal.sandbox.config
  else
    return 1
  fi
}

function _cabal_sandbox () {
  local db
  db=`cabal_sandbox_package_db`
  if [ $? -eq 0 ]; then
    $1 -no-user-package-db -package-db=$db ${@:2}
  else
    $@
  fi
  return 1

  if [ -f cabal.sandbox.config ]; then
    ${(z)1[@]} ${@:3}
  else
    ${(z)2[@]} ${@:3}
  fi
}

function _ghc-pkg () {
  cabal_sandbox_package_db &> /dev/null
  if [ $? -eq 0 ]; then
    cabal sandbox hc-pkg $@
  else
    ghc-pkg $@
  fi
}
alias ghc-pkg=_ghc-pkg
alias runhaskell='_cabal_sandbox runhaskell'
alias runghc='_cabal_sandbox runghc'
alias ghci='_cabal_sandbox ghci'
alias ghc='_cabal_sandbox ghc'

