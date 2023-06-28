#!/usr/bin/env bash
# install packages and setup os config

trap 'echo "ERR trap (line: $LINENO, exit code: $?)"' ERR

set -eu

script_name="$(basename $BASH_SOURCE)"

usage() {
    printf "Usage: $0 <OPTION> ...\n\n"
    printf "Options:\n"
    printf "  -f            execute each step without prompting for confirmation\n"
    printf "  -o <path>     output base path (default: $HOME)\n"
    printf "\n"
    exit 2
}

is_interactive=1
outPath="$HOME"
localBinPath="$outPath/code/bin"

while getopts bfho: opt; do
    case "$opt" in
        f) is_interactive=0;;
        h) usage;;
        o) outPath="$(realpath $OPTARG)";;
        ?) usage;;
    esac
done

source "$(realpath $(dirname ${BASH_SOURCE[0]}))/utils.sh"

configure_env() {
    msg "Configuring common environment..."

    mkdir -vp "$localBinPath"

    msg_done
}

configure_mac() {
    msg "Configuring macOS defaults..."

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

    msg_done
}

install_homebrew() {
    if has brew; then
        warn "Homebrew already installed, skipping..."
        return
    fi

    msg "Installing Homebrew..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    msg_done
}

install_mac_pkgs() {
    msg "Installing packages for macOS..."

    local pkgs="chafa fd fzy neovim node python3 renameutils ripgrep"
    brew install $pkgs

    msg_done
}

install_ubuntu_pkgs() {
    msg "Installing packages for Ubuntu..."

    (
        set -eu
        mkdir -vp "$localBinPath"
        cd "$localBinPath"
        dl - "https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz" | tar -xz
        ln -vsnf "$localBinPath/nvim-linux64/bin/nvim" "$localBinPath/nvim"
    )

    (
        set -eu
        mkdir -vp "$localBinPath"
        cd "$localBinPath"
        dl direnv "https://github.com/direnv/direnv/releases/latest/download/direnv.linux-$(uname -m)"
        chmod ug+x direnv
    )

    local apt_pkgs="chafa fd-find fzy nodejs python3-pip renameutils ripgrep"
    sudo apt update
    sudo apt install $apt_pkgs

    msg_done
}

install_arch_pkgs() {
    msg "Installing packages for Arch Linux..."

    local pkgs="chafa fd fzy git htop jq neovim nodejs openssh python renameutils ripgrep"
    sudo pacman -Syyu --needed $pkgs

    msg_done
}

install_blocklets() {
    msg "Installing i3blocks blocklets..."

    local blockletdir="$configdir/i3blocks/blocklets"
    local tmpdir="$(mktemp -d /tmp/i3blocks-blocklets-XXX)"
    local url="https://github.com/vivien/i3blocks-contrib"

    if has git; then
        git clone --depth 1 "$url" "$tmpdir"
        rm -rf "$blockletdir"
        mv "$tmpdir" "$blockletdir"
    else
        warn "Git not found, skipping blocklets install."
        return
    fi

    msg_done
}

install_fzf() {
    msg "Installing fzf..."

    local fzfdir="$outPath/.fzf"
    local tmpdir="$(mktemp -d /tmp/fzf-XXX)"
    local url="https://github.com/junegunn/fzf.git"

    if has git; then
        git clone --depth 1 "$url" "$tmpdir"
        rm -rf "$fzfdir"
        mv "$tmpdir" "$fzfdir"

        chmod ug+x "$fzfdir/install"
        "$fzfdir/install" --key-bindings \
                          --completion \
                          --no-zsh \
                          --no-fish \
                          --no-update-rc \
                          1>/dev/null
    else
        warn "Git not found, skipping fzf install."
        return
    fi

    msg_done
}

install_z() {
    msg "Installing z..."

    local zdir="$configdir/z"
    local url="https://raw.githubusercontent.com/rupa/z/master/z.sh"

    mkdir -vp "$zdir"
    dl "$zdir/z.sh" "$url"

    msg_done
}

install_langservers() {
    msg "Installing language servers..."

    if is_mac; then
        brew install lua-language-server
    fi

    if has go; then
        GOBIN="$localBinPath" go install golang.org/x/tools/gopls@latest
    fi

    local npm_servers="bash-language-server pyright typescript typescript-language-server vscode-langservers-extracted"
    if has npm; then
        npm i -g "$npm_servers"
    else
        warn "Npm not found, skipping language server install."
    fi

    msg_done
}

main() {
    msg "Starting $script_name...\n"

    exec_step configure_env

    if is_mac; then
        exec_step configure_mac
        exec_step install_homebrew
        exec_step instalL_mac_pkgs
    elif is_linux; then
        if is_distro arch; then
            exec_step install_arch_pkgs
            exec_step install_blocklets
        elif is_distro ubuntu; then
            exec_step install_ubuntu_pkgs
        fi
    fi

    # exec_step install_fzf
    exec_step install_z
    # exec_step install_langservers

    printf "\n<<< Completed $script_name.\n\n"
}

main
