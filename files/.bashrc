# .bashrc

# skip if not running interactively
[[ $- != *i* ]] && return

# check if command exists
has() {
    type -p "$1" &>/dev/null
}

# cd to dirname
cdd() {
    cd "$(dirname "${1:-$PWD}")" || return
}

# cd to selected shell wd
cdsh() {
    local dir
    dir="$(pgrep -x bash | xargs -I_ readlink /proc/_/cwd | \
        sort -u | grep -Fvx "$PWD" | \
        fzf +s --reverse)" && cd "$dir" || return
}

# cd to git root
cdgr() {
    local gitdir dir
    if [ $# -gt 0 ]; then
        gitdir="$(realpath "$1")"
        [ -d "$gitdir" ] || gitdir="$(dirname "$gitdir")"
        dir="$(git -C "$gitdir" rev-parse --show-toplevel)" && cd "$dir" || return
    else
        dir="$(git rev-parse --show-toplevel)" && cd "$dir" || return
    fi
}

# browse man pages by name and description
manf() {
    man -k . | fzf | awk '{ print $1 }' | xargs -r man
}

# browse git commits
gcb() {
    git rev-parse || return
    git log --graph --color=always --date=short \
        --format="%C(yellow)%h %Cgreen%ad %Cblue%aN%Cred%d %Creset%s" "$@" | \
        fzf --ansi --no-sort --reverse --tiebreak=index \
        --preview 'git show --color=always {+2}' \
        --bind "ctrl-m:execute:
            (grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
            {}
FZF-EOF"
}

gco() {
    git rev-parse || return
    git branch --format='%(refname:short)' | \
        fzf --preview='git log -10 --color=always {..}' | \
        xargs -r git checkout
}

# kill selected process
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u "$UID" | sed 1d | fzf -m | awk '{ print $2 }')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{ print $2 }')
    fi

    [ "$pid" != "" ] && printf "%s\n" "$pid" | xargs kill -"${1:-9}"
}

# print compacted wd path
compact_pwd() {
    local path=""
    local pathsep="/"
    local path_parts=()
    local trunclen="1"
    local triglen="20"

    if test "${#PWD}" -lt "$triglen"; then
        printf "%s" "$PWD"
        return
    fi

    IFS="$pathsep" read -ra path_parts < <(printf "%s\0" "$PWD")

    for part in "${path_parts[@]:1:${#path_parts[@]}-2}"; do
        path="$path$pathsep${part::trunclen}"
    done

    path="$path$pathsep${path_parts[-1]}"
    printf "%s" "$path"
}

# print number of stopped jobs
__nstopjobs() {
    n_stopped="$(jobs -ps 2>/dev/null | wc -l)"
    test "$n_stopped" -gt 0 && printf " [%s]" "${n_stopped#${n_stopped%%[![:space:]]*}}"
}

# prompt
if test -f /usr/share/git/completion/git-prompt.sh; then
    source "$_"
elif test -f /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh; then
    source "$_"
elif test -f /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh; then
    source "$_"
fi

# git completion
if test -f /opt/homebrew/etc/bash_completion.d/git-completion.bash; then
    source "$_"
fi

if has __git_ps1; then
    PS1="\u:\W\$(__git_ps1)\$(__nstopjobs) $ "
else
    PS1="\u:\W\$(__nstopjobs) $ "
fi

# aliases
alias g="git"
alias l="ls -lhF"
alias ll="ls -lhAF"
alias lx="ls -lhAFX"

# shell options
shopt -s histappend

# command history options
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE=bg:cd:cdd:exit:shd:f:fg:l:ll:ls:v:z

# environment variables
export GIT_PS1_SHOWDIRTYSTATE=1
export PATH="$HOME/code/bin:$PATH"

# set nvim/vim as EDITOR
if has nvim; then
    alias vim=nvim
    export VISUAL=nvim EDITOR=nvim
elif has vim; then
    export VISUAL=vim EDITOR=vim
fi

# bash completion
if test -f /usr/share/bash-completion/bash_completion; then
    source "$_"
elif test -f /usr/local/share/bash-completion/bash_completion; then
    source "$_"
elif test -f /usr/local/etc/bash_completion; then
    source "$_"
elif test -f /etc/bash_completion; then
    source "$_"
fi

# fzf
if test -f ~/.config/fzf/fzf.bash; then
    source "$_"
elif test -f ~/.fzf.bash; then
    source "$_"
fi
if has fzf; then
    export FZF_DEFAULT_OPTS="--reverse --border"
    if has fd; then
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
    elif has rg; then
        export FZF_DEFAULT_COMMAND="rg --files --hidden -g'!.git/'"
    fi
fi

# z
if test -f ~/.config/z/z.sh; then
    export _Z_DATA="$HOME/.config/z/z_data"
    source ~/.config/z/z.sh

    f() {
        test $# -gt 0 && _z "$*" && return
        cd "$(_z -l 2>&1 | awk '{ print $2 }' | fzf --reverse --tac --no-sort --height=40%)" || return
    }

    ff() {
        test $# -gt 0 && _z -c "$*" && return
        cd "$(_z -lc 2>&1 | awk '{ print $2 }' | fzf --reverse --tac --no-sort --height=40%)" || return
    }
fi

# source local bashrc
test -f ~/.bashrc.local && source "$_"
