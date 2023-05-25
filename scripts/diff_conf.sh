#!/bin/bash

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

diff -r --suppress-common-lines --color=always -W "$(tput cols)" "$outPath" "$filedir" | grep -ve "^Only in $outPath"
