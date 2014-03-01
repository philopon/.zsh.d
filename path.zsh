typeset -xT DYLD_LIBRARY_PATH dyld_library_path
typeset -xT LD_LIBRARY_PATH ld_library_path
typeset -xT LIBRARY_PATH library_path
typeset -xT C_INCLUDE_PATH c_include_path
typeset -xT CPLUS_INCLUDE_PATH cplus_include_path
typeset -xT PYTHONPATH pythonpath
typeset -xT PKG_CONFIG_PATH pkg_config_path

typeset -U path cdpath fpath manpath library_path ld_library_path dyld_library_path c_include_path cplus_include_path pythonpath pkg_config_path

fpath=(~/.zsh.d/zsh-completions/src $fpath)

case $OSTYPE in
    linux-gnu)
        alias ls='ls --color ';;
esac

for file in ~/.paths; do
  if [ -f $file ]; then
    while read line; do
      path=(`eval echo $line` $path)
    done < $file
  fi
done

for file in ~/.library_paths; do
  if [ -f $file ]; then
    while read line; do
      library_path=(`eval echo $line` $library_path)
      ld_library_path=(`eval echo $line` $ld_library_path)
      dyld_library_path=(`eval echo $line` $dyld_library_path)
    done < $file
  fi
done

for file in ~/.include_paths; do
  if [ -f $file ]; then
    while read line; do
      c_include_path=(`eval echo $line` $c_include_path)
      cplus_include_path=(`eval echo $line` $cplus_include_path)
    done < $file
  fi
done

for file in ~/.python_paths; do
  if [ -f $file ]; then
    while read line; do
      pythonpath=(`eval echo $line` $pythonpath)
    done < $file
  fi
done

for file in ~/.pkg-config_paths; do
  if [ -f $file ]; then
    while read line; do
      pkg_config_path=(`eval echo $line` $pkg_config_path)
    done < $file
  fi
done


