# bashrc

# exit if not bash
[ -n "$BASH" ] || exit

# get git branch
_git_br() {
    [ -d .git ] || return 1
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# check if command exists
has() {
    type -p $* &>/dev/null
}

# show hostname in prompt if in ssh session
if [ -n "$SSH_CONNECTION" ]; then
    PS1="\u@\h:\W\$(_git_br) $ "
else
    PS1="\u:\W\$(_git_br) $ "
fi

# aliases
alias l="ls -lhF"
alias ll="ls -lhAF"
alias f=z

# shell options
shopt -s histappend

# command history options
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="bg:cd:exit:f:fg:l:ll:ls:v:z"

# add custom bin directory to PATH
export PATH="$HOME/code/bin:$PATH"

# set nvim/vim as EDITOR
if has nvim; then
    export VISUAL=nvim EDITOR=nvim
elif has vim; then
    export VISUAL=vim EDITOR=vim
fi

# source bash completion
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
elif [ -f /usr/local/share/bash-completion/bash_completion ]; then
    source /usr/local/share/bash-completion/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
elif [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
fi

# fzf config
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--reverse --border'
has ag && export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -f -g ""'
has rg && export FZF_DEFAULT_COMMAND='rg --files --hidden'

# z config
[ -f "$HOME/.config/z/z.sh" ] && source "$HOME/.config/z/z.sh"
has z && export _Z_DATA="$HOME/.config/z/z"

# source local bashrc
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
