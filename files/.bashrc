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
    if test "$(uname -s)" = Darwin; then
        dir="$(pgrep -x -- -bash | \
            xargs -I_ lsof -a -Fn -d cwd -p _ | \
            awk '/^n/ { print substr($1, 2) }' | \
            sort -u | grep -Fvx "$PWD" | \
            fzf +s --reverse)" && cd "$dir" || return
    else
        dir="$(pgrep -x bash | \
            xargs -I_ readlink /proc/_/cwd | \
            sort -u | grep -Fvx "$PWD" | \
            fzf +s --reverse)" && cd "$dir" || return
    fi
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

# browse git commits
gcb() {
    git log --color \
        --date=format:"%F %H:%M:%S" \
        --pretty=format:"%C(auto)%h  %C(green)%ad  %C(blue)%<(15,trunc)%an %C(auto)%s%d" \
        "$@" | \
        fzf --ansi --multi --no-sort --reverse \
        --preview "git show --color {+1}" \
        --bind "ctrl-m:execute:(grep -o '[0-9a-f]\{7\}' | paste -sd ' ' | xargs git show) << EOF
            {+}
EOF"
}

# browse and checkout git branches
gco() {
    git branch --format="%(refname:short)" | \
        fzf --preview "git log -10 --color {..}" | \
        xargs -r git checkout
}

# browse man pages by name and description
fman() {
    man -k . | fzf | awk '{ print $1 }' | xargs -r man
}

# browse and kill user processes
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{ print $2 }')
    [ "$pid" != "" ] && printf "%s\n" "$pid" | xargs kill -"${1:-9}"
}

# source first found file
sourcef() {
    for f in "$@"; do
        if [ -f "$f" ] || [ -h "$f" ]; then
            source "$f"
            return
        fi
    done
}

# print compacted wd path
compact_pwd() {
    local path=""
    local pathsep="/"
    local path_parts=()
    local trunclen="1"
    local triglen="20"

    if [ "${#PWD}" -lt "$triglen" ]; then
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

# tmux convenience wrapper
t() {
    if [ $# -gt 0 ]; then
        tmux "$@"
    else
        tmux at || tmux
    fi
}

# print number of stopped jobs
__nstopjobs() {
    n_stopped="$(jobs -ps 2>/dev/null | wc -l)"
    [ "$n_stopped" -gt 0 ] && printf " [%s]" "${n_stopped#${n_stopped%%[![:space:]]*}}"
}

# git prompt
sourcef \
    /usr/share/git/completion/git-prompt.sh \
    /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh \
    /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh

# git completion
sourcef /opt/homebrew/etc/bash_completion.d/git-completion.bash

# prompt
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
alias v="fzf -m --bind 'enter:become(nvim {+})'"

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
sourcef \
    /usr/share/bash-completion/bash_completion \
    /usr/local/share/bash-completion/bash_completion \
    /usr/local/etc/bash_completion \
    /etc/bash_completion

# fzf
sourcef \
    ~/.config/fzf/fzf.bash \
    ~/.fzf.bash

if has fzf; then
    export FZF_DEFAULT_OPTS="--reverse --border"
    if has fd; then
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
    elif has rg; then
        export FZF_DEFAULT_COMMAND="rg --files --hidden -g'!.git/'"
    fi
fi

# z
if [ -f ~/.config/z/z.sh ]; then
    export _Z_DATA="$HOME/.config/z/z_data"
    source ~/.config/z/z.sh

    f() {
        [ $# -gt 0 ] && _z "$*" && return
        cd "$(_z -l 2>&1 | \
            awk '{ print $2 }' | \
            fzf --reverse --tac --no-sort --height=40% --preview 'ls -Aq --color {}' \
        )" || return
    }

    ff() {
        [ $# -gt 0 ] && _z -c "$*" && return
        cd "$(_z -lc 2>&1 | \
            awk '{ print $2 }' | \
            fzf --reverse --tac --no-sort --height=40% --preview 'ls -Aq --color {}' \
        )" || return
    }
fi

# source local bashrc
sourcef ~/.bashrc.local
