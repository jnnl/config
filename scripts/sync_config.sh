#!/usr/bin/env bash
# copy changed local config files to repo

trap 'echo "ERR trap (line: $LINENO, exit code: $?)"' ERR

set -eu

source "$(realpath $(dirname ${BASH_SOURCE[0]}))/utils.sh"

usage() {
    printf "Usage: $0 <OPTION> ...\n\n"
    printf "Options:\n"
    printf "  -f            sync all changed files without prompting for confirmation\n"
    printf "  -h            display this help text and exit\n"
    printf "  -i <path>     input base path (default: $HOME)\n"
    printf "\n"
    exit 2
}

is_interactive=1
in_path="$HOME"

while getopts fhi: opt; do
    case "$opt" in
        f) is_interactive=0;;
        h) usage;;
        i) in_path="$(realpath $OPTARG)";;
        ?) usage;;
    esac
done
shift $((OPTIND-1))

while read -a line_files <&3; do
    if test ${#line_files[@]} -ne 2; then 
        continue
    fi

    source_file="$(realpath ${line_files[0]})"
    destination_file="$(realpath ${line_files[1]})"
    if cmp --silent "$source_file" "$destination_file"; then
        continue
    fi

    if test "$is_interactive" = "1"; then
        cp -iv "$source_file" "$destination_file" || true
    else
        cp -v "$source_file" "$destination_file"
    fi
done 3<<< "$(diff -qr "$in_path" "$file_dir" | awk '!/^Only in/ { print $2, $4 }')"
