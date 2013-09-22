cd ~
git clone git://github.yandex-team.ru/search-interfaces/dotfiles.git
chmod 600 ~/dotfiles/ssh/*

test -f ~/.tmux.conf || ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

echo 'source ~/dotfiles/.bash_profile' >> ~/.bash_profile
source ~/.bash_profile
