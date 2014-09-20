#!/usr/bin/env bash

cd "$(dirname "$0")"
git pull
for f in `find . -name '\.*' -exec basename {} \; | grep -v 'git\|\.$'`
do
    ln -fs $PWD/$f ~/$f
done
cp .gitconfig ~/.gitconfig
source ~/.profile

echo Fetch/update neobundle.vim
rm -rf ~/.vim/bundle/neobundle.vim
wget -q https://codeload.github.com/Shougo/neobundle.vim/tar.gz/master
mkdir -p .vim/bundle/
tar xf master
mv neobundle.vim-master .vim/bundle/neobundle.vim
rm master
echo Done
