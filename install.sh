cd ~
git clone git://github.yandex-team.ru/search-interfaces/dotfiles.git
chmod 600 ~/dotfiles/ssh/*
touch ~/.profile
sed -i '' -e '1i\ 
source ~/dotfiles/.profile' .profile
source ~/.profile
