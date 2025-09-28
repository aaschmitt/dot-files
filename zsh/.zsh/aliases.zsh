# Tools
alias cat='bat'
alias ls='exa --icons'
alias vim='nvim'
alias battery='acpi -b'

# Configurations
alias hyprland_conf='vim $HOME/.config/hypr/hyprland.conf'
alias reload_hypr='hyprctl reload'

alias zshrc='vim ~/.zshrc'
alias srczsh='source ~/.zshrc'
alias zsh_alias='vim $ZSH/aliases.zsh'

alias starship_conf='vim $HOME/.config/starship/starship.toml'

alias kitty_conf='vim $HOME/.config/kitty/kitty.conf'
alias reload_kitty='kitty @ load-config'

alias tmux_conf='vim $HOME/.tmux.conf'

alias init_lua='vim $NVIM/init.lua'
alias lazy_lua='vim $NVIM/lua/config/lazy.lua'
alias spec_lua='vim $NVIM/lua/plugins'
alias vim_opts='vim $NVIM/lua/vim-options.lua'

alias gst='git status'
glog() {
    local n="${1#-}"
    git log "-${n:-10}" --oneline --graph --decorate
}

# Navigation
alias sandbox='cd $HOME/sandbox'
alias projects='cd $HOME/Projects'

# Arch linux specific
alias sys_update='sudo pacman -Syu'
alias install='sudo pacman -S'

