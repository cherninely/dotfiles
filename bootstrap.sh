#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {

    git pull origin master;

    pip3 install --user pynvim
    npm install -g neovim

    rsync --exclude ".git/" \
        --exclude "nvim/" \
        --exclude ".osx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~;

    rsync -avh --mkpath --no-perms ./nvim/ ~/.config/nvim/;

    #MailMate
    rsync -avh --mkpath --no-perms ./mailmate.plist ~/Library/Application\ Support/MailMate/Resources/KeyBindings/mailmate.plist;

    # Symling for rcmd
    rsync -avh --mkpath --no-perms ~/com.lowtechguys.rcmd.plist ~/Library/Containers/com.lowtechguys.rcmd/Data/Library/Preferences/com.lowtechguys.rcmd.plist

    rm -rf "${HOME}/.tmux/plugins/tpm"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"

    printf "\n\nInstalling tmux plugins...\n"

    export TMUX_PLUGIN_MANAGER_PATH="${HOME}/.tmux/plugins"
    "${HOME}/.tmux/plugins/tpm/bin/install_plugins"

    source ~/.bash_profile;
}

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
