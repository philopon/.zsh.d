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
