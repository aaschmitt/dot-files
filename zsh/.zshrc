# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

export ZSH="$HOME/.zsh"
export NVIM="$HOME/.config/nvim"
export NVIM_LOGS="$HOME/.local/state/nvim"
export DOTFILES="$HOME/Projects/dot-files"
export EDITOR=nvim

# Source ZSH files
for file in $ZSH/*.zsh; do
    [ -r "$file" ] && source "$file"
done

plug "zsh-users/zsh-autosuggestions"
plug "zdharma-continuum/fast-syntax-highlighting"
plug "marlonrichert/zsh-autocomplete"
# plug "zsh-users/zsh-syntax-highlighting"
# plug "zap-zsh/supercharge"
# plug "zap-zsh/zap-prompt"

# Starship
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
eval "$(starship init zsh)"

# Firefox
export MOZ_ENABLE_WAYLAND=1

# Load and initialise completion system
autoload -Uz compinit
compinit

