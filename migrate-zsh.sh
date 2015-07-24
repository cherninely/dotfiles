#!/bin/bash

#
echo Установить ZSH если не установлен...
which zsh > /dev/null || sudo apt-get install zsh

echo Установить необходимые утилиты
which wget > /dev/null 2>&1 || sudo apt-get install wget
which unzip > /dev/null 2>&1 || sudo apt-get install unzip

# установить или не установить OMZ
echo 'Ставим OMZ (oh-my-zsh) [yn] ?:'; read WANT_OMZ

if [[ $WANT_OMZ = y ]]; then

    echo 'Ура, Ставим:'
    wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -qO- | zsh; echo Продолжаем миграцию...

    echo 'Установить тему ya-mm...'
    cd ~/.oh-my-zsh/themes && wget https://raw.githubusercontent.com/bem-kit/oh-my-zsh/master/themes/ya-mm.zsh-theme

    echo 'Установить fasd (github.com/clvv/fasd)...'
    if [ $IS_OSX ]; then
        brew install fasd
    else
        wget https://github.com/clvv/fasd/zipball/master -qO- > fasd.zip && unzip fasd.zip
        cd fasd/* && sudo make install
    fi

else
    WANT_OMZ=
fi

echo 'Ставим thefuck (github.com/nvbn/thefuck) [yn] ?:'; read WANT_THEFUCK;
if [[ $WANT_THEFUCK = y ]]; then
    echo 'Ставим!'
    if [ $IS_OSX ]; then
        brew install thefuck
    else
        sudo apt-get update
        sudo apt-get uninstall python-pip python-dev
        sudo apt-get install python-pip python-dev
        sudo pip install thefuck
    fi
else
    WANT_THEFUCK=
fi

echo 'Ставим bem-cat [yn] ?:'; read WANT_BEMCAT;
if [[ $WANT_BEMCAT = y ]]; then
    echo 'Ставим!'
    wget -qO- https://github.yandex-team.ru/bem-kit/bem-levels/raw/master/install.sh | sh
else
    WANT_BEMCAT=
fi

mv ~/.gitconfig ~/.gitconfig.bak
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
mkdir -p ~/.config/git/
touch ~/.config/git/config
echo 'Внимание: ~/.gitconfig забэкаплен (~/.gitconfig.bak)) и заменён симлинкой на dotfiles'
echo 'Запустите diff ~/.gitconfig.bak ~/.gitconfig чтобы проверить отличия'
echo 'Используйте ~/.config/git/config для ваших настроек git, а так же имени и email'

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
