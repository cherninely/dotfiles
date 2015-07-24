#!/bin/bash

#
echo Установить ZSH если не установлен...
which zsh > /dev/null || sudo apt-get install zsh

echo Установить необходимые утилиты
which wget > /dev/null 2>&1 || sudo apt-get install wget
which unzip > /dev/null 2>&1 || sudo apt-get install unzip

# установить или не установить OMZ
echo 'Ставим OMZ (oh-my-zsh) [yn] ?:'; read WANT_OMZ; [[ $WANT_OMZ == y ]] && (echo 'Ура, Ставим:'; wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -qO- | zsh; echo Продолжаем миграцию...) || WANT_OMZ=

if [ $WANT_OMZ ]; then

    echo 'Установить тему ya-mm...'
    cd ~/.oh-my-zsh/themes && wget https://raw.githubusercontent.com/bem-kit/oh-my-zsh/master/themes/ya-mm.zsh-theme

    echo 'Установить fasd (github.com/clvv/fasd)...'
    if [ $IS_OSX ]; then
        brew install fasd
    else
        wget https://github.com/clvv/fasd/zipball/master -qO- > fasd.zip && unzip fasd.zip
        cd fasd/* && sudo make install
    fi

fi

#
echo заменить .zshrc на симлинк из dotfiles
([ -e ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak); ln -s ~/dotfiles/.zshrc ~
echo прежний конфиг сохранён в ~/.zshrc.bak

#
echo переключить шелл
sudo chsh -s $(which zsh) $(whoami)

echo ${ORANGE}${BOLD}
echo Всё, перезагружайтесь
echo ${RESET}

echo 'Если шелл таки не переключится, то добавьте себя в /etc/passwd и /etc/group (sudo vim ...)'
echo 'Возможно, это костыльно, но другого способа разрешения этой проблемы не найдено (пока)'
