if hash rustup &> /dev/null; then
    export RUST_SRC_PATH=${$(rustup which cargo):h:h}/lib/rustlib/src/rust/src
fi
