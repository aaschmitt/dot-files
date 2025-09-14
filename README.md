# Dotfiles with GNU Stow

```
stow --target=$HOME/ -n -v {pkg}       # Dry run
stow --target=$HOME/.config/ {pkg}     # For .config/ configurations
stow --target=$HOME/ {pkg}             # Create symlink: ~/.zshrc -> dotfiles/zsh/.zshrc
```

