# FreeBSD stuff
#
# Setting TERM is normally done through /etc/ttys.  Do only override
# if you're sure that you'll never log in via telnet or xterm or a
# serial line.
# Use cons25l1 for iso-* fonts
# TERM=cons25;  export TERM

# set ENV to a file invoked each time sh is started for interactive use.
export ENV=$HOME/.shrc

if [ -x /usr/games/fortune ] ; then /usr/games/fortune freebsd-tips ; fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && source "$file"
done
unset file

source ~/dotfiles/git-completion.bash
source ~/dotfiles/wcshow-completion.bash
source ~/dotfiles/wcnew-complition.bash
source ~/dotfiles/tms-complition.bash

if [[ -z `git config --global user.name` ]]; then
    echo -n "Please, enter user name for git config: "
    read GIT_AUTHOR_NAME
    git config --global user.name "$GIT_AUTHOR_NAME"
fi

if [[ -z `git config --global user.email` ]]; then
    echo -n "Please, enter email for git config: "
    read GIT_AUTHOR_EMAIL
    git config --global user.email "$GIT_AUTHOR_EMAIL"
fi

if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

# Create a new directory and enter it
function d() {
    mkdir -p "$@" && cd "$@"
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* *
    fi
}

_expand()
{
    return 0;
}

# Save ssh agent socket for using in tmux sessions
if [[ $SSH_AUTH_SOCK && $SSH_AUTH_SOCK != $HOME/.ssh/ssh_auth_sock ]]
then
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi

# # command prompt
# case $TERM in
#     screen*)
#         SCREENTITLE='\[\ek\e\\\]\[\ek\W\e\\\]'
#         ;;
#     *)
#         SCREENTITLE=''
#         ;;
# esac
# export PS1="${SCREENTITLE}[\u@\h \W]\$ "


[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
