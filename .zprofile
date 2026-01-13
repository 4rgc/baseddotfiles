# Load brew on MacOS (needed for Ghostty tmux auto-start setup)
if [[ $(uname) == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
