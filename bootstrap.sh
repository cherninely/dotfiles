#!/usr/bin/env bash

cd "$(dirname "$0")"
git pull
for f in `find . -name '\.*' -exec basename {} \; | grep -v 'git\|\.$'`
do
    ln -fs $PWD/$f ~
done

# git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

#
echo Настройка git ...
GIT_AUTHOR_NAME=`cherninely`
GIT_AUTHOR_EMAIL=`cherninely@yandex-team.ru`
[ -f ~/.gitconfig ] || ln -s ~/dotfiles/.gitconfig ~/.gitconfig
mkdir -p ~/.config/git/
git config -f ~/.config/git/config user.name "$GIT_AUTHOR_NAME"
git config -f ~/.config/git/config user.email "$GIT_AUTHOR_EMAIL"

#
echo Перезагрузка bash-профиля ...
source ~/.profile

# 
echo Настройка vim ...
echo Fetch/update neobundle.vim
rm -rf ~/.vim/bundle/neobundle.vim
wget -q https://codeload.github.com/Shougo/neobundle.vim/tar.gz/master
mkdir -p .vim/bundle/
tar xf master
mv neobundle.vim-master .vim/bundle/neobundle.vim
rm master

echo Done
