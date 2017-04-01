# zshrc

# Get current git branch for PROMPT
get_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export HISTCONTROL=ignoredups
export PATH="$PATH:$HOME/code/bin"
export PROMPT="%n:%1~$(get_git_branch) %% "

alias ll="ls -lahF"
