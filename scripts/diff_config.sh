#!/usr/bin/env bash
# diff local and repo configs

trap 'echo "ERR trap (line: $LINENO, exit code: $?)"' ERR

set -eu

source "$(realpath $(dirname ${BASH_SOURCE[0]}))/utils.sh"

usage() {
    printf "Usage: $0 <OPTION> ...\n\n"
    printf "Options:\n"
    printf "  -o <path>     output base path (default: $HOME)\n"
    printf "\n"
    exit 2
}

outPath="$HOME"

while getopts ho: opt; do
    case "$opt" in
        h) usage;;
        o) outPath="$(realpath $OPTARG)";;
        ?) usage;;
    esac
done
shift $((OPTIND-1))

diff -r --suppress-common-lines --color=always -W "$(tput cols)" "$outPath" "$(realpath $filedir)" | grep -ve "^Only in $outPath" || true
