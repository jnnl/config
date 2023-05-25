#!/bin/bash

set -eu

source "$(realpath $(dirname ${BASH_SOURCE[0]}))/utils.sh"

"$scriptdir/install_base.sh" "$*"
"$scriptdir/install_config.sh" "$*"

printf "<<< all done!\n"
