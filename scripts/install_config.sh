#!/usr/bin/env bash
# install config files

set -eu

script_name="$(basename "${BASH_SOURCE[0]}")"

usage() {
    printf "Usage: %s [OPTION] ...\n\n" "$0"
    printf "Install config files.\n"
    printf "\n"
    printf "Options:\n"
    printf "  -b            make a backup of each existing config file\n"
    printf "  -e <pattern>  specify installable files by ERE regex pattern\n"
    printf "  -f            execute each step without prompting for confirmation\n"
    printf "  -h            display this help text and exit\n"
    printf "  -o <path>     output base path (default: %s)\n" "$HOME"
    exit 2
}

[[ "${1:--X}" =~ ^\-[^-]+ ]] || usage # reject incorrect positional args

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
        o) out_path="$(realpath "$OPTARG")";;
        ?) usage;;
    esac
done
shift "$((OPTIND - 1))"

# shellcheck source=utils.sh
source "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/utils.sh"

backup_file() {
    local src="$1"
    local dest="$2"
    if is_mac; then
        rsync -ab "$src" "$dest" && printf "%s -> %s\n" "$src" "$dest"
    else
        cp -bv "$src" "$dest"
    fi
}

resolve_path() {
    local path="$1"
    if is_mac; then
        printf "%s" "$(grealpath -m "$path")"
    else
        printf "%s" "$(realpath -m "$path")"
    fi
}

copy_config_files() {
    printf "Copying config files...\n"

    local file files matching_files source_file destination_file

    while IFS= read -r line; do
        files+=("$line")
    done < <(find "$file_dir" -type f | sed 's|^'"$file_dir"'/||')

    if [ "$should_use_file_pattern" = "1" ]; then
        while IFS= read -r line; do
            matching_files+=("$line")
        done < <(printf "%s\n" "${files[@]}" | grep -E "$file_pattern")
        files=("${matching_files[@]}")
    fi

    for file in "${files[@]}"; do
        source_file="$(resolve_path "$file_dir/$file")"
        destination_file="$(resolve_path "$out_path/$file")"

        if [ "$should_use_file_pattern" = "1" ] && ! [ -d "$destination_file" ]; then
            {
                prompt_confirm "copy ${source_file} to ${destination_file}?"
                local prompt_confirm_code="$?"
                if [ "$prompt_confirm_code" = "1" ]; then
                    continue;
                elif [ "$prompt_confirm_code" = "2" ]; then
                    break;
                fi
            } || true
        fi

        destination_file_dir="$(dirname "$destination_file")"
        [ -d "$destination_file_dir" ] || mkdir -vp "$destination_file_dir"
        [ -d "$destination_file" ] && continue

        if [ "$should_create_backups" = "1" ]; then
            backup_file "$source_file" "$destination_file"
        else
            cp -v "$source_file" "$destination_file"
        fi
    done

    msg_done "${FUNCNAME[0]}"
}

main() {
    printf "Starting %s...\n\n" "$script_name"
    printf "Output base path: %s\n" "$out_path"

    if [ "$should_use_file_pattern" = "1" ] && [ "$is_interactive" = "1" ]; then
        printf "File pattern '%s' was specified, you will be prompted before copying each matching file.\n" "$file_pattern"
    fi

    if [ "$should_create_backups" != "1" ]; then
        printf "\n"
        warn "backup not enabled, existing config files will be replaced."
    fi

    printf "\n"

    exec_step copy_config_files

    printf "Completed %s.\n" "$script_name"
}

main
