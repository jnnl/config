# bashrc
# jnnl.net

[ -z "$BASH" ] && exit  # exit if not bash
[[ $- != *i* ]] && exit # exit if not interactive

[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"
[ -f /usr/local/etc/profile.d/z.sh ] && source /usr/local/etc/profile.d/z.sh

if [ -d "$HOME/.cargo/bin" ] && [[ $PATH != *cargo/bin* ]]; then
    PATH="$PATH:$HOME/.cargo/bin"
fi

if [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# get git branch
function _git_br() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# github.com/justinmk/config/blob/master/.bashrc
function bd() {
    new_dir=$(echo $(pwd) | sed 's|\(.*/'$1'[^/]*/\).*|\1|')
    index=$(echo $new_dir | awk '{ print index($1,"/'$1'"); }')
    if [ $index -eq 0 ]; then
        echo "No such occurrence."
    else
        echo $new_dir
        cd "$new_dir"
    fi
}

function mcd() {
    mkdir -p "$@" && cd "$@"
}

shopt -s histappend
shopt -s cdspell

HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="bg:fg:exit:ls:ll:cd:z"
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

type -p fzf rg &>/dev/null && \
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
type -p vim &>/dev/null && export EDITOR=vim MANPAGER="vim '+set ft=man noma' -"
type -p nvim &>/dev/null && export EDITOR=nvim MANPAGER="nvim '+set ft=man noma' -"

export PATH="$PATH:$HOME/code/bin"
export _Z_DATA="$HOME/.config/z"

if [ -z "$SSH_CONNECTION" ]; then
    PS1="\u:\W\$(_git_br) $ "
else
    PS1="\u@\h:\W\$(_git_br) $ "
fi

alias ll="ls -lahF"

# Linux-specific settings
if [[ $(uname) == "Linux" ]]; then
    alias gdb="gdb -q"
fi

# macOS-specific settings
if [[ $(uname) == "Darwin" ]]; then
    alias bup="brew update && brew upgrade && brew cleanup && brew doctor"
    alias gdb="sudo gdb -q"

    export HOMEBREW_NO_ANALYTICS=1
fi
