#!/bin/bash
# install.sh
# Installs config files from the repository to ~/.dotfiles and symlinks them to ~

# Config file directory
dir=~/.dotfiles
# Config file backup directory
backupdir=$dir/backup
# Directory of this script
scriptdir=$(cd "$(dirname "$1")"; pwd)/$(basename "$1")
# Config files to install
files="bashrc vimrc"
colorschemes="tungsten.vim tantalum.vim"
# Operating system
platform=$(uname)

# Add bash_profile if running OS X
if [[ $platform == "Darwin" ]]; then
    files+=" bash_profile"
fi

cd ~

# Check if config file directory exists
if [[ -d "$dir" ]]; then
    echo -n "$dir already exists. Continue? [y/N] "
    read choice
    if echo "$choice" | grep -viq "^y" ;then
        echo "No changes were made."
        exit
    fi
fi

# Backup config files to the backup directory
echo "Backing up existing config files"
mkdir -p $backupdir

for file in $files; do
    if [[ -f ".$file" ]]; then
        mv ~/.$file $backupdir/$file.$(date +%Y%m%d%H%M%S)
        if [[ "$?" -eq 0 ]]; then
            echo "Moved ~/.$file to $backupdir/"
        fi
    fi
done

# Copy config files from the repo to the config file directory
echo "Copying config files to $dir"
cd $scriptdir

for file in $files; do
    cp $file $dir/
    if [[ "$?" -eq 0 ]]; then
        echo "Copied $file to $dir/$file"
    fi
done

# Create symlinks of the config files to home directory
echo "Linking config files to $HOME"
cd $dir

for file in $files; do
    ln -s $dir/$file ~/.$file
    if [[ "$?" -eq 0 ]]; then
        echo "Created symlink: $dir/$file -> ~/.$file"
    fi
done

# Install vim-plug and colorschemes
echo -n "Install vim-plug and colorschemes? [y/N] "
read choice
if echo "$choice" | grep -viq "^y" ;then
    echo "Vim extras were not installed."
    echo "done"
    exit
fi

# Copy colorschemes
mkdir -p ~/.vim/colors/
for cs in $colorschemes; do
    cp $scriptdir/$cs ~/.vim/colors/$cs
    if [[ "$?" -eq 0 ]]; then
        echo "Copied $cs to ~/.vim/colors/$cs"
    fi
done

# Install vim-plug
echo "Installing vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
if [[ "$?" -eq 0 ]]; then
    echo "Vim-plug installed."
fi

echo "done"
