# Agents Guide

## Repo structure

Personal dotfiles for an Arch Linux / Hyprland setup, tracked with git from `~/.dotfiles`.

```
.config/
  hypr/                  Hyprland WM configuration (see .config/hypr/AGENTS.md)
  nvim/                  Neovim config (lazy.nvim)
  ghostty/               Ghostty terminal config
  ohmyposh/              Prompt theme
  tmux/                  tmux config + tpm plugins
  alacritty/             Alacritty colors
.local/bin/              User scripts and local binaries
.zshrc.example           Zsh config template
.zprofile                Zsh login profile
.zsh_plugins.txt         Antidote plugin list
.osxrc                   macOS-specific shell config
.nvimrc                  Minimal Neovim config (repo root override)
.gitignore               Git ignore rules
.stow-local-ignore       Stow ignore rules
.ignore                  ripgrep/fd ignore rules
corne_v4.layout.json     Vial keyboard layout for Corne v4
com.googlecode.iterm2.plist  iTerm2 preferences (macOS)
setup_mac.sh             macOS bootstrap script
```

## Critical rules

**Never edit files under `.config/hypr/hyprland/`** — these are upstream defaults. All customisation goes in `.config/hypr/custom/`.

See `.config/hypr/AGENTS.md` for Hyprland config and keybind details.
