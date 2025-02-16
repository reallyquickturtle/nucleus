#######################
# Base Configuration
#######################

# Directory and file locations
CURRENT_DIR="${0:A:h}"
BASE_ALIASES_FILE="${CURRENT_DIR}/base_aliases"
P10K_CONFIG_FILE="${CURRENT_DIR}/.p10k.zsh"


#######################
# Early Configurations
#######################

# Disable directory stack features before anything else loads
DISABLE_AUTO_CD=true
DISABLE_PUSHD=true
ZSH_DISABLE_COMPFIX=true
unset DIRSTACKSIZE
DIRSTACKSIZE=0

# Disable all directory-related options
setopt NO_AUTO_CD
setopt NO_AUTO_PUSHD
setopt NO_PUSHD_IGNORE_DUPS
setopt NO_PUSHD_MINUS
setopt NO_PUSHD_SILENT
setopt NO_PUSHD_TO_HOME
setopt NO_AUTO_PARAM_SLASH
setopt NO_CDABLE_VARS
setopt NO_CD_SILENT


#######################
# Powerlevel10k Setup
#######################

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


#######################
# Antigen Setup
#######################

# Source antigen with error handling
if [[ -f $HOME/antigen.zsh ]]; then
    source $HOME/antigen.zsh
else
    echo "Warning: antigen.zsh not found at $HOME/antigen.zsh"
    return 1
fi

antigen use oh-my-zsh

# Core ZSH enhancements
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

# Git-related bundles
antigen bundle git
antigen bundle gitfast
antigen bundle git-extras

# Language and package management
antigen bundle npm
antigen bundle pip
antigen bundle rust

# Cloud and platform tools
antigen bundle aws
antigen bundle heroku
antigen bundle lein

# System utilities
antigen bundle command-not-found

# Syntax highlighting (keep last among plugins)
antigen bundle zsh-users/zsh-syntax-highlighting

# Theme
antigen theme romkatv/powerlevel10k

antigen apply


#######################
# Post-Antigen Cleanup
#######################

# Force remove any directory history aliases
unalias -m '[0-9]' 2>/dev/null
unalias -- '-' 2>/dev/null

# Disable the directory stack commands completely
disable -f pushd 2>/dev/null
disable -f popd 2>/dev/null
disable -f dirs 2>/dev/null


#######################
# Tool Configuration
#######################

# Mise setup
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
    eval "$(mise completion zsh)"
else
    echo "Warning: mise not found"
fi


#######################
# Custom Imports
#######################

# Import custom aliases
if [[ -f "$BASE_ALIASES_FILE" ]]; then
    source "$BASE_ALIASES_FILE"
else
    echo "Warning: Base aliases not found at $BASE_ALIASES_FILE"
fi


#######################
# History Configuration
#######################

# History Settings
setopt appendhistory     # Append to history file rather than overwrite
setopt sharehistory      # Share history between all sessions
setopt incappendhistory  # Append commands to history immediately
setopt histignoredups    # Don't store duplicate commands
setopt extendedhistory   # Save timestamp and duration for each command


#######################
# Powerlevel10k Config
#######################

# Load p10k configuration
if [[ -f "$P10K_CONFIG_FILE" ]]; then
    source "$P10K_CONFIG_FILE"
else
    echo "Warning: P10K config not found at $P10K_CONFIG_FILE"
fi

