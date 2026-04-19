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

    # fzf-tab (not available via brew)
    if [ ! -d "${HOME}/.zsh/fzf-tab" ]; then
        mkdir -p "${HOME}/.zsh"
        git clone --depth 1 https://github.com/Aloxaf/fzf-tab "${HOME}/.zsh/fzf-tab"
    fi

    # fzf shell integration (~/.fzf.zsh with Ctrl-R/Ctrl-T/Alt-C bindings)
    if [ ! -f "${HOME}/.fzf.zsh" ] && [ -f "$(brew --prefix)/opt/fzf/install" ]; then
        "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
    fi

    printf "\n\nRun \`exec zsh\` to start the new shell.\n"
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
