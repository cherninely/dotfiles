# Add `~/bin` to the `$PATH`
export "PATH=$HOME/.bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done
unset file

source ~/dotfiles/git-completion.bash
source ~/dotfiles/tms-complition.bash

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
    # Ensure existing Homebrew v1 completions continue to work
    export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
    complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

[ -e `which npm` ] && (. <(npm completion))2>/dev/null

if [[ -z `git config user.name` ]]; then
    echo -n "Please, enter user name for git config [Name Surname (nickname)]: "
    read GIT_AUTHOR_NAME
    mkdir -p ~/.config/git/
    git config -f ~/.config/git/config user.name "$GIT_AUTHOR_NAME"
fi

if [[ -z `git config user.email` ]]; then

    EMAIL_DOMAIN="yandex-team.ru"
    _GIT_AUTHOR_EMAIL="$(git config -f ~/.config/git/config user.name | grep -Eo '\(.+\)' | sed 's/(//; s/)//')"

    if [ $_GIT_AUTHOR_EMAIL ]; then

        GIT_AUTHOR_EMAIL="$_GIT_AUTHOR_EMAIL@$EMAIL_DOMAIN"
        echo "Your email is: $GIT_AUTHOR_EMAIL"

    else

        echo -n "Please, enter internal email login for git config [nickname]: "
        read GIT_AUTHOR_EMAIL
        GIT_AUTHOR_EMAIL="$(echo $GIT_AUTHOR_EMAIL | sed "s/@$EMAIL_DOMAIN//")@$EMAIL_DOMAIN"
        mkdir -p ~/.config/git/

    fi

    git config -f ~/.config/git/config user.email "$GIT_AUTHOR_EMAIL"

fi

# Save ssh agent socket for using in tmux sessions
if [[ $SSH_AUTH_SOCK && $SSH_AUTH_SOCK != $HOME/.ssh/ssh_auth_sock ]]
then
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi
