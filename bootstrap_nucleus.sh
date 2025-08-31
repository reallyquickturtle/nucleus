#!/usr/bin/env bash
# bootstrap_nucleus.sh
# - Clones/updates nucleus
# - Appends your zsh blocks (idempotent, with backups)
# - Ensures ~/bin exists
# - Optionally installs zsh on Debian/Ubuntu/Raspbian ONLY (--install-zsh)
# - Never installs antigen or any plugins

set -euo pipefail
trap 'rc=$?; echo "❌ Error on line $LINENO (exit $rc). Last: ${BASH_COMMAND}" >&2' ERR

REPO_URL_DEFAULT="https://github.com/reallyquickturtle/nucleus.git"
WORKDIR_DEFAULT="${HOME}/workplace"
BRANCH_DEFAULT="main"
NO_PULL=0
INSTALL_ZSH=0   # install zsh on apt-based systems if missing

usage() {
  cat <<'USAGE'
Usage: ./bootstrap_nucleus.sh [options]
  -r, --repo URL        Git repo URL (default: https://github.com/reallyquickturtle/nucleus.git)
  -w, --workdir DIR     Parent dir for clone (default: ~/workplace)
  -b, --branch NAME     Branch to checkout (default: main)
      --no-pull         Skip pull if repo exists
      --install-zsh     If missing, install zsh (Debian/Ubuntu/Raspbian only)
  -h, --help            Show help
USAGE
}

REPO_URL="$REPO_URL_DEFAULT"
WORKDIR="$WORKDIR_DEFAULT"
BRANCH="$BRANCH_DEFAULT"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--repo)        REPO_URL="${2:-}"; shift 2 ;;
    -w|--workdir)     WORKDIR="${2:-}"; shift 2 ;;
    -b|--branch)      BRANCH="${2:-}"; shift 2 ;;
    --no-pull)        NO_PULL=1; shift ;;
    --install-zsh)    INSTALL_ZSH=1; shift ;;
    -h|--help)        usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

REPO_DIR="${WORKDIR}/nucleus"

has_cmd(){ command -v "$1" >/dev/null 2>&1; }
is_apt(){ [[ -f /etc/os-release ]] && grep -qiE 'debian|ubuntu|raspbian' /etc/os-release; }

timestamp(){ date +"%Y%m%d-%H%M%S"; }
backup_file(){ [[ -f $1 ]] && cp -p "$1" "$1.bak.$(timestamp)" && echo "    • Backed up $1 -> $1.bak.$(timestamp)"; }
ensure_file(){ [[ -f $1 ]] || { touch "$1"; echo "    • Created $1"; }; }

append_block_once(){ # file begin end content
  local file="$1" begin="$2" end="$3" content="$4"
  if grep -Fq "$begin" "$file" 2>/dev/null; then
    echo "    • Block already present in ${file}, skipping."; return 0
  fi
  backup_file "$file"
  { echo ""; echo "$begin"; echo "$content"; echo "$end"; } >> "$file"
  echo "    • Appended block to ${file}"
}

# exact blocks you specified
ZSHENV_BLOCK_BEGIN="# >>> nucleus zshenv >>>"
ZSHENV_BLOCK_END="# <<< nucleus zshenv <<<"
ZSHENV_BLOCK="$(cat <<'EOF'
export ZSH_BASE_CONFIG="$HOME/workplace/nucleus/configs/zsh"
[[ ! -f "${ZSH_BASE_CONFIG}/.base.zshenv" ]] || source "${ZSH_BASE_CONFIG}/.base.zshenv"

source ~/bin
EOF
)"

ZSHRC_BLOCK_BEGIN="# >>> nucleus zshrc >>>"
ZSHRC_BLOCK_END="# <<< nucleus zshrc <<<"
ZSHRC_BLOCK="$(cat <<'EOF'
export ZSH_BASE_CONFIG="$HOME/workplace/nucleus/configs/zsh"
source "$ZSH_BASE_CONFIG/.base.zshrc"
EOF
)"

echo "==> Ensuring repository at: ${REPO_DIR}"
mkdir -p "$WORKDIR"
if [[ -d "$REPO_DIR/.git" ]]; then
  echo "    • Repo exists."
  if [[ "$NO_PULL" -eq 0 ]]; then
    echo "    • Pulling latest from $BRANCH..."
    git -C "$REPO_DIR" fetch --all --prune
    git -C "$REPO_DIR" checkout "$BRANCH"
    git -C "$REPO_DIR" pull --ff-only origin "$BRANCH"
  else
    echo "    • Skipping pull (per --no-pull)."
  fi
else
  echo "    • Cloning fresh from ${REPO_URL} ..."
  git clone --branch "$BRANCH" "$REPO_URL" "$REPO_DIR"
fi

# optional zsh install (only apt-based)
if [[ "$INSTALL_ZSH" -eq 1 ]] && ! has_cmd zsh; then
  if is_apt; then
    echo "==> Installing zsh (apt)…"
    if has_cmd sudo; then
      sudo apt-get update -y && sudo apt-get install -y zsh
    else
      apt-get update -y && apt-get install -y zsh
    fi
  else
    echo "⚠️  --install-zsh was requested, but this is not an apt-based system. Skipping."
  fi
fi

# update dotfiles
ZSHENV="${HOME}/.zshenv"
ZSHRC="${HOME}/.zshrc"
echo "==> Updating ${ZSHENV}"
ensure_file "$ZSHENV"; append_block_once "$ZSHENV" "$ZSHENV_BLOCK_BEGIN" "$ZSHENV_BLOCK_END" "$ZSHENV_BLOCK"
echo "==> Updating ${ZSHRC}"
ensure_file "$ZSHRC"; append_block_once "$ZSHRC" "$ZSHRC_BLOCK_BEGIN" "$ZSHRC_BLOCK_END" "$ZSHRC_BLOCK"

# ensure ~/bin exists
[[ -d "${HOME}/bin" ]] || { mkdir -p "${HOME}/bin"; echo "==> Created ${HOME}/bin"; }

echo
echo "✅ Done."
echo "   • Repo: ${REPO_DIR}"
echo "   • Updated: ${ZSHENV}, ${ZSHRC}"
echo "   • Open a new terminal (or run: zsh) when ready."
echo

