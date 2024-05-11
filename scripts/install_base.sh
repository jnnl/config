#!/usr/bin/env bash
# install packages and configure environment

set -eu

script_name="$(basename "${BASH_SOURCE[0]}")"

usage() {
    printf "Usage: %s [OPTION] ...\n\n" "$0"
    printf "Install packages and configure environment.\n"
    printf "\n"
    printf "Options:\n"
    printf "  -f            execute each step without prompting for confirmation\n"
    printf "  -h            display this help text and exit\n"
    printf "  -o <path>     output base path (default: %s)\n" "$HOME"
    exit 2
}

[[ "${1:--X}" =~ ^\-[^-]+ ]] || usage

is_interactive=1
out_path="$HOME"
local_bin_path="$out_path/code/bin"

while getopts bfho: opt; do
    case "$opt" in
        f) is_interactive=0;;
        h) usage;;
        o) out_path="$(realpath "$OPTARG")";;
        ?) usage;;
    esac
done
shift "$((OPTIND - 1))"

# shellcheck source=utils.sh
source "$(realpath "$(dirname "${BASH_SOURCE[0]}")")/utils.sh"

configure_common_env() {
    printf "Configuring common environment...\n"

    mkdir -vp "$local_bin_path"

    msg_done "$FUNCNAME"
}

configure_mac_env() {
    printf "Configuring macOS environment...\n"

    # Expand save panels
    defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
    defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

    # Disable automatic text meddling
    defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
    defaults write -g NSAutomaticCapitalizationEnabled -bool false
    defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
    defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
    defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

    # Show filename extensions
    defaults write -g AppleShowAllExtensions -bool true

    # Disable inverted scrolling
    defaults write -g com.apple.swipescrolldirection -bool false

    # Enable font smoothing
    defaults write -g CGFontRenderingFontSmoothingDisabled -bool false

    # Disable animations
    defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
    defaults write -g QLPanelAnimationDuration -float 0
    defaults write com.apple.finder DisableAllAnimations -bool true

    # Show full paths
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # Autohide Dock
    defaults write com.apple.dock autohide -bool true

    # Disable screenshot shadows
    defaults write com.apple.screencapture disable-shadow -bool true

    # Show ~/Library in Finder
    chflags nohidden ~/Library

    killall Dock Finder

    msg_done "$FUNCNAME"
}

install_homebrew() {
    if has brew; then
        printf "Homebrew already installed, skipping...\n"
        return
    fi

    printf "Installing Homebrew...\n"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    msg_done "$FUNCNAME"
}

install_mac_pkgs() {
    printf "Installing packages for macOS...\n"

    local pkgs=("chafa" "coreutils" "fd" "neovim" "node" "python3" "ranger" "renameutils" "ripgrep" "shellcheck")
    brew install "${pkgs[@]}"

    msg_done "$FUNCNAME"
}

install_deb_pkgs() {
    printf "Installing packages for Debian/Ubuntu...\n"

    (
        set -eu
        mkdir -vp "$local_bin_path"
        cd "$local_bin_path"
        dl - "https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz" | tar -xz
        ln -vsnf "$local_bin_path/nvim-linux64/bin/nvim" "$local_bin_path/nvim"
    )

    (
        set -eu
        mkdir -vp "$local_bin_path"
        cd "$local_bin_path"
        local arch
        arch="$(uname -m)"
        if [ "$arch" = "x86_64" ]; then
            arch="amd64"
        fi
        dl direnv "https://github.com/direnv/direnv/releases/latest/download/direnv.linux-$arch"
        chmod ug+x direnv
    )

    local apt_pkgs=("chafa" "fd-find" "nodejs" "python3-pip" "ranger" "renameutils" "ripgrep" "shellcheck")
    sudo apt update
    sudo apt install "${apt_pkgs[@]}"

    msg_done "$FUNCNAME"
}

install_arch_pkgs() {
    printf "Installing packages for Arch Linux...\n"

    local pkgs=("chafa" "fd" "git" "htop" "jq" "neovim" "nodejs" "openssh" "python" "ranger" "renameutils" "ripgrep" "shellcheck")
    sudo pacman -Syyu --needed "${pkgs[@]}"

    msg_done "$FUNCNAME"
}

install_fzf() {
    printf "Installing fzf...\n"

    local fzf_dir="$out_path/.fzf"
    local tmp_dir
    tmp_dir="$(mktemp -d /tmp/fzf-XXXXX)"
    local url="https://github.com/junegunn/fzf.git"

    if ! has git; then
        warn "git not found, skipping fzf install."
        return
    fi

    git clone --depth 1 "$url" "$tmp_dir"
    rm -rf "$fzf_dir"
    mv "$tmp_dir" "$fzf_dir"

    chmod ug+x "$fzf_dir/install"
    "$fzf_dir/install" \
        --key-bindings \
        --completion \
        --no-zsh \
        --no-fish \
        --no-update-rc \
        1>/dev/null

    [ -d "$tmp_dir" ] && rm -rf "$tmp_dir"

    msg_done "$FUNCNAME"
}

install_z() {
    printf "Installing z...\n"

    local z_dir="$config_dir/z"
    mkdir -vp "$z_dir"
    cp -v "$script_dir/tools/z.sh" "$z_dir"

    msg_done "$FUNCNAME"
}

install_tool_scripts() {
    printf "Installing tool scripts...\n"

    exec_step install_z

    msg_done "$FUNCNAME"
}

main() {
    printf "Starting %s...\n\n" "$script_name"

    exec_step configure_common_env

    if is_mac; then
        exec_step configure_mac_env
        exec_step install_homebrew
        exec_step install_mac_pkgs
    elif is_linux; then
        if is_distro arch; then
            exec_step install_arch_pkgs
        elif is_distro debian; then
            exec_step install_deb_pkgs
        elif is_distro ubuntu; then
            exec_step install_deb_pkgs
        fi
    fi

    exec_step install_fzf
    exec_step install_tool_scripts

    printf "\nCompleted %s.\n" "$script_name"
}

main
