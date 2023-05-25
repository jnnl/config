#!/bin/bash
# install config files

set -eu

script_name="$(basename $BASH_SOURCE)"

usage() {
    printf "Usage: $0 <OPTION> ...\n\n"
    printf "Options:\n"
    printf "  -b            make a backup of each existing config file\n"
    printf "  -i            prompt before executing each step\n"
    printf "  -o <path>     output base path (default: $HOME)\n"
    printf "\n"
    exit 2
}

should_create_backups=0
is_interactive=0
outPath="$HOME"

while getopts bhio: opt; do
    case "$opt" in
        b) should_create_backups=1;;
        h) usage;;
        i) is_interactive=1;;
        o) outPath="$(realpath $OPTARG)";;
        ?) usage;;
    esac
done

source "$(realpath $(dirname ${BASH_SOURCE[0]}))/utils.sh"

create_dirs() {
    msg "Creating directories..."

    local directories="$(find $filedir -mindepth 1 -type d | sed 's|^'$filedir'/||')"
    local directory

    for directory in $directories; do
        mkdir -vp "$outPath/$directory"
    done

    msg_done

}

copy_files() {
    create_dirs

    msg "Copying files..."

    local files="$(find $filedir -type f | sed 's|^'$filedir'/||')"
    local file
    local cp_opts="-v"
    if test "$should_create_backups" = "1"; then
        cp_opts="$cp_opts -b"
    fi

    for file in $files; do
        cp $cp_opts "$filedir/$file" "$outPath/$file"
    done

    msg_done
}

main() {
    msg "Starting $script_name..."
    msg "Output base path: $outPath\n"

    exec_step copy_files

    printf "\n<<< Completed $script_name.\n\n"
}

main
