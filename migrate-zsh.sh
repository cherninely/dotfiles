#!/bin/bash

#
echo ${ORANGE}${BOLD}
echo Установить ZSH если не установлен...
echo ${RESET}
which zsh > /dev/null || sudo apt-get install zsh

echo ${ORANGE}${BOLD}
echo Установить необходимые утилиты
echo ${RESET}
which wget > /dev/null 2>&1 || sudo apt-get install wget
which unzip > /dev/null 2>&1 || sudo apt-get install unzip

# установить или не установить OMZ
echo ${GREEN}${BOLD}
echo 'Ставим OMZ (oh-my-zsh) [yn] ?:'; read WANT_OMZ
echo ${RESET}

if [[ $WANT_OMZ = y ]]; then

    echo 'Ура, Ставим:'
    wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -qO- | zsh; echo Продолжаем миграцию...

    echo ${ORANGE}${BOLD}
    echo 'Установить тему ya-mm...'
    echo ${RESET}
    cd ~/.oh-my-zsh/themes && wget https://raw.githubusercontent.com/bem-kit/oh-my-zsh/master/themes/ya-mm.zsh-theme

    echo ${ORANGE}${BOLD}
    echo 'Установить fasd (github.com/clvv/fasd)...'
    echo ${RESET}
    if [ $IS_OSX ]; then
        brew install fasd
    else
        wget https://github.com/clvv/fasd/zipball/master -qO- > fasd.zip && unzip fasd.zip
        cd fasd/* && sudo make install
    fi

else
    WANT_OMZ=
fi

echo ${GREEN}${BOLD}
echo 'Ставим thefuck (github.com/nvbn/thefuck) [yn] ?:'; read WANT_THEFUCK;
echo ${RESET}
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

echo ${GREEN}${BOLD}
echo 'Ставим bem-cat [yn] ?:'; read WANT_BEMCAT;
echo ${RESET}
if [[ $WANT_BEMCAT = y ]]; then
    echo 'Ставим!'
    wget -qO- https://github.yandex-team.ru/bem-kit/bem-levels/raw/master/install.sh | sh
else
    WANT_BEMCAT=
fi

mkdir -p ~/.config/git/
touch ~/.config/git/config
git config -f ~/.config/git/config user.email "$(git config user.email)"
git config -f ~/.config/git/config user.name "$(git config user.name)"
mv ~/.gitconfig ~/.gitconfig.bak
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
echo ${ORANGE}${BOLD}
echo 'Внимание: ~/.gitconfig забэкаплен (~/.gitconfig.bak)) и заменён симлинкой на dotfiles'
echo 'Запустите diff ~/.gitconfig.bak ~/.gitconfig чтобы проверить отличия'
echo 'Используйте ~/.config/git/config для ваших настроек git, а так же имени и email'
echo ${RESET}

#
echo ${ORANGE}${BOLD}
echo заменить .zshrc на симлинк из dotfiles
echo ${RESET}
([ -e ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak); ln -s ~/dotfiles/.zshrc ~
echo ${ORANGE}${BOLD}
echo прежний конфиг сохранён в ~/.zshrc.bak
echo ${RESET}

#
echo переключить шелл
sudo chsh -s $(which zsh) $(whoami)

echo ${ORANGE}${BOLD}
echo Всё, перезагружайтесь
echo
echo 'Если шелл таки не переключится, то добавьте себя в /etc/passwd и /etc/group (sudo vim ...)'
echo 'Возможно, это костыльно, но другого способа разрешения этой проблемы не найдено (пока)'
echo ${RESET}
