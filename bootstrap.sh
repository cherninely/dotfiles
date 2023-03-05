#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
    rsync --exclude ".git/" \
        --exclude "nvim/" \
        --exclude ".osx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~;

    rsync -avh --mkpath --no-perms ./nvim/ ~/.config/nvim/;

    source ~/.bash_profile;
}

git pull origin master;
pip3 install --user pynvim
npm install -g neovim

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
