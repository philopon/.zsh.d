[[ ! -f ~/.tmux.conf ]] && ln -sf $ZDOTDIR/tmux.conf ~/.tmux.conf
[[ ! -d ~/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if ((`grep @plugin $ZDOTDIR/tmux.conf | wc -l` - `ls ~/.tmux/plugins|wc -l` > 0)); then
    tmux run-shell ~/.tmux/plugins/tpm/bindings/install_plugins
fi
