#!/bin/bash
# install.sh

dir=~/.dotfiles
backupdir=$dir/backup
scriptdir=$(cd "$(dirname "$1")"; pwd)/$(basename "$1")
files="bashrc vimrc"
platform=$(uname)

if [[ $platform == "Darwin" ]]; then
	files+=" bash_profile"
fi

cd ~

if [[ -d "$dir" ]]; then
	echo -n "$dir already exists. Continue? [y/N] "
	read choice
	if echo "$choice" | grep -viq "^y" ;then
		echo "No changes were made. Exiting..."
		exit
	fi
fi

echo "Backing up existing config files"
mkdir -p $backupdir

for file in $files; do
	if [[ -f ".$file" ]]; then
		mv ~/.$file $backupdir/
		if [[ "$?" -eq 0 ]]; then
			echo "Moved .$file to $backupdir/"
		fi
	fi
done

echo "Copying config files to $dir"
cd $scriptdir

for file in $files; do
	cp $file $dir/
	if [[ "$?" -eq 0 ]]; then
		echo "Copied $file to $dir/$file"
	fi
done

echo "Linking config files to $HOME"
cd $dir

for file in $files; do
        ln -s $dir/$file ~/.$file
	if [[ "$?" -eq 0 ]]; then
		echo "Created symlink: $dir/$file -> ~/.$file"
	fi
done

echo "done"
