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

# Only in interactive shells
[[ $- != *i* ]] && { ANTIGEN_SKIP=1; }

# Resolve Antigen path (XDG-aware; override with ANTIGEN_HOME if you want)
: ${XDG_DATA_HOME:="$HOME/.local/share"}
ANTIGEN_HOME="${ANTIGEN_HOME:-$XDG_DATA_HOME/antigen}"
ANTIGEN="${ANTIGEN:-$ANTIGEN_HOME/antigen.zsh}"

# Soft bootstrap: fetch Antigen once if missing (interactive only)
if [[ -z ${ANTIGEN_SKIP:-} && ! -f "$ANTIGEN" ]]; then
  mkdir -p "$ANTIGEN_HOME"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh" -o "$ANTIGEN" || true
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$ANTIGEN" "https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh" || true
  fi
fi

# Load Antigen if available (don’t hard-fail if not)
if [[ -r "$ANTIGEN" ]]; then
  source "$ANTIGEN"

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
else
  # Quiet warning; do not abort the rest of zshrc
  [[ -z ${ANTIGEN_SKIP:-} ]] && print -r -- "Warning: Antigen not found at $ANTIGEN (skipping plugin init)" >&2
fi


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

