#!/usr/bin/env bash
# diff local and repo configs

set -eu

# shellcheck source=utils.sh
source "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/utils.sh"

usage() {
    printf "Usage: %s [OPTION] ...\n\n" "$0"
    printf "Compare local and repo configs.\n"
    printf "\n"
    printf "Options:\n"
    printf "  -h            display this help text and exit\n"
    printf "  -o <path>     output base path (default: %s)\n" "$HOME"
    exit 2
}

out_path="$HOME"

while getopts ho: opt; do
    case "$opt" in
        h) usage;;
        o) out_path="$(realpath "$OPTARG")";;
        ?) usage;;
    esac
done
shift "$((OPTIND - 1))"

diff -r --suppress-common-lines --color=always -W "$(tput cols)" "$out_path" "$(realpath "$file_dir")" "$@" | grep -ve "^Only in $out_path" || true
