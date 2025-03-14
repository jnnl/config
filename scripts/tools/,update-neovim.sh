#!/bin/bash
# install/update neovim

set -eu -o pipefail

base_path="$HOME/code/bin"
pkg_name=""
tag="nightly"

kernel="$(uname -s)"
arch="$(uname -m)"

if [ "$kernel" = "Linux" ]; then
    pkg_name="nvim-linux-$arch"
elif [ "$kernel" = "Darwin" ]; then
    pkg_name="nvim-macos-$arch"
else
    printf "ERROR: unsupported operating system '%s'\n" "$kernel" 1>&2
    exit 1
fi

cd "$base_path"
[ -d "$base_path" ] || mkdir -vp "$base_path"

[ "$#" -gt 0 ] && tag="$1"

if type -p nvim &>/dev/null; then
    printf "currently installed neovim version: %s\n" "$(nvim -v | awk 'NR==1 { print $2 }')"
fi
printf "install directory: %s\n" "$base_path/$pkg_name"

if [ -d "$pkg_name" ]; then
    printf "creating backup: %s -> %s ... " "$pkg_name" "$pkg_name.bak"
    rm -rf "$pkg_name.bak"
    cp -prf "$pkg_name" "$pkg_name.bak"
    printf "done\n"
fi

printf "downloading $pkg_name.tar.gz (tag: %s) ... " "$tag"
curl -sSfLO "https://github.com/neovim/neovim/releases/download/$tag/$pkg_name.tar.gz"
printf "done\n"

printf "downloading %s ... " "shasum.txt"
curl -sSfLO "https://github.com/neovim/neovim/releases/download/$tag/shasum.txt"
printf "done\n"

printf "verifying %s sha256sum ... " "$pkg_name.tar.gz"
sha256sum --quiet --ignore-missing -c "shasum.txt"
printf "done\n"

printf "removing %s ... " "$pkg_name"
rm -rf "$pkg_name"
printf "done\n"

printf "unpacking %s ... " "$pkg_name.tar.gz"
tar xf "$pkg_name.tar.gz"
printf "done\n"

printf "removing %s, %s ... " "$pkg_name.tar.gz" "shasum.txt"
rm -f "$pkg_name.tar.gz" "shasum.txt"
printf "done\n"

printf "linking %s to %s ... " "$base_path/$pkg_name/bin/nvim" "$base_path/nvim"
ln -snf "$base_path/$pkg_name/bin/nvim" "$base_path/nvim"
printf "done\n"

printf "successfully installed neovim version %s\n" "$(nvim -v | awk 'NR==1 { print $2 }')"
