cd ~
git clone git://github.yandex-team.ru/search-interfaces/dotfiles.git
chmod 600 dotfiles/ssh/*
sed -i '' -e '1i\ 
source dotfiles/.profile' .profile
source .profile
