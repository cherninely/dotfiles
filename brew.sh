#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install `wget`
brew install wget

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install fonts
brew tap homebrew/cask-fonts
brew install --cask font-liberation-nerd-font

brew install tmux
brew install neovim
brew install grep
brew install ripgrep # for neovim
brew install fd # for neovim telescope
brew install the_silver_searcher
brew install fzf
brew install screen
brew install gmp
brew install rsync

# Install other useful binaries.
brew install git
brew install git-lfs
brew install jesseduffield/lazygit/lazygit
brew install gs
brew install imagemagick
brew install lua
brew install go # for lsp sqls
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install zopfli
brew install nvm
brew install python3
brew install --cask finicky
brew install --cask alt-tab
brew install docker
brew install --cask rectangle

# Remove outdated versions from the cellar.
brew cleanup
