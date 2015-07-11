#!/bin/bash

#
echo Установить ZSH если не установлен...
[[ `which zsh` ]] || sudo apt-get install zsh

# установить или не установить OMZ
echo 'Ставим OMZ (oh-my-zsh) [yn] ?:'; read WANT_OMZ; [[ $WANT_OMZ == y ]] && (echo 'Ура, Ставим:'; wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -qO- | zsh; echo Продолжаем миграцию...) || WANT_OMZ=

# Если OMZ, то и установить тему ya-mm
[ $WANT_OMZ ] && (echo 'Установить тему ya-mm...'; cd ~/.oh-my-zsh/themes && wget https://raw.githubusercontent.com/bem-kit/oh-my-zsh/master/themes/ya-mm.zsh-theme)

#
echo заменить .zshrc на симлинк из dotfiles
([ -e ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak); ln -s ~/dotfiles/.zshrc ~
echo прежний конфиг сохранён в ~/.zshrc.bak

#
echo переключить шелл
sudo chsh -s $(which zsh)

echo ${ORANGE}${BOLD}
echo Всё, перезагружайтесь
echo ${RESET}
