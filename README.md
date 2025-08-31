## Installation

```
mkdir ~/workplace && cd ~/workplace
git clone https://github.com/reallyquickturtle/nucleus.git
cd nucleus
```

Add to `~/.zshenv`
```
export ZSH_BASE_CONFIG="$HOME/workplace/nucleus/configs/zsh"
[[ ! -f "${ZSH_BASE_CONFIG}/.base.zshenv" ]] || source "${ZSH_BASE_CONFIG}/.base.zshenv"

source ~/bin
```

Add to `~/.zshrc`
```
export ZSH_BASE_CONFIG="$HOME/workplace/nucleus/configs/zsh"
source "$ZSH_BASE_CONFIG/.base.zshrc"
```
