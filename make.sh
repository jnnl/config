#!/bin/bash

platform=$(uname)

dir=~/.configs
backupdir=~/.configs/backup
files="bashrc vimrc"

if [ $platform == "Darwin" ]; then
	files+=" bash_profile"
fi

echo "Backing up existing config files..."
mkdir -p $backupdir

cd $dir
for file in $files; do
	mv ~/.$file $backupdir
	echo "Moved .$file to $backupdir"
done

echo "done"
echo "Linking config files to ~..."
cd $dir

for file in $files; do
        ln -s $dir/$file ~/.$file
	echo "Created symlink: $dir/$file -> ~/.$file"
done

echo "done"
