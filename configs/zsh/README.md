# ZSH Configuration

## Source this configuration

### .zshrc

Append this to your `~/.zshrc`
```bash
export ZSH_BASE_CONFIG="$HOME/workplace/nucleus/configs/zsh"
source "$ZSH_BASE_CONFIG/.base.zshrc"
```

### .zshenv

Append this to your `~/.zshenv`
```bash
export ZSH_BASE_CONFIG="$HOME/workplace/nucleus/configs/zsh"
[[ ! -f "${ZSH_BASE_CONFIG}/.base.zshenv" ]] || source "${ZSH_BASE_CONFIG}/.base.zshenv"
```

## Troubleshooting

### oh-my-zsh plugin no such file or directory for autocompletion cache

The issue will look something like
```bash
~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/rust/rust.plugin.zsh:22: no such file or directory: ~/.antigen/bundles/robbyrussell/oh-my-zsh/cache//completions/_rustup
```

To solve, simply create the directory
```bash
mkdir -p ~/.antigen/bundles/robbyrussell/oh-my-zsh/cache//completions
```

You may have to remove the `.antigen/` directory and restart a new terminal session for the change to take effect

