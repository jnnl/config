#!/usr/bin/env bash
# install packages, setup os config and install config files

trap 'echo "ERR trap (line: $LINENO, exit code: $?)"' ERR

set -eu

source "$(realpath $(dirname ${BASH_SOURCE[0]}))/utils.sh"

"$script_dir/install_base.sh" "$*"
"$script_dir/install_config.sh" "$*"

printf "<<< all done!\n"