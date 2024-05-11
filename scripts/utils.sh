#!/usr/bin/env bash
# utility functions

set -eu

[ "$BASH_VERSION" != "" ] || { printf "This script requires bash to run.\n"; exit 1; }

readonly script_dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
readonly file_dir="$script_dir/../files"
readonly config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
export script_dir file_dir config_dir

err() {
    local msg="ERROR: $*"
    if [ -t 1 ]; then
        printf "%b%s%b\n" "\033[31m" "$msg" "\033[0m" >&2
    else
        printf "%s\n" "$msg" >&2
    fi
    exit 1
}

warn() {
    local msg="WARNING: $*"
    if [ -t 1 ]; then
        printf "%b%s%b\n" "\033[33m" "$msg" "\033[0m" >&2
    else
        printf "%s\n" "$msg" >&2
    fi
}

msg_done() {
    printf "Completed %s.\n\n" "$*"
}

has() {
    type -p "$1" &>/dev/null
}

is_mac() {
    [ "$(uname -s)" = Darwin ]
}

is_linux() {
    [ "$(uname -s)" = Linux ]
}

is_distro() {
    grep -qsx "ID=\"*$1\"*" /etc/os-release
}

is_arch() {
    [ "$(uname -m)" = "$1" ]
}

dl() {
    if has curl; then
        curl -#fLo "$@"
    elif has wget; then
        wget --show-progress -qO "$@"
    else
        err "no curl or wget found"
    fi
}

prompt_confirm() {
    if [ "$is_interactive" = "1" ]; then
        read -rp "> $* [Y/n/q] " choice
        case "$choice" in
            y|Y|"") return 0;;
            q) return 2;;
            n|N|*) return 1;;
        esac
    else
        return 0;
    fi
}

exec_step() {
    if [ "$is_interactive" = "1" ]; then
        read -rp "> $*? [Y/n/q] " choice
        case "$choice" in
            y|Y|"") "$@";;
            q) printf "\nSkipping rest of %s...\n" "$script_name"; exit 0;;
            n|N|*) ;;
        esac
    else
        "$@"
    fi
}
