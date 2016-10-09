#!/bin/bash
# install.sh
# Installs config files from the repository to ~/.dotfiles and symlinks them to ~

# Config file directory
dir="$HOME"/.dotfiles
# Config file backup directory
backupdir=""$dir"/backup"
# Directory of this script
scriptdir="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
# Config files to install
files="bashrc vimrc tmux.conf"
colorschemes="tungsten.vim tantalum.vim blank.vim"
# Operating system
platform="$(uname)"

# Add bash_profile if running OS X
if [[ "$platform" == "Darwin" ]]; then
    files+=" bash_profile"
fi

cd "$HOME"

# Check if config file directory exists
if [[ -d "$dir" ]]; then
    echo -n ""$dir" already exists. Continue? [y/N] "
    read choice
    if echo "$choice" | grep -viq "^y" ;then
        echo "No changes were made."
        exit
    fi
fi

echo ""

# Backup config files to the backup directory
echo "Backing up existing config files..."
mkdir -p "$backupdir"

for file in $files; do
    if [[ -f ".$file" ]]; then
        if mv "$HOME/.$file" "$backupdir"/"$file"."$(date +%Y%m%d%H%M%S)"; then
            echo "Moved "$HOME/.$file" to "$backupdir"/"
        fi
    fi
done

echo ""

# Copy config files from the repo to the config file directory
echo "Copying config files to "$dir"..."
cd "$scriptdir"

for file in $files; do
    if cp "$scriptdir"/"$file" "$dir"/; then
        echo "Copied "$file" to "$dir"/"$file""
    fi
done

echo ""

# Create symlinks of the config files to home directory
echo "Linking config files to "$HOME"..."
cd "$dir"

for file in $files; do
    if ln -s "$dir"/"$file" "$HOME/.$file"; then
        echo "Created symlink: "$dir"/"$file" -> "$HOME/.$file""
    fi
done

echo ""

# Install vim colorschemes
echo -n "Install vim colorschemes? [y/N] "
read choice
if echo "$choice" | grep -viq "^y"; then
    echo "Vim colorschemes were not installed."
else
    # Copy colorschemes
    mkdir -p "$HOME"/.vim/colors/
    for cs in $colorschemes; do
        if cp "$scriptdir"/"$cs" "$HOME"/.vim/colors/"$cs"; then
            echo "Copied "$cs" to "$HOME"/.vim/colors/"$cs""
        fi
    done
fi

echo ""

if [ ! -e "$HOME"/.vim/autoload/plug.vim ]; then
    # Install vim-plug
    echo -n "Install vim-plug? [y/N] "
    read choice
    if echo "$choice" | grep -viq "^y"; then
        echo "Vim-plug was not installed."
        echo -e "\ndone"
        exit
    fi

    if which curl 1>/dev/null; then
        echo "Installing vim-plug..."
        if curl -fLo "$HOME"/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
            echo "Vim-plug installed. Remember to :PlugInstall."
        fi
    elif which wget 1>/dev/null; then
        echo "Installing vim-plug..."
        mkdir -p "$HOME"/.vim/autoload/
        if wget --show-progress -qO "$HOME"/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
            echo "Vim-plug installed. Remember to :PlugInstall."
        fi
    else
        echo "No curl or wget found. Please install either to install vim-plug."
    fi
fi

echo -e "\ndone"
