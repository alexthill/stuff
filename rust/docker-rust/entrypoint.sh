#!/bin/bash

HOME=/root
CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"

source "$HOME/.bashrc"

echo PATH=$PATH
case ":$PATH:" in
    *":$CARGO_HOME/bin:"*) ;; # Cargo home is already in path
    *) needs_cargo_home=1 ;;
esac

if [ -n "${needs_cargo_home:-}" ]; then
    echo "adding $CARGO_HOME/bin to path"
    echo "export PATH=\"$CARGO_HOME/bin"':$PATH"' >> /root/.bashrc
fi

if [ ! -f "$CARGO_HOME/bin/cargo-binstall" ]; then
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
fi

if [ ! -f "$CARGO_HOME/bin/shuttle" ]; then
    $CARGO_HOME/bin/cargo binstall cargo-shuttle
fi

tail -f
