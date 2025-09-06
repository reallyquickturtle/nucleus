########################################
# Base Configuration
########################################

# Robust path of this file and related assets
CURRENT_DIR="${${(%):-%N}:A:h}"
BASE_ALIASES_FILE="${CURRENT_DIR}/base_aliases"
P10K_CONFIG_FILE="${CURRENT_DIR}/.p10k.zsh"

# XDG defaults
: ${XDG_CONFIG_HOME:="$HOME/.config"}
: ${XDG_CACHE_HOME:="$HOME/.cache"}
: ${XDG_DATA_HOME:="$HOME/.local/share"}
: ${XDG_STATE_HOME:="$HOME/.local/state"}
: ${XDG_BIN_HOME:="$HOME/.local/bin"}

# Core PATH (other exports live in .zshenv)
export PATH="${HOME}/.local/bin:${HOME}/bin:/usr/local/bin:/usr/local/sbin:$PATH"

# Early Zsh options (disable dir stack)
DISABLE_AUTO_CD=true
DISABLE_PUSHD=true
ZSH_DISABLE_COMPFIX=true
unset DIRSTACKSIZE
DIRSTACKSIZE=0

setopt NO_AUTO_CD NO_AUTO_PUSHD NO_PUSHD_IGNORE_DUPS NO_PUSHD_MINUS \
       NO_PUSHD_SILENT NO_PUSHD_TO_HOME NO_AUTO_PARAM_SLASH \
       NO_CDABLE_VARS NO_CD_SILENT


########################################
# Powerlevel10k Instant Prompt
########################################
if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


########################################
# Interactive-only setup
########################################
if [[ -o interactive ]]; then

  # -------- Antigen + Plugins + Theme (quiet, explicit OMZ libs) --------
  if [[ -z ${ANTIGEN_INITIALIZED:-} ]]; then
    typeset -g ANTIGEN_INITIALIZED=1

    ANTIGEN_HOME="${ANTIGEN_HOME:-$XDG_DATA_HOME/antigen}"
    ANTIGEN="${ANTIGEN_HOME}/antigen.zsh"

    # Silent bootstrap if missing
    if [[ ! -f "$ANTIGEN" ]]; then
      mkdir -p "$ANTIGEN_HOME"
      if command -v curl >/dev/null 2>&1; then
        curl -fsSL "https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh" -o "$ANTIGEN" >/dev/null 2>&1 || true
      elif command -v wget >/dev/null 2>&1; then
        wget -qO "$ANTIGEN" "https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh" >/dev/null 2>&1 || true
      fi
    fi

    if [[ -r "$ANTIGEN" ]]; then
      source "$ANTIGEN"
      {
        # Explicit oh-my-zsh core libs (no lib/directories)
        antigen bundle oh-my-zsh/oh-my-zsh lib/git
        antigen bundle oh-my-zsh/oh-my-zsh lib/completion
        antigen bundle oh-my-zsh/oh-my-zsh lib/theme-and-appearance
        antigen bundle oh-my-zsh/oh-my-zsh lib/history
        antigen bundle oh-my-zsh/oh-my-zsh lib/key-bindings

        # Community bundles
        antigen bundle zsh-users/zsh-completions
        antigen bundle zsh-users/zsh-autosuggestions
        antigen bundle git
        antigen bundle gitfast
        antigen bundle git-extras
        antigen bundle npm
        antigen bundle pip
        antigen bundle rust
        antigen bundle aws
        antigen bundle heroku
        antigen bundle lein
        antigen bundle command-not-found
        antigen bundle zsh-users/zsh-syntax-highlighting

        # Theme
        antigen theme romkatv/powerlevel10k

        antigen apply
      } >/dev/null 2>&1
    fi
  fi

  # -------- Mise (auto-install) --------
  if ! command -v mise >/dev/null 2>&1; then
    mkdir -p "$XDG_BIN_HOME"
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL https://mise.jdx.dev/install.sh | sh >/dev/null 2>&1 || true
    elif command -v wget >/dev/null 2>&1; then
      wget -qO- https://mise.jdx.dev/install.sh | sh >/dev/null 2>&1 || true
    fi
  fi

  # Ensure PATH + activate
  if [[ ":$PATH:" != *":$XDG_BIN_HOME:"* ]]; then
    export PATH="$XDG_BIN_HOME:$PATH"
  fi
  if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
    eval "$(mise completion zsh)"
  fi

fi  # end interactive


########################################
# Custom Imports
########################################
[[ -f "$BASE_ALIASES_FILE" ]] && source "$BASE_ALIASES_FILE"


########################################
# History
########################################
setopt appendhistory sharehistory incappendhistory histignoredups extendedhistory


########################################
# Powerlevel10k Config
########################################
if [[ -f "$P10K_CONFIG_FILE" ]]; then
  source "$P10K_CONFIG_FILE"
fi

# Fallback prompt if theme failed
[[ -z ${PROMPT:-} ]] && PROMPT='%n@%m %1~ %# '

# Post-Antigen cleanup
unalias -m '[0-9]' 2>/dev/null
unalias -- '-' 2>/dev/null
disable -f pushd popd dirs 2>/dev/null