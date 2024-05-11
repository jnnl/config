#!/usr/bin/env bash
# install packages, setup os config and install config files

set -eu

# shellcheck source=utils.sh
source "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/utils.sh"

"$script_dir/install_base.sh" "$*"
"$script_dir/install_config.sh" "$*"

printf "Completed install.sh.\n"
