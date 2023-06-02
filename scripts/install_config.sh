#!/bin/bash
# install config files

set -eu

script_name="$(basename $BASH_SOURCE)"

usage() {
    printf "Usage: $0 <OPTION> ...\n\n"
    printf "Options:\n"
    printf "  -b            make a backup of each existing config file\n"
    printf "  -f            execute each step without prompting for confirmation\n"
    printf "  -o <path>     output base path (default: $HOME)\n"
    printf "\n"
    exit 2
}

should_create_backups=0
is_interactive=1
outPath="$HOME"

while getopts bfho: opt; do
    case "$opt" in
        b) should_create_backups=1;;
        f) is_interactive=0;;
        h) usage;;
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

    for file in $files; do
        if test "$should_create_backups" = "1"; then
            if is_mac; then
                rsync -ab "$filedir/$file" "$outPath/$file" && printf "$filedir/$file -> $outPath/$file\n"
            else
                cp -bv "$filedir/$file" "$outPath/$file"
            fi
        else
            cp -v "$filedir/$file" "$outPath/$file"
        fi
    done

    msg_done
}

main() {
    msg "Starting $script_name..."
    msg "Output base path: $outPath\n"

    if test "$should_create_backups" != "1"; then
        msg "NOTE: backup not enabled, existing config files will be overwritten\n"
    fi

    exec_step copy_files

    printf "\n<<< Completed $script_name.\n\n"
}

main
