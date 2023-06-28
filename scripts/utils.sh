#!/usr/bin/env bash
# utility functions

trap 'echo "ERR trap (line: $LINENO, exit code: $?)"' ERR

set -eu

test -n "$BASH" || { printf "This script requires bash to run."; exit 1; }

readonly scriptdir="$(realpath $(dirname ${BASH_SOURCE[0]}))"
readonly filedir="$scriptdir/../files"
readonly configdir="${XDG_CONFIG_HOME:-$HOME/.config}"

err() {
    printf "!!! ERROR: $*\n" >&2
    exit 1
}

warn() {
    printf "~~~ $*\n" >&2
}

msg() {
    printf ">>> $*\n"
}

msg_done() {
    printf "<<< done\n\n"
}

has() {
    type -p "$1" &>/dev/null
}

is_mac() {
    test "$(uname -s)" = Darwin
}

is_linux() {
    test "$(uname -s)" = Linux
}

is_distro() {
    grep -qsx "ID=\"*$1\"*" /etc/os-release
}

is_arch() {
    test "$(uname -m)" = "$1"
}

dl() {
    if has curl; then
        curl -#fLo $*
    elif has wget; then
        wget --show-progress -qO $*
    else
        err "no curl or wget found"
    fi
}

exec_step() {
    if test "$is_interactive" = "1"; then
        read -p "> $*? [Y/n/q] " choice
        case "$choice" in
            y|Y|"") $*;;
            q) printf "\n<<< Skipping rest of $script_name...\n\n"; exit 0;;
            n|N|*) ;;
        esac
    else
        $*
    fi
}
