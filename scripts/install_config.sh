#!/usr/bin/env bash
# install config files

trap 'echo "ERR trap (line: $LINENO, exit code: $?)"' ERR

set -eu

script_name="$(basename $BASH_SOURCE)"

usage() {
    printf "Usage: $0 <OPTION> ...\n\n"
    printf "Options:\n"
    printf "  -b            make a backup of each existing config file\n"
    printf "  -e <pattern>  specify installable files by ERE regex pattern\n"
    printf "  -f            execute each step without prompting for confirmation\n"
    printf "  -h            display this help text and exit\n"
    printf "  -o <path>     output base path (default: $HOME)\n"
    printf "\n"
    exit 2
}

should_create_backups=0
should_use_file_pattern=0
file_pattern=""
is_interactive=1
out_path="$HOME"

while getopts be:fho: opt; do
    case "$opt" in
        b) should_create_backups=1;;
        e) should_use_file_pattern=1; file_pattern="$OPTARG";;
        f) is_interactive=0;;
        h) usage;;
        o) out_path="$(realpath $OPTARG)";;
        ?) usage;;
    esac
done

source "$(realpath $(dirname ${BASH_SOURCE[0]}))/utils.sh"


copy_files() {
    msg "Copying files..."

    local files="$(find $file_dir -type f | sed 's|^'$file_dir'/||')"
    local file source_file destination_file

    if test "$should_use_file_pattern" = "1"; then
        files="$(echo $files | tr ' ' '\n' | grep -E $file_pattern || true)"
    fi

    for file in $files; do
        source_file="$(realpath $file_dir/$file)"
        destination_file="$(realpath -m $out_path/$file)"

        if test "$should_use_file_pattern" = "1"; then
            {
                prompt_confirm "copy $source_file to $destination_file"
                local prompt_confirm_code="$?"
                if test "$prompt_confirm_code" = "1"; then
                    continue;
                elif test "$prompt_confirm_code" = "2"; then
                    break;
                fi
            } || true
        fi

        destination_file_dir="$(dirname $destination_file)"
        [ -d "$destination_file_dir" ] || mkdir -vp "$destination_file_dir"

        if test "$should_create_backups" = "1"; then
            if is_mac; then
                rsync -ab "$source_file" "$destination_file" && printf "$source_file -> $destination_file\n"
            else
                cp -bv "$source_file" "$destination_file"
            fi
        else
            cp -v "$source_file" "$destination_file"
        fi
    done

    msg_done
}

main() {
    msg "Starting $script_name..."
    msg "Output base path: $out_path\n"

    if test "$should_create_backups" != "1"; then
        msg "NOTE: backup not enabled, existing config files will be overwritten\n"
    fi

    if test "$should_use_file_pattern" = "1" -a "$is_interactive" = "1"; then
        msg "NOTE: install file pattern specified, you will be prompted before copying each matching file\n"
    fi

    exec_step copy_files

    printf "\n<<< Completed $script_name.\n\n"
}

main
