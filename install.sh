#!/bin/bash
# install.sh
# Installs config files from the repository to ~/.dotfiles and symlinks them to ~

# Config file directory
dir=~/.dotfiles
# Config file backup directory
backupdir=""$dir"/backup"
# Directory of this script
scriptdir="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
# Config files to install
files="bashrc vimrc tmux.conf"
colorschemes="tungsten.vim tantalum.vim tantalum-dark.vim blank.vim"
# Operating system
platform="$(uname)"

# Add bash_profile if running OS X
if [[ "$platform" == "Darwin" ]]; then
    files+=" bash_profile"
fi

cd ~

# Check if config file directory exists
if [[ -d "$dir" ]]; then
    echo -n ""$dir" already exists. Continue? [y/N] "
    read choice
    if echo "$choice" | grep -viq "^y" ;then
        echo "No changes were made."
        exit
    fi
fi

# Backup config files to the backup directory
echo "Backing up existing config files..."
mkdir -p "$backupdir"

for file in $files; do
    if [[ -f ".$file" ]]; then
        if mv ~/."$file" "$backupdir"/"$file"."$(date +%Y%m%d%H%M%S)"; then
            echo "Moved ~/."$file" to "$backupdir"/"
        fi
    fi
done

# Copy config files from the repo to the config file directory
echo "Copying config files to "$dir"..."
cd "$scriptdir"

for file in $files; do
    if cp "$scriptdir"/"$file" "$dir"/; then
        echo "Copied "$file" to "$dir"/"$file""
    fi
done

# Create symlinks of the config files to home directory
echo "Linking config files to "$HOME"..."
cd "$dir"

for file in $files; do
    if ln -s "$dir"/"$file" ~/."$file"; then
        echo "Created symlink: "$dir"/"$file" -> ~/."$file""
    fi
done

# Install vim-plug and colorschemes
echo -n "Install vim colorschemes? [y/N] "
read choice
if echo "$choice" | grep -viq "^y"; then
    echo "Vim colorschemes were not installed."
else
    # Copy colorschemes
    mkdir -p ~/.vim/colors/
    for cs in $colorschemes; do
        if cp "$scriptdir"/"$cs" ~/.vim/colors/"$cs"; then
            echo "Copied "$cs" to ~/.vim/colors/"$cs""
        fi
    done
fi

# Install vim-plug
echo -n "Install vim-plug? [y/N] "
read choice
if echo "$choice" | grep -viq "^y"; then
    echo "Vim-plug was not installed."
    echo "done"
    exit
fi

if which curl 1>/dev/null; then
    echo "Installing vim-plug..."
    if curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
        echo "Vim-plug installed. Remember to :PlugInstall."
    fi
elif which wget 1>/dev/null; then
    mkdir -p ~/.vim/autoload/
    if wget --show-progress -qO ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
        echo "Vim-plug installed. Remember to :PlugInstall."
    fi
else
    echo "No curl or wget found. Please install either to install vim-plug."
fi
echo "done"
