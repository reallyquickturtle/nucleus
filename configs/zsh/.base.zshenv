# Set XDG Base Directory specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# AWS CLI flags
export AWS_EC2_METADATA_DISABLED=true

# Homebrew on ARM Macs
if [[ "$(uname)" == "Darwin" && "$(uname -m)" == "arm64" ]]; then
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

# Set base PATH
export PATH="${HOME}/.local/bin:${HOME}/bin:/usr/local/bin:/usr/local/sbin:$PATH"

# Android Path
if [[ "$(uname)" == "Darwin" ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
else
    export ANDROID_HOME="$HOME/Android/Sdk"
fi
export PATH="$ANDROID_HOME/platform-tools:$PATH"

# Set default editors
export EDITOR='vim'
export VISUAL='vim'

# Set language and locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Set history file location
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=10000

# Configure less
export LESS='-R --use-color -Dd+r$Du+b'
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"

# Set temp directory
export TMPDIR="/tmp"

