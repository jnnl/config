#!/bin/bash

set -eu
source utils

"$scriptdir/install_base.sh" "$*"
"$scriptdir/install_config.sh" "$*"

printf "<<< all done!\n"
