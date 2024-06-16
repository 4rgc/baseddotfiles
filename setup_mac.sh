#!/usr/bin/env zsh

RED='\033[0;31m'
RESET='\033[0m'

# This script is used to install the dotfiles in the home directory of the user

# Check if brew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! command -v stow &> /dev/null ; then
    echo "Stow is not installed. Installing now..."
    brew install stow
fi

if [ -f ~/.zshrc ]; then
    read "yn?~/.zshrc already exists. Do you want to overwrite it? [y/n] "
    if [[ $yn == "y" ]]; then
        rm ~/.zshrc
    fi
    cp .zshrc.example .zshrc
    sed -i '' "s/DOTFILES=$/DOTFILES=$( echo ${${0:a:h}:gs/\//\\\//} )/" .zshrc
fi

stow .

source ~/.zshrc

if ! command -v omz &> /dev/null; then
    echo "Oh My Zsh is not installed. Installing now..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if command -v nvim; then
    echo "${RED}Neovim is already installed. Cannot build and install from source.${RESET}"
else
    read "yn?Neovim is not installed. Build and install it from source? [y/n] "
    if [[ $yn == "y" ]]; then
        ~/.local/bin/nvim_launcher --skip-launch
    fi
fi

# Install the nerdfont
brew install --cask font-meslo-lg-nerd-font

