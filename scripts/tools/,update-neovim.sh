#!/bin/bash
# install/update neovim

set -eu

(
set -eu

base_dir="$HOME/code/bin"
pkg_name="nvim-linux64"
tag="nightly"

if [ "$(uname -s)" = "Darwin" ]; then
    pkg_name="nvim-macos-$(uname -m)"
fi

cd "$base_dir"

[ "$#" -gt 0 ] && tag="$1"

if type -p nvim &>/dev/null; then
    printf "currently installed neovim version: %s\n" "$(nvim -v | awk 'NR==1 { print $2 }')"
fi
printf "base directory: %s\n\n" "$base_dir"

if [ -d "$pkg_name" ]; then
    printf "creating backup: %s -> %s ..." "$pkg_name" "$pkg_name.bak"
    cp -rf "$pkg_name" "$pkg_name.bak"
    printf " done\n"
fi

printf "downloading $pkg_name.tar.gz (%s) ..." "$tag"
curl -sfLO "https://github.com/neovim/neovim/releases/download/$tag/$pkg_name.tar.gz"
printf " done\n"

printf "downloading %s ..." "$pkg_name.tar.gz.sha256sum"
curl -sfLO "https://github.com/neovim/neovim/releases/download/$tag/$pkg_name.tar.gz.sha256sum"
printf " done\n"

printf "verifying %s sha256sum ..." "$pkg_name.tar.gz"
sha256sum --quiet -c "$pkg_name.tar.gz.sha256sum"
printf " done\n"

printf "removing %s ..." "$pkg_name"
rm -rf "$pkg_name"
printf " done\n"

printf "unpacking %s ..." "$pkg_name.tar.gz"
tar xf "$pkg_name.tar.gz"
printf " done\n"

printf "removing %s, %s ..." "$pkg_name.tar.gz" "$pkg_name.tar.gz.sha256sum"
rm -f "$pkg_name.tar.gz" "$pkg_name.tar.gz.sha256sum"
printf " done\n"

printf "linking %s to %s ..." "$base_dir/$pkg_name/bin/nvim" "$base_dir/nvim"
ln -snf "$base_dir/$pkg_name/bin/nvim" "$base_dir/nvim"
printf " done\n"

printf "successfully installed neovim version %s\n" "$(nvim -v | awk 'NR==1 { print $2 }')"
)
