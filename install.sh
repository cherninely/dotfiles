cd ~
git clone git://github.yandex-team.ru/search-interfaces/dotfiles.git
chmod 600 ~/dotfiles/ssh/*

# дописываем в самое начало "source dotfiles/..."
touch ~/.bash_profile
sed -i '' -e '1i\
source ~/dotfiles/.bash_profile' ~/.bash_profile
source ~/.bash_profile
