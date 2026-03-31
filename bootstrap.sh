#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {

    git pull origin master;

    pip3 install --user pynvim
    npm install -g neovim

    # Stow
    stow --dir=deploy-auto --target="$HOME" --restow home

    # Конфиги приложений
    ln -sf "$(pwd)/deploy-auto/external-apps/rectangle.json" \
        "$HOME/Library/Application Support/Rectangle/RectangleConfig.json"

    cp "$(pwd)/deploy-auto/external-apps/com.lowtechguys.rcmd.plist" \
        "$HOME/Library/Containers/com.lowtechguys.rcmd/Data/Library/Preferences/com.lowtechguys.rcmd.plist"

    # Tmux plugins
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
