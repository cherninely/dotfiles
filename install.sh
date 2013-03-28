cd ~
git clone git://github.yandex-team.ru/search-interfaces/dotfiles.git
chmod 600 ~/dotfiles/ssh/*

echo 'source ~/dotfiles/.bash_profile' >> ~/.bash_profile
source ~/.bash_profile
