#!/bin/bash

set -eu

source "$(realpath $(dirname ${BASH_SOURCE[0]}))/utils.sh"

usage() {
    printf "Usage: $0 <OPTION> ...\n\n"
    printf "Options:\n"
    printf "  -f            execute each step without prompting for confirmation\n"
    printf "  -i <path>     input base path (default: $HOME)\n"
    printf "\n"
    exit 2
}

is_interactive=1
inPath="$HOME"

while getopts fhi: opt; do
    case "$opt" in
        h) usage;;
        f) is_interactive=0;;
        i) inPath="$(realpath $OPTARG)";;
        ?) usage;;
    esac
done
shift $((OPTIND-1))

while read line <&3; do
    line_files=($line)
    if test ${#line_files[@]} -ne 2; then 
        continue
    fi

    source_file="$(realpath ${line_files[0]})"
    destination_file="$(realpath ${line_files[1]})"
    if cmp --silent "$source_file" "$destination_file"; then
        continue
    fi

    if test "$is_interactive" = "1"; then
        cp -i "$source_file" "$destination_file"
    else
        cp "$source_file" "$destination_file"
    fi
done 3<<< $(diff -qr "$inPath" "$filedir" | awk '!/^Only in/ { print $2, $4 }')
